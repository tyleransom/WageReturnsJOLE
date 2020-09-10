version 14.1
set more off
capture log close
capture log using create_vlad_scaled_t0_16.log, replace

clear all
set mem 5g
set maxvar 30000
* This do-file creates the *vlad.dat and .dta files

!unzip -u yCombinedAnalysis_t0_16.dta.zip
use       yCombinedAnalysis_t0_16.dta
!rm       yCombinedAnalysis_t0_16.dta

* Rename variables
rename annualOccMain  occupation
rename annualIndMain  industry
rename hoursWorked    hours

*--------
* Macros
*--------
local AFQTvars  afqt asvabAR asvabCS asvabMK asvabNO asvabPC asvabWK m_afqt m_asvabAR m_asvabCS m_asvabMK m_asvabNO m_asvabPC m_asvabWK
local Pvars79  black hispanic born1957 born1958 born1959 born1960 born1961 born1962 born1963  foreignBorn
local Pvars79O black hispanic born1957 born1958 born1959                                      foreignBorn
local Pvars79Y black hispanic                                     born1961 born1962 born1963  foreignBorn
local Pvars97  black hispanic born1980 born1981 born1982 born1983                             foreignBorn
* local Mvars    empPct incPerCapita numBAperCapita numAAperCapita tuitionFlagship
local Mvars    empPct incPerCapita 
* local Svars    schoolOnlyt schoolOnlySq  
* local Zvars    workK12t workK12Sq workColleget workCollegeSq
* local Evars    workPTonlyt workPTSq workFTonlyt workFTSq militaryt militarySq othert otherSq
local Svars    schoolOnlyt schoolOnlyBlack schoolOnlyHisp schoolOnlySq schoolOnlySqBlack schoolOnlySqHisp schoolOnlyCu
local Svars2   anySchoolt  anySchoolBlack  anySchoolHisp  anySchoolSq  anySchoolSqBlack  anySchoolSqHisp  anySchoolCu
* local Zvars    workK12t workK12Black workK12Hisp workK12Sq workK12SqBlack workK12SqHisp workK12Cu workColleget workCollegeBlack workCollegeHisp workCollegeSq workCollegeSqBlack workCollegeSqHisp workCollegeCu workGradScht workGradSchBlack workGradSchHisp workGradSchSq workGradSchSqBlack workGradSchSqHisp workGradSchCu
local Zvars    workK12t workK12Black workK12Hisp workK12Sq workK12SqBlack workK12SqHisp workK12Cu workColleget workCollegeBlack workCollegeHisp workCollegeSq workCollegeSqBlack workCollegeSqHisp workCollegeCu 
local Evars    workPTonlyt workPTBlack workPTHisp workPTSq workPTSqBlack workPTSqHisp workPTCu workFTonlyt workFTBlack workFTHisp workFTSq workFTSqBlack workFTSqHisp workFTCu militaryt militaryBlack militaryHisp militarySq militarySqBlack militarySqHisp militaryCu othert otherBlack otherHisp otherSq otherSqBlack otherSqHisp otherCu
local Fvars    hgcMoth hgcMothSq m_hgcMoth hgcFath hgcFathSq m_hgcFath famInc famIncSq m_famInc femaleHeadHH14 liveWithMom14
local Cvars    numBAzero numBAperCapita tuitionFlagship
* local Zvarint  workK12schoolOnly workCollegeschoolOnly workCollegeworkK12 workGradSchschoolOnly workGradSchworkK12 workPTschoolOnly workPTworkK12 workPTworkCollege workPTworkGradSch workFTschoolOnly workFTworkK12 workFTworkGradSch workFTworkCollege workFTworkPT
* local Zvarint2 workK12anySchool  workCollegeanySchool  workCollegeworkK12 workGradSchanySchool  workGradSchworkK12 workPTanySchool  workPTworkK12 workPTworkCollege workPTworkGradSch workFTanySchool  workFTworkK12 workFTworkGradSch workFTworkCollege workFTworkPT
local Zvarint  workK12schoolOnly workCollegeschoolOnly workCollegeworkK12 workPTschoolOnly workPTworkK12 workPTworkCollege workFTschoolOnly workFTworkK12 workFTworkCollege workFTworkPT
local Zvarint2 workK12anySchool  workCollegeanySchool  workCollegeworkK12 workPTanySchool  workPTworkK12 workPTworkCollege workFTanySchool  workFTworkK12 workFTworkCollege workFTworkPT
local Avars    potExpt potExpSq potExpCu potExpClassict potExpClassicSq potExpClassicCu

