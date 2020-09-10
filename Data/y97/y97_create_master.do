version 14.1
clear all
set more off
capture log close
set maxvar 32000

log using "y97_create_master.log", replace

**************************************************
* Create all permanent variables and save all data
**************************************************

!unzip y97_raw.dta.zip
use y97_raw.dta
!rm y97_raw.dta

* Bring in CPI and min_wage
do cpi_min_wage.do

* Create age, foreignBorn, race, sex, family background measures, missed interview history, etc.
do y97_create_demographics.do

* Create schooling variables
do y97_create_school.do

* Create primary activity variables and wages
do y97_create_work.do

sort ID year
compress
save y97_master.dta, replace
!zip -m y97_master.dta.zip y97_master.dta

log close

