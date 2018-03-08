*********************************************************************************************************************************************
* OESCH CLASS SCHEMA
* Create 16-Class schema, 8-Class schema and 5-Class schema
* Data: ESS round 6 - 2012
* May 2014
* Amal Tawfik, University of Geneva
*********************************************************************************************************************************************

**** References:
**** Oesch, D. (2006a) "Coming to grips with a changing class structure" International Sociology 21 (2): 263-288.
**** Oesch, D. (2006b) "Redrawing the Class Map. Stratification and Institutions in Britain, Germany, Sweden and Switzerland", Basingstoke: Palgrave Macmillan.
**** A few minor changes were made with respect to the procedure described in these two sources (decisions taken by Oesch and Tawfik in 2014)

**** 16-Class schema constructed
  *1 Large employers
  *2 Self-employed professionals
  *3 Small business owners with employees
  *4 Small business owners without employees
  *5 Technical experts
  *6 Technicians
  *7 Skilled manual
  *8 Low-skilled manual
  *9 Higher-grade managers and administrators
  *10 Lower-grade managers and administrators
  *11 Skilled clerks
  *12 Unskilled clerks
  *13 Socio-cultural professionals
  *14 Socio-cultural semi-professionals
  *15 Skilled service
  *16 Low-skilled service

**** 8-Class schema constructed
  *1 Self-employed professionals and large employers
  *2 Small business owners
  *3 Technical (semi-)professionals
  *4 Production workers
  *5 (Associate) managers
  *6 Clerks
  *7 Socio-cultural (semi-)professionals
  *8 Service workers

**** 5-Class schema constructed
  *1 Higher-grade service class
  *2 Lower-grade service class
  *3 Small business owners
  *4 Skilled workers
  *5 Unskilled workers
  
**** WARNING: before you execute this syntax, you have to execute the "ESS_miss.do" syntax file that accompanies the ESS round 6 - 2012 file

**** Variables used to construct Oesch class schema: isco08, emplrel, emplno, isco08p, emprelp

****************************************************************************************
* Respondent's Oesch class position
* Recode and create variables used to construct class variable for respondents
* Variables used to construct class variable for respondents: isco08, emplrel, emplno
****************************************************************************************

**** Recode occupation variable (isco08 com 4-digit) for respondents

tab isco08

recode isco08 (missing=-9), copyrest gen(isco_mainjob)
label variable isco_mainjob "Current occupation of respondent - isco88 4-digit"
tab isco_mainjob

**** Recode employment status for respondents

tab emplrel 

recode emplrel (missing=9), copyrest gen(emplrel_r)
label define emplrel_r ///
1 "Employee" ///
2 "Self-employed" ///
3 "Working for own family business" ///
9 "Missing"
label value emplrel_r emplrel_r
tab emplrel_r

tab emplno

recode emplno (0=0)(1/9=1)(10/10000=2)(missing=0), gen(emplno_r)
label define emplno_r ///
0 "0 employees" ///
1 "1-9 employees" ///
2 "10+ employees"
label value emplno_r emplno_r
tab emplno_r

gen selfem_mainjob=.
replace selfem_mainjob=1 if emplrel_r==1 | emplrel_r==9
replace selfem_mainjob=2 if emplrel_r==2 & emplno_r==0
replace selfem_mainjob=2 if emplrel_r==3
replace selfem_mainjob=3 if emplrel_r==2 & emplno_r==1
replace selfem_mainjob=4 if emplrel_r==2 & emplno_r==2
label variable selfem_mainjob "Employment status for respondants"
label define selfem_mainjob ///
1 "Not self-employed" ///
2 "Self-empl without employees" ///
3 "Self-empl with 1-9 employees" ///
4 "Self-empl with 10 or more"
label value selfem_mainjob selfem_mainjob
tab selfem_mainjob


*************************************************
* Create Oesch class schema for respondents
*************************************************

gen class16_r = -9.

* Large employers (1)

replace class16_r=1 if selfem_mainjob==4

* Self-employed professionals (2)

replace class16_r=2 if (selfem_mainjob==2 | selfem_mainjob==3) & (isco_mainjob >= 2000 & isco_mainjob <= 2162) 
replace class16_r=2 if (selfem_mainjob==2 | selfem_mainjob==3) & (isco_mainjob >= 2164 & isco_mainjob <= 2165) 
replace class16_r=2 if (selfem_mainjob==2 | selfem_mainjob==3) & (isco_mainjob >= 2200 & isco_mainjob <= 2212) 
replace class16_r=2 if (selfem_mainjob==2 | selfem_mainjob==3) & (isco_mainjob == 2250)
replace class16_r=2 if (selfem_mainjob==2 | selfem_mainjob==3) & (isco_mainjob >= 2261 & isco_mainjob <= 2262)
replace class16_r=2 if (selfem_mainjob==2 | selfem_mainjob==3) & (isco_mainjob >= 2300 & isco_mainjob <= 2330)
replace class16_r=2 if (selfem_mainjob==2 | selfem_mainjob==3) & (isco_mainjob >= 2350 & isco_mainjob <= 2352)
replace class16_r=2 if (selfem_mainjob==2 | selfem_mainjob==3) & (isco_mainjob >= 2359 & isco_mainjob <= 2432)
replace class16_r=2 if (selfem_mainjob==2 | selfem_mainjob==3) & (isco_mainjob >= 2500 & isco_mainjob <= 2619)
replace class16_r=2 if (selfem_mainjob==2 | selfem_mainjob==3) & (isco_mainjob == 2621)
replace class16_r=2 if (selfem_mainjob==2 | selfem_mainjob==3) & (isco_mainjob >= 2630 & isco_mainjob <= 2634)
replace class16_r=2 if (selfem_mainjob==2 | selfem_mainjob==3) & (isco_mainjob >= 2636 & isco_mainjob <= 2640)
replace class16_r=2 if (selfem_mainjob==2 | selfem_mainjob==3) & (isco_mainjob >= 2642 & isco_mainjob <= 2643)

