********************************************************************************
* Project:	Protest in East and West Germany
* Task:		Perform APC analysis on ESS data
* Version:	09.03.2018
* Author:	Philippe Joly, Humboldt-Universität zu Berlin
********************************************************************************

version 14
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

local controls "i.female c.age10##c.age10 i.edu3 i.unemp i.union i.city i.class5 i.land"
local fe_eq "i.eastsoc `controls'"

* _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _
* Random slope at cohort level

* Model info
local level_1 "cohort"
local re_eq_1 "|| _all: R.period || cohort: eastsoc"

*Graph options
local lines_1 "xline(1929,lcolor(edkblue) lpattern(dash)) xline(1970,lcolor(edkblue) lpattern(dash))"
local xlab_1 "1910(10)1985"
local xtitle_1 "Birth cohorts"

* _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _
* Random slope at period level

* Model info
local level_2 "period"
local re_eq_2 "|| _all: R.cohort || period: eastsoc"

*Graph options
local lines_2 ""
local xlab_2 "2002(2)2016"
local xtitle_2 "Periods"

foreach dv of varlist demonstration petition boycott {
	
	* _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _
	* Random-intercept model

	meqrlogit `dv' `fe_eq' || _all: R.period || cohort:
	est store m_`dv'_0 
	
	forvalues i=1/2 {
		
		* _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _
		* Random-slope model
		meqrlogit `dv' `fe_eq' `re_eq_`i''
		est store m_`dv'_`i'
		
		* _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _
		* Postestimation (EB prediction)
		predict b*, reffects relevel(`level_`i'')
		predict se*, reses relevel(`level_`i'')
		
		gen slope = _b[eq1:1.eastsoc] + b1
		gen ll = _b[eq1:1.eastsoc] + b1 - 1.96*se1
		gen ul = _b[eq1:1.eastsoc] + b1 + 1.96*se1
		
		gen fe_east = _b[eq1:1.eastsoc]
		
		* _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _
		* Graph
		twoway ///
			(rarea ll ul `level_`i'', sort fcolor(gs13) lcolor(gs13)) ///
			(connected slope `level_`i'', sort mcolor(black) lcolor(black)) ///
			(line fe_east `level_`i'', sort lcolor(black) lpattern(dash)), ///
			`lines_`i'' ///
			yline(0,lcolor(edkblue) ///
			xlab(`xlab_`i'') ///
			xtitle(`xtitle_`i'') ///
			ylab(0(-0.2)-0.6) ///
			ytitle("Predicted effect of socialization in East Germany") ///
			legend(order(3 "Random effect" 4 "Fixed effect")) ///
			saving("${figures_gph}fig_`dv'-`level_`i''.gph", replace)
		graph export "${figures_pdf}fig_`dv'-`level_`i''.pdf", replace
		
		* _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _
		* Clear
		drop b1 b2 se1 se2 slope ll ul fe_east
	} 
}
drop yline

* ______________________________________________________________________________
* Export Tables

do "${programs}export_tab_APC_models_tex.do" ///
	m_demonstration_1 /// Model 1
	m_petition_1 /// Model 2
	m_boycott_1 /// Model 3
	tab_APC_rs_cohort // filename

do "${programs}export_tab_APC_models_tex.do" ///
	m_demonstration_2 ///
	m_petition_2 ///
	m_boycott_2 ///
	tab_APC_rs_period // filename
* ______________________________________________________________________________
* Export Graph

do "${programs}export_coefplot.do" ///
	m_demonstration_1 "Demonstration" ///
	m_petition_1 "Petition" ///
	m_boycott_1 "Boycott" ///
	"fig_coefplot" // filename
	
* ______________________________________________________________________________
* Close

log close
exit
