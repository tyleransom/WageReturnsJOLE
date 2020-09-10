version 11.2
clear all
set mem 10g
set more off
capture log close
capture cd "/afs/econ.duke.edu/data/vjh3/WageReturns/Data/y97"
log using "y97_import_coll_major.log", replace

**********************************************************
* Import and save RawData/the data (either to file or to tempfile)
**********************************************************

global college 1

* Demographics
do y97_import_demographics.do
sort ID year
tempfile holder1
save `holder1', replace
compress
save RawData/y97_demographics_raw.dta, replace

* School
do y97_import_school.do
sort ID year
tempfile holder2
save `holder2', replace
compress
save RawData/y97_school_raw.dta, replace

if ${college}==1 {
	* College
	do y97_import_college.do
	sort ID year
	tempfile holder3
	save `holder3', replace
	compress
	save RawData/y97_college_raw.dta, replace
}
***********************************
* Merge and save the data
***********************************

use `holder1', clear

merge 1:1 ID year using `holder2'
assert _merge==3
drop _merge

if ${college}==1 {
	merge 1:1 ID year using `holder3'
	assert _merge==3
	drop _merge
}

compress
save y97_coll_major_raw.dta, replace

log close
exit
