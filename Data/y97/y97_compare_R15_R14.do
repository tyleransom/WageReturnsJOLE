version 11.2
clear all
set more off
capture log close
capture cd "/afs/econ.duke.edu/data/vjh3/WageReturns/Data/y97"

log using "y97_compare_R15_R14.log", replace

use /afs/econ.duke.edu/data/vjh3/WageReturns/Data/y97/y97_all.dta, clear
xtset id yrmo
summarize, sep(0)
tab activity
tab year birthYear
tab age birthYear

use /afs/econ.duke.edu/data/vjh3/WageReturns/Data/y97/y97_all.dta, clear
xtset id yrmo
summarize, sep(0)
tab activity
tab year birthYear
tab age birthYear

log close
exit
