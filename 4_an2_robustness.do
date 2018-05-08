********************************************************************************
* Project:	Protest in East and West Germany
* Task:		Robustness checks
* Version:	12.04.2018
* Author:	Philippe Joly, Humboldt-Universität zu Berlin
********************************************************************************

version 14
capture log close
capture log using "${logfiles}4_an2_robustness.smcl", replace
set more off

* ______________________________________________________________________________
* Load ESS MI dataset

use "${data}ess.dta", clear

* ______________________________________________________________________________
* Fixed effect model with interaction terms (excluding age)

* _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _
* variables
local controls "i.female i.edu3 i.unemp i.union i.city i.class5 i.land"

* _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _

foreach dv of varlist demonstration petition boycott {
	logit `dv' i.eastsoc i.cohort i.period ///
		i.eastsoc#i.cohort i.eastsoc#i.period `controls'
	est store m_`dv'
	
	margins if e(sample)==1, dydx(eastsoc) at(cohort=(1920(5)1985))
	marginsplot, ///
		xline(1929,lcolor(edkblue) lpattern(dash)) ///
		xline(1970,lcolor(edkblue) lpattern(dash)) ///
		yline(0,lcolor(edkblue)) ///
		plotop(mcolor(black) lcolor(black)) ///
		recastci(rarea) ///
		ciop(lcolor(gs13))  ///
		ci(fcolor(gs13)) ///
		xtitle("Birth cohorts") xlab(1920(10)1980) ///
		ytitle("Effect of socialization in East Germany") ///
		title("") ///
		saving("${figures_gph}fig_`dv'-cohort_FE.gph", replace)
	graph export "${figures_pdf}fig_`dv'-cohort_FE.pdf", replace
	
	est restore m_`dv'
	margins if e(sample)==1, dydx(eastsoc) at(period=(2002(2)2016))
	marginsplot, ///
		yline(0,lcolor(edkblue)) ///
		plotop(mcolor(black) lcolor(black)) ///
		recastci(rarea) ///
		ciop(lcolor(gs13))  ///
		ci(fcolor(gs13)) ///
		xtitle("Periods") xlab(2002(2)2016) ///
		ytitle("Effect of socialization in Eastern Germany") ///
		title("") ///
		saving("${figures_gph}fig_`dv'-period_FE.gph", replace)
	graph export "${figures_emf}fig_`dv'-period_FE.emf", replace
	graph export "${figures_pdf}fig_`dv'-period_FE.pdf", replace
	graph export "${figures_png}fig_`dv'-period_FE.png", replace ///
		width(2750) height(2000)
}	
* ______________________________________________________________________________
* Close

log close
exit
