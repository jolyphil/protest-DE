********************************************************************************
* Project:	Protest in East and West Germany
* File: 	export_tab_APC_models.do
* Task:		Export 2-column regression table in LaTeX
* Version:	06.04.2018
* Author:	Philippe Joly, Humboldt-Universität zu Berlin
********************************************************************************

local M1 `1' // assumed to be random slope at cohort-level
local M2 `2' // assumed to be random slope at period-level
local saveas "${tables_tex}`5'.tex"

est restore `M1'
mat M_clust = e(N_g)
estadd scalar N_cohort = M_clust[1,2], replace : `M1'
estadd scalar N_cohort = M_clust[1,2], replace : `M2'

est restore `M2'
mat M_clust = e(N_g)
estadd scalar N_period = M_clust[1,2], replace : `M1'
estadd scalar N_period = M_clust[1,2], replace : `M2'


/*
local vspacing "\hspace{0.4cm}"
local hspacing " & & & & \\ "
local subtitle1 "\textit{Individual Resources} & & & & \\ "
local subtitle2 "`hspacing'\textit{Individual attitudes} & & & & \\ "
local subtitle3 "`hspacing'\textit{Other controls} & & & & \\ "
local subtitle4 "`hspacing'\textit{Early exposure to repression} & & & & \\ "
local subtitle5 "`hspacing'\textit{Macro-level predictors} & & & & \\ "
local subtitle6 "`hspacing'\textit{Growth rates} & & & & \\ "
*local notdisp "EVS dummy &\multicolumn{1}{c}{yes} & &\multicolumn{1}{c}{yes} & &\multicolumn{1}{c}{yes} & \\ "
*/

#delimit ;

esttab `M1' `M2', 
b(4) se(4) noomit nobase nonum star(+ 0.10 * 0.05 ** 0.01 *** 0.001) 
	mtitles("Model 1" "Model 2")
	transform(var_*: exp(2*@) 2*exp(2*@))
	stats(N_cohort N_period N, 
		fmt(0 0 0) 
		labels(
			`"N (cohorts)"'
			`"N (periods)"'
			`"N (individuals)"'))
;

* ______________________________________________________________________________
* Table for 2 cross-classified models

/*b(4) se(4) noomit nobase nonum star(+ 0.10 * 0.05 ** 0.01 *** 0.001) 
	mtitles("Model 1" "Model 2")
	transform(var_*: exp(2*@) 2*exp(2*@))
	stats(N_cohort N_period N, 
		fmt(0 0 0) 
		labels(
			`"N (cohorts)"'
			`"N (periods)"'
			`"N (individuals)"')
*/

/*esttab `models' using `saveas',
	replace b(4) se(4) noomit nobase wide booktabs fragment nonum
	star(+ 0.10 * 0.05 ** 0.01 *** 0.001) alignment(S S) compress
	mtitles("Model 2" "Model 3" "Model 4") 
	collabels("\multicolumn{1}{c}{Coef.}" "\multicolumn{1}{c}{SE}")
	equations(
		main=1:1:1, 
		var_country_year=2:2:2, 
		var_country_cons=3:3:3,
		var_cw_cons=4:4:4, 
		var_res=5:5:5
		)
	order(
		2.edulvl
		3.edulvl
		2.inctert
		3.inctert
		1.unemp
		
		1.trust
		lifesatis
		confparl
		lrscale
		
		1.female
		age
		c.age#c.age
		
		`exposure'
		
		lgdp_mean
		lgdp_diff
		polyarchy_mean
		polyarchy_diff
		1.postcommunist
		democont_mean
		
		yeardiff
		c.democont_mean#c.yeardiff
		c.`exposure'#c.yeardiff
		
		1.evs
		
		_cons
		)
	refcat( 
		2.edulvl "`subtitle1'Education, Low (ref.)"
		2.inctert "Income, T1 (ref.)" 
		, nolabel) 
	coeflabel( 
		2.edulvl "`vspacing'Middle"
		3.edulvl "`vspacing'High"
		2.inctert "`vspacing'T2" 
		3.inctert "`vspacing'T3" 
		1.unemp "Unemployed" 
		
		1.trust "`subtitle2'Generalized trust (yes)" 
		lifesatis "Life satisfaction (10 pt)" 
		confparl "Confidence in parliament (4 pt)" 
		lrscale "Left-right scale (10 pt)" 
		
		1.female "`subtitle3'Gender (women)" 
		age "Age"
		c.age#c.age "Age\textsuperscript{2}"
		
		`exposure' "`subtitle4'`exposurelbl'"
		
		lgdp_mean "`subtitle5'Logged GDP/cap. (mean)"
		lgdp_diff "Logged GDP/cap. (diff.)"
		polyarchy_mean "Electoral democracy index (mean)"
		polyarchy_diff "Electoral democracy index (diff.)"
		1.postcommunist "Post-communist"
		democont_mean "Years of democracy (mean)"
				
		yeardiff "`subtitle6'Time"
		c.democont_mean#c.yeardiff "Time x Years of democracy (mean)"
		c.`exposure'#c.yeardiff "Time x Exposure"
		
		1.evs "`hspacing'EVS dummy"
		
		_cons "`hspacing'Constant"
		)
	transform(var_*: exp(2*@) 2*exp(2*@))
	eqlabels("" "\midrule Variance (countries: time)" "Variance (countries: cons.)" "Variance (country-waves)" "Variance (residuals)", none)
	stats(N_cohort N_period N, 
		fmt(0 0 0) 
		layout(
			"\multicolumn{1}{c}{@}"
			"\multicolumn{1}{c}{@}"
			"\multicolumn{1}{c}{@}"
			)
		labels(
			`"N (countries)"'
			`"N (country-waves)"'
			`"N (individuals)"'
		))
	;
*/
#delimit cr
