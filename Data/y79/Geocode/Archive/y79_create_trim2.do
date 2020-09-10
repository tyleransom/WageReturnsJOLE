version 14.1
clear all
set maxvar 32000
set more off
capture log close

log using "y79_create_trim2.log", replace

*****************************************************************************
* Merge geocode data into the main file
*****************************************************************************
use y79_all, clear
merge 1:1 id year month using y79_geocode3.dta, keepusing(empPct incPerCapita empPctFinal incPerCapitaFinal)
assert _merge==3
drop _merge

save y79_all2.dta, replace

!chmod 774 *.dta

* With full 79 cohort data
use y79_all_full_cohorts, clear
merge 1:1 id year month using y79_geocode3_full_cohorts.dta, keepusing(empPct incPerCapita empPctFinal incPerCapitaFinal)
assert _merge==3
drop _merge

save y79_all2_full_cohorts.dta, replace

!chmod 774 *.dta

log close