* Small business owners with employees (3)

replace class16_r=3 if (selfem_mainjob==3) & (isco_mainjob >= 1000 & isco_mainjob <= 1439)
replace class16_r=3 if (selfem_mainjob==3) & (isco_mainjob == 2163)
replace class16_r=3 if (selfem_mainjob==3) & (isco_mainjob == 2166)
replace class16_r=3 if (selfem_mainjob==3) & (isco_mainjob >= 2220 & isco_mainjob <= 2240)
replace class16_r=3 if (selfem_mainjob==3) & (isco_mainjob == 2260)
replace class16_r=3 if (selfem_mainjob==3) & (isco_mainjob >= 2263 & isco_mainjob <= 2269)
replace class16_r=3 if (selfem_mainjob==3) & (isco_mainjob >= 2340 & isco_mainjob <= 2342)
replace class16_r=3 if (selfem_mainjob==3) & (isco_mainjob >= 2353 & isco_mainjob <= 2356)
replace class16_r=3 if (selfem_mainjob==3) & (isco_mainjob >= 2433 & isco_mainjob <= 2434)
replace class16_r=3 if (selfem_mainjob==3) & (isco_mainjob == 2620)
replace class16_r=3 if (selfem_mainjob==3) & (isco_mainjob == 2622)
replace class16_r=3 if (selfem_mainjob==3) & (isco_mainjob == 2635)
replace class16_r=3 if (selfem_mainjob==3) & (isco_mainjob == 2641)
replace class16_r=3 if (selfem_mainjob==3) & (isco_mainjob >= 2650 & isco_mainjob <= 2659)
replace class16_r=3 if (selfem_mainjob==3) & (isco_mainjob >= 3000 & isco_mainjob <= 9629)

* Small business owners without employees (4)

replace class16_r=4 if (selfem_mainjob==2) & (isco_mainjob >= 1000 & isco_mainjob <= 1439)
replace class16_r=4 if (selfem_mainjob==2) & (isco_mainjob == 2163)
replace class16_r=4 if (selfem_mainjob==2) & (isco_mainjob == 2166)
replace class16_r=4 if (selfem_mainjob==2) & (isco_mainjob >= 2220 & isco_mainjob <= 2240)
replace class16_r=4 if (selfem_mainjob==2) & (isco_mainjob == 2260)
replace class16_r=4 if (selfem_mainjob==2) & (isco_mainjob >= 2263 & isco_mainjob <= 2269)
replace class16_r=4 if (selfem_mainjob==2) & (isco_mainjob >= 2340 & isco_mainjob <= 2342)
replace class16_r=4 if (selfem_mainjob==2) & (isco_mainjob >= 2353 & isco_mainjob <= 2356)
replace class16_r=4 if (selfem_mainjob==2) & (isco_mainjob >= 2433 & isco_mainjob <= 2434)
replace class16_r=4 if (selfem_mainjob==2) & (isco_mainjob == 2620)
replace class16_r=4 if (selfem_mainjob==2) & (isco_mainjob == 2622)
replace class16_r=4 if (selfem_mainjob==2) & (isco_mainjob == 2635)
replace class16_r=4 if (selfem_mainjob==2) & (isco_mainjob == 2641)
replace class16_r=4 if (selfem_mainjob==2) & (isco_mainjob >= 2650 & isco_mainjob <= 2659)
replace class16_r=4 if (selfem_mainjob==2) & (isco_mainjob >= 3000 & isco_mainjob <= 9629)

* Technical experts (5)

replace class16_r=5 if (selfem_mainjob==1) & (isco_mainjob >= 2100 & isco_mainjob <= 2162)
replace class16_r=5 if (selfem_mainjob==1) & (isco_mainjob >= 2164 & isco_mainjob <= 2165)
replace class16_r=5 if (selfem_mainjob==1) & (isco_mainjob >= 2500 & isco_mainjob <= 2529)

* Technicians (6)

replace class16_r=6 if (selfem_mainjob==1) & (isco_mainjob >= 3100 & isco_mainjob <= 3155)
replace class16_r=6 if (selfem_mainjob==1) & (isco_mainjob >= 3210 & isco_mainjob <= 3214)
replace class16_r=6 if (selfem_mainjob==1) & (isco_mainjob == 3252)
replace class16_r=6 if (selfem_mainjob==1) & (isco_mainjob >= 3500 & isco_mainjob <= 3522)

* Skilled manual (7)

replace class16_r=7 if (selfem_mainjob==1) & (isco_mainjob >= 6000 & isco_mainjob <= 7549)
replace class16_r=7 if (selfem_mainjob==1) & (isco_mainjob >= 8310 & isco_mainjob <= 8312)
replace class16_r=7 if (selfem_mainjob==1) & (isco_mainjob == 8330)
replace class16_r=7 if (selfem_mainjob==1) & (isco_mainjob >= 8332 & isco_mainjob <= 8340)
replace class16_r=7 if (selfem_mainjob==1) & (isco_mainjob >= 8342 & isco_mainjob <= 8344)

