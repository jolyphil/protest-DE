********************************************************************************
* Project:	Protest in East and West Germany
* File: 	4_an1.do
* Task:		Perform APC analysis on ESS data
* Version:	09.03.2018
* Author:	Philippe Joly, Humboldt-Universität zu Berlin
********************************************************************************

*version 14
capture log close
capture log using "${logfiles}4_an1.smcl", replace
set more off

ssc install estout
ssc install coefplot

* ______________________________________________________________________________
* Load ESS MI dataset

use "${data}ess.dta", clear

* ______________________________________________________________________________
* Cross-classified random effect models

local controls "i.female c.age##c.age i.edu3 i.unemp i.union i.city i.class5 i.land"
local fe_eq "i.eastsoc `controls'"

* _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _
* Random slope at cohort level
local level_1 "cohort"
local re_eq_1 "|| _all: R.period || cohort: eastsoc"
local lines_1 "xline(1929,lcolor(black) lpattern(dash)) xline(1970,lcolor(black) lpattern(dash))"

* _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _
* Random slope at period level
local level_2 "period"
local re_eq_2 "|| _all: R.cohort || period: eastsoc"
local lines_2 ""

foreach dv of varlist petition {
	forvalues i=1/2 {
	
		capture drop b1 b2 se1 se2 slope ll ul
		
		* _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _
		* Model
		meqrlogit `dv' `fe_eq' `re_eq_`i''
		est store m_`dv'_`i'
		
		* _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _
		* Postestimation (EB prediction)
		predict b*, reffects relevel(`level_`i'')
		predict se*, reses relevel(`level_`i'')
		
		gen slope = _b[eq1:1.eastsoc] + b1
		gen ll = _b[eq1:1.eastsoc] + b1 - 1.96*se1
		gen ul = _b[eq1:1.eastsoc] + b1 + 1.96*se1
		
		* _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _
		* Graph
		twoway ///
			(rarea ll ul `level_`i'', sort fcolor(gs12) lcolor(gs12)) ///
			(connected slope `level_`i'', sort mcolor(black) lcolor(black)), ///
			`lines_`i'' ///
			legend(off) ///
			saving("${figures_gph}`dv'-`level_`i''.gph", replace)
		graph export "${figures_png}`dv'-`level_`i''.png", replace
		
	} 
}
* margins land, predict(mu fixed)
* marginsplot, recast(scatter)

* ______________________________________________________________________________
* Close

log close
exit
