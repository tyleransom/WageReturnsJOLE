clear all
set maxvar  32000
set matsize 11000
set more off
version 13.1

capture log close
global runname y97_mincerv8
log using ${runname}.log, replace

**********************************************************************
* Mincerian and other wage specifications for comparison purposes
**********************************************************************

if "`c(username)'"=="jared"  global secretdir [REDACTED]
if "`c(username)'"=="ransom" global secretdir [REDACTED]

use if cohortFlag==1997 & ~female & inlist(activity,2,3,4,12,13,14,22,23,24) using ${secretdir}/yCombined_scaled_t0_16.dta, clear
* drop if inlist(birthYear,1957,1958)

drop lnWage
rena lnWageNoSelf lnWage
recode lnWage (-999 = .)

gen inSchWork  = inlist(activity,2,12,22)
gen PTwork     = inlist(activity,3,13,23)
local Pvars79  black hispanic born1959 born1960 born1961 born1962 born1963 foreignBorn
local Pvars97  black hispanic born1980 born1981 born1982 born1983          foreignBorn
local Mvars    empPct incPerCapita

local Svars3   c.anySchoolt##c.anySchoolt##c.anySchoolt
local Zvars3I  c.workK12t    c.workK12t#(c.workK12t c.anySchoolt c.workK12t#c.workK12t)             c.workColleget c.workColleget#(c.workColleget c.anySchoolt c.workColleget#c.workColleget)
local Evars3I  c.workPTonlyt c.workPTonlyt#(c.workPTonlyt c.anySchoolt c.workPTonlyt#c.workPTonlyt) c.workFTonlyt  c.workFTonlyt#(c.workFTonlyt c.anySchoolt c.workFTonlyt#c.workFTonlyt)     c.militaryt##c.militaryt##c.militaryt c.othert##c.othert##c.othert

local risk     gradHS grad4yr
local work     inSchWork PTwork

*================================================
* Programs
*================================================
*--------------------------------------------------
* Program to export output from most recent run in tab '`1'', with replace option '`2''
*--------------------------------------------------
capture program drop exporter
program exporter
	version 13.1
	qui outreg2 using ${runname},      excel `2' bdec(4) sdec(4) ctitle(`1')
	estimates store tmp
	margins if agemo==2812 , dydx(${tmpvars}) atmeans post
	qui outreg2 using ${runname}_mfx,  excel `2' bdec(4) sdec(4) ctitle(mfx`1')
	estimates restore tmp
	margins if agemo==3112 , dydx(${tmpvars}) atmeans post
	qui outreg2 using ${runname}_mfx32,excel `2' bdec(4) sdec(4) ctitle(mfx`1')
end

*--------------------------------------
* Program to run with ml max that allows variance to be different across wage types
*--------------------------------------
gen     byte dummy = (2)*( inlist(activity,2,12,22)) + (3)*( inlist(activity,3,13,23)) + (4)*( inlist(activity,4,14,24))
global dumbo dummy

capture program drop normal
program normal
	version 13.1
	args lnf Xb sigma2 sigma3 sigma4
	quietly replace `lnf'=( ${dumbo}==2)*ln(normalden(${ML_y1}, `Xb', `sigma2'))+( ${dumbo}==3)*ln(normalden(${ML_y1}, `Xb', `sigma3'))+( ${dumbo}==4)*ln(normalden(${ML_y1}, `Xb', `sigma4'))
end

*================================================
* Wage OLS coef at all ages; mfx at age 2812 and 3112
*================================================
* Descriptives
reg  lnWage     `risk' `work', vce(cluster id)
global tmpvars `risk'
exporter DescriptiveGraduation replace

reg  lnWage anySchoolt `work', vce(cluster id)
global tmpvars anySchoolt
exporter DescriptiveAnySchool append

*================================================
* Wage MLE coef at all ages; mfx at age 2812 and 3112
*================================================
* Mincer
ml model lf normal (lnWage =                    `Svars3'    c.potExpt##c.potExpt##c.potExpt                        `risk' `work') /sigma2 /sigma3 /sigma4 , vce(cluster id)
ml max
global tmpvars anySchoolt potExpt `risk'
exporter MincerCubic append

* HLT
ml model lf normal (lnWage =  black hispanic    `Svars3'    c.potExpt##c.potExpt##c.potExpt c.anySchoolt#c.potExpt `risk' `work') /sigma2 /sigma3 /sigma4 , vce(cluster id)
ml max
global tmpvars anySchoolt potExpt `risk'
exporter HLTcubicInterRace append

* HLT + Background
ml model lf normal (lnWage =  `Pvars97' `Mvars' `Svars3'    c.potExpt##c.potExpt##c.potExpt c.anySchoolt#c.potExpt `risk' `work') /sigma2 /sigma3 /sigma4 , vce(cluster id)
ml max
global tmpvars anySchoolt potExpt `risk'
exporter HLTplusBack append

* + Actual Experience (each exp term enters as a cubic; each exp term is interacted with schooling, except for military and other)
ml model lf normal (lnWage = `Pvars97' `Mvars' `Svars3'    `Zvars3I' `Evars3I'                                     `risk' `work') /sigma2 /sigma3 /sigma4 , vce(cluster id)
ml max
global tmpvars anySchoolt workK12t workColleget workPTonlyt workFTonlyt militaryt othert `risk'
exporter FullCubicInterBack append

* Cleanup--only use xml files, thus rm txt files
!rm ${runname}*txt

log close
