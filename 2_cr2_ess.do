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
label define landlb ///
	1  "Baden-Wuerttemberg" ///
	2  "Bayern" ///
	3  "Berlin" ///
	4  "Brandenburg" ///
	5  "Bremen" ///
	6  "Hamburg" ///
	7  "Hessen" ///
	8  "Mecklenburg-Vorpommern" ///
	9  "Niedersachsen" ///
	10 "Nordrhein-Westfalen" ///
	11 "Rheinland-Pfalz" ///
	12 "Saarland" ///
	13 "Sachsen" ///
	14 "Sachsen-Anhalt" ///
	15 "Schleswig-Holstein" ///
	16 "Thueringen", modify
label values land landlb

* ______________________________________________________________________________
* East/West Germany: Region where interview was conducted

recode intewde (2 = 0), gen(eastintv) // west=0, east=1
_crcslbl eastintv intewde
label define eastlb				///
	0 "West Germany"			///
	1 "East Germany", modify
label values eastintv eastlb

* (!) Impossible values:  respondents interviewed in East Germany, 
*     but in a Western region (or vice versa) --> recode as missing
replace eastintv = . if eastintv == 0 ///
	& (	land == 4  | ///
		land == 8  | ///
		land == 13 | ///
		land == 14 | ///
		land == 16)
replace eastintv = . if eastintv == 1 ///
	& (	land == 1  | ///
		land == 2  | ///
		land == 5  | ///
		land == 6  | ///
		land == 7  | ///
		land == 9  | ///
		land == 10 | ///
		land == 11 | ///
		land == 12 | ///
		land == 15)
* ______________________________________________________________________________
* Political socialization based on where respondent grew up

* _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _
* Current Age | agea --> age
drop age
gen age = agea if agea <= 100
label variable age "Age of respondent"

gen age10 = agea/10 if agea <= 100
label variable age10 "Age of respondent (10 years)"

* _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _
* Lived in East Germany before 1990 | splow2de, n3 --> eastbefore1990
* Note: keep German natives only.

recode splow2de (1=1) (2=0) (else=.), gen(eastbefore1990)
recode n3 (1=1) (2=0) (else=.), gen(eastbefore1990_ess5) // ESS 5
replace eastbefore1990 = eastbefore1990_ess5 if eastbefore1990_ess5 != .
drop eastbefore1990_ess5

* _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _
* Age when moved to East Germany | --> agemovetoeast
gen agemovetoeast = splow5de - yrbrn if splow5de != . & splow5de <= 2017
replace agemovetoeast = n5b_1 - yrbrn if n5b_1 != . & n5b_1 <= 2017 // ESS 5
replace agemovetoeast = . if agemovetoeast < 0 

* _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _
* Age when moved to West Germany | --> agemovetowest
gen agemovetowest = splow4de - yrbrn if splow4de != . & splow4de <= 2017
replace agemovetowest = n5a_1 - yrbrn if n5a_1 != . & n5a_1 <= 2017 // ESS 5
replace agemovetowest = . if agemovetowest < 0 

* _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _
* Total years of political socialization | --> soctotyears
gen soctotyears = .
replace soctotyears = 11 if age > 25
replace soctotyears = age - 15 if age >= 15 & age <= 25

* _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _
* Years of political socialization in East Germany
gen socyearseast = .

* (1) Lived in the GDR before 1990, still living in East Germany
replace socyearseast = 11 if age > 25 ///
	& eastintv == 1 & eastbefore1990 == 1
replace socyearseast = age - 15 if age >= 15 & age <= 25 ///
	& eastintv == 1 & eastbefore1990 == 1

* (2) Lived in the GDR before 1990, moved to West Germany 
replace socyearseast = 0 if agemovetowest < 15 & agemovetowest != .
replace socyearseast = agemovetowest - 15 /// 
	if agemovetowest >= 15 & agemovetowest <= 25
replace socyearseast = 11 if agemovetowest > 25 & agemovetowest != .
// tw line socyearseast agemovetowest, sort

* (3) Lived in the West Germany before 1990, still living in West Germany
replace socyearseast = 0 if eastintv == 0 & eastbefore1990 == 0

* (4) Lived in the West Germany before 1990, moved to East Germany
replace socyearseast = 11 if agemovetoeast < 15 & agemovetoeast != .
replace socyearseast = 26 - agemovetoeast /// 
	if agemovetoeast >= 15 & agemovetoeast <= 25
replace socyearseast = 0 if agemovetoeast > 25 & agemovetoeast != .
// tw line socyearseast agemovetoeast, sort

* _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _
* Lived most formative years in East Germany | --> eastsoc
gen eastsoc = (socyearseast / soctotyears) > 0.5 if socyearseast != .
label variable eastsoc "Region of early socialization"
label values eastsoc eastlb

* Drop unnecessary variables 
drop eastbefore1990 agemovetoeast agemovetowest soctotyears socyearseast

* ______________________________________________________________________________
* Periods, cohorts and generations
* _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _
* Period variable
gen period=essround
recode period (1=2002) (2=2004) (3=2006) (4=2008) (5=2010) (6=2012) (7=2014) ///
	(8=2016)
