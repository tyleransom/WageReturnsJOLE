version 14.1
clear all
set maxvar 32000
set more off
capture log close

log using "y97_import_all.log", replace

**********************************************************
* Import and save the data (either to file or to tempfile)
**********************************************************

* Location
do y97_import_loc.do
sort ID year
tempfile holder1
save `holder1', replace
compress
save y97_loc_raw.dta, replace

* Distance Variables
do y97_import_dist.do
sort ID year
tempfile holder2
save `holder2', replace
compress
save y97_dist_raw.dta, replace

***********************************
* Merge the data and save the data
***********************************

use `holder1', clear
merge 1:1 ID year using `holder2'
sum if _merge!=3, sep(0)
assert _merge==3
drop _merge

ren ID id
compress
save y97_geocode_raw.dta, replace

log close
