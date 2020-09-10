version 13.1
clear all
set more off

capture log close
log using y79_wages_anyschool_school_interaction_t0_16.log, replace
set matsize 4000

*****************************************************************************
* Perform mlogits on data to use at starting points for V++
*  MFX Model
*****************************************************************************
*============================================================================
* Import data, define macros, gen variables
*============================================================================

if "`c(username)'"=="jared"  global secretdir [REDACTED]
if "`c(username)'"=="ransom" global secretdir [REDACTED]

use if cohortFlag==1979 & ~female using ${secretdir}/yCombined_scaled_t0_16.dta, clear
drop if inlist(birthYear,1957,1958)

* local Pvars79O black hispanic born1957 born1958 born1959          foreignBorn
* local Pvars79Y black hispanic born1961 born1962 born1963          foreignBorn
local Pvars79  black hispanic born1959 born1960 born1961 born1962 born1963 foreignBorn
local Pvars97  black hispanic born1980 born1981 born1982 born1983          foreignBorn
local Qvars    afqt m_afqt
local Mvars    empPct incPerCapita
local Avars    potExpt potExpSq potExpCu

local Svars    schoolOnlyt schoolOnlySq schoolOnlyCu
local Svars1   anySchoolt anySchoolBlack anySchoolHisp anySchoolSq anySchoolCu 
local Svars2   anySchoolt  anySchoolSq  anySchoolCu
local Svars3   anySchoolt anySchoolBlack anySchoolHisp anySchoolSq anySchoolSqBlack anySchoolSqHisp anySchoolCu anySchoolCuBlack anySchoolCuHisp anySchoolQr                              

local Zvars    workK12t workK12Sq workK12schoolOnly workK12Cu workColleget workCollegeSq workCollegeschoolOnly workCollegeCu
local Zvars1   workK12t workK12Black workK12Hisp workK12Sq workK12Cu workColleget workCollegeBlack workCollegeHisp workCollegeSq workCollegeCu
local Zvars2   workK12t workK12Sq workK12anySchool  workK12Cu workColleget workCollegeSq workCollegeanySchool  workCollegeCu
local Zvars3   workK12t workK12Black workK12Hisp workK12Sq workK12SqBlack workK12SqHisp workK12Cu workK12CuBlack workK12CuHisp workK12Qr workColleget workCollegeBlack workCollegeHisp workCollegeSq workCollegeSqBlack workCollegeSqHisp workCollegeCu workCollegeCuBlack workCollegeCuHisp workCollegeQr                    

local Evars    workPTonlyt workPTSq workPTschoolOnly workPTCu workFTonlyt workFTSq workFTschoolOnly workFTCu militaryt militarySq militaryCu othert otherSq otherCu
local Evars1   workPTonlyt workPTBlack workPTHisp workPTSq workPTCu workPTQr workFTonlyt workFTBlack workFTHisp workFTSq workFTCu workFTQr militaryt militaryBlack militaryHisp militarySq militaryCu militaryQr othert otherBlack otherHisp otherSq otherCu otherQr
local Evars2   workPTonlyt workPTSq workPTanySchool  workPTCu workFTonlyt workFTSq workFTanySchool  workFTCu militaryt militarySq militaryCu othert otherSq otherCu
local Evars3   workPTonlyt workPTBlack workPTHisp workPTSq workPTSqBlack workPTSqHisp workPTCu workPTCuBlack workPTCuHisp workPTQr workFTonlyt workFTBlack workFTHisp workFTSq workFTSqBlack workFTSqHisp workFTCu workFTCuBlack workFTCuHisp workFTQr militaryt militaryBlack militaryHisp militarySq militarySqBlack militarySqHisp militaryCu militaryCuBlack militaryCuHisp militaryQr othert otherBlack otherHisp otherSq otherSqBlack otherSqHisp otherCu otherCuBlack otherCuHisp otherQr
local Ivars3   workK12anySchool workCollegeanySchool workCollegeworkK12 workPTanySchool workPTworkK12 workPTworkCollege workFTanySchool workFTworkK12 workFTworkCollege workFTworkPT                              

