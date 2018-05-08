# Description
This repository assembles material to reproduce the findings of Philippe Joly's paper entitled "Generations and Protest in Eastern Germany: Between Revolution and Apathy" (2018) in Stata (version 14 or more recent).

# Instructions 
A few steps are necessary to run the analysis.

## 1. Clone the repository

* Clone or download the repository on your own computer. 

## 2. Download the ESS data

* Go to the European Social Survey website and, from there, on [the page for Germany]( http://www.europeansocialsurvey.org/data/country.html?c=germany).

### 2.1. Country files

* Download the "country file (subset of integrated file)" in Stata format (.dta) for each of the eight ESS rounds. 
* Place the datafiles in their appropriate folder in `data/raw/`.
  * Example: `data/raw/ESS_1/Country file/ESS1DE.dta`
* Place the `ESS_miss.do` file provided by the ESS in `data/raw/ESS_miss/`.

### 2.2. Country-specific data

* Unfortunately, the ESS only provides country-specific data as SPSS portable files (.por)
* You will need to convert the files in .dta format.
  * The safest way to do this is to open the files in SPSS, from there, and to save them as .dta.
  * Another option (which I have not tried) would be to open the files in R using the `Hmisc` package and save them back to .dta using the `foreign` package.
* Once you have saved the eight datafiles, place them in their appropriate folder in `data/raw/`.
  * Example: `data/raw/ESS_1/Country-specific data/ESS1csDE.dta`

## 3. Download the EVS data

* If you want to reproduce Figure 1, download the EVS Longitudinal datafile from the [Gesis website]( https://dbk.gesis.org/dbksearch/SDesc2.asp?ll=10&notabs=&af=&nf=&search=&search2=&db=E&no=4804).
* Save the file as `data/raw/EVS_longitudinal/ZA4804_v3-0-0.dta`.

## 4. Set up your working directory

* The repository contains a do-file, `mydirectory.do`, which details the hierarchical structure of the repository and allows to save the path to each folder in global macros. 
* If you cloned the repository, the only change you would need to do is to add the path to your local copy of the repository.
  * Update the line `global path "N:/Analyses/protest-DE/"` with the path to your local copy of the repository. Be sure that your path ends with `/`
* Double-check that the path to the source datafiles is correct.
* Run `mydirectory.do` to save the global macros. 

## 5. Run the analysis

* Run `master.do`. 
