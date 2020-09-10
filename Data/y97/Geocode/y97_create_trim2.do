version 14.1
clear all
set maxvar 32000
set more off
capture log close

log using "y97_create_trim2.log", replace

*****************************************************************************
* Merge geocode data into the main file
*****************************************************************************
!unzip -u ../y97_all.dta.zip
use y97_all, clear
!rm y97_all.dta

!unzip y97_geocode3.dta.zip
merge 1:1 id year month using y97_geocode3.dta, assert(match) keepusing(empPct empPctFinal incPerCapita incPerCapitaFinal numBAperCapita numAAperCapita tuitionFlagship)
! rm y97_geocode3.dta

save y97_all2.dta, replace
! chmod 774 y97_all2.dta

!zip -m y97_all2.dta.zip y97_all2.dta

log close