* _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _
* Cohort variable
local c_min=1920
local c_max=1985
local c_d=5
gen cohort=.
forvalues c = `c_min'(`c_d')`c_max' {
	replace cohort=`c' if yrbrn>=`c' & yrbrn<=(`c'+`c_d'-1)
}
* _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _
* Cohort-east variable
egen cohorteast = group(cohort eastsoc), label

* ______________________________________________________________________________
* Socio-demographic and socio-economic variables

* _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _
* Gender | gndr --> female
recode gndr (1=0) (2=1), gen(female) // male=0, female=1
_crcslbl female gndr
label define femalelb ///
	0 "Male" ///
	1 "Female", modify
label values female femalelb

* _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _
* Age --> age, Already defined; see previous section.

/* _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _
* Highest level of education (7 categories) | eisced --> edu7
gen edu7 = eisced
replace edu7 = . if eisced > 7
_crcslbl edu7 eisced
label define edu7lb ///
	1 "Less than lower secondary" ///
	2 "Lower secondary" ///
	3 "Lower tier upper secondary" ///
	4 "Upper tier upper secondary" ///
	5 "Advanced vocational, sub-degree" ///
	6 "Lower tertiary education" ///
	7 "Higher tertiary education", modify
label values edu7 edu7lb */

* _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _
* Highest level of education (3 categories) | eisced --> edu3
recode eisced (1/2 = 1) (3/5 = 2) (6/7 = 3) (else = .), gen(edu3)
label variable edu3 "Highest level of education"
label define edu3lb ///
	1 "Lower" ///
	2 "Middle" ///
	3 "Upper", modify
label values edu3 edu3lb

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
label define incquartlb ///
	1 "Q1" ///
	2 "Q2" ///
	3 "Q3" ///
	4 "Q4", modify
label values incquart incquartlb

* _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _
* Unemployed | mnactic --> unemp (0:no, 1:yes)
gen unemp = (mnactic==3 | mnactic==4) if (mnactic<.)
label variable unemp "Unemployed"
label define unemplb ///
	0 "No" ///
	1 "Yes", modify
label values unemp unemplb

* _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _
* Member of trade union | mbtru --> union
recode mbtru (3=0) (1 2=1), gen(union) // male=0, female=1
_crcslbl union mbtru
label define unionlb ///
	0 "No" ///
	1 "Yes, currently or previously", modify
label values union unionlb

* _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _
* Size of town | domicil --> city
gen city = domicil
label variable city "Size of town/city"
replace city = 5 + 1 - city // Inverses ordinal scale
label define citylb ///
	1 "Farm or home in countryside" ///
	2 "Country village" ///
	3 "Town or small city" ///
	4 "Suburbs or outskirts of big city" ///
	5 "A big city", modify
label values city citylb

* _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _
* Social class (Oesch 2006) | --> class5

* Preserve dataset before splitting sample 
tempfile master  // temporary dataset
save "`master'"

* ESS 1, 2, and 3
keep if essround == 1 | essround == 2 | essround == 3
do "${programs}Oesch_class_schema_ESS2002_2006_Stata.do"
tempfile ess_1_3  // temporary dataset: ESS 1 to 3
save "`ess_1_3'"

* ESS 4 and 5
use "`master'", clear
keep if essround == 4 | essround == 5
do "${programs}Oesch_class_schema_ESS2008_2010_ESS_Cumulative_Data_Wizard_Stata.do"
tempfile ess_4_5  // temporary dataset: ESS 4 and 5
save "`ess_4_5'"

* ESS 6, 7, and 8
use "`master'", clear
keep if essround == 6 | essround == 7 | essround == 8
do "${programs}Oesch_class_schema_ESS2012_Stata.do"
tempfile ess_6_8  // temporary dataset: ESS 6 to 8
save "`ess_6_8'"

* Reassemble dataset
append using "`ess_1_3'"
append using "`ess_4_5'"

* Drop unnecessary variables
drop class16_r class8_r class5_r class16_p class8_p class5_p class16 class8

/* _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _
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
label values relig religlb */

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

/* _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _
* Trust in the legal system | trstlgl --> trustlegal
gen trustlegal = trstlgl 
_crcslbl trustlegal trstlgl
label values trustlegal trstlgl

* _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _
* Trust in the parliament | trstprl --> trustparl
gen trustparl = trstprl
_crcslbl trustparl trstprl
label values trustparl trstprl

* _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _
* Trust in the political parties | trstprt --> trustparties
gen trustparties = trstprt
_crcslbl trustparties trstprt
replace trustparties = trstplde if essround == 1
label values trustparties trstprt 

* _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _
* Most people can be trusted | ppltrst --> trustpeople
gen trustpeople = ppltrst
_crcslbl trustpeople ppltrst
label values trustpeople ppltrst
*/
* _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _
* Satisfied with the way democracy works | stfdem --> stfdem
* Ok! No recode.

* _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _
* Satisfied with life as a whole | stflife --> stflife
* Ok! No recode.

* _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _
* Left-Right Scale | lrscale --> lrscale
* Ok! No recode.

* _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _
* Cultural life enriched by immigrants | imueclt --> promigrant
gen promigrant = imueclt
_crcslbl promigrant imueclt
label values promigrant imueclt

* ______________________________________________________________________________
* Save and close

keep dweight ///
	petition boycott demonstration ///
	land eastintv eastsoc ///
	period cohort cohorteast ///
	age age10 female edu3 incquart unemp union city class5 ///
	stfdem promigrant

save "${data}ess.dta", replace

log close
exit
