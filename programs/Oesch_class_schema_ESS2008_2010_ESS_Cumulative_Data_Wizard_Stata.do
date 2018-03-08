*********************************************************************************************************************************************
* OESCH CLASS SCHEMA
* Create 16-Class schema, 8-Class schema and 5-Class schema
* Data: ESS round 4 - 2008, ESS round 5 - 2010 or ESS Cumulative Data Wizard (round 1-5)
* May 2014
* Amal Tawfik, University of Geneva
*********************************************************************************************************************************************

**** References:
**** Oesch, D. (2006a) "Coming to grips with a changing class structure" International Sociology 21 (2): 263-288.
**** Oesch, D. (2006b) "Redrawing the Class Map. Stratification and Institutions in Britain, Germany, Sweden and Switzerland", Basingstoke: Palgrave Macmillan.
**** A few minor changes were made with respect to the procedure described in these two sources (decisions taken by Oesch and Tawfik in 2013)

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

**** WARNING: if you use ESS round 4 (2008 file) or ESS round 5 (2010 file), and not the ESS Cumulative Data Wizard, before you execute this syntax, you have to execute the "ESS_miss.do" syntax file which accompanies these ESS files on the ESS website

**** Variables used to construct Oesch class schema: iscoco, emplrel, emplno, iscocop, emprelp, emplnop, cntry, essround

**** Oesch class schema is not constructed for:
  * France in ESS round 1 (2002) and ESS round 2 (2004)
  * Hungary in ESS round 2 (2004)
  * because variable emplrel is missing for these countries in these surveys
  * see below (after End 1) how to construct the class schema for France and Hungary

****************************************************************************************
* Respondent's Oesch class position
* Recode and create variables used to construct class variable for respondents
* Variables used to construct class variable for respondents: iscoco, emplrel, emplno
****************************************************************************************

**** Recode occupation variable (isco88 com 4-digit) for respondents

tab iscoco

recode iscoco (missing=-9), copyrest gen(isco_mainjob)
label variable isco_mainjob "Current occupation of respondent - isco88 4-digit"
tab isco_mainjob

**** Recode employment status for respondents

tab emplrel

recode emplrel (missing=9), copyrest gen(emplrel_r)
replace emplrel_r=-9 if cntry=="FR" & (essround==1 | essround==2) // Replace this command line with [SYNTAX G and SYNTAX I]
replace emplrel_r=-9 if cntry=="HU" & essround==2 // Replace this command line with [SYNTAX E]
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

gen class16_r = -9

* Large employers (1)

replace class16_r=1 if selfem_mainjob==4


* Self-employed professionals (2)

replace class16_r=2 if (selfem_mainjob==2 | selfem_mainjob==3) & (isco_mainjob >= 2000 & isco_mainjob <= 2229) 
replace class16_r=2 if (selfem_mainjob==2 | selfem_mainjob==3) & (isco_mainjob >= 2300 & isco_mainjob <= 2470)

* Small business owners with employees (3)

replace class16_r=3 if (selfem_mainjob==3) & (isco_mainjob >= 1000 & isco_mainjob <= 1999)
replace class16_r=3 if (selfem_mainjob==3) & (isco_mainjob >= 3000 & isco_mainjob <= 9333)
replace class16_r=3 if (selfem_mainjob==3) & (isco_mainjob == 2230)

* Small business owners without employees (4)

replace class16_r=4 if (selfem_mainjob==2) & (isco_mainjob >= 1000 & isco_mainjob <= 1999)
replace class16_r=4 if (selfem_mainjob==2) & (isco_mainjob >= 3000 & isco_mainjob <= 9333)
replace class16_r=4 if (selfem_mainjob==2) & (isco_mainjob == 2230)

* Technical experts (5)

replace class16_r=5 if (selfem_mainjob==1) & (isco_mainjob >= 2100 & isco_mainjob <= 2213)

* Technicians (6)

