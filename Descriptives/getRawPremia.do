clear all
set maxvar  32000
set matsize 11000
set more off
version 13.1

capture log close
log using getRawPremia.log, replace

**********************************************************************
* Mincerian and other wage specifications for comparison purposes
**********************************************************************

if "`c(username)'"=="jared"  global secretdir [REDACTED]
if "`c(username)'"=="ransom" global secretdir [REDACTED]

use if ~female & inlist(activity,2,3,4,12,13,14,22,23,24) using ${secretdir}/yCombined_scaled_t0_16.dta, clear
drop if inlist(birthYear,1957,1958)

drop lnWage
rena lnWageNoSelf lnWage
recode lnWage (-999 = .)

gen inSchWork  = inlist(activity,2,12,22)
gen PTwork     = inlist(activity,3,13,23)
* local Pvars79O black hispanic born1957 born1958 born1959          foreignBorn
* local Pvars79Y black hispanic born1961 born1962 born1963          foreignBorn
local Pvars79  black hispanic born1959 born1960 born1961 born1962 born1963 foreignBorn
local Pvars97  black hispanic born1980 born1981 born1982 born1983          foreignBorn
local Mvars    empPct incPerCapita

local Svars1   c.anySchoolt##c.anySchoolt
local Svars2   c.anySchoolt##c.anySchoolt##c.anySchoolt

local Zvars1   c.workK12t##c.workK12t                                                 c.workColleget##c.workColleget
local Zvars1A  c.workK12t  c.workK12t#(c.workK12t c.anySchoolt)                       c.workColleget  c.workColleget#(c.workColleget c.anySchoolt c.workK12t)
local Zvars1B  c.workK12t  c.workK12t#(c.workK12t c.anySchoolt)                       c.workColleget  c.workColleget#(c.workColleget c.anySchoolt           )
local Zvars2   c.workK12t##c.workK12t##c.workK12t                                     c.workColleget##c.workColleget##c.workColleget
local Zvars2A  c.workK12t  c.workK12t#(c.workK12t c.anySchoolt c.workK12t#c.workK12t) c.workColleget  c.workColleget#(c.workColleget c.anySchoolt c.workK12t c.workColleget#c.workColleget)
local Zvars2B  c.workK12t  c.workK12t#(c.workK12t c.anySchoolt c.workK12t#c.workK12t) c.workColleget  c.workColleget#(c.workColleget c.anySchoolt            c.workColleget#c.workColleget)

local Evars1   c.workPTonlyt##c.workPTonlyt                                                                                    c.workFTonlyt##c.workFTonlyt                                                                                                  c.militaryt##c.militaryt              c.othert##c.othert
local Evars1A  c.workPTonlyt  c.workPTonlyt#(c.workPTonlyt c.anySchoolt c.workK12t c.workColleget)                             c.workFTonlyt  c.workFTonlyt#(c.workFTonlyt c.anySchoolt c.workK12t c.workColleget c.workPTonlyt)                             c.militaryt##c.militaryt              c.othert##c.othert
local Evars1B  c.workPTonlyt  c.workPTonlyt#(c.workPTonlyt c.anySchoolt                          )                             c.workFTonlyt  c.workFTonlyt#(c.workFTonlyt c.anySchoolt                                        )                             c.militaryt##c.militaryt              c.othert##c.othert
local Evars2   c.workPTonlyt##c.workPTonlyt##c.workPTonlyt                                                                     c.workFTonlyt##c.workFTonlyt##c.workFTonlyt                                                                                   c.militaryt##c.militaryt##c.militaryt c.othert##c.othert##c.othert
local Evars2A  c.workPTonlyt  c.workPTonlyt#(c.workPTonlyt c.anySchoolt c.workK12t c.workColleget c.workPTonlyt#c.workPTonlyt) c.workFTonlyt  c.workFTonlyt#(c.workFTonlyt c.anySchoolt c.workK12t c.workColleget c.workPTonlyt c.workFTonlyt#c.workFTonlyt) c.militaryt##c.militaryt##c.militaryt c.othert##c.othert##c.othert
local Evars2B  c.workPTonlyt  c.workPTonlyt#(c.workPTonlyt c.anySchoolt                           c.workPTonlyt#c.workPTonlyt) c.workFTonlyt  c.workFTonlyt#(c.workFTonlyt c.anySchoolt                                         c.workFTonlyt#c.workFTonlyt) c.militaryt##c.militaryt##c.militaryt c.othert##c.othert##c.othert

local risk     gradHS grad4yr
local work     inSchWork PTwork


*================================================
* Wage OLS coef at all ages; mfx at age 2812 and 3112
*================================================
reg  lnWage `risk' if cohortFlag==1979
reg  lnWage `risk' if cohortFlag==1997

reg  lnWage `risk' if cohortFlag==1979 & agemo==2812
reg  lnWage `risk' if cohortFlag==1997 & agemo==2812

log close

