# Contents
1. Description
2. Raw data
3. Generated data
4. Instruction to reproduce the analysis

---

# 1 Description
This repository assembles documentation and scripts to reproduce the findings of Philippe Joly's paper entitled "Generations and Protest in Eastern Germany: Between Revolution and Apathy" (2018) in Stata (version 14 or more recent).

## 1.1 Abstract of the research project

How is the protest behavior of citizens in new democracies influenced by their experience of the past? Certain theories of political socialization hold that cohorts reaching political maturity under dictatorship are subject to apathy. Yet, it remains unclear whether mobilization during the transition can counterbalance this effect. This article examines the protest behavior of citizens socialized in Eastern Germany, a region marked by two legacies: a legacy of autocracy and, following the 1989-90 revolution, a legacy of transitional mobilization. Using age-period-cohort models with data from the European Social Survey, the analysis assesses the evolution of gaps in protest across generations and time between East and West Germans. The results demonstrate that participation in demonstrations, petitions, and boycotts is lower for East Germans socialized under communism in comparison with West Germans from the same cohorts. This participation deficit remains stable over time and even increases for certain protest activities.

## 1.2 What this repository contains

* Folders
  * `data/` contains empty subfolders where you can save the ESS raw data. Generated data will also be saved there.
  * `figures/` contains empty subfolders where figures will be saved in different formats: GPH, EMF, PDF, and PNG.
  * `logfiles/` is an empty folder where Stata logfiles will be stored.
  * `programs/` contains a series of do-files. Files with names like `export_*.do` are programms exporting tables and figures. The folder also contains Oesch's do-files to generate social class variables.
  * `schemes/` contains the file `minimal.scheme`, a Stata scheme I designed to export my figures.
  * `tables/` contains empty subfolders where tables will be saved in TEX or RTF formats.
* Do-files
  * `0_master.do` executes all do-files of the repository.
  * `1_cr1_evs.do` extracts raw EVS data, exports Figure 1, and saves EVS dataset.
  * `2_cr2_ess.do` extracts raw ESS data and produces dataset for analysis.
  * `3_an1.do` performs age-period-cohort (APC) analysis on ESS data.
  * `4_an2_robustness.do` runs robustness checks.
  * `mydirectory.do` loads paths to the folders of the repository in global macros.
* Markdown files
  * `codebook.md` is the codebook of the final dataset (based on ESS data).
  * `README.md` is the file you are currently reading.


# 2 Raw data
All the figures and tables, with the exception of Figure 1, are based on data from the European Social Survey (rounds 1 to 8).

Figure 1 is based on data from the European Values Study (EVS). In the theory section, it describes the protest experience of East and West Germans in 1990.

## 2.1 Conditions of use

