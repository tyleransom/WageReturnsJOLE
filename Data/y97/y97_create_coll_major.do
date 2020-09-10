version 11.2
clear all
set mem 12g
set more off
capture log close
capture cd "/afs/econ.duke.edu/data/vjh3/WageReturns/Data/y97"

log using "y97_create_coll_major.log", replace

**************************************************
* Create all permanent variables and save all data
**************************************************

use y97_coll_major_raw.dta

gen afqt_std    = 0
gen asvabAR_std = 0
gen asvabCS_std = 0
gen asvabMK_std = 0
gen asvabNO_std = 0
gen asvabPC_std = 0
gen asvabWK_std = 0

* Bring in CPI and min_wage
do cpi_min_wage.do

* Create age, foreignBorn, race, sex, family background measures, missed interview history, etc.
do y97_create_demographics.do

* Create schooling variables
do y97_create_school.do

* Create college majors
do y97_create_college.do

xtset ID year

keep ID year female finalMajor BA_year grad4yr everGrad4yr

compress
save y97_coll_major.dta, replace
log close
exit
