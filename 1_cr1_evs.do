********************************************************************************
* Project:	Protest in East and West Germany
* File: 	1_cr1_evs.do
* Task:		Extract raw EVS data and produce dataset for analysis
* Version:	28.02.2018
* Author:	Philippe Joly, Humboldt-Universität zu Berlin
********************************************************************************

version 14
capture log close
capture log using "${logfiles}1_cr1_evs.smcl", replace
set more off

* ______________________________________________________________________________
* Get EVS data

use "${evslg}", clear // EVS Longitudinal 1981-2008 (EVS 1 to 4)
keep if S003==276 & S002EVS == 2 // Keep German data in wave 1990

* ______________________________________________________________________________
* Clean EVS data

* _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _
* Wave | S002EVS --> wave
gen evswave = S002EVS // Wave 2
_crcslbl evswave S002EVS

* _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _
* Country | S003 --> country
gen country = S003 // Country: DE
_crcslbl country S003

* _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _
* Region of interview  | S003A --> east
recode S003A (900 = 0) (901 = 1), gen(east) // East Germany == 1
label variable east "Region of interview"
label define eastlb				///
	0 "West Germany"			///
	1 "East Germany", modify
label values east eastlb

* _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _
* Weight | S017 --> weight
gen weight = S017
_crcslbl weight S017

* _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _
* Year | S020 --> year
gen year = S020

* _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _
* Taking part in a demonstration | E027 --> demonstration
recode E027 (2 3 = 0), gen(demonstration)
_crcslbl demonstration E027 // Copies var. label
label define poliactlb ///
	0 "Not done" ///
	1 "Have done", modify
label values demonstration poliactlb // Copies label values

* _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _
* Year of birth | X002 --> yearborn
gen yearborn = X002
_crcslbl yearborn X002

* ______________________________________________________________________________
* Save and close

keep evswave country east weight year demonstration yearborn
save "${data}evs.dta", replace 

log close
exit
