version 14.1
clear all
set more off
capture log close

log using "y79_import_all.log", replace

set maxvar 20000

**********************************************************
* Import and save the data
**********************************************************
* Demographics
do y79_import_demographics.do
sort id year
compress
save y79_demographics_raw.dta, replace

* School
do y79_import_school.do
sort id year
compress
save y79_school_raw.dta, replace

* Work
do y79_import_work.do
sort id year
compress
save y79_work_raw.dta, replace

* College majors...? -- It sorts and saves it itself
do y79_import_college_majors.do

***********************************
* Merge the data and save the data
***********************************
use y79_demographics_raw, clear
merge 1:1 id year using y79_school_raw, assert(match) nogen
merge 1:1 id year using y79_work_raw
drop if year==2015
assert _merge==3
drop _merge

compress
save y79_raw.dta, replace

!zip -m y79_demographics_raw.dta.zip y79_demographics_raw.dta
!zip -m y79_school_raw.dta.zip y79_school_raw.dta
!zip -m y79_work_raw.dta.zip y79_work_raw.dta
!zip -m y79_raw.dta.zip y79_raw.dta

log close