local risk     gradHS grad4yr
local work     inSchWork PTwork

gen inSchWork  = (activity==2 | activity==12 | activity==22)
gen PTwork     = (activity==3 | activity==13 | activity==23)


*============================================================================
* Summary statistics (for comparison with V++ data read-in)
*============================================================================
recode lnWage lnWageAlt lnWageNoSelf lnWageAltNoSelf lnWageJobMain  (-999=.)
sum lnWageNoSelf `Pvars79' `Mvars' `Svars2' `Zvars2' `Evars2' `Fvars' if inlist(activity,2,3,4,12,13,14,22,23,24) & ~mi(lnWageNoSelf), sep(0)


*============================================================================
* Main Specification
*============================================================================
*--------------------------------------
* Reg2--Variance varies across wage types
*--------------------------------------
gen byte dummy = (2)*( inlist(activity,2,12,22)) + (3)*( inlist(activity,3,13,23)) + (4)*( inlist(activity,4,14,24))
global dumbo dummy

capture program drop normal
	program normal
	version 11.2
	args lnf Xb sigma2 sigma3 sigma4
	quietly replace `lnf'=( ${dumbo}==2)*ln(normalden(${ML_y1}, `Xb', `sigma2'))+( ${dumbo}==3)*ln(normalden(${ML_y1}, `Xb', `sigma3'))+( ${dumbo}==4)*ln(normalden(${ML_y1}, `Xb', `sigma4'))
end

ml model lf normal (lnWageNoSelf = `Pvars79' `Mvars' `Svars2' `Zvars2' `Evars2' `risk' `work') /sigma2 /sigma3 /sigma4 if inlist(activity,2,3,4,12,13,14,22,23,24) & ~mi(lnWageNoSelf), vce(cluster id)
ml max
estimates store reg2
qui outreg2 using y79_wages_anyschool_school_interaction_t0_16, excel replace bdec(4) sdec(4) ctitle(WagesDiffVar)

*--------------------------------------
* Create output for starting values for V++
*--------------------------------------
estimates restore reg2
matrix  wage1   = e(b)'
matrix  wage1v  = vecdiag(e(V))'
matmap  wage1v wage1se, map(sqrt(@))
matrix  like1   = e(ll)

matrix wage_coef  = wage1[1..rowsof(wage1)-3            , 1]
matrix wage_sigma = wage1[rowsof(wage1)-2..rowsof(wage1), 1]
matrix wage_all   = [wage_coef \ wage_sigma]

matrix wage_se_coef  = wage1se[1..rowsof(wage1se)-3              , 1]
matrix wage_se_sigma = wage1se[rowsof(wage1se)-2..rowsof(wage1se), 1]
matrix wage_se_all   = [wage_se_coef \ wage_se_sigma]

svmat  wage_coef
svmat  wage_sigma
svmat  wage_all

svmat  wage_se_coef
svmat  wage_se_sigma
svmat  wage_se_all

matrix wage_output = [wage_coef , wage_se_coef]
matrix sigma_output = [wage_sigma , wage_se_sigma]

outsheet wage_all    using y79_wages_anyschool_school_interaction_t0_16_coef.csv if !mi(wage_all), comma replace
outsheet wage_se_all using y79_wages_anyschool_school_interaction_t0_16_se.csv   if !mi(wage_all), comma replace

putexcel A1=("WageCoefs") A2=matrix(wage_output ,rownames) using y79_wages_anyschool_school_interaction_t0_16.xlsx, sheet ("WageCoefs") modify
putexcel F1=("WageLike")  F2=matrix(like1       ,rownames) using y79_wages_anyschool_school_interaction_t0_16.xlsx, sheet ("WageCoefs") modify
putexcel A1=("WageCoefs") A2=matrix(sigma_output,rownames) using y79_wages_anyschool_school_interaction_t0_16.xlsx, sheet ("WageSigmas") modify

matrix drop _all
drop wage_coef-wage_se_all

log close
