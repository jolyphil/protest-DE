meqrlogit demonstration c.age##c.age i.eisced i.landnum || _all: R.period || cohorteast:
predict b*, reffects relevel(cohorteast)
predict se*,  reses relevel(cohorteast)

gen ll = b1 - 1.96*se1
gen ul = b1 + 1.96*se1

twoway (rarea ll ul cohort if eastsoc==0, sort) (rarea ll ul cohort if eastsoc==1, sort) (connected b1 cohort if eastsoc==0, sort) (connected b1 cohort if eastsoc==1, sort), yline(0) legend(off) scheme(minimal)
twoway (rarea ll ul cohort if eastsoc==0, sort) (connected b1 cohort if eastsoc==0, sort), yline(0) legend(off)
twoway (rarea ll ul cohort if eastsoc==1, sort) (connected b1 cohort if eastsoc==1, sort), yline(0) legend(off)
