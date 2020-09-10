version 14.1
clear all
set more off
capture log close

set mem 3g
set maxvar 32000

log using "y79_create_master.log", replace

**************************************************
* Create all permanent variables and save all data
**************************************************
!unzip y79_raw.dta.zip
use y79_raw.dta, clear
!rm y79_raw.dta

* Bring in CPI and min_wage
run cpi_min_wage.do

* Create various demographic variables
do y79_create_demographics.do
* Create enroll_status and hgc
do y79_create_school.do

* Create work status vars, armed forces vars, wages, and activities
do y79_create_work.do

sort id year
compress
save y79_master.dta, replace
!zip -m y79_master.dta.zip y79_master.dta
log close