* Low-skilled manual (8)

replace class16_r=8 if (selfem_mainjob==1) & (isco_mainjob >= 8000 & isco_mainjob <= 8300)
replace class16_r=8 if (selfem_mainjob==1) & (isco_mainjob >= 8320 & isco_mainjob <= 8321)
replace class16_r=8 if (selfem_mainjob==1) & (isco_mainjob == 8341)
replace class16_r=8 if (selfem_mainjob==1) & (isco_mainjob == 8350)
replace class16_r=8 if (selfem_mainjob==1) & (isco_mainjob >= 9200 & isco_mainjob <= 9334)
replace class16_r=8 if (selfem_mainjob==1) & (isco_mainjob >= 9600 & isco_mainjob <= 9620)
replace class16_r=8 if (selfem_mainjob==1) & (isco_mainjob >= 9622 & isco_mainjob <= 9629)

* Higher-grade managers and administrators (9)

replace class16_r=9 if (selfem_mainjob==1) & (isco_mainjob >= 1000 & isco_mainjob <= 1300)
replace class16_r=9 if (selfem_mainjob==1) & (isco_mainjob >= 1320 & isco_mainjob <= 1349)
replace class16_r=9 if (selfem_mainjob==1) & (isco_mainjob >= 2400 & isco_mainjob <= 2432)
replace class16_r=9 if (selfem_mainjob==1) & (isco_mainjob >= 2610 & isco_mainjob <= 2619)
replace class16_r=9 if (selfem_mainjob==1) & (isco_mainjob == 2631)
replace class16_r=9 if (selfem_mainjob==1) & (isco_mainjob >= 100 & isco_mainjob <= 110)

* Lower-grade managers and administrators (10)

replace class16_r=10 if (selfem_mainjob==1) & (isco_mainjob >= 1310 & isco_mainjob <= 1312)
replace class16_r=10 if (selfem_mainjob==1) & (isco_mainjob >= 1400 & isco_mainjob <= 1439)
replace class16_r=10 if (selfem_mainjob==1) & (isco_mainjob >= 2433 & isco_mainjob <= 2434)
replace class16_r=10 if (selfem_mainjob==1) & (isco_mainjob >= 3300 & isco_mainjob <= 3339)
replace class16_r=10 if (selfem_mainjob==1) & (isco_mainjob == 3343)
replace class16_r=10 if (selfem_mainjob==1) & (isco_mainjob >= 3350 & isco_mainjob <= 3359)
replace class16_r=10 if (selfem_mainjob==1) & (isco_mainjob == 3411)
replace class16_r=10 if (selfem_mainjob==1) & (isco_mainjob == 5221)
replace class16_r=10 if (selfem_mainjob==1) & (isco_mainjob >= 200 & isco_mainjob <= 210)

* Skilled clerks (11)

replace class16_r=11 if (selfem_mainjob==1) & (isco_mainjob >= 3340 & isco_mainjob <= 3342)
replace class16_r=11 if (selfem_mainjob==1) & (isco_mainjob == 3344)
replace class16_r=11 if (selfem_mainjob==1) & (isco_mainjob >= 4000 & isco_mainjob <= 4131)
replace class16_r=11 if (selfem_mainjob==1) & (isco_mainjob >= 4200 & isco_mainjob <= 4221)
replace class16_r=11 if (selfem_mainjob==1) & (isco_mainjob >= 4224 & isco_mainjob <= 4413)
replace class16_r=11 if (selfem_mainjob==1) & (isco_mainjob >= 4415 & isco_mainjob <= 4419)

* Unskilled clerks (12)

replace class16_r=12 if (selfem_mainjob==1) & (isco_mainjob == 4132)
replace class16_r=12 if (selfem_mainjob==1) & (isco_mainjob == 4222)
replace class16_r=12 if (selfem_mainjob==1) & (isco_mainjob == 4223)
replace class16_r=12 if (selfem_mainjob==1) & (isco_mainjob == 5230)
replace class16_r=12 if (selfem_mainjob==1) & (isco_mainjob == 9621)

* Socio-cultural professionals (13)

replace class16_r=13 if (selfem_mainjob==1) & (isco_mainjob >= 2200 &  isco_mainjob <= 2212)
replace class16_r=13 if (selfem_mainjob==1) & (isco_mainjob == 2250)
replace class16_r=13 if (selfem_mainjob==1) & (isco_mainjob >= 2261 &  isco_mainjob <= 2262)
replace class16_r=13 if (selfem_mainjob==1) & (isco_mainjob >= 2300 &  isco_mainjob <= 2330)
replace class16_r=13 if (selfem_mainjob==1) & (isco_mainjob >= 2350 &  isco_mainjob <= 2352)
replace class16_r=13 if (selfem_mainjob==1) & (isco_mainjob == 2359)
replace class16_r=13 if (selfem_mainjob==1) & (isco_mainjob == 2600)
replace class16_r=13 if (selfem_mainjob==1) & (isco_mainjob == 2621)
replace class16_r=13 if (selfem_mainjob==1) & (isco_mainjob == 2630)
replace class16_r=13 if (selfem_mainjob==1) & (isco_mainjob >= 2632 &  isco_mainjob <= 2634)
replace class16_r=13 if (selfem_mainjob==1) & (isco_mainjob >= 2636 &  isco_mainjob <= 2640)
replace class16_r=13 if (selfem_mainjob==1) & (isco_mainjob >= 2642 &  isco_mainjob <= 2643)

