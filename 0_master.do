********************************************************************************
* Project:	Protest in East and West Germany
* Task:		Execute all do-files of the repository
* Version:	12.04.2018
* Author:	Philippe Joly, Humboldt-Universität zu Berlin
********************************************************************************

version 14
set more off

* ______________________________________________________________________________
* Run all do-files

do "${path}1_cr1_evs.do"
do "${path}2_cr2_ess.do"
do "${path}3_an1.do"
do "${path}4_an2_robustness.do"
