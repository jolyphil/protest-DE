********************************************************************************
* Project:	Protest in East and West Germany
* File: 	2_cr2_ess.do
* Task:		Extract raw ESS data and produce dataset for analysis
* Version:	28.02.2018
* Author:	Philippe Joly, Humboldt-Universität zu Berlin
********************************************************************************

version 14
capture log close
capture log using "${logfiles}2_cr2_ess.smcl", replace
set more off

* ______________________________________________________________________________
* Create ESS Cumulative Dataset

forvalues i = 8(-1)1 {
* Merges country and country-specific files
	use "${ess`i'}", clear
	merge 1:1 idno using "${ess`i'_cs}"
	tempfile ESS`i'_merged_temp  /* create a temporary file */
	save "`ESS`i'_merged_temp'"
}
forvalues i = 2(1)8 {
* Appends all 8 waves of the ESS
	append using "`ESS`i'_merged_temp'", force
}
* Handles missing values
do "${ess_miss}"

* Generates unique id for cumulative file
gen id = _n

* ______________________________________________________________________________
* Clean ESS data

* _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _
* Dependent variables

* Creates variables for recent protest: petition, boycott and demonstration
label define poliactlb 0 "Not done" 1 "Have done", modify

local varname1 "petition"
local varname2 "boycott"
local varname3 "demonstration"

foreach var of varlist sgnptit bctprd pbldmn {
	local j=`j'+1
	recode `var' (2 = 0) if `var'<=2, gen(`varname`j'')
	_crcslbl `varname`j'' `var' // Copies var. label
	label values `varname`j'' poliactlb // Copies label values
}
*

* _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _
* East/West Germany

*Based on region where interview was conducted
recode intewde (2 = 0), gen(east_intv) // west=0, east=1
label define eastlb				///
	0 "West Germany"			///
	1 "East Germany", modify
label values east_intv eastlb

* Age when moved to East Germany
gen agemovetoeast = splow5de - yrbrn if splow5de!=. & splow5de<=2017
replace agemovetoeast = n5b_1 - yrbrn if n5b_1!=. & n5b_1<=2017 // ESS 5 

* Age when moved to West Germany
gen agemovetowest = splow4de - yrbrn if splow4de!=. & splow4de<=2017
replace agemovetowest = n5a_1 - yrbrn if n5a_1!=. & n5a_1<=2017 // ESS 5

* West germans living in East Germany
gen westgermanineast = ((agemovetoeast>15)&(agemovetoeast!=.))

* East germans living in West Germany
gen eastgermaninwest = ((agemovetowest>15)&(agemovetowest!=.))

* Socialized in East Germany
gen east_soc = (east_intv==1 & westgermanineast==0) | eastgermaninwest==1
label variable east_soc "Region of early socialization"
label values east_soc eastlb


* _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _
* Periods, cohorts and generations
* _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _
* Period variable
gen period=essround
recode period (1=2002) (2=2004) (3=2006) (4=2008) (5=2010) (6=2012) (7=2014) (8=2016)
egen pickone_p=tag(period)
* _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _
* Cohort variable
local c_min=1910
local c_max=1990
local c_d=5
gen cohort=.
forvalues c = `c_min'(`c_d')`c_max' {
	replace cohort=`c' if yrbrn>=`c' & yrbrn<=(`c'+`c_d'-1)
}
* _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _
* Generations
gen generation=1 if yrbrn<=1933
replace generation=2 if yrbrn>=1934 & yrbrn<=1974
replace generation=3 if yrbrn>=1975


* _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _
* Other controls

* RESOURCES

* _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _
*Highest level of education | eisced --> edu
recode eisced (1/2 = 1) (3/4 = 2) (5/7 = 3) (else = .), gen(edu)
label variable edu "Highest level of education"
label define groups3lb				///
	1 "Lower"						///
	2 "Middle"						///
	3 "Upper", modify
label values edu groups3lb
* Note: see documentation on education measurement: 
* www.europeansocialsurvey.org/docs/round6/survey/ESS6_appendix_a1_e02_0.pdf

