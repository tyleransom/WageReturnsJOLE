version 14.1
clear all
set more off
capture log close
log using "y97_import_all.log", replace

**********************************************************
* Import and save RawData/the data (either to file or to tempfile)
**********************************************************

global college 0

* Demographics
do y97_import_demographics.do
sort ID year
tempfile holder1
save `holder1', replace
compress
save RawData/y97_demographics_raw.dta, replace
!zip -m RawData/y97_demographics_raw.dta.zip RawData/y97_demographics_raw.dta

* School
do y97_import_school.do
sort ID year
tempfile holder2
save `holder2', replace
compress
save RawData/y97_school_raw.dta, replace
!zip -m RawData/y97_school_raw.dta.zip RawData/y97_school_raw.dta

* Work
do y97_import_work.do
sort ID year
tempfile holder3
save `holder3', replace
compress
save RawData/y97_work_raw.dta, replace
!zip -m RawData/y97_work_raw.dta.zip RawData/y97_work_raw.dta

if ${college}==1 {
	* College
	do y97_import_college.do
	sort ID year
	tempfile holder4
	save `holder4', replace
	compress
	save RawData/y97_college_raw.dta, replace
    !zip -m RawData/y97_college_raw.dta.zip RawData/y97_college_raw.dta
}
***********************************
* Merge and save the data
***********************************

use `holder1', clear

merge 1:1 ID year using `holder2'
assert _merge==3
drop _merge

merge 1:1 ID year using `holder3'
assert _merge==3
drop _merge

if ${college}==1 {
	merge 1:1 ID year using `holder4'
	assert _merge==3
	drop _merge
}

merge     m:1 ID using RawData/AFQT_MATCHING/afqt_adjusted_final97, keepusing(ID afqt_std)
assert    _merge!=2
drop      _merge
merge     m:1 ID using RawData/AFQT_MATCHING_AR/afqt_adjusted_final97, keepusing(ID asvabAR_std)
assert    _merge!=2
drop      _merge
merge     m:1 ID using RawData/AFQT_MATCHING_CS/afqt_adjusted_final97, keepusing(ID asvabCS_std)
assert    _merge!=2
drop      _merge
merge     m:1 ID using RawData/AFQT_MATCHING_MK/afqt_adjusted_final97, keepusing(ID asvabMK_std)
assert    _merge!=2
drop      _merge
merge     m:1 ID using RawData/AFQT_MATCHING_NO/afqt_adjusted_final97, keepusing(ID asvabNO_std)
assert    _merge!=2
drop      _merge
merge     m:1 ID using RawData/AFQT_MATCHING_PC/afqt_adjusted_final97, keepusing(ID asvabPC_std)
assert    _merge!=2
drop      _merge
merge     m:1 ID using RawData/AFQT_MATCHING_WK/afqt_adjusted_final97, keepusing(ID asvabWK_std)
assert    _merge!=2
drop      _merge

compress
save y97_raw.dta, replace
!zip -m y97_raw.dta.zip y97_raw.dta

log close