* Socio-cultural semi-professionals (14)

replace class16_r=14 if (selfem_mainjob==1) & (isco_mainjob == 2163)
replace class16_r=14 if (selfem_mainjob==1) & (isco_mainjob == 2166)
replace class16_r=14 if (selfem_mainjob==1) & (isco_mainjob >= 2220 & isco_mainjob <= 2240)
replace class16_r=14 if (selfem_mainjob==1) & (isco_mainjob == 2260)
replace class16_r=14 if (selfem_mainjob==1) & (isco_mainjob >= 2263 & isco_mainjob <= 2269)
replace class16_r=14 if (selfem_mainjob==1) & (isco_mainjob >= 2340 & isco_mainjob <= 2342)
replace class16_r=14 if (selfem_mainjob==1) & (isco_mainjob >= 2353 & isco_mainjob <= 2356)
replace class16_r=14 if (selfem_mainjob==1) & (isco_mainjob == 2620)
replace class16_r=14 if (selfem_mainjob==1) & (isco_mainjob == 2622)
replace class16_r=14 if (selfem_mainjob==1) & (isco_mainjob == 2635)
replace class16_r=14 if (selfem_mainjob==1) & (isco_mainjob == 2641)
replace class16_r=14 if (selfem_mainjob==1) & (isco_mainjob >= 2650 & isco_mainjob <= 2659)
replace class16_r=14 if (selfem_mainjob==1) & (isco_mainjob == 3200)
replace class16_r=14 if (selfem_mainjob==1) & (isco_mainjob >= 3220 & isco_mainjob <= 3230)
replace class16_r=14 if (selfem_mainjob==1) & (isco_mainjob == 3250)
replace class16_r=14 if (selfem_mainjob==1) & (isco_mainjob >= 3253 & isco_mainjob <= 3257)
replace class16_r=14 if (selfem_mainjob==1) & (isco_mainjob == 3259)
replace class16_r=14 if (selfem_mainjob==1) & (isco_mainjob >= 3400 & isco_mainjob <= 3410)
replace class16_r=14 if (selfem_mainjob==1) & (isco_mainjob >= 3412 & isco_mainjob <= 3413)
replace class16_r=14 if (selfem_mainjob==1) & (isco_mainjob >= 3430 & isco_mainjob <= 3433)
replace class16_r=14 if (selfem_mainjob==1) & (isco_mainjob == 3435)
replace class16_r=14 if (selfem_mainjob==1) & (isco_mainjob == 4414)

* Skilled service (15)

replace class16_r=15 if (selfem_mainjob==1) & (isco_mainjob == 3240)
replace class16_r=15 if (selfem_mainjob==1) & (isco_mainjob == 3251)
replace class16_r=15 if (selfem_mainjob==1) & (isco_mainjob == 3258)
replace class16_r=15 if (selfem_mainjob==1) & (isco_mainjob >= 3420 & isco_mainjob <= 3423)
replace class16_r=15 if (selfem_mainjob==1) & (isco_mainjob == 3434)
replace class16_r=15 if (selfem_mainjob==1) & (isco_mainjob >= 5000 & isco_mainjob <= 5120)
replace class16_r=15 if (selfem_mainjob==1) & (isco_mainjob >= 5140 & isco_mainjob <= 5142)
replace class16_r=15 if (selfem_mainjob==1) & (isco_mainjob == 5163)
replace class16_r=15 if (selfem_mainjob==1) & (isco_mainjob == 5165)
replace class16_r=15 if (selfem_mainjob==1) & (isco_mainjob == 5200)
replace class16_r=15 if (selfem_mainjob==1) & (isco_mainjob == 5220)
replace class16_r=15 if (selfem_mainjob==1) & (isco_mainjob >= 5222 & isco_mainjob <= 5223)
replace class16_r=15 if (selfem_mainjob==1) & (isco_mainjob >= 5241 & isco_mainjob <= 5242)
replace class16_r=15 if (selfem_mainjob==1) & (isco_mainjob >= 5300 & isco_mainjob <= 5321)
replace class16_r=15 if (selfem_mainjob==1) & (isco_mainjob >= 5400 & isco_mainjob <= 5413)
replace class16_r=15 if (selfem_mainjob==1) & (isco_mainjob == 5419)
replace class16_r=15 if (selfem_mainjob==1) & (isco_mainjob == 8331)

* Low-skilled service (16)

replace class16_r=16 if (selfem_mainjob==1) & (isco_mainjob >= 5130 & isco_mainjob <= 5132)
replace class16_r=16 if (selfem_mainjob==1) & (isco_mainjob >= 5150 & isco_mainjob <= 5162)
replace class16_r=16 if (selfem_mainjob==1) & (isco_mainjob == 5164)
replace class16_r=16 if (selfem_mainjob==1) & (isco_mainjob == 5169)
replace class16_r=16 if (selfem_mainjob==1) & (isco_mainjob >= 5210 & isco_mainjob <= 5212)
replace class16_r=16 if (selfem_mainjob==1) & (isco_mainjob == 5240)
replace class16_r=16 if (selfem_mainjob==1) & (isco_mainjob >= 5243 & isco_mainjob <= 5249)
replace class16_r=16 if (selfem_mainjob==1) & (isco_mainjob >= 5322 & isco_mainjob <= 5329)
replace class16_r=16 if (selfem_mainjob==1) & (isco_mainjob == 5414)
replace class16_r=16 if (selfem_mainjob==1) & (isco_mainjob == 8322)
replace class16_r=16 if (selfem_mainjob==1) & (isco_mainjob >= 9100 & isco_mainjob <= 9129)
replace class16_r=16 if (selfem_mainjob==1) & (isco_mainjob >= 9400 & isco_mainjob <= 9520)

