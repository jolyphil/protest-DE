********************************************************************************
* Project:	Protest in East and West Germany
* File: 	4_an1.do
* Task:		Perform APC analysis on ESS data
* Version:	09.03.2018
* Author:	Philippe Joly, Humboldt-Universität zu Berlin
********************************************************************************

version 14
capture log close
capture log using "${logfiles}4_an1.smcl", replace
set more off

* ______________________________________________________________________________
* Load ESS MI dataset

use "${data}ess.dta", clear

* ______________________________________________________________________________
* Cross-classified random effect models
* _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _
* Taking part in a demonstration

*mi estimate, noisily saving("${estfiles}miestfile1", replace): ///

*drop b1 se1 ll ul

meqrlogit petition i.female c.age##c.age i.edu3 /*i.incquart*/ i.unemp ///
	i.union i.city i.class5 i.land || _all: R.period || cohorteast:

predict b*, reffects relevel(cohorteast)
predict se*,  reses relevel(cohorteast)

gen ll = b1 - 1.96*se1
gen ul = b1 + 1.96*se1

twoway ///
	(rarea ll ul cohort, sort fcolor(gs12) lcolor(gs12)) ///
	(connected b1 cohort, sort mcolor(black) lcolor(black)), ///
	xline(1934,lcolor(black) lpattern(dash)) xline(1975,lcolor(black) lpattern(dash)) ///
	by(, note("")) by(, legend(off)) by(eastsoc)

* _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _
twoway ///
	(rarea ll ul cohort, sort fcolor(gs12) lcolor(gs12)) ///
	(connected b1 cohort, sort mcolor(black) lcolor(black)), ///
	by(, note("")) by(, legend(off)) by(eastsoc)
	
meqrlogit demonstration i.female c.age##c.age i.edu3 i.incquart i.unemp ///
	i.union i.city i.class5 i.land promigrant || _all: R.period || cohorteast: promigrant

predict b*, reffects relevel(cohorteast)
predict se*,  reses relevel(cohorteast)

gen ll = b1 - 1.96*se1
gen ul = b1 + 1.96*se1

twoway ///
	(rarea ll ul cohort, sort fcolor(gs12) lcolor(gs12)) ///
	(connected b1 cohort, sort mcolor(black) lcolor(black)), ///
	xline(1934,lcolor(black) lpattern(dash)) xline(1975,lcolor(black) lpattern(dash)) ///
	by(, note("")) by(, legend(off)) by(eastsoc)