replace class16_r=6 if (selfem_mainjob==1) & (isco_mainjob >= 3100 & isco_mainjob <= 3152)
replace class16_r=6 if (selfem_mainjob==1) & (isco_mainjob >= 3210 & isco_mainjob <= 3213)
replace class16_r=6 if (selfem_mainjob==1) & (isco_mainjob == 3434)

* Skilled manual (7)

replace class16_r=7 if (selfem_mainjob==1) & (isco_mainjob >= 6000 & isco_mainjob <= 7442)
replace class16_r=7 if (selfem_mainjob==1) & (isco_mainjob >= 8310 & isco_mainjob <= 8312)
replace class16_r=7 if (selfem_mainjob==1) & (isco_mainjob >= 8324 & isco_mainjob <= 8330)
replace class16_r=7 if (selfem_mainjob==1) & (isco_mainjob >= 8332 & isco_mainjob <= 8340)

* Low-skilled manual (8)

replace class16_r=8 if (selfem_mainjob==1) & (isco_mainjob >= 8000 & isco_mainjob <= 8300)
replace class16_r=8 if (selfem_mainjob==1) & (isco_mainjob >= 8320 & isco_mainjob <= 8321)
replace class16_r=8 if (selfem_mainjob==1) & (isco_mainjob == 8331)
replace class16_r=8 if (selfem_mainjob==1) & (isco_mainjob >= 9153 & isco_mainjob <= 9333)

* Higher-grade managers and administrators (9)

replace class16_r=9 if (selfem_mainjob==1) & (isco_mainjob >= 1000 & isco_mainjob <= 1239)
replace class16_r=9 if (selfem_mainjob==1) & (isco_mainjob >= 2400 & isco_mainjob <= 2429)
replace class16_r=9 if (selfem_mainjob==1) & (isco_mainjob == 2441)
replace class16_r=9 if (selfem_mainjob==1) & (isco_mainjob == 2470)

* Lower-grade managers and administrators (10)

replace class16_r=10 if (selfem_mainjob==1) & (isco_mainjob >= 1300 & isco_mainjob <= 1319)
replace class16_r=10 if (selfem_mainjob==1) & (isco_mainjob >= 3400 & isco_mainjob <= 3433)
replace class16_r=10 if (selfem_mainjob==1) & (isco_mainjob >= 3440 & isco_mainjob <= 3450)

* Skilled clerks (11)

replace class16_r=11 if (selfem_mainjob==1) & (isco_mainjob >= 4000 & isco_mainjob <= 4112)
replace class16_r=11 if (selfem_mainjob==1) & (isco_mainjob >= 4114 & isco_mainjob <= 4210)
replace class16_r=11 if (selfem_mainjob==1) & (isco_mainjob >= 4212 & isco_mainjob <= 4222)

* Unskilled clerks (12)

replace class16_r=12 if (selfem_mainjob==1) & (isco_mainjob == 4113)
replace class16_r=12 if (selfem_mainjob==1) & (isco_mainjob == 4211)
replace class16_r=12 if (selfem_mainjob==1) & (isco_mainjob == 4223)

* Socio-cultural professionals (13)

replace class16_r=13 if (selfem_mainjob==1) & (isco_mainjob >= 2220 &  isco_mainjob <= 2229)
replace class16_r=13 if (selfem_mainjob==1) & (isco_mainjob >= 2300 &  isco_mainjob <= 2320)
replace class16_r=13 if (selfem_mainjob==1) & (isco_mainjob >= 2340 &  isco_mainjob <= 2359)
replace class16_r=13 if (selfem_mainjob==1) & (isco_mainjob >= 2430 &  isco_mainjob <= 2440)
replace class16_r=13 if (selfem_mainjob==1) & (isco_mainjob >= 2442 &  isco_mainjob <= 2443)
replace class16_r=13 if (selfem_mainjob==1) & (isco_mainjob == 2445)
replace class16_r=13 if (selfem_mainjob==1) & (isco_mainjob == 2451)
replace class16_r=13 if (selfem_mainjob==1) & (isco_mainjob == 2460)