*------------------------
* Keep and generate vars
*  wage, wageAlt and wageJobMain
*------------------------
gen constant = 1
* capture drop wage lnWage
* ren     wageJobMain wage
gen     lnWage = log(wage)
assert  lnWage == .   if inlist(activity_simple,1,5,6)
replace lnWage = -999 if mi(lnWage)

gen     lnWageAlt = log(wageAlt)
assert  lnWageAlt == .   if inlist(activity_simple,1,5,6)
replace lnWageAlt = -999 if mi(lnWageAlt)

gen     lnWageNoSelf = log(wageNoSelf)
assert  lnWageNoSelf == .   if inlist(activity_simple,1,5,6)
replace lnWageNoSelf = -999 if mi(lnWageNoSelf)

gen     lnWageAltNoSelf = log(wageAltNoSelf)
assert  lnWageAltNoSelf == .   if inlist(activity_simple,1,5,6)
replace lnWageAltNoSelf = -999 if mi(lnWageAltNoSelf)

gen     lnWageJobMain = log(wageJobMain)
assert  lnWageJobMain == .   if inlist(activity_simple,1,5,6)
replace lnWageJobMain = -999 if mi(lnWageJobMain)

* re-scale activity variables, by dividing by 12
foreach var in potExpt potExpClassict schoolOnlyt schoolOnlyBlack schoolOnlyHisp anySchoolt anySchoolBlack anySchoolHisp workK12t workK12Black workK12Hisp workColleget workCollegeBlack workCollegeHisp workGradScht workGradSchBlack workGradSchHisp workPTonlyt workPTBlack workPTHisp workFTonlyt workFTBlack workFTHisp militaryt militaryBlack militaryHisp othert otherBlack otherHisp {
	replace `var' = `var'/12
}

* re-scale activity Squared variables by dividing by 12*12*10 = 1440
foreach var in potExpSq potExpClassicSq schoolOnlySq schoolOnlySqBlack schoolOnlySqHisp anySchoolSq anySchoolSqBlack anySchoolSqHisp workK12Sq workK12SqBlack workK12SqHisp workCollegeSq workCollegeSqBlack workCollegeSqHisp workGradSchSq workGradSchSqBlack workGradSchSqHisp workPTSq workPTSqBlack workPTSqHisp workFTSq workFTSqBlack workFTSqHisp militarySq militarySqBlack militarySqHisp otherSq otherSqBlack otherSqHisp  {
	replace `var' = `var'/1440
}

* re-scale activity interaction variables by dividing by 12*12*10 = 1440
foreach var in workK12schoolOnly workCollegeschoolOnly workCollegeworkK12 workGradSchschoolOnly workGradSchworkK12 workPTschoolOnly workPTworkK12 workPTworkCollege workPTworkGradSch workFTschoolOnly workFTworkK12 workFTworkCollege workFTworkGradSch workFTworkPT workK12anySchool workCollegeanySchool workGradSchanySchool workPTanySchool workFTanySchool {
	replace `var' = `var'/1440
}

