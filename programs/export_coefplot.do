********************************************************************************
* Project:	Protest in East and West Germany
* Task:		Export coefplot (fixed effects without land effects)
* Version:	10.04.2018
* Author:	Philippe Joly, Humboldt-Universität zu Berlin
********************************************************************************
* ______________________________________________________________________________
* Input arguments

local M1 `1'
local M1_label `2'
local M2 `3'
local M2_label `4'
local M3 `5'
local M3_label `6'

local saveas "`7'"

* ______________________________________________________________________________
* Graph

#delimit ;
coefplot
	(`M1', label(`M1_label'))
	(`M2', label(`M2_label') msymbol(triangle))
	(`M3', label(`M3_label') msymbol(square)),
	drop(*.land _cons) /*eform*/ xline(0) xtitle("LogitPr(Protest = 1)", size(small))
	order(
		1.eastsoc
		. 
		1.female 
		. 
		age
		c.age#c.age
		.
		"*.edu3"
		.
		1.unemp
		.
		1.union
		.
		"*.city"
		.
		"*.class5"
		)
	headings( 
		2.edu3 = "Education, Low (ref.)" 
		2.city = "Town size, Home in countryside (ref.)" 
		2.class5 = "Social class, High service class (ref.)"  
		)
	coeflabels(
		1.eastsoc = "`subtitle1'East German"
		1.female = "Woman" 
		age = "Age"
		c.age#c.age = "Age{superscript:2}"	
		2.edu3 = "Middle"
		3.edu3 = "High"
		1.unemp = "Unemployed" 
		1.union = "Union member" 
		2.city = "Country village"
		3.city = "Town or small city"
		4.city = "Outskirts of big city"
		5.city = "A big city"
		2.class5 = "Low service class"
		3.class5 = "Small business owners"
		4.class5 = "Skilled workers"
		5.class5 = "Unskilled workers"
	)
	saving("${figures_gph}`saveas'.gph", replace)
;
#delimit cr

graph export "${figures_pdf}`saveas'.pdf", replace