* _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _
* Income | hinctnt, hinctnta --> incquart (income in quartiles)
gen incquart=.
forvalues i = 1(1)3 {
	xtile incquart_`i' = hinctnt if (essround==`i'), nq(4)
}
forvalues i = 4(1)8 {
	xtile incquart_`i' = hinctnta if (essround==`i'), nq(4)
}
forvalues i = 1(1)8 {
	replace incquart = incquart_`i' if essround==`i'
}
drop incquart_*
label variable incquart "Income groups"
label define incquartlb		///
	1 "Q1"					///
	2 "Q2"					///
	3 "Q3"					///
	4 "Q4", modify
label values incquart incquartlb
* Note: 
* This procedures harmonizes 2 different measures of income. The ESS changed its
* methodology starting round 4. 
* See:
* https://www.europeansocialsurvey.org/docs/round4/survey/ESS4_appendix_a5_e05_0.pdf

* _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _
* Unemployed | mnactic --> unemp (0:no, 1:yes)
gen unemp=(mnactic==3 | mnactic==4) if (mnactic<.)
label variable unemp "Unemployed"
label define unemplb	///
	0 "No"				///
	1 "Yes", modify
label values unemp unemplb

* _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _
* Size of town | domicil --> city
gen city = domicil
label variable city "Size of town/city"
replace city = 5 + 1 - city // Inverses ordinal scale
label define citylb							///
	1 "Farm or home in countryside"			///
	2 "Country village"						///
	3 "Town or small city"					///
	4 "Suburbs or outskirts of big city"	///
	5 "A big city", modify
label values city citylb


* VALUES/ATTITUDES
* _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _
* Trust
gen trust = ppltrst
_crcslbl trust ppltrst
label values trust ppltrst
* _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _
* Life satisfaction | stflife --> lifesatis
gen lifesatis=stflife
_crcslbl lifesatis stflife
label values lifesatis stflife
* _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _
* Confidence in Parliament | trstprl --> confparl
gen confparl=trstprl
_crcslbl confparl trstprl
label values confparl trstprl
* _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _
* Left-Right Scale | lrscale --> lrscale
* OK
* _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _
* Self-expression values | impfree --> selfexp
gen selfexp = impfree
_crcslbl selfexp impfree
replace selfexp = 6 + 1 - selfexp // Inverses ordinal scale
label define selfexplb				///
	1 "Not like me at all"			///
	2 "Not like me"					///
	3 "A little like me"			///
	4 "Somewhat like me"			///
	5 "Like me"						///
	6 "Very much like me", modify
label values selfexp selfexplb

/*
* Satisfaction with democracy | stfdem --> demosatis
gen demosatis = stfdem
_crcslbl demosatis stfdem
label values demosatis stfdem

* Xenophobic attitude | imwbcnt --> xeno
gen xeno = imwbcnt
_crcslbl xeno imwbcnt
replace xeno = 10 - xeno // Inverses ordinal scale
label define xenolb				///
	0 "Better place to live"		///
	10 "Worse place to live", modify
label values xeno xenolb
*/

* OTHER CONTROLS
* _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _
*Gender | gndr --> female
recode gndr (1=0) (2=1), gen(female) // male=0, female=1
_crcslbl female gndr
label define femalelb				///
	0 "Male"						///
	1 "Female", modify
label values female femalelb

* _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _
*Age
drop age
gen age=agea if agea<=100
label variable age "Age of respondent"

* _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _
* Attendance of religious services | rlgatnd --> relig
gen relig = rlgatnd
_crcslbl relig rlgatnd
replace relig = 7 + 1 - relig // Inverses ordinal scale
recode relig (7 = 6)
label define religlb				///
	1 "Never practically never"		///
	2 "Less often"					///
	3 "Only on special holy days"	///
	4 "Once a month"				///
	5 "Once a week"					///
	6 "More than once a week", modify
label values relig religlb

* _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _
* Partner | partner --> partner
replace partner=icpart1 if essround>=5  //harmonizes variables for ESSrounds 5-7
recode partner (2=0)
label define partnerlb				///
	0 "Does not"					///
	1 "Lives with husband/wife/partner at house", modify
label values partner partnerlb

* ______________________________________________________________________________
* Save and close

keep petition-relig
save "${data}ess.dta", replace

log close
exit
