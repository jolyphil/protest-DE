********************************************************************************
* Project:	Protest in East and West Germany
* File: 	3_cr3_mi.do
* Task:		Produce MI datasets
* Version:	08.03.2018
* Author:	Philippe Joly, Humboldt-Universität zu Berlin
********************************************************************************

version 14
capture log close
capture log using "${logfiles}3_cr3_mi.smcl", replace
set more off

ssc install estout

* ______________________________________________________________________________
* Load ESS data

use "${data}ess.dta", clear

* _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _
* Recodes all missing values as "."

foreach var of varlist _all {
	replace `var' = . ///
		if `var'==.a | `var'==.b | `var'==.c | `var'==.d | `var'==.e
}
* ______________________________________________________________________________
* Perform imputation

mi set flong
mi svyset [pweight=dweight]
mi register imputed ///
	petition boycott demonstration ///
	age female edu3 incquart unemp union city class5 ///
	stfdem promigrant
mi register regular ///
	land eastintv eastsoc period cohort
mi register passive ///
	cohorteast
mi impute chained ///
	(regress) age ///
	(logit) petition boycott demonstration female unemp stfdem promigrant ///
	(ologit) edu3 incquart city ///
	(mlogit) class5 ///
		= i.land i.eastintv i.eastsoc##c.cohort##c.cohort i.period, ///
		add(5) force dots noisily rseed(12345)

* _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _
* Summary table
* do "${programs}export_tabB2_rtf.do"

* _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _
save "${data}ess-mi.dta", replace

* _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _
* Close

log close
exit
