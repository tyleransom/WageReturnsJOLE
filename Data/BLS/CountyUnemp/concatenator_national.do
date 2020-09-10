clear all
version 14.2
set more off
capture log close
log using concatenator_national.log, replace

insheet using national_unemp_monthly.txt, clear

ren jan national_urate1
ren feb national_urate2
ren mar national_urate3
ren apr national_urate4
ren may national_urate5
ren jun national_urate6
ren jul national_urate7
ren aug national_urate8
ren sep national_urate9
ren oct national_urate10
ren nov national_urate11
ren dec national_urate12

reshape long national_urate, i(year) j(month)

gen mdate = mofd(mdy(month,1,year))
format mdate %tm

drop if mi(national_urate)

compress
save national_unemp_monthly, replace

log close