* Socio-cultural semi-professionals (14)

replace class16_r=14 if (selfem_mainjob==1) & (isco_mainjob == 2230)
replace class16_r=14 if (selfem_mainjob==1) & (isco_mainjob >= 2330 & isco_mainjob <= 2332)
replace class16_r=14 if (selfem_mainjob==1) & (isco_mainjob == 2444)
replace class16_r=14 if (selfem_mainjob==1) & (isco_mainjob >= 2446 & isco_mainjob <= 2450)
replace class16_r=14 if (selfem_mainjob==1) & (isco_mainjob >= 2452 & isco_mainjob <= 2455)
replace class16_r=14 if (selfem_mainjob==1) & (isco_mainjob == 3200)
replace class16_r=14 if (selfem_mainjob==1) & (isco_mainjob >= 3220 & isco_mainjob <= 3224)
replace class16_r=14 if (selfem_mainjob==1) & (isco_mainjob == 3226)
replace class16_r=14 if (selfem_mainjob==1) & (isco_mainjob >= 3229 & isco_mainjob <= 3340)
replace class16_r=14 if (selfem_mainjob==1) & (isco_mainjob >= 3460 & isco_mainjob <= 3472)
replace class16_r=14 if (selfem_mainjob==1) & (isco_mainjob == 3480)

* Skilled service (15)

replace class16_r=15 if (selfem_mainjob==1) & (isco_mainjob == 3225)
replace class16_r=15 if (selfem_mainjob==1) & (isco_mainjob >= 3227 & isco_mainjob <= 3228)
replace class16_r=15 if (selfem_mainjob==1) & (isco_mainjob >= 3473 & isco_mainjob <= 3475)
replace class16_r=15 if (selfem_mainjob==1) & (isco_mainjob >= 5000 & isco_mainjob <= 5113)
replace class16_r=15 if (selfem_mainjob==1) & (isco_mainjob == 5122)
replace class16_r=15 if (selfem_mainjob==1) & (isco_mainjob >= 5131 & isco_mainjob <= 5132)
replace class16_r=15 if (selfem_mainjob==1) & (isco_mainjob >= 5140 & isco_mainjob <= 5141)
replace class16_r=15 if (selfem_mainjob==1) & (isco_mainjob == 5143)
replace class16_r=15 if (selfem_mainjob==1) & (isco_mainjob >= 5160 & isco_mainjob <= 5220)
replace class16_r=15 if (selfem_mainjob==1) & (isco_mainjob == 8323)

* Low-skilled service (16)

replace class16_r=16 if (selfem_mainjob==1) & (isco_mainjob >= 5120 & isco_mainjob <= 5121)
replace class16_r=16 if (selfem_mainjob==1) & (isco_mainjob >= 5123 & isco_mainjob <= 5130)
replace class16_r=16 if (selfem_mainjob==1) & (isco_mainjob >= 5133 & isco_mainjob <= 5139)
replace class16_r=16 if (selfem_mainjob==1) & (isco_mainjob == 5142)
replace class16_r=16 if (selfem_mainjob==1) & (isco_mainjob == 5149)
replace class16_r=16 if (selfem_mainjob==1) & (isco_mainjob == 5230)
replace class16_r=16 if (selfem_mainjob==1) & (isco_mainjob == 8322)
replace class16_r=16 if (selfem_mainjob==1) & (isco_mainjob >= 9100 &  isco_mainjob <= 9152)

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
* Variables used to construct class variable for partners: iscocop, emprelp, emplnop
***************************************************************************************

**** Recode occupation variable (isco88 com 4-digit) for partners

tab iscocop

recode iscocop (missing=-9), copyrest gen(isco_partner)
label variable isco_partner "Current occupation of partner - isco88 4-digit" 
tab isco_partner

**** Recode employment status for partners

tab emprelp

