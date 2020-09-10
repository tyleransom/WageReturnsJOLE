version 14.1
clear all
set maxvar 32000
set more off
capture log close
log using "y79_import_all.log", replace

**********************************************************
* Import and save the data (either to file or to tempfile)
**********************************************************

* Survey and Created variables (unemployment, college ids)
* do y79_import_dist.do
* sort id year
* tempfile holder1
* save `holder1', replace
* compress
* save y79_dist_raw.dta, replace

* Location variables (county, state, quality)
do y79_import_loc.do
sort id year
tempfile holder2
save `holder2', replace
compress
save y79_loc_raw.dta, replace

***********************************
* Merge the data and save the data
***********************************

* use y79_raw.dta, clear
* merge 1:1 id year using `holder1'
* assert _merge==3
* drop _merge

* use `holder1', clear
* merge 1:1 id year using `holder2'
* assert _merge==3
* drop _merge

compress
save y79_geocode_raw.dta, replace

!chmod 774 *.dta
log close
