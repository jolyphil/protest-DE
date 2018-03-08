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

set matsize 10000

mi set flong
mi svyset [pweight=dweight]
mi register imputed ///
	petition boycott demonstration age female edu incquart /*student*/ unemp ///
	union city relig polint trustlegal trustparl trustparties ///
	trustpeople stfdem stflife lrscale promigrant
mi register regular ///
	land eastintv eastsoc period cohort class8
mi register passive ///
	cohorteast
mi impute chained ///
	(regress) age ///
	(logit) petition boycott demonstration female unemp union ///
	(ologit) edu incquart city relig polint trustlegal trustparl ///
		trustparties trustpeople stfdem stflife lrscale promigrant ///
		= i.land i.eastintv i.eastsoc##c.cohort##c.cohort i.period i.class8, ///
		add(5) force dots noisily

* _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _
* Summary table
* do "${programs}export_tabB2_rtf.do"

* _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _
save "${data}ess-mi.dta", replace

* _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _
* Close

log close
exit
