********************************************************************************
* Project:	Generations and Protest in Eastern Germany
* Task:		Execute all do-files of the repository
* Version:	17.05.2018
* Author:	Philippe Joly, Humboldt-Universität zu Berlin
********************************************************************************

version 14
set more off

* Important:
* Run mydirectory.do before executing this master do-file.
* mydirectory.do loads paths to the folders of the repository in global macros.

* ______________________________________________________________________________
* Run all do-files

do "${path}1_cr1_evs.do" 
	// Task: Extract raw EVS data, export graph, and save dataset for analysis
	
do "${path}2_cr2_ess.do"
	// Task: Extract raw ESS data and produce dataset for analysis

do "${path}3_an1.do"
	// Task: Perform age-period-cohort (APC) analysis on ESS data

do "${path}4_an2_robustness.do"
	// Task: Run robustness checks