recode emprelp (missing=9), copyrest gen(emplrel_p)
replace emplrel_p=-9 if cntry=="FR" & (essround==1 | essround==2) // Replace this command line with [SYNTAX H and SYNTAX J]
replace emplrel_p=-9 if cntry=="HU" & essround==2 // Replace this command line with [SYNTAX F]
label define emplrel_p ///
1 "Employee" ///
2 "Self-employed" ///
3 "Working for own family business" ///
9 "Missing"
label value emplrel_p emplrel_p
tab emplrel_p

tab emplnop

recode emplnop (0=0)(1/9=1)(10/10000=2)(missing=0), gen(emplno_p)
label define emplno_p ///
0 "0 employees" ///
1 "1-9 employees" ///
2 "10+ employees"
label value emplno_p emplno_p
tab emplno_p

gen selfem_partner=.
replace selfem_partner=1 if emplrel_p==1 | emplrel_p==9
replace selfem_partner=2 if emplrel_p==2 & emplno_p==0
replace selfem_partner=2 if emplrel_p==3
replace selfem_partner=3 if emplrel_p==2 & emplno_p==1
replace selfem_partner=4 if emplrel_p==2 & emplno_p==2
label variable selfem_partner "Employment status for partners"
label define selfem_partner ///
1 "Not self-employed" ///
2 "Self-empl without employees" ///
3 "Self-empl with 1-9 employees" ///
4 "Self-empl with 10 or more"
label value selfem_partner selfem_partner
tab selfem_partner


********************************************
* Create Oesch class schema for partners 
********************************************

gen class16_p = -9

* Large employers (1)

replace class16_p=1 if selfem_partner==4


* Self-employed professionals (2)

replace class16_p=2 if (selfem_partner==2 | selfem_partner==3) & (isco_partner >= 2000 & isco_partner <= 2229) 
replace class16_p=2 if (selfem_partner==2 | selfem_partner==3) & (isco_partner >= 2300 & isco_partner <= 2470)

* Small business owners with employees (3)

replace class16_p=3 if (selfem_partner==3) & (isco_partner >= 1000 & isco_partner <= 1999)
replace class16_p=3 if (selfem_partner==3) & (isco_partner >= 3000 & isco_partner <= 9333)
replace class16_p=3 if (selfem_partner==3) & (isco_partner == 2230)

* Small business owners without employees (4)

replace class16_p=4 if (selfem_partner==2) & (isco_partner >= 1000 & isco_partner <= 1999)
replace class16_p=4 if (selfem_partner==2) & (isco_partner >= 3000 & isco_partner <= 9333)
replace class16_p=4 if (selfem_partner==2) & (isco_partner == 2230)

* Technical experts (5)

replace class16_p=5 if (selfem_partner==1) & (isco_partner >= 2100 & isco_partner <= 2213)

* Technicians (6)

replace class16_p=6 if (selfem_partner==1) & (isco_partner >= 3100 & isco_partner <= 3152)
replace class16_p=6 if (selfem_partner==1) & (isco_partner >= 3210 & isco_partner <= 3213)
replace class16_p=6 if (selfem_partner==1) & (isco_partner == 3434)

* Skilled manual (7)

replace class16_p=7 if (selfem_partner==1) & (isco_partner >= 6000 & isco_partner <= 7442)
replace class16_p=7 if (selfem_partner==1) & (isco_partner >= 8310 & isco_partner <= 8312)
replace class16_p=7 if (selfem_partner==1) & (isco_partner >= 8324 & isco_partner <= 8330)
replace class16_p=7 if (selfem_partner==1) & (isco_partner >= 8332 & isco_partner <= 8340)

* Low-skilled manual (8)

replace class16_p=8 if (selfem_partner==1) & (isco_partner >= 8000 & isco_partner <= 8300)
replace class16_p=8 if (selfem_partner==1) & (isco_partner >= 8320 & isco_partner <= 8321)
replace class16_p=8 if (selfem_partner==1) & (isco_partner == 8331)
replace class16_p=8 if (selfem_partner==1) & (isco_partner >= 9153 & isco_partner <= 9333)

* Higher-grade managers and administrators (9)

