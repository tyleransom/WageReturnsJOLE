version 13.1
clear all
set more off

capture log close
log using y79_logits_all_binned_t0_16.log, replace
set matsize 4000

*****************************************************************************
* Perform mlogits on data to use at starting points for V++
*  Race Interactions Model
*****************************************************************************
*============================================================================
* Import data, define macros, call constraints
*============================================================================

if "`c(username)'"=="jared"  global secretdir [REDACTED]
if "`c(username)'"=="ransom" global secretdir [REDACTED]

use if cohortFlag==1979 & ~female using ${secretdir}/yCombined_scaled_t0_16.dta, clear
drop if inlist(birthYear,1957,1958)

* local Pvars79O black hispanic born1957 born1958 born1959          foreignBorn
* local Pvars79Y black hispanic born1961 born1962 born1963          foreignBorn
local Pvars79  black hispanic born1959 born1960 born1961 born1962 born1963 foreignBorn
local Pvars97  black hispanic born1980 born1981 born1982 born1983          foreignBorn
local Mvars    empPct incPerCapita
local Fvars    hgcMoth hgcMothSq m_hgcMoth hgcFath hgcFathSq m_hgcFath famInc famIncSq m_famInc femaleHeadHH14 liveWithMom14
local Cvars    numBAzero numBAperCapita tuitionFlagship

local Svars1    schoolOnlyBlack schoolOnlyHisp
local Zvars1    workK12Black workK12Hisp
local Evars1    workPTBlack workPTHisp workFTBlack workFTHisp otherBlack otherHisp

local Svars2    schoolOnlyBlack schoolOnlyHisp
local Zvars2    workK12Black workK12Hisp workCollegeBlack workCollegeHisp 
local Evars2    workPTBlack workPTHisp workFTBlack workFTHisp militaryBlack militaryHisp otherBlack otherHisp

local Svars3    schoolOnlyBlack schoolOnlyHisp
local Zvars3    workK12Black workK12Hisp workCollegeBlack workCollegeHisp 
local Evars3    workPTBlack workPTHisp workFTBlack workFTHisp militaryBlack militaryHisp otherBlack otherHisp

local Svars    schoolOnlyt schoolOnlyBlack schoolOnlyHisp schoolOnlySq
local Zvars    workK12t workK12Black workK12Hisp workK12Sq workColleget workCollegeBlack workCollegeHisp workCollegeSq
local Evars    workPTonlyt workPTBlack workPTHisp workPTSq workFTonlyt workFTBlack workFTHisp workFTSq militaryt militaryBlack militaryHisp militarySq othert otherBlack otherHisp otherSq


* table activity, c(freq p5 anySchoolt   mean anySchoolt   median anySchoolt   p95 anySchoolt  )
* table activity, c(freq p5 schoolOnlyt  mean schoolOnlyt  median schoolOnlyt  p95 schoolOnlyt )
* table activity, c(freq p5 workK12t     mean workK12t     median workK12t     p95 workK12t    )
* table activity, c(freq p5 workColleget mean workColleget median workColleget p95 workColleget)
* table activity, c(freq p5 workPTonlyt  mean workPTonlyt  median workPTonlyt  p95 workPTonlyt )
* table activity, c(freq p5 workFTonlyt  mean workFTonlyt  median workFTonlyt  p95 workFTonlyt )
* table activity, c(freq p5 militaryt    mean militaryt    median militaryt    p95 militaryt   )
* table activity, c(freq p5 othert       mean othert       median othert       p95 othert      )

* Generate some bin variables based on schooling experience

