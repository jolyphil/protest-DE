********************************************************************************
* Project:	Generations and Protest in Eastern Germany
* Task:		Export regression tables for 3 models in RTF
* Version:	17.05.2018
* Author:	Philippe Joly, Humboldt-Universität zu Berlin
********************************************************************************
* ______________________________________________________________________________
* Input arguments

local M1 `1' // Assume all models have the same hierarchical structure
local M2 `2'
local M3 `3'

local saveas_a "${tables_rtf}`4'_a.rtf"
local saveas_b "${tables_rtf}`4'_b.rtf"

* ______________________________________________________________________________
* Hierarchical structure

est restore `M1'

local posspace = strpos(e(ivars), " ") 
	// find position of space in stored result e(ivars)
	// e.g. "_all cohort" --> position = 5
local L2 = substr(e(ivars),`posspace' + 1,.)
	// extract second grouping variable, e.g "cohort"
if "`L2'" == "cohort" {
	local L3 "period"
} 
else {
	local L3 "cohort"
}
disp "Note: `L2' nested within `L3'."	

* ______________________________________________________________________________
* Extract number of clusters

forval i = 1/3 {
	est restore `M`i''
	
	* _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _
	* Number of clusters at L2
	mat M_clust = e(N_g)
	estadd scalar N_L2 = M_clust[1,2], replace : `M`i''
	
	* _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _
	* Number of clusters at L3

	tempvar tag_L3
	tempvar sum_L3_clusters
	
	egen `tag_L3' = tag(`L3') if e(sample)==1
	egen `sum_L3_clusters' = sum(`tag_L3')
	summ `sum_L3_clusters'
	estadd scalar N_L3 = r(max), replace : `M`i''
	
	drop `tag_L3' `sum_L3_clusters'
}
* ______________________________________________________________________________
* Spaces and subtitles

local vspacing "  "
local hspacing "}\cell \pard\intbl\qc {}\cell \pard\intbl\qc {}\cell \pard\intbl\qc {}\cell \pard\intbl\qc {}\cell \pard\intbl\qc {}\cell \pard\intbl\qc {}\cell\row} {\trowd\trgaph108\trleft-108\cellx2028\cellx3684\cellx4980\cellx6636\cellx7932\cellx9588\cellx10884\pard\intbl\ql {"

if "`L2'" == "cohort" {
	local title1 "\b Table A1:\b0  APC Models of Protest Participation: Random Slopes at the Cohort Level \line"
	local title2 "\b Table A1 (Continued):\b0  APC Models of Protest Participation: Random Slopes at the Cohort Level \line"
} 
else {
	local title1 "\b Table A2:\b0  APC Models of Protest Participation: Random Slopes at the Period Level \line"
	local title2 "\b Table A2 (Continued):\b0  APC Models of Protest Participation: Random Slopes at the Period Level \line"
}
* ______________________________________________________________________________
* Table

#delimit ;

esttab `M1' `M2' `M3' using `saveas_a', replace 
	b(4) se(4) noomit nobase noobs wide nonum
	star(+ 0.10 * 0.05 ** 0.01 *** 0.001) compress
	title("`title1'")
	mtitles("Demonstration" "Petition" "Boycott")
	collabels("Coef." "SE")
	drop(*.land _cons)
	refcat( 
		1.eastsoc "\i Individual-level variables \i0"
		2.edu3 "Education, Low (ref.)"
		2.city "Town size, Home in countryside (ref.)"
		2.class5 "Social class, High service class (ref.)" 
		, nolabel
		) 
	coeflabel(
		1.eastsoc "East German"
		1.female "Woman" 
		age10 "Age (10 years)"
		c.age10#c.age10 "Age\textsuperscript{2}"	
		2.edu3 "`vspacing'Middle"
		3.edu3 "`vspacing'High"
		1.unemp "Unemployed" 
		1.union "Union member" 
		2.city "`vspacing'Country village"
		3.city "`vspacing'Town or small city"
		4.city "`vspacing'Outskirts of big city"
		5.city "`vspacing'A big city"
		2.class5 "`vspacing'Low service class"
		3.class5 "`vspacing'Small business owners"
		4.class5 "`vspacing'Skilled workers"
		5.class5 "`vspacing'Unskilled workers"
		)
	eqlabels("" "" "" "", none)
	nonote
	addnotes("Continued on next page");
;

esttab `M1' `M2' `M3' using `saveas_b', replace 
	b(4) se(4) noomit nobase noobs wide nonum
	star(+ 0.10 * 0.05 ** 0.01 *** 0.001) stardrop(ln*:_cons)
	compress
	title("`title2'")
	mtitles("Demonstration" "Petition" "Boycott")
	collabels("Coef." "SE")
	label
	keep(*.land *_cons)
	refcat( 
		2.land "Baden-Wuerttemberg (ref.)"
		, nolabel) 
	coeflabel(		
		_cons "`hspacing'Intercept"
		)
	transform(ln*: exp(2*@) 2*exp(2*@))
	eqlabels("" "Variance (`L3': intercept)" "Variance (`L2': slope)" "Variance (`L2': intercept)", none)
	stats(bic N_L3 N_L2 N, 
		fmt(1 0 0 0)
		labels(
			`"BIC"'
			`"N (`L3's)"'
			`"N (`L2's)"'
			`"N (individuals)"'
			)
		)
	nonote
	addnotes("(Significance: + \i p \i0 < 0.1, * \i p \i0 < 0.05, ** \i p \i0 < 0.01, *** \i p \i0 < 0.001)" "" "\b Note: \b0 Results with logit estimates and standard errors. Source: ESS 2017.");
;

#delimit cr