replace class16_p=9 if (selfem_partner==1) & (isco_partner >= 1000 & isco_partner <= 1239)
replace class16_p=9 if (selfem_partner==1) & (isco_partner >= 2400 & isco_partner <= 2429)
replace class16_p=9 if (selfem_partner==1) & (isco_partner == 2441)
replace class16_p=9 if (selfem_partner==1) & (isco_partner == 2470)

* Lower-grade managers and administrators (10)

replace class16_p=10 if (selfem_partner==1) & (isco_partner >= 1300 & isco_partner <= 1319)
replace class16_p=10 if (selfem_partner==1) & (isco_partner >= 3400 & isco_partner <= 3433)
replace class16_p=10 if (selfem_partner==1) & (isco_partner >= 3440 & isco_partner <= 3450)

* Skilled clerks (11)

replace class16_p=11 if (selfem_partner==1) & (isco_partner >= 4000 & isco_partner <= 4112)
replace class16_p=11 if (selfem_partner==1) & (isco_partner >= 4114 & isco_partner <= 4210)
replace class16_p=11 if (selfem_partner==1) & (isco_partner >= 4212 & isco_partner <= 4222)

* Unskilled clerks (12)

replace class16_p=12 if (selfem_partner==1) & (isco_partner == 4113)
replace class16_p=12 if (selfem_partner==1) & (isco_partner == 4211)
replace class16_p=12 if (selfem_partner==1) & (isco_partner == 4223)

* Socio-cultural professionals (13)

replace class16_p=13 if (selfem_partner==1) & (isco_partner >= 2220 &  isco_partner <= 2229)
replace class16_p=13 if (selfem_partner==1) & (isco_partner >= 2300 &  isco_partner <= 2320)
replace class16_p=13 if (selfem_partner==1) & (isco_partner >= 2340 &  isco_partner <= 2359)
replace class16_p=13 if (selfem_partner==1) & (isco_partner >= 2430 &  isco_partner <= 2440)
replace class16_p=13 if (selfem_partner==1) & (isco_partner >= 2442 &  isco_partner <= 2443)
replace class16_p=13 if (selfem_partner==1) & (isco_partner == 2445)
replace class16_p=13 if (selfem_partner==1) & (isco_partner == 2451)
replace class16_p=13 if (selfem_partner==1) & (isco_partner == 2460)

* Socio-cultural semi-professionals (14)

replace class16_p=14 if (selfem_partner==1) & (isco_partner == 2230)
replace class16_p=14 if (selfem_partner==1) & (isco_partner >= 2330 & isco_partner <= 2332)
replace class16_p=14 if (selfem_partner==1) & (isco_partner == 2444)
replace class16_p=14 if (selfem_partner==1) & (isco_partner >= 2446 & isco_partner <= 2450)
replace class16_p=14 if (selfem_partner==1) & (isco_partner >= 2452 & isco_partner <= 2455)
replace class16_p=14 if (selfem_partner==1) & (isco_partner == 3200)
replace class16_p=14 if (selfem_partner==1) & (isco_partner >= 3220 & isco_partner <= 3224)
replace class16_p=14 if (selfem_partner==1) & (isco_partner == 3226)
replace class16_p=14 if (selfem_partner==1) & (isco_partner >= 3229 & isco_partner <= 3340)
replace class16_p=14 if (selfem_partner==1) & (isco_partner >= 3460 & isco_partner <= 3472)
replace class16_p=14 if (selfem_partner==1) & (isco_partner == 3480)

* Skilled service (15)