* re-scale activity Cubed variables by dividing by 12*12*12*100 = 172800
foreach var in potExpCu potExpClassicCu schoolOnlyCu schoolOnlyCuBlack schoolOnlyCuHisp anySchoolCu anySchoolCuBlack anySchoolCuHisp workK12Cu workK12CuBlack workK12CuHisp workCollegeCu workCollegeCuBlack workCollegeCuHisp workGradSchCu workGradSchCuBlack workGradSchCuHisp workPTCu workPTCuBlack workPTCuHisp workFTCu workFTCuBlack workFTCuHisp militaryCu militaryCuBlack militaryCuHisp otherCu otherCuBlack otherCuHisp  {
	replace `var' = `var'/172800
}

* re-scale activity Quartic'ed variables by dividing by 12*12*12*12*1000 = 20736000
foreach var in schoolOnlyQr anySchoolQr workK12Qr workCollegeQr workGradSchQr workPTQr workFTQr militaryQr otherQr  {
	replace `var' = `var'/20736000
}

foreach var in  hgcSq hgcMothSq hgcMothSqBlack hgcMothSqHisp hgcFathSq hgcFathSqBlack hgcFathSqHisp famInc famIncBlack famIncHisp {
	replace `var' = `var'/10
}

foreach var in  hgcMothCu hgcMothCuBlack hgcMothCuHisp hgcFathCu hgcFathCuBlack hgcFathCuHisp famIncSq famIncSqBlack famIncSqHisp {
	replace `var' = `var'/1000
}

foreach var in  hgcMothQr hgcFathQr famIncCu famIncCuBlack famIncCuHisp {
	replace `var' = `var'/100000
}

foreach var in  famIncQr {
	replace `var' = `var'/10000000
}

save yCombined_scaled_t0_16.dta, replace


*----------------------------------------------------------------------------
* Reshape wide
* The 'cons' vars are not included in the reshape since they never change
*----------------------------------------------------------------------------
local chng   uniqueid period yearmo activity activity_simple lnWage lnWageAlt lnWageNoSelf lnWageAltNoSelf lnWageJobMain hours `Svars' `Svars2' `Zvars' `Evars' `Zvarint2' `Avars' `Mvars' gradHS grad2yr grad4yr gradGraduate
local cons   cohortFlag id constant female oversampleRace weight `Pvars79' `Pvars97' `AFQTvars' `Fvars' `Cvars'
local cons79 cohortFlag id constant female oversampleRace weight `Pvars79'           `AFQTvars' `Fvars' `Cvars'
local cons97 cohortFlag id constant female oversampleRace weight           `Pvars97' `AFQTvars' `Fvars' `Cvars'

* sum   `cons79' `chng' if cohortFlag==1979 & ( born1957==1 | born1958==1 | born1959==1 | born1960==1) & !female, separator(0)
sum   `cons79' `chng' if cohortFlag==1979 & ~female & ~mi(activity) & born1957==0 & born1958==0 , separator(0)
sum   `cons97' `chng' if cohortFlag==1997 & ~female & ~mi(activity)                             , separator(0)
keep  `cons'   `chng' agemo
order `cons'   `chng'

reshape wide `chng', i(cohortFlag id) j(agemo)
order        `cons'

* JA: I already did the hard work in data_import to line these up, BUT it seems we 
*     should have had the same var list in both and then just set to missing those
*     with the `wrong' birth cohort. Que sera...
preserve
	drop born198?
	order `cons79'

	* outsheet using y79m_vlad_scaled_full_cohorts_t0_16.csv if cohortFlag==1979, comma replace nolabel
	* drop if born1957==1 | born1958==1 | born1959==1 | born1960==1
	outsheet using y79_vlad_scaled_t0_16.csv              if cohortFlag==1979, comma replace nolabel
restore
preserve
	drop born195? born196?
	order `cons97'

	outsheet using y97_vlad_scaled_t0_16.csv if cohortFlag==1997, comma replace nolabel
	* ! cp -pf y97m_vlad_scaled_full_cohorts_t0_16.csv y97m_vlad_scaled_t0_16.csv
restore

! chmod 774 *.dta
log close
