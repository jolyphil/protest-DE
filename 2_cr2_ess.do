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
* Depedent variables

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
* ______________________________________________________________________________
* Bundesland | region, regionde --> land

gen land = .
replace land = 1  if regionde == 8  | region == "DE1" // Baden-Wuerttemberg
replace land = 2  if regionde == 9  | region == "DE2" // Bayern
replace land = 3  if regionde == 11 | region == "DE3" // Berlin
replace land = 4  if regionde == 12 | region == "DE4" // Brandenburg
replace land = 5  if regionde == 4  | region == "DE5" // Bremen
replace land = 6  if regionde == 2  | region == "DE6" // Hamburg
replace land = 7  if regionde == 6  | region == "DE7" // Hessen
replace land = 8  if regionde == 13 | region == "DE8" // Mecklenburg-Vorpommern
replace land = 9  if regionde == 3  | region == "DE9" // Niedersachsen
replace land = 10 if regionde == 5  | region == "DEA" // Nordrhein-Westfalen
replace land = 11 if regionde == 7  | region == "DEB" // Rheinland-Pfalz
replace land = 12 if regionde == 10 | region == "DEC" // Saarland
replace land = 13 if regionde == 14 | region == "DED" // Sachsen
replace land = 14 if regionde == 15 | region == "DEE" // Sachsen-Anhalt
replace land = 15 if regionde == 1  | region == "DEF" // Schleswig-Holstein
replace land = 16 if regionde == 16 | region == "DEG" // Thueringen

label variable land "Land"
label define landlb				///
	1  "Baden-Wuerttemberg"		///
	2  "Bayern"					///
	3  "Berlin"					///
	4  "Brandenburg"			///
	5  "Bremen"					///
	6  "Hamburg"				///
	7  "Hessen"					///
	8  "Mecklenburg-Vorpommern" ///
	9  "Niedersachsen"			///
	10 "Nordrhein-Westfalen"	///
	11 "Rheinland-Pfalz"		///
	12 "Saarland"				///
	13 "Sachsen"				///
	14 "Sachsen-Anhalt"			///
	15 "Schleswig-Holstein"		///
	16 "Thueringen", modify
label values land landlb

* ______________________________________________________________________________
* East/West Germany
* _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _
* Based on region where interview was conducted

recode intewde (2 = 0), gen(eastintv) // west=0, east=1
label define eastlb				///
	0 "West Germany"			///
	1 "East Germany", modify
label values eastintv eastlb

* (!) Impossible values:  respondents interviewed in East Germany, 
*     but in a Western region (or vice versa) --> recode as missing
replace eastintv = . if eastintv == 0 ///
	& (	land == "BB" | ///
		land == "MV" | ///
		land == "SN" | ///
		land == "ST" | ///
		land == "TH")
replace eastintv = . if eastintv == 1 ///
	& (	land == "BW" | ///
		land == "BY" | ///
		land == "HB" | ///
		land == "HE" | ///
		land == "HH" | ///
		land == "NI" | ///
		land == "NW" | ///
		land == "RP" | ///
		land == "SH" | ///
		land == "SL")
		
* _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _
* Based on where respondent grew up

* Age when moved to East Germany
gen agemovetoeast = splow5de - yrbrn if splow5de!=. & splow5de<=2017
replace agemovetoeast = n5b_1 - yrbrn if n5b_1!=. & n5b_1<=2017 // ESS 5 

// (agemovetoeast - 15) / 11 

* Age when moved to West Germany
gen agemovetowest = splow4de - yrbrn if splow4de!=. & splow4de<=2017
replace agemovetowest = n5a_1 - yrbrn if n5a_1!=. & n5a_1<=2017 // ESS 5

* West germans living in East Germany
gen westgermanineast = ((agemovetoeast>15)&(agemovetoeast!=.))

* East germans living in West Germany
gen eastgermaninwest = ((agemovetowest>15)&(agemovetowest!=.))

* Socialized in East Germany
gen eastsoc = (eastintv==1 & westgermanineast==0) | eastgermaninwest==1
label variable eastsoc "Region of early socialization"
label values eastsoc eastlb

* ______________________________________________________________________________
* Periods, cohorts and generations
* _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _
* Period variable
gen period=essround
recode period (1=2002) (2=2004) (3=2006) (4=2008) (5=2010) (6=2012) (7=2014) (8=2016)
egen pickone_p=tag(period)