generat schoolOnlyBin = . 
replace schoolOnlyBin = 1 if schoolOnlyt>=0   & schoolOnlyt<0.5
replace schoolOnlyBin = 2 if schoolOnlyt>=0.5 & schoolOnlyt<1
replace schoolOnlyBin = 3 if schoolOnlyt>=1   & schoolOnlyt<1.5
replace schoolOnlyBin = 4 if schoolOnlyt>=1.5 & schoolOnlyt<2
replace schoolOnlyBin = 5 if schoolOnlyt>=2   & schoolOnlyt<3
replace schoolOnlyBin = 6 if schoolOnlyt>=3   & schoolOnlyt<4
replace schoolOnlyBin = 7 if schoolOnlyt>=4   & schoolOnlyt<5
replace schoolOnlyBin = 8 if schoolOnlyt>=5   & schoolOnlyt<6
replace schoolOnlyBin = 9 if schoolOnlyt>=6   & schoolOnlyt<.

generat workK12Bin = . 
replace workK12Bin = 1 if workK12t>=0    & workK12t<0.20
replace workK12Bin = 2 if workK12t>=0.20 & workK12t<0.40
replace workK12Bin = 3 if workK12t>=0.40 & workK12t<0.60
replace workK12Bin = 4 if workK12t>=0.60 & workK12t<0.80
replace workK12Bin = 5 if workK12t>=0.80 & workK12t<1.00
replace workK12Bin = 6 if workK12t>=1.00 & workK12t<1.20
replace workK12Bin = 7 if workK12t>=1.20 & workK12t<1.40
replace workK12Bin = 8 if workK12t>=1.40 & workK12t<1.60
replace workK12Bin = 9 if workK12t>=1.60 & workK12t<.

generat workCollegeBin = . 
replace workCollegeBin = 1 if workColleget>=0   & workColleget<0.5
replace workCollegeBin = 2 if workColleget>=0.5 & workColleget<1.0
replace workCollegeBin = 3 if workColleget>=1.0 & workColleget<1.5
replace workCollegeBin = 4 if workColleget>=1.5 & workColleget<2.0
replace workCollegeBin = 5 if workColleget>=2.0 & workColleget<2.5
replace workCollegeBin = 6 if workColleget>=2.5 & workColleget<3.0
replace workCollegeBin = 7 if workColleget>=3.0 & workColleget<4.0
replace workCollegeBin = 8 if workColleget>=4.0 & workColleget<5.0
replace workCollegeBin = 9 if workColleget>=5.0 & workColleget<.

generat workPTonlyBin = . 
replace workPTonlyBin = 1 if workPTonlyt>=(0/3) & workPTonlyt<(1/3)
replace workPTonlyBin = 2 if workPTonlyt>=(1/3) & workPTonlyt<(2/3)
replace workPTonlyBin = 3 if workPTonlyt>=(2/3) & workPTonlyt<(3/3)
replace workPTonlyBin = 4 if workPTonlyt>=(3/3) & workPTonlyt<(4/3)
replace workPTonlyBin = 5 if workPTonlyt>=(4/3) & workPTonlyt<(5/3)
replace workPTonlyBin = 6 if workPTonlyt>=(5/3) & workPTonlyt<(6/3)
replace workPTonlyBin = 7 if workPTonlyt>=(6/3) & workPTonlyt<(7/3)
replace workPTonlyBin = 8 if workPTonlyt>=(7/3) & workPTonlyt<(8/3)
replace workPTonlyBin = 9 if workPTonlyt>=(8/3) & workPTonlyt<.

generat workFTonlyBin = . 
replace workFTonlyBin = 1 if workFTonlyt>=0 & workFTonlyt<1
replace workFTonlyBin = 2 if workFTonlyt>=1 & workFTonlyt<2
replace workFTonlyBin = 3 if workFTonlyt>=2 & workFTonlyt<3
replace workFTonlyBin = 4 if workFTonlyt>=3 & workFTonlyt<4
replace workFTonlyBin = 5 if workFTonlyt>=4 & workFTonlyt<5
replace workFTonlyBin = 6 if workFTonlyt>=5 & workFTonlyt<6
replace workFTonlyBin = 7 if workFTonlyt>=6 & workFTonlyt<7
replace workFTonlyBin = 8 if workFTonlyt>=7 & workFTonlyt<8
replace workFTonlyBin = 9 if workFTonlyt>=8 & workFTonlyt<.