mvdecode class16_r, mv(-9)
label variable class16_r "Respondent's Oesch class position - 16 classes"
label define class16_r ///
1 "Large employers" ///
2 "Self-employed professionals" ///
3 "Small business owners with employees" ///
4 "Small business owners without employees" ///
5 "Technical experts" ///
6 "Technicians" ///
7 "Skilled manual" ///
8 "Low-skilled manual" ///
9 "Higher-grade managers and administrators" ///
10 "Lower-grade managers and administrators" ///
11 "Skilled clerks" ///
12 "Unskilled clerks" ///
13 "Socio-cultural professionals" ///
14 "Socio-cultural semi-professionals" ///
15 "Skilled service" ///
16 "Low-skilled service"
label value class16_r class16_r
tab class16_r

recode class16_r (1 2=1)(3 4=2)(5 6=3)(7 8=4)(9 10=5)(11 12=6)(13 14=7)(15 16=8), gen(class8_r)
label variable class8_r "Respondent's Oesch class position - 8 classes"
label define class8_r ///
1 "Self-employed professionals and large employers" ///
2 "Small business owners" ///
3 "Technical (semi-)professionals" ///
4 "Production workers" ///
5 "(Associate) managers" ///
6 "Clerks" ///
7 "Socio-cultural (semi-)professionals" ///
8 "Service workers"
label value class8_r class8_r
tab class8_r

recode class16_r (1 2 5 9 13=1)(6 10 14=2)(3 4=3)(7 11 15=4)(8 12 16=5), gen(class5_r)
label variable class5_r "Respondent's Oesch class position - 5 classes"
label define  class5_r ///
1 "Higher-grade service class" ///
2 "Lower-grade service class" ///
3 "Small business owners" ///
4 "Skilled workers" ///
5 "Unskilled workers"
label value class5_r class5_r
tab class5_r


***************************************************************************************
* Partner's Oesch class position
* Recode and create variables used to construct class variable for partners
* Variables used to construct class variable for partners: isco08p, emprelp
***************************************************************************************

**** Recode occupation variable (isco88 com 4-digit) for partners

tab isco08p

recode isco08p (missing=-9), copyrest gen(isco_partner)
label variable isco_partner "Current occupation of partner - isco88 4-digit" 
tab isco_partner

**** Recode employment status for partners

tab emprelp

recode emprelp (1=1)(2 3=2)(missing=1), gen(selfem_partner)
label variable selfem_partner "Employment status for partners"
label define selfem_partner ///
1"Not self-employed" ///
2"Self-employed"
label value selfem_partner selfem_partner
tab selfem_partner

********************************************
* Create Oesch class schema for partners 
********************************************

gen class16_p = -9

* Large employers (1)



* Self-employed professionals (2)

replace class16_p=2 if (selfem_partner==2) & (isco_partner >= 2000 & isco_partner <= 2162)
replace class16_p=2 if (selfem_partner==2) & (isco_partner >= 2164 & isco_partner <= 2165)
replace class16_p=2 if (selfem_partner==2) & (isco_partner >= 2200 & isco_partner <= 2212)
replace class16_p=2 if (selfem_partner==2) & (isco_partner == 2250)
replace class16_p=2 if (selfem_partner==2) & (isco_partner >= 2261 & isco_partner <= 2262)
replace class16_p=2 if (selfem_partner==2) & (isco_partner >= 2300 & isco_partner <= 2330)
replace class16_p=2 if (selfem_partner==2) & (isco_partner >= 2350 & isco_partner <= 2352)
replace class16_p=2 if (selfem_partner==2) & (isco_partner >= 2359 & isco_partner <= 2432)
replace class16_p=2 if (selfem_partner==2) & (isco_partner >= 2500 & isco_partner <= 2619)
replace class16_p=2 if (selfem_partner==2) & (isco_partner == 2621)
replace class16_p=2 if (selfem_partner==2) & (isco_partner >= 2630 & isco_partner <= 2634)
replace class16_p=2 if (selfem_partner==2) & (isco_partner >= 2636 & isco_partner <= 2640)
replace class16_p=2 if (selfem_partner==2) & (isco_partner >= 2642 & isco_partner <= 2643)

* Small business owners with employees (3)
 


* Small business owners without employees (4)

