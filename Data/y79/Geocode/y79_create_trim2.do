version 14.1
clear all
set maxvar 32000
set more off
capture log close

log using "y79_create_trim2.log", replace

*****************************************************************************
* Merge geocode data into the main file
*****************************************************************************
!unzip -u ../y79_all.dta.zip
use y79_all, clear
!rm y79_all.dta

!unzip y79_geocode3.dta.zip
merge 1:1 id year month using y79_geocode3.dta, assert(match) nogen keepusing(empPct incPerCapita empPctFinal incPerCapitaFinal numBAperCapita numAAperCapita tuitionFlagship)
!rm y79_geocode3.dta

save y79_all2.dta, replace
!chmod 774 y79_all2.dta

!zip -m y79_all2.dta.zip y79_all2.dta

log close