Please consult the conditions of use of the [ESS]( http://www.europeansocialsurvey.org/data/conditions_of_use.html) and of the [EVS]( https://www.gesis.org/en/services/data-analysis/international-survey-programs/european-values-study/data-access/) before downloading the data. 

## 2.2 References

ESS. 2002. ESS Round 1: European Social Survey Round 1 Data. Data file edition 6.5. NSD - Norwegian Centre for Research Data, Norway - Data Archive and distributor of ESS data for ESS ERIC.

ESS. 2004. ESS Round 2: European Social Survey Round 2 Data. Data file edition 3.5. NSD - Norwegian Centre for Research Data, Norway - Data Archive and distributor of ESS data for ESS ERIC.

ESS. 2006. ESS Round 3: European Social Survey Round 3 Data. Data file edition 3.6. NSD - Norwegian Centre for Research Data, Norway - Data Archive and distributor of ESS data for ESS ERIC.

ESS. 2008. ESS Round 4: European Social Survey Round 4 Data. Data file edition 4.4. NSD - Norwegian Centre for Research Data, Norway - Data Archive and distributor of ESS data for ESS ERIC.

ESS. 2010. ESS Round 5: European Social Survey Round 5 Data. Data file edition 3.3. NSD - Norwegian Centre for Research Data, Norway - Data Archive and distributor of ESS data for ESS ERIC.

ESS. 2012. ESS Round 6: European Social Survey Round 6 Data. Data file edition 2.3. NSD - Norwegian Centre for Research Data, Norway - Data Archive and distributor of ESS data for ESS ERIC.

ESS. 2014. ESS Round 7: European Social Survey Round 7 Data. Data file edition 2.1. NSD - Norwegian Centre for Research Data, Norway - Data Archive and distributor of ESS data for ESS ERIC.

ESS. 2016. ESS Round 8: European Social Survey Round 8 Data. Data file edition 2.0. NSD - Norwegian Centre for Research Data, Norway - Data Archive and distributor of ESS data for ESS ERIC.

EVS. 2015. European Values Study Longitudinal Data File 1981-2008, ZA4804 Data File, Version 3.0.0. Cologne: GESIS Data Archive.DOI 10.4232/1.12253


# 3 Generated data and codebook

Transformations operated on the ESS data are described in the do-file, `2_cr2_ess.do`. Data is generated by recoding existing variables in the ESS. For most variables, this involved minimal transformation (e.g., renaming or merging categories together). 

## Socialization in Eastern Germany

More work was necessary to generate the variable `eastsoc`, which tags respondents as East or West Germans based on where they grew up. A respondent is said to have been socialized in Eastern Germany (coded '1', otherwise '0') if he or she has spent the majority of his or her early formative years (from 15 to 25 years old) in this region.

## Social classes

Social classes were coded using [scripts provided by Daniel Oesch](http://people.unil.ch/danieloesch/scripts/). These do-files recode occupation variables in the ESS to create 5-, 8-, or 16-class schemas. This paper uses the 5-class schema.

See:

Oesch, Daniel. 2006a. "Coming to Grips with a Changing Class Structure: An Analysis of Employment Stratification in Britain, Germany, Sweden and Switzerland." _International Sociology_ 21(2):263-88.

Oesch, Daniel. 2006b. _Redrawing the Class Map: Stratification and Institutions in Britain, Germany, Sweden and Switzerland_. Houndmills, Basingstoke, Hampshire: Palgrave Macmillan.

## Codebook

Running `2_cr2_ess.do` will transform the ESS raw data to produce a final dataset, `ess.dta`. The repository contains a **codebook**, `codebook.md`, describing all variables in the final dataset.


# 4 Instructions to reproduce the analysis
A few steps are necessary to run the analysis.


## Step 1: Clone the repository

* Clone or download the repository on your own computer. 

## Step 2: Download the ESS data

* Go to the European Social Survey website and, from there, on [Germany's page]( http://www.europeansocialsurvey.org/data/country.html?c=germany).

### a) Country files

* Download the "country file (subset of integrated file)" in Stata format (DTA) for each of the eight ESS rounds. 
* Place the datafiles in their appropriate folder in `data/raw/`.
  * Example: `data/raw/ESS_1/Country file/ESS1DE.dta`

### b) Country-specific data

* Unfortunately, the ESS only provides country-specific data as SPSS portable files (POR).
* You will need to obtain files in DTA format.
  * The safest way to do this is to open the POR files in SPSS and, from there, to save them as DTA.
  * Another option would be to open the files in R using the `foreign` package and save them back to DTA.
  * Finally, I also make the DTA files available on [my OSF page](https://osf.io/7cjt8/).
* Once you have downloaded the eight datafiles, place them in their appropriate folder in `data/raw/`.
  * Example: `data/raw/ESS_1/Country-specific data/ESS1csDE.dta`

## Step 3: Download the EVS data

* To reproduce Figure 1, download the EVS Longitudinal datafile from the [Gesis website]( https://dbk.gesis.org/dbksearch/SDesc2.asp?ll=10&notabs=&af=&nf=&search=&search2=&db=E&no=4804).
* Save the file as `data/raw/EVS_longitudinal/ZA4804_v3-0-0.dta`.

## Step 4: Set up your working directory

* The repository contains a do-file, `mydirectory.do`, which details the hierarchical structure of the repository and allows to save the path to each folder in global macros. 
* If you cloned the repository, the only change you would need to do is to add the path to your local copy of the repository.
  * Update the line `global path "N:/Analyses/protest-DE/"` with the path to your local copy of the repository. Be sure that your path ends with `/`
* Double-check that the paths to the source datafiles are correct.
* Run `mydirectory.do` to save the global macros. 

## Step 5: Run the analysis

* Run `0_master.do`. 