replace class16_p=4 if (selfem_partner==2) & (isco_partner >= 1000 & isco_partner <= 1439)
replace class16_p=4 if (selfem_partner==2) & (isco_partner == 2163)
replace class16_p=4 if (selfem_partner==2) & (isco_partner == 2166)
replace class16_p=4 if (selfem_partner==2) & (isco_partner >= 2220 & isco_partner <= 2240)
replace class16_p=4 if (selfem_partner==2) & (isco_partner == 2260)
replace class16_p=4 if (selfem_partner==2) & (isco_partner >= 2263 & isco_partner <= 2269)
replace class16_p=4 if (selfem_partner==2) & (isco_partner >= 2340 & isco_partner <= 2342)
replace class16_p=4 if (selfem_partner==2) & (isco_partner >= 2353 & isco_partner <= 2356)
replace class16_p=4 if (selfem_partner==2) & (isco_partner >= 2433 & isco_partner <= 2434)
replace class16_p=4 if (selfem_partner==2) & (isco_partner == 2620)
replace class16_p=4 if (selfem_partner==2) & (isco_partner == 2622)
replace class16_p=4 if (selfem_partner==2) & (isco_partner == 2635)
replace class16_p=4 if (selfem_partner==2) & (isco_partner == 2641)
replace class16_p=4 if (selfem_partner==2) & (isco_partner >= 2650 & isco_partner <= 2659)
replace class16_p=4 if (selfem_partner==2) & (isco_partner >= 3000 & isco_partner <= 9629)

* Technical experts (5)

replace class16_p=5 if (selfem_partner==1) & (isco_partner >= 2100 & isco_partner <= 2162)
replace class16_p=5 if (selfem_partner==1) & (isco_partner >= 2164 & isco_partner <= 2165)
replace class16_p=5 if (selfem_partner==1) & (isco_partner >= 2500 & isco_partner <= 2529)

* Technicians (6)

replace class16_p=6 if (selfem_partner==1) & (isco_partner >= 3100 & isco_partner <= 3155)
replace class16_p=6 if (selfem_partner==1) & (isco_partner >= 3210 & isco_partner <= 3214)
replace class16_p=6 if (selfem_partner==1) & (isco_partner == 3252)
replace class16_p=6 if (selfem_partner==1) & (isco_partner >= 3500 & isco_partner <= 3522)

* Skilled manual (7)

replace class16_p=7 if (selfem_partner==1) & (isco_partner >= 6000 & isco_partner <= 7549)
replace class16_p=7 if (selfem_partner==1) & (isco_partner >= 8310 & isco_partner <= 8312)
replace class16_p=7 if (selfem_partner==1) & (isco_partner == 8330)
replace class16_p=7 if (selfem_partner==1) & (isco_partner >= 8332 & isco_partner <= 8340)
replace class16_p=7 if (selfem_partner==1) & (isco_partner >= 8342 & isco_partner <= 8344)

* Low-skilled manual (8)

replace class16_p=8 if (selfem_partner==1) & (isco_partner >= 8000 & isco_partner <= 8300)
replace class16_p=8 if (selfem_partner==1) & (isco_partner >= 8320 & isco_partner <= 8321)
replace class16_p=8 if (selfem_partner==1) & (isco_partner == 8341)
replace class16_p=8 if (selfem_partner==1) & (isco_partner == 8350)
replace class16_p=8 if (selfem_partner==1) & (isco_partner >= 9200 & isco_partner <= 9334)
replace class16_p=8 if (selfem_partner==1) & (isco_partner >= 9600 & isco_partner <= 9620)
replace class16_p=8 if (selfem_partner==1) & (isco_partner >= 9622 & isco_partner <= 9629)

* Higher-grade managers and administrators (9)

replace class16_p=9 if (selfem_partner==1) & (isco_partner >= 1000 & isco_partner <= 1300)
replace class16_p=9 if (selfem_partner==1) & (isco_partner >= 1320 & isco_partner <= 1349)
replace class16_p=9 if (selfem_partner==1) & (isco_partner >= 2400 & isco_partner <= 2432)
replace class16_p=9 if (selfem_partner==1) & (isco_partner >= 2610 & isco_partner <= 2619)
replace class16_p=9 if (selfem_partner==1) & (isco_partner == 2631)
replace class16_p=9 if (selfem_partner==1) & (isco_partner >= 100 & isco_partner <= 110)

* Lower-grade managers and administrators (10)


replace class16_p=10 if (selfem_partner==1) & (isco_partner >= 1310 & isco_partner <= 1312)
replace class16_p=10 if (selfem_partner==1) & (isco_partner >= 1400 & isco_partner <= 1439)
replace class16_p=10 if (selfem_partner==1) & (isco_partner >= 2433 & isco_partner <= 2434)
replace class16_p=10 if (selfem_partner==1) & (isco_partner >= 3300 & isco_partner <= 3339)
replace class16_p=10 if (selfem_partner==1) & (isco_partner == 3343)
replace class16_p=10 if (selfem_partner==1) & (isco_partner >= 3350 & isco_partner <= 3359)
replace class16_p=10 if (selfem_partner==1) & (isco_partner == 3411)
replace class16_p=10 if (selfem_partner==1) & (isco_partner == 5221)
replace class16_p=10 if (selfem_partner==1) & (isco_partner >= 200 & isco_partner <= 210)

* Skilled clerks (11)

replace class16_p=11 if (selfem_partner==1) & (isco_partner >= 3340 & isco_partner <= 3342)
replace class16_p=11 if (selfem_partner==1) & (isco_partner == 3344)
replace class16_p=11 if (selfem_partner==1) & (isco_partner >= 4000 & isco_partner <= 4131)
replace class16_p=11 if (selfem_partner==1) & (isco_partner >= 4200 & isco_partner <= 4221)
replace class16_p=11 if (selfem_partner==1) & (isco_partner >= 4224 & isco_partner <= 4413)
replace class16_p=11 if (selfem_partner==1) & (isco_partner >= 4415 & isco_partner <= 4419)