generat militaryBin = . 
replace militaryBin = 1 if militaryt>=0   & militaryt<1.0
replace militaryBin = 2 if militaryt>=1.0 & militaryt<1.5
replace militaryBin = 3 if militaryt>=1.5 & militaryt<2.0
replace militaryBin = 4 if militaryt>=2.0 & militaryt<3.0
replace militaryBin = 5 if militaryt>=3.0 & militaryt<.

generat otherBin = . 
replace otherBin = 1 if othert>=0    & othert<0.25
replace otherBin = 2 if othert>=0.25 & othert<0.50
replace otherBin = 3 if othert>=0.50 & othert<1.00
replace otherBin = 4 if othert>=1.00 & othert<1.50
replace otherBin = 5 if othert>=1.50 & othert<2.00
replace otherBin = 6 if othert>=2.00 & othert<3.00
replace otherBin = 7 if othert>=3.00 & othert<4.00
replace otherBin = 8 if othert>=4.00 & othert<5.00
replace otherBin = 9 if othert>=5.00 & othert<.

foreach var in schoolOnly workK12 workCollege workPTonly workFTonly military other {
	qui tab `var'Bin, gen(`var')
}

local Bvars  b4.schoolOnlyBin b3.workK12Bin b3.workCollegeBin b4.workPTonlyBin b3.workFTonlyBin b3.militaryBin b4.otherBin
local Bvars1 b4.schoolOnlyBin b3.workK12Bin                   b4.workPTonlyBin b3.workFTonlyBin                b4.otherBin
local Bvars2 b4.schoolOnlyBin b3.workK12Bin b3.workCollegeBin b4.workPTonlyBin b3.workFTonlyBin b3.militaryBin b4.otherBin
local Bvars3 b4.schoolOnlyBin b3.workK12Bin b3.workCollegeBin b4.workPTonlyBin b3.workFTonlyBin b3.militaryBin b4.otherBin

local BvarsSum schoolOnly? workK12? workCollege? workPTonly? workFTonly? military? other? 

* Constraints 
constraint drop _all
* do y79_constraints.do
do y79_constraints_all_binned.do
label val activity .
label val activity_simple .


*============================================================================
* Summary statistics (for comparison with V++ data read-in)
*============================================================================
recode lnWage lnWageAlt lnWageNoSelf lnWageAltNoSelf lnWageJobMain  (-999=.)

sum lnWageNoSelf `Pvars79' `Mvars' `Svars'  `Zvars'  `Evars'  `Fvars' `Cvars' `BvarsSum' if inlist(activity,1,2,3,4,5,6,7,11,12,13,14,15,16,17,21,22,23,24,25,26), sep(0)
sum lnWageNoSelf `Pvars79' `Mvars' `Svars1' `Zvars1' `Evars1' `Fvars' `Cvars' `BvarsSum' if inlist(activity,1,2,3,4,5,6,7,11,12,13,14,15,16,17,21,22,23,24,25,26), sep(0)


*============================================================================
* Logits
*============================================================================
mlogit  activity        `Pvars79' `Mvars' `Svars1' `Zvars1' `Evars1' `Fvars' `Cvars' `Bvars1' if inrange(activity, 1, 7) , difficult baseoutcome(1 ) constraints(101/179) vce(cluster id)
predict p1risk1 p1risk2 p1risk3 p1risk4 p1risk5 p1risk6 p1risk7 if e(sample), pr
estimates store logit1
qui outreg2 using y79_logits_all_binned_t0_16, excel replace bdec(4) sdec(4)

mlogit  activity        `Pvars79' `Mvars' `Svars2' `Zvars2' `Evars2' `Fvars' `Cvars' `Bvars2' if inrange(activity,11,17) , difficult baseoutcome(11) constraints(201/220) vce(cluster id)
predict p2risk11 p2risk12 p2risk13 p2risk14 p2risk15 p2risk16 p2risk17 if e(sample), pr
estimates store logit2
qui outreg2 using y79_logits_all_binned_t0_16, excel append  bdec(4) sdec(4)

