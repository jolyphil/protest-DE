********************************************************************************
* Project:	Protest in East and West Germany
* Task:		Set up working directory
* Version:	08.05.2018
* Author:	Philippe Joly, Humboldt-Universität zu Berlin
********************************************************************************

* ______________________________________________________________________________
* Main path

global path "M:/user/joly/Analyses/protest-DE/"

* ______________________________________________________________________________
* Folders

global data "${path}data/"
	global data_raw "${data}raw/"
global figures "${path}figures/"
	global figures_emf "${figures}emf/"
	global figures_gph "${figures}gph/"
	global figures_pdf "${figures}pdf/"
	global figures_png "${figures}png/"
global logfiles "${path}logfiles/"
global programs "${path}programs/"
global schemes "${path}schemes/"
global tables "${path}tables/"
	global tables_rtf "${tables}rtf/"
	global tables_tex "${tables}tex/"

* ______________________________________________________________________________
* Source datafiles

global evslg "${data_raw}EVS_longitudinal/ZA4804_v3-0-0.dta" // EVS Longitudinal

global ess1 "${data_raw}ESS_1/Country file/ESS1DE.dta" // ESS 1 Country file
global ess2 "${data_raw}ESS_2/Country file/ESS2DE.dta" // ESS 2 Country file
global ess3 "${data_raw}ESS_3/Country file/ESS3DE.dta" // ESS 3 Country file
global ess4 "${data_raw}ESS_4/Country file/ESS4DE.dta" // ESS 4 Country file
global ess5 "${data_raw}ESS_5/Country file/ESS5DE.dta" // ESS 5 Country file
global ess6 "${data_raw}ESS_6/Country file/ESS6DE.dta" // ESS 6 Country file
global ess7 "${data_raw}ESS_7/Country file/ESS7DE.dta" // ESS 7 Country file
global ess8 "${data_raw}ESS_8/Country file/ESS8DE.dta" // ESS 8 Country file

global ess1_cs "${data_raw}ESS_1/Country-specific data/ESS1csDE.dta" // ESS 1 Country-specific file
global ess2_cs "${data_raw}ESS_2/Country-specific data/ESS2csDE.dta" // ESS 2 Country-specific file
global ess3_cs "${data_raw}ESS_3/Country-specific data/ESS3csDE.dta" // ESS 3 Country-specific file
global ess4_cs "${data_raw}ESS_4/Country-specific data/ESS4csDE.dta" // ESS 4 Country-specific file
global ess5_cs "${data_raw}ESS_5/Country-specific data/ESS5csDE.dta" // ESS 5 Country-specific file
global ess6_cs "${data_raw}ESS_6/Country-specific data/ESS6csDE.dta" // ESS 6 Country-specific file
global ess7_cs "${data_raw}ESS_7/Country-specific data/ESS7csDE.dta" // ESS 7 Country-specific file
global ess8_cs "${data_raw}ESS_8/Country-specific data/ESS8csDE.dta" // ESS 8 Country-specific file

* ______________________________________________________________________________
* Source ESS miss do-file

global ess_miss "${data_raw}ESS_miss/ESS_miss.do" // Provided by ESS, handles missing data

* ______________________________________________________________________________
* Plot schemes: 

* 	Adds a scheme directory to the beginning of the search path stored in the 
* 	global macro S_ADO.

adopath ++ "${schemes}"