* Unskilled clerks (12)

replace class16_p=12 if (selfem_partner==1) & (isco_partner == 4132)
replace class16_p=12 if (selfem_partner==1) & (isco_partner == 4222)
replace class16_p=12 if (selfem_partner==1) & (isco_partner == 4223)
replace class16_p=12 if (selfem_partner==1) & (isco_partner == 5230)
replace class16_p=12 if (selfem_partner==1) & (isco_partner == 9621)

* Socio-cultural professionals (13)

replace class16_p=13 if (selfem_partner==1) & (isco_partner >= 2200 & isco_partner <= 2212)
replace class16_p=13 if (selfem_partner==1) & (isco_partner == 2250)
replace class16_p=13 if (selfem_partner==1) & (isco_partner >= 2261 & isco_partner <= 2262)
replace class16_p=13 if (selfem_partner==1) & (isco_partner >= 2300 & isco_partner <= 2330)
replace class16_p=13 if (selfem_partner==1) & (isco_partner >= 2350 & isco_partner <= 2352)
replace class16_p=13 if (selfem_partner==1) & (isco_partner == 2359)
replace class16_p=13 if (selfem_partner==1) & (isco_partner == 2600)
replace class16_p=13 if (selfem_partner==1) & (isco_partner == 2621)
replace class16_p=13 if (selfem_partner==1) & (isco_partner == 2630)
replace class16_p=13 if (selfem_partner==1) & (isco_partner >= 2632 & isco_partner <= 2634)
replace class16_p=13 if (selfem_partner==1) & (isco_partner >= 2636 & isco_partner <= 2640)
replace class16_p=13 if (selfem_partner==1) & (isco_partner >= 2642 & isco_partner <= 2643)

* Socio-cultural semi-professionals (14)

replace class16_p=14 if (selfem_partner==1) & (isco_partner == 2163)
replace class16_p=14 if (selfem_partner==1) & (isco_partner == 2166)
replace class16_p=14 if (selfem_partner==1) & (isco_partner >= 2220 & isco_partner <= 2240)
replace class16_p=14 if (selfem_partner==1) & (isco_partner == 2260)
replace class16_p=14 if (selfem_partner==1) & (isco_partner >= 2263 & isco_partner <= 2269)
replace class16_p=14 if (selfem_partner==1) & (isco_partner >= 2340 & isco_partner <= 2342)
replace class16_p=14 if (selfem_partner==1) & (isco_partner >= 2353 & isco_partner <= 2356)
replace class16_p=14 if (selfem_partner==1) & (isco_partner == 2620)
replace class16_p=14 if (selfem_partner==1) & (isco_partner == 2622)
replace class16_p=14 if (selfem_partner==1) & (isco_partner == 2635)
replace class16_p=14 if (selfem_partner==1) & (isco_partner == 2641)
replace class16_p=14 if (selfem_partner==1) & (isco_partner >= 2650 & isco_partner <= 2659)
replace class16_p=14 if (selfem_partner==1) & (isco_partner == 3200)
replace class16_p=14 if (selfem_partner==1) & (isco_partner >= 3220 & isco_partner <= 3230)
replace class16_p=14 if (selfem_partner==1) & (isco_partner == 3250)
replace class16_p=14 if (selfem_partner==1) & (isco_partner >= 3253 & isco_partner <= 3257)
replace class16_p=14 if (selfem_partner==1) & (isco_partner == 3259)
replace class16_p=14 if (selfem_partner==1) & (isco_partner >= 3400 & isco_partner <= 3410)
replace class16_p=14 if (selfem_partner==1) & (isco_partner >= 3412 & isco_partner <= 3413)
replace class16_p=14 if (selfem_partner==1) & (isco_partner >= 3430 & isco_partner <= 3433)
replace class16_p=14 if (selfem_partner==1) & (isco_partner == 3435)
replace class16_p=14 if (selfem_partner==1) & (isco_partner == 4414)

* Skilled service (15)

replace class16_p=15 if (selfem_partner==1) & (isco_partner == 3240)
replace class16_p=15 if (selfem_partner==1) & (isco_partner == 3251)
replace class16_p=15 if (selfem_partner==1) & (isco_partner == 3258)
replace class16_p=15 if (selfem_partner==1) & (isco_partner >= 3420 & isco_partner <= 3423)
replace class16_p=15 if (selfem_partner==1) & (isco_partner == 3434)
replace class16_p=15 if (selfem_partner==1) & (isco_partner >= 5000 & isco_partner <= 5120)
replace class16_p=15 if (selfem_partner==1) & (isco_partner >= 5140 & isco_partner <= 5142)
replace class16_p=15 if (selfem_partner==1) & (isco_partner == 5163)
replace class16_p=15 if (selfem_partner==1) & (isco_partner == 5165)
replace class16_p=15 if (selfem_partner==1) & (isco_partner == 5200)
replace class16_p=15 if (selfem_partner==1) & (isco_partner == 5220)
replace class16_p=15 if (selfem_partner==1) & (isco_partner >= 5222 & isco_partner <= 5223)
replace class16_p=15 if (selfem_partner==1) & (isco_partner >= 5241 & isco_partner <= 5242)
replace class16_p=15 if (selfem_partner==1) & (isco_partner >= 5300 & isco_partner <= 5321)
replace class16_p=15 if (selfem_partner==1) & (isco_partner >= 5400 & isco_partner <= 5413)
replace class16_p=15 if (selfem_partner==1) & (isco_partner == 5419)
replace class16_p=15 if (selfem_partner==1) & (isco_partner == 8331)