replace class16_p=15 if (selfem_partner==1) & (isco_partner == 3225)
replace class16_p=15 if (selfem_partner==1) & (isco_partner >= 3227 & isco_partner <= 3228)
replace class16_p=15 if (selfem_partner==1) & (isco_partner >= 3473 & isco_partner <= 3475)
replace class16_p=15 if (selfem_partner==1) & (isco_partner >= 5000 & isco_partner <= 5113)
replace class16_p=15 if (selfem_partner==1) & (isco_partner == 5122)
replace class16_p=15 if (selfem_partner==1) & (isco_partner >= 5131 & isco_partner <= 5132)
replace class16_p=15 if (selfem_partner==1) & (isco_partner >= 5140 & isco_partner <= 5141)
replace class16_p=15 if (selfem_partner==1) & (isco_partner == 5143)
replace class16_p=15 if (selfem_partner==1) & (isco_partner >= 5160 & isco_partner <= 5220)
replace class16_p=15 if (selfem_partner==1) & (isco_partner == 8323)

* Low-skilled service (16)

replace class16_p=16 if (selfem_partner==1) & (isco_partner >= 5120 & isco_partner <= 5121)
replace class16_p=16 if (selfem_partner==1) & (isco_partner >= 5123 & isco_partner <= 5130)
replace class16_p=16 if (selfem_partner==1) & (isco_partner >= 5133 & isco_partner <= 5139)
replace class16_p=16 if (selfem_partner==1) & (isco_partner == 5142)
replace class16_p=16 if (selfem_partner==1) & (isco_partner == 5149)
replace class16_p=16 if (selfem_partner==1) & (isco_partner == 5230)
replace class16_p=16 if (selfem_partner==1) & (isco_partner == 8322)
replace class16_p=16 if (selfem_partner==1) & (isco_partner >= 9100 &  isco_partner <= 9152)

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


drop isco_mainjob emplrel_r emplno_r selfem_mainjob  isco_partner emplrel_p emplno_p selfem_partner


**********************************
* End 1
**********************************


**** In order to construct the Oesch class schema for France and Hungary in ESS Cumulative Data Wizard:
**** You have to add to your ESS data file the following variables from "Country specific variables":
  * ESS round 1 - 2002: France: emprlfr emprlpfr (http://www.europeansocialsurvey.org/data/country.html?c=france)
  * ESS round 2 - 2004: France: emprlfr emprlpfr / Hungary: emprelhu emprlphu (http://www.europeansocialsurvey.org/data/country.html?c=hungary)

**** You have to replace command lines with the following syntaxes: 

**** ESS Cumulative Data Wizard
 
  ** Before merging, you have to rename variables in the "Country specific file" for France
  ** Country specific file - France -  ESS round 1 - 2002
  /* rename emprlfr emprlfr02
  /* rename emprlpfr emprlpfr02
  ** Country specific file - France - ESS round 4 - 2004
  /* rename emprlfr emprlfr04
  /* rename emprlpfr emprlpfr04

  ** SYNTAX G (France - respondent):
  /* recode emprlfr02 (2 3 4=1)(1=2)(5=3)(6 8 9=9)
  /* replace emplrel_r=emprlfr02 if cntry=="FR" & essround==1
  
  ** SYNTAX H (France - partner):
  /* recode emprlpfr02 (2 3 4=1)(1=2)(5=3)(6 8 9=9)
  /* replace emplrel_p=emprlpfr02 if cntry=="FR" & essround==1
  
  ** SYNTAX I (France - respondent):
  /* recode emprlfr04 (2 3 4=1)(1=2)(5=3)(6 8 9=9)
  /* replace emplrel_r=emprlfr04 if cntry=="FR" & essround==2

  ** SYNTAX J (France - partner):
  /* recode emprlpfr04 (2 3 4=1)(1=2)(5=3)(6 8 9=9)
  /* replace emplrel_p=emprlpfr04 if cntry=="FR" & essround==2

  ** SYNTAX E (Hungary - respondent):
  /* recode emprelhu (1 4=1)(2=2)(3=3)(6 7 8 9=9)
  /* replace emplrel_r=emprelhu if cntry=="HU" & essround==2

  ** SYNTAX F (Hungary - partner):
  /* recode emprlphu (1 4=1)(2=2)(3=3)(6 7 8 9=9)
  /* replace emplrel_p=emprlphu if cntry=="HU" & essround==2


**********************************
* End 2
**********************************

