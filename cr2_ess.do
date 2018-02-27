/*
*******************************************************************************
Last Update: 15.12.2017
Philippe Joly (HU-BGSS)

TRAJECTORIES OF PROTEST IN POST-AUTOCRATIC CONTEXTS
Assessing the Legacies of the Past in East Germany

Creation do-file 2: Merging ESS

*******************************************************************************
*/

version 14
capture log close
capture log using "${logfiles}cr2_ess.smcl", replace

set more off

****************************************************************************
*  Creating Cumulative Dataset - ESS
****************************************************************************

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

save "${data}ess.dta", replace

log close
exit