* Low-skilled service (16)

replace class16_p=16 if (selfem_partner==1) & (isco_partner >= 5130 & isco_partner <= 5132)
replace class16_p=16 if (selfem_partner==1) & (isco_partner >= 5150 & isco_partner <= 5162)
replace class16_p=16 if (selfem_partner==1) & (isco_partner == 5164)
replace class16_p=16 if (selfem_partner==1) & (isco_partner == 5169)
replace class16_p=16 if (selfem_partner==1) & (isco_partner >= 5210 & isco_partner <= 5212)
replace class16_p=16 if (selfem_partner==1) & (isco_partner == 5240)
replace class16_p=16 if (selfem_partner==1) & (isco_partner >= 5243 & isco_partner <= 5249)
replace class16_p=16 if (selfem_partner==1) & (isco_partner >= 5322 & isco_partner <= 5329)
replace class16_p=16 if (selfem_partner==1) & (isco_partner == 5414)
replace class16_p=16 if (selfem_partner==1) & (isco_partner == 8322)
replace class16_p=16 if (selfem_partner==1) & (isco_partner >= 9100 & isco_partner <= 9129)
replace class16_p=16 if (selfem_partner==1) & (isco_partner >= 9400 & isco_partner <= 9520)

mvdecode class16_p, mv(-9)
label variable class16_p "Partner's Oesch class position - 16 classes"
label define class16_p ///
1 "Large employers" ///
2 "Self-employed professionals" ///
3 "Small business owners with employees" ///
4 "Small business owners without employees" ///
5 "Technical experts" ///
6 "Technicians" ///
7 "Skilled manual" ///
8 "Low-skilled manual" ///
9 "Higher-grade managers and administrators" ///
10 "Lower-grade managers and administrators" ///
11 "Skilled clerks" ///
12 "Unskilled clerks" ///
13 "Socio-cultural professionals" ///
14 "Socio-cultural semi-professionals" ///
15 "Skilled service" ///
16 "Low-skilled service"
label value class16_p class16_p
tab class16_p

recode class16_p (1 2=1)(3 4=2)(5 6=3)(7 8=4)(9 10=5)(11 12=6)(13 14=7)(15 16=8), gen(class8_p)
label variable class8_p "Partner's Oesch class position - 8 classes"
label define class8_p ///
1 "Self-employed professionals and large employers" ///
2 "Small business owners" ///
3 "Technical (semi-)professionals" ///
4 "Production workers" ///
5 "(Associate) managers" ///
6 "Clerks" ///
7 "Socio-cultural (semi-)professionals" ///
8 "Service workers"
label value class8_p class8_p
tab class8_p

recode class16_p (1 2 5 9 13=1)(6 10 14=2)(3 4=3)(7 11 15=4)(8 12 16=5), gen(class5_p)
label variable class5_p "Partner's Oesch class position - 5 classes"
label define  class5_p ///
1 "Higher-grade service class" ///
2 "Lower-grade service class" ///
3 "Small business owners" ///
4 "Skilled workers" ///
5 "Unskilled workers"
label value class5_p class5_p
tab class5_p

****************************************************************************************************
* Final Oesch class position
* Merge two class variables (respondents and partners)
* Assign the partner's Oesch class position when the responant's Oesch class position is missing:
****************************************************************************************************

gen class16=class16_r

replace class16=class16_p if class16_r==.

label variable class16 "Final Oesch class position - 16 classes"
label define class16 ///
1 "Large employers" ///
2 "Self-employed professionals" ///
3 "Small business owners with employees" ///
4 "Small business owners without employees" ///
5 "Technical experts" ///
6 "Technicians" ///
7 "Skilled manual" ///
8 "Low-skilled manual" ///
9 "Higher-grade managers and administrators" ///
10 "Lower-grade managers and administrators" ///
11 "Skilled clerks" ///
12 "Unskilled clerks" ///
13 "Socio-cultural professionals" ///
14 "Socio-cultural semi-professionals" ///
15 "Skilled service" ///
16 "Low-skilled service"
label value class16 class16
tab class16

recode class16 (1 2=1)(3 4=2)(5 6=3)(7 8=4)(9 10=5)(11 12=6)(13 14=7)(15 16=8), gen(class8)
label variable class8 "Final Oesch class position - 8 classes"
label define class8 ///
1 "Self-employed professionals and large employers" ///
2 "Small business owners" ///
3 "Technical (semi-)professionals" ///
4 "Production workers" ///
5 "(Associate) managers" ///
6 "Clerks" ///
7 "Socio-cultural (semi-)professionals" ///
8 "Service workers"
label value class8 class8
tab class8

recode class16 (1 2 5 9 13=1)(6 10 14=2)(3 4=3)(7 11 15=4)(8 12 16=5), gen(class5)
label variable class5 "Final Oesch class position - 5 classes"
label define class5 ///
1 "Higher-grade service class" ///
2 "Lower-grade service class" ///
3 "Small business owners" ///
4 "Skilled workers" ///
5 "Unskilled workers"
label value class5 class5
tab class5


drop isco_mainjob emplrel_r emplno_r selfem_mainjob  isco_partner selfem_partner

**********************************
* End
**********************************