* _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _
* Cohort variable
local c_min=1910
local c_max=1990
local c_d=5
gen cohort=.
forvalues c = `c_min'(`c_d')`c_max' {
	replace cohort=`c' if yrbrn>=`c' & yrbrn<=(`c'+`c_d'-1)
}
* _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _
* Generations
gen generation=1 if yrbrn<=1933
replace generation=2 if yrbrn>=1934 & yrbrn<=1974
replace generation=3 if yrbrn>=1975

* ______________________________________________________________________________
* Socio-demographic and socio-economic variables

* _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _
* Gender | gndr --> female
recode gndr (1=0) (2=1), gen(female) // male=0, female=1
_crcslbl female gndr
label define femalelb				///
	0 "Male"						///
	1 "Female", modify
label values female femalelb

* _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _
* Age
drop age // (!) (?)
gen age=agea if agea<=100
label variable age "Age of respondent"

* _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _
* Highest level of education | eisced --> edu
gen edu = eisced
_crcslbl edu eisced

* _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _
* Income | hinctnt, hinctnta --> incquart (income in quartiles)

* Note:	This procedures harmonizes 2 different measures of income. The ESS 
*		changed its methodology starting round 4. 
* 		See:
* 		https://www.europeansocialsurvey.org/docs/round4/survey/ESS4_appendix_a5_e05_0.pdf

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

* _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _
* Student | mnactic --> student (0:no, 1:yes)
gen student=(mnactic==2) if (mnactic<.)
label variable student "Student"
label define studentlb	///
	0 "Not student"		///
	1 "Student", modify
label values student studentlb

* _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _
* Unemployed | mnactic --> unemp (0:no, 1:yes)
gen unemp=(mnactic==3 | mnactic==4) if (mnactic<.)
label variable unemp "Unemployed"
label define unemplb	///
	0 "No"				///
	1 "Yes", modify
label values unemp unemplb

* _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _
* Member of trade union | mbtru --> union
recode mbtru (3=0) (1 2=1), gen(union) // male=0, female=1
_crcslbl union mbtru
label define unionlb			///
	0 "No"						///
	1 "Yes, currently or previously", modify
label values union unionlb

* _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _
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

* _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _
* Born in Germany | brncntr --> native
recode brncntr (2=0), gen(native)
_crcslbl native brncntr
label define noyeslb			///
	0 "No"						///
	1 "Yes", modify
label values native noyeslb


* ______________________________________________________________________________
* Political attitudes
* _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _
* Political interest | polint --> polintr

gen polint = polintr
_crcslbl polint polintr
replace polint = 4 + 1 - polint // Inverses ordinal scale
label define polintlb				///
	1 "Not at all interested"		///
	2 "Hardly interested"			///
	3 "Quite interested"			///
	4 "Very interested", modify
label values polint polintlb




/*

ctzcntr         double  %10.0g     ctzcntr    Citizen of country
ctzship         str2    %2s                   Citizenship
brncntr         double  %10.0g     brncntr    Born in country
cntbrth         str2    %2s                   Country of birth

trunn           double  %10.0g     trunn      Trade union, last 12 months: none apply
trummb          double  %10.0g     trummb     Trade union, last 12 months: member
truptp          double  %10.0g     truptp     Trade union, last 12 months: participated
trudm           double  %10.0g     trudm      Trade union, last 12 months: donated money
truvw           double  %10.0g     truvw      Trade union, last 12 months: voluntary work
truref          double  %10.0g     truref     Trade union, last 12 months: refusal
truna           double  %10.0g     truna      Trade union, last 12 months: no answer

pdwrk           double  %10.0g     pdwrk      Doing last 7 days: paid work
edctn           double  %10.0g     edctn      Doing last 7 days: education
uempla          double  %10.0g     uempla     Doing last 7 days: unemployed, actively looking for job
uempli          double  %10.0g     uempli     Doing last 7 days: unemployed, not actively looking for job
dsbld           double  %10.0g     dsbld      Doing last 7 days: permanently sick or disabled
rtrd            double  %10.0g     rtrd       Doing last 7 days: retired
cmsrv           double  %10.0g     cmsrv      Doing last 7 days: community or military service
hswrk           double  %10.0g     hswrk      Doing last 7 days: housework, looking after children, others
dngoth          double  %10.0g     dngoth     Doing last 7 days: other
dngdk           double  %10.0g     dngdk      Doing last 7 days: don't know
dngref          double  %10.0g     dngref     Doing last 7 days: refusal
dngna           double  %10.0g     dngna      Doing last 7 days: no answer
mainact         double  %41.0g     mainact    Main activity last 7 days
mnactic         double  %41.0g     mnactic    Main activity, last 7 days. All respondents. Post coded

iscoco          double  %46.0g     iscoco     Occupation, ISCO88 (com)

hinctnt         double  %10.0g     hinctnt    Household's total net income, all sources
hincfel         double  %36.0g     hincfel    Feeling about household's income nowadays


*/











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