mlogit  activity        `Pvars79' `Mvars' `Svars3' `Zvars3' `Evars3' `Fvars' `Cvars' `Bvars3' if inrange(activity,21,26) , difficult baseoutcome(21) constraints(301/450) iterate(20) vce(cluster id)
predict p3risk21 p3risk22 p3risk23 p3risk24 p3risk25 p3risk26 if e(sample), pr
estimates store logit3
qui outreg2 using y79_logits_all_binned_t0_16, excel append  bdec(4) sdec(4)

*============================================================================
* Model Fit of Logits
*============================================================================
tab activity if inrange(activity, 1, 7)
sum p1risk*  if inrange(activity, 1, 7), sep(0)
tab activity if inrange(activity,11,17)
sum p2risk*  if inrange(activity,11,17), sep(0)
tab activity if inrange(activity,21,26)
sum p3risk*  if inrange(activity,21,26), sep(0)

*============================================================================
* Model Fit of Graduation probabilities by schooling bins
*============================================================================
tab schoolOnlyBin          if inrange(activity, 1, 7), sum(p1risk7)
tab schoolOnlyBin activity if inrange(activity, 1, 7), cell
tab schoolOnlyBin          if inrange(activity,11,17), sum(p2risk17)
tab schoolOnlyBin activity if inrange(activity,11,17), cell

*============================================================================
* Create output for starting values for V++
*============================================================================
estimates restore logit1
matrix  log1   = e(b)'
matrix list log1
matrix  log1v  = vecdiag(e(V))'
matmap  log1v  log1se, map(sqrt(@))
scalar  start1 = rowsof(log1) - e(k) + 1
scalar  end1   = rowsof(log1)
matrix  log1   = log1[start1..end1, 1]
matrix  log1se = log1se[start1..end1, 1]
matrix  like1  = e(ll)

estimates restore logit2
matrix  log2   = e(b)'
matrix list log2
matrix  log2v  = vecdiag(e(V))'
matmap  log2v  log2se, map(sqrt(@))
scalar  start2 = rowsof(log2) - e(k) + 1
scalar  end2   = rowsof(log2)
matrix  log2   = log2[start2..end2, 1]
matrix  log2se = log2se[start2..end2, 1]
matrix  like2  = e(ll)

estimates restore logit3
matrix  log3   = e(b)'
matrix list log3
matrix  log3v  = vecdiag(e(V))'
matmap  log3v  log3se, map(sqrt(@))
scalar  start3 = rowsof(log3) - e(k) + 1
scalar  end3   = rowsof(log3)
matrix  log3   = log3[start3..end3, 1]
matrix  log3se = log3se[start3..end3, 1]
matrix  like3  = e(ll)

matrix logit_coef = [log1 \ log2 \ log3]
matrix logit_se = [log1se \ log2se \ log3se]

svmat  logit_coef
svmat  logit_se

matrix logit_output = [logit_coef , logit_se]
matrix likeSum =  like1 + like2 + like3 
matrix likeAll = [like1 \ like2 \ like3 \ likeSum]

preserve
	keep logit_coef
	drop if logit_coef==.
	outsheet logit_coef using y79_logits_all_binned_t0_16_coef.csv, comma replace
restore
preserve
	keep logit_se
	drop if logit_se==.
	outsheet logit_se using y79_logits_all_binned_t0_16_se.csv, comma replace
restore

putexcel A1=("LogitCoefs") A2=matrix(logit_output,rownames) using y79_logits_all_binned_t0_16.xlsx, sheet("LogitAll") modify
putexcel F1=("LogitLikes") F2=matrix(likeAll     ,rownames) using y79_logits_all_binned_t0_16.xlsx, sheet("LogitAll") modify

log close
