version 14.1
clear all
set maxvar 32000

capture log close
set more off
set seed 32 // TROGDOR!!!
log using activity_tabulations29.log, replace

* if "`c(username)'"=="jared"  global secretdir [REDACTED]
* if "`c(username)'"=="ransom" global secretdir [REDACTED]
* For confidential data, unzip to secretdir; also, I'm not sure how to use a macro here

if "`c(username)'"=="jared"  {
	!unzip -u [REDACTED]yCombinedAnalysis_t0_16.dta.zip yCombinedAnalysis_t0_16.dta -d [REDACTED]
	use       [REDACTED]yCombinedAnalysis_t0_16.dta, clear
	!rm       [REDACTED]yCombinedAnalysis_t0_16.dta
}
else if "`c(username)'"=="ransom"  {
	!unzip -u [REDACTED]yCombinedAnalysis_t0_16.dta.zip yCombinedAnalysis_t0_16.dta -d [REDACTED]
	use       [REDACTED]yCombinedAnalysis_t0_16.dta, clear
	!rm       [REDACTED]yCombinedAnalysis_t0_16.dta
}

global tbls_loc ./

********************************************************************
* Perform and export various graphs and tabulations for both cohorts
********************************************************************

* Program to return a string of stars based on p-value
capture program drop star
program star
	if      `1' <= 0.01   c_local `2' "***"  
	else if `1' <= 0.05   c_local `2' "**"
	else if `1' <= 0.1    c_local `2' "*"
	else                  c_local `2' " "
end

*=============================================
* Create variables used in the graphs and tabs
*=============================================
* Create a cohortFlag variable that breaks out 79o and 79y separately
* EDIT: JA 1/2019, no more breaking them out separately
drop if inlist(birthYear,1957,1958)

* EDIT: JA 2/26/2020: Eval at age 29 including education by that point
* Thus, no need for anything after 2812
drop if agemo>2812

* Clean data
replace avgHrs = 0 if mi(avgHrs)
drop if female
sort cohortFlag id year

lab def vlfemale   0 "Male" 1 "Female"
lab def vlrace     1 "White" 2 "Black" 3 "Hispanic"
lab def vlactivity 1 "School" 2 "WorkSch" 3 "WorkPT" 4 "WorkFT" 5 "Military" 6 "Other"
* lab val female     vlfemale
lab val race       vlrace
lab val activity_simple  vlactivity

* Log wages: use monthly wage that excludes self-employed workers
capture drop wage
ren wageNoSelf wage 
gen lnWage = log(wage)

* How many ever started college?
bys cohortFlag id: generat startCol         = (activity==11 | activity==12)
bys cohortFlag id: replace startCol         = 1 if startCol[_n-1]==1 & _n>1
bys cohortFlag id: egen    everStartCol     = max(startCol)

* How many ever started grad school?
bys cohortFlag id: generat startGS         = (activity==21 | activity==22)
bys cohortFlag id: replace startGS         = 1 if startGS[_n-1]==1 & _n>1
bys cohortFlag id: egen    everStartGS     = max(startGS)

* BA completion conditional on starting any type of college
* generat condlGrad4yr = 1 if grad4yr
* replace condlGrad4yr = 0 if ~grad4yr & startCol
gen grad4yrCond = grad4yr if startCol

* Num months between first month in college and graduation
* Find month in which startCol is turned on and month in which activity==17
*  Hrmmm...panel should be continuous, ie no one should be missing at any point
*  thus, all we care about is the difference in _n
bys cohortFlag id: gen  nEndHSTemp  = _n if activity==7
bys cohortFlag id: egen nEndHS      = max(nEndHSTemp)
bys cohortFlag id: gen  nEndColTemp = _n if activity==17
bys cohortFlag id: egen nEndCol     = max(nEndColTemp)

* monthsToCol will be missing for anyone that is never in activity 17
gen monthsToCol = nEndCol-nEndHS+1 if grad4yr
gen yearsToCol = monthsToCol/12 if grad4yr

drop nEndHSTemp nEndColTemp

* get variable indicating last month of each year
gen firstMonth = mod(agemo, (age*100))==1
gen lastMonth  = mod(agemo, (age*100))==12

* generate total experience
gen totExpert = workScht+workPTonlyt+workFTonlyt

* generate total work in college experience from "Freshman" and "Sophmore" years
* From data_append: bys uniqueid (period): gen workColleget  = sum(L.workCollege)
gen workCollegeEarly = workCollege & enrColleget<=16
gen workCollegeLate  = workCollege & enrColleget>16

bys uniqueid (period): gen workCollegeEarlyt  = sum(L.workCollegeEarly)
bys uniqueid (period): gen workCollegeLatet   = sum(L.workCollegeLate)

assert workColleget==workCollegeEarlyt + workCollegeLatet

*--------------------------------------------------------------------
* generate indicators for highest degree attained
* Note: we dropped all obs after 2812. As such, to determine
*  highest degree attained by age 29, look at the LASTOBS for
*  each person
*--------------------------------------------------------------------
* gen HSdropout  = ~everGradHS
* gen HSgraduate = everGradHS & ~everStartCol
* gen BAdropout  = everGradHS &  everStartCol & ~everGrad4yr
* gen BAgraduate = everGrad4yr

bys cohortFlag id: gen HSdropout  =  gradHS[_N]==0 &  startCol[_N]==0 &  grad4yr[_N]==0
bys cohortFlag id: gen HSgraduate =  gradHS[_N]==1 &  startCol[_N]==0 &  grad4yr[_N]==0
bys cohortFlag id: gen BAdropout  =  gradHS[_N]==1 &  startCol[_N]==1 &  grad4yr[_N]==0
bys cohortFlag id: gen BAgraduate =  gradHS[_N]==1 &  startCol[_N]==1 &  grad4yr[_N]==1

gen     highDegAttain = 1 if HSdropout
replace highDegAttain = 2 if HSgraduate
replace highDegAttain = 3 if BAdropout
replace highDegAttain = 4 if BAgraduate

local vlHDA 1 "HS drop" 2 "HS grad"  3 "Some col" 4 "BA grad" 5 "All"
lab def vlHDA `vlHDA'
lab val highDegAttain vlHDA

* Fix miscode of workK12
gen workK12fix = inlist(activity,2)
bys uniqueid (period): gen workK12fixt = sum(L.workK12fix)

replace workK12  = workK12fix
replace workK12t = workK12fixt

* generate average experience levels at last observation
foreach X in anySchool schoolOnly workK12 workCollege workCollegeEarly workCollegeLate workSch workPTonly workFTonly military other totExper {
	bys cohortFlag id: gen `X'T = `X't[_N]
}

* generate annualized experience variables
foreach X in anySchool schoolOnly workK12 workCollege workCollegeEarly workCollegeLate workSch workPTonly workFTonly military other totExper {
	bys cohortFlag id: gen `X'tYears = round(`X't/12)
}

* generate positive indicator for numBA
gen posBA = numBAperCapita>0 & !mi(numBAperCapita)

*** Old vars
* * What is graduation status of people at various ages?
* bys cohortFlag id:  gen everGrad4yr      = (BA_year<.)
* bys cohortFlag id:  gen ageYrGrad4yr     = age if activity==17
* * HS Diploma ONLY
* bys cohortFlag id:  gen everGradDiploma      = (Diploma_year<.)
* bys cohortFlag id:  gen ageYrGradDiploma     = age         if year==Diploma_year & month==Diploma_month
                    * * gen FTexperYrGradDiploma = workFTonlyt if year==Diploma_year & month==Diploma_month
* * either HS Diploma OR GED (or both)
* bys cohortFlag id:  gen everGradHS           = (HS_year<.)
* bys cohortFlag id:  gen ageYrGradHS          = age         if activity==7
* bys cohortFlag id:  gen ageYrGradGED         = age         if year==GED_year & month==GED_month

* * generate experience variables as of last period in school
* gen inSchool    = inlist(activity,1,2,11,12,21,22)
* gen lastSchoolA = yearmo*inSchool
* bys cohortFlag id: egen lastSchool = max(lastSchoolA)
* gen yearLastSchool  = floor(lastSchool/100)
* gen monthLastSchool = lastSchool-100*yearLastSchool
* gen FTexperLastSch1 = workFTonlyt if yearmo==lastSchool
* bys cohortFlag id: egen FTexperLastSch = mean(FTexperLastSch1)
* * set FT experience at 0 if someone never attended school
* recode FTexperLastSch (. = 0)

* gen FTexperYrGradHS1 = workFTonlyt if activity==7
* bys cohortFlag id: egen FTexperYrGradHS = mean(FTexperYrGradHS1)
* gen FTexperYrGradBA1 = workFTonlyt if activity==17
* bys cohortFlag id: egen FTexperYrGradBA = mean(FTexperYrGradBA1)
* drop FTexperYrGradHS1 FTexperYrGradBA1 lastSchoolA

* * generate indicators for ever obtaining certain work experience
* bys cohortFlag id: gen everWorkK12     = workK12t[_N]>=3
* bys cohortFlag id: gen everWorkCollege = workColleget[_N]>=3 if everStartCol
* bys cohortFlag id: gen everWorkPT = workPTonlyt[_N]>=3
* bys cohortFlag id: gen everWorkFT = workFTonlyt[_N]>=3

* * generate variable indicating number of months individual workPT or workFT for a given age
* bys cohortFlag id age (agemo): egen workPTonlyMonths = total(workPTonly)
* bys cohortFlag id age (agemo): egen workFTonlyMonths = total(workFTonly)

*==========================
* Do graphs and tabulations
*==========================
*------------------------------------------------
* Table: Personal and Family Background Vars (Demog, AFQT, family)
*------------------------------------------------
* Data tweaks
bys cohortFlag id: gen numMonths = _N
recode hgcMoth hgcFath famInc (0 = .)


foreach cohort in 1979 1997 {
	* N at 16 and 29, and average NT by age 29 (including those who dropped out)
	count if firstObs & cohortFlag==`cohort'
	local N_`cohort'_age16 = `r(N)'

	count if agemo==2812 & cohortFlag==`cohort'
	local N_`cohort'_age29 = `r(N)'

	sum numMonths if firstObs & cohortFlag==`cohort'
	local NT_`cohort'_age29 = `r(mean)'
}

* Demog and family
local v = 1
foreach var in white black hispanic foreignBorn hgcMoth hgcFath famInc femaleHeadHH14 {
	qui mean `var' [aw=weight] if agemo==2812 , over(cohortFlag)
	matrix m = e(b)
	foreach cohort in 1979 1997 {
		local mu`v'_`cohort'_all = el(m,1,colnumb(m,"`var':`cohort'"))
	}
	qui test[`var']1979 = [`var']1997
    star `r(p)' star`v'_diff_all 
    * forvalues x=1/4 {
		* qui mean `var' [aw=weight] if agemo==2812 & highDegAttain==`x', over(cohortFlag)
		* matrix m = e(b)
		* foreach cohort in 1979 1997 {
			* local mu`v'_`cohort'_`x' = el(m,1,colnumb(m,"`var':`cohort'"))
		* }
		* qui test[`var']1979 = [`var']1997
		* star `r(p)' star`v'_diff_`x'
    * }
local ++v
}

***** AFQT
*** compute median, SD, and N
foreach y in 1979 1997 {
	qui sum afqt [aw=weight] if agemo==2812 & !m_afqt & cohortFlag==`y', d
	local med_`y'_all = `r(p50)'
	local  sd_`y'_all = `r(sd)'
	local   N_`y'_all = `r(N)'
	* forvalues x=1/4 {
		* qui sum afqt [aw=weight] if agemo==2812 & !m_afqt & highDegAttain==`x' & cohortFlag==`y', d
		* local med_`y'_`x' = `r(p50)'
		* local  sd_`y'_`x' = `r(sd)'
		* local   N_`y'_`x' = `r(N)'
	* }
}

*** bootstrapped standard errors of median
matrix holderDerek = J(5,2,0)

local cc = 0
foreach y in 1979 1997 {
	local cc = `cc'+1
	qui bsqreg afqt if cohortFlag==`y' & agemo==2812 & ~m_afqt, reps(500) // weights not allowed
	matrix tester = e(V)
	matrix holderDerek[5,`cc'] = sqrt(tester[1,1])
}
matrix list holderDerek
local SEmed_1979_all = holderDerek[5,1]
local SEmed_1997_all = holderDerek[5,2]

* local cc = 0
* foreach y in 1979 1997 {
	* local cc = `cc'+1
	* forvalues h = 1/4 {
		* qui bsqreg afqt if cohortFlag==`y' & highDegAttain==`h' & agemo==2812 & ~m_afqt, reps(500) // weights not allowed
		* matrix tester = e(V)
		* matrix holderDerek[`h',`cc'] = sqrt(tester[1,1])
	* }
* }
* matrix list holderDerek
* forvalues h = 1/4 {
    * local SEmed_1979_`h' = holderDerek[`h',1]
    * local SEmed_1997_`h' = holderDerek[`h',2]
* }


*** compute p-values for differences in median
local tee = `=(`med_1997_all'-`med_1979_all')/(sqrt(`SEmed_1997_all'^2+`SEmed_1979_all'^2))'
local pv  = tprob(`=min(`N_1997_all',`N_1979_all')',`tee')
star `pv' starMed_diff_all

* forv h=1/4 {
    * local tee = `=(`med_1997_`h''-`med_1979_`h'')/(sqrt(`SEmed_1997_`h''^2+`SEmed_1979_`h''^2))'
    * local pv  = tprob(`=min(`N_1997_`h'',`N_1979_`h'')',`tee')
	* star `pv' starMed_diff_`h'
* }

*** compute p-values for ratios of standard deviation
local eff = `=(`med_1997_all'^2/`med_1979_all'^2)'
local pv  = fprob(`N_1997_all',`N_1979_all',`eff')
star `pv' starSD_diff_all

* forv h=1/4 {
    * local eff = `=(`med_1997_`h''^2/`med_1979_`h''^2)'
    * local pv  = fprob(`N_1997_`h'',`N_1979_`h'',`eff')
	* star `pv' starSD_diff_`h'
* }


capture file close Tbackground
file open Tbackground using "${tbls_loc}Tbackground_29.tex", write replace
file write Tbackground "\begin{table}[ht]" _n 
* file write Tbackground "\caption{Demographic and AFQT performance by educational attainment at age 29}" _n 
file write Tbackground "\caption{Demographic, Family and AFQT characteristics}" _n 
file write Tbackground "\label{tab:background}" _n 
file write Tbackground "\centering" _n 
file write Tbackground "\scalebox{1.0}[1.0]{% " _n 
file write Tbackground "\begin{threeparttable}" _n 
file write Tbackground "\begin{tabular}{lrrr@{}l}" _n 
file write Tbackground "\toprule " _n 
file write Tbackground "Variable & NLSY79 & NLSY97 & \multicolumn{2}{c}{97--79} \\" _n 
file write Tbackground "\midrule " _n 
file write Tbackground "\multicolumn{5}{l}{\emph{Demographics:}} \\" _n 
file write Tbackground "~~White:                            " " & " %4.2f (`mu1_1979_all')  " & " %4.2f (`mu1_1997_all')  " & " %4.2f (`=`mu1_1997_all'-`mu1_1979_all'')  " & `star1_diff_all' \\ "  _n 
file write Tbackground "~~Black:                            " " & " %4.2f (`mu2_1979_all')  " & " %4.2f (`mu2_1997_all')  " & " %4.2f (`=`mu2_1997_all'-`mu2_1979_all'')  " & `star2_diff_all' \\ "  _n 
file write Tbackground "~~Hispanic:                         " " & " %4.2f (`mu3_1979_all')  " & " %4.2f (`mu3_1997_all')  " & " %4.2f (`=`mu3_1997_all'-`mu3_1979_all'')  " & `star3_diff_all' \\ "  _n 
file write Tbackground "~~Foreign Born:                     " " & " %4.2f (`mu4_1979_all')  " & " %4.2f (`mu4_1997_all')  " & " %4.2f (`=`mu4_1997_all'-`mu4_1979_all'')  " & `star4_diff_all' \\ "  _n 
file write Tbackground "\vspace{-6pt}  \\" _n                                                                                                         
file write Tbackground "\multicolumn{5}{l}{\emph{Family Characteristics:}} \\" _n 
file write Tbackground "~~Mother's education:               " " & " %4.2f (`mu5_1979_all')  " & " %4.2f (`mu5_1997_all')  " & " %4.2f (`=`mu5_1997_all'-`mu5_1979_all'')  " & `star5_diff_all' \\ "  _n 
file write Tbackground "~~Father's education:               " " & " %4.2f (`mu6_1979_all')  " & " %4.2f (`mu6_1997_all')  " & " %4.2f (`=`mu6_1997_all'-`mu6_1979_all'')  " & `star6_diff_all' \\ "  _n 
file write Tbackground "~~Family Income:                    " " & " %4.2f (`mu7_1979_all')  " & " %4.2f (`mu7_1997_all')  " & " %4.2f (`=`mu7_1997_all'-`mu7_1979_all'')  " & `star7_diff_all' \\ "  _n 
file write Tbackground "~~Share lived in female-headed HH:  " " & " %4.2f (`mu8_1979_all')  " & " %4.2f (`mu8_1997_all')  " & " %4.2f (`=`mu8_1997_all'-`mu8_1979_all'')  " & `star8_diff_all' \\ "  _n 
file write Tbackground "\vspace{-6pt}  \\" _n                                                                                                         
file write Tbackground "\multicolumn{5}{l}{\emph{AFQT:}} \\" _n 
file write Tbackground "~~Median of AFQT score              " " & " %4.2f (`med_1979_all')  " & " %4.2f (`med_1997_all')  " & " %4.2f (`=`med_1997_all'-`med_1979_all'')  " & `starMed_diff_all' \\ "  _n 
file write Tbackground "~~Standard Deviation of AFQT score: " " & " %4.2f (`sd_1979_all')   " & " %4.2f (`sd_1997_all')   " & " %4.2f (`=`sd_1997_all'-`sd_1979_all'')    " & `starSD_diff_all' \\ "  _n 
* file write Tbackground "\multicolumn{5}{l}{\emph{Black:}} \\" _n 
* file write Tbackground "~~HS Dropouts                " " & " %4.2f (`mu1_1979_1')    " & " %4.2f (`mu1_1997_1')    " & " %4.2f (`=`mu1_1997_1'-`mu1_1979_1'')      " & `star1_diff_1'   \\ "  _n 
* file write Tbackground "~~HS Graduates               " " & " %4.2f (`mu1_1979_2')    " & " %4.2f (`mu1_1997_2')    " & " %4.2f (`=`mu1_1997_2'-`mu1_1979_2'')      " & `star1_diff_2'   \\ "  _n 
* file write Tbackground "~~Some College               " " & " %4.2f (`mu1_1979_3')    " & " %4.2f (`mu1_1997_3')    " & " %4.2f (`=`mu1_1997_3'-`mu1_1979_3'')      " & `star1_diff_3'   \\ "  _n 
* file write Tbackground "~~College Graduates          " " & " %4.2f (`mu1_1979_4')    " & " %4.2f (`mu1_1997_4')    " & " %4.2f (`=`mu1_1997_4'-`mu1_1979_4'')      " & `star1_diff_4'   \\ "  _n 
* file write Tbackground "~~All Education Levels       " " & " %4.2f (`mu1_1979_all')  " & " %4.2f (`mu1_1997_all')  " & " %4.2f (`=`mu1_1997_all'-`mu1_1979_all'')  " & `star1_diff_all' \\ "  _n 
* file write Tbackground "\vspace{-6pt}  \\" _n                                                                                                         
* file write Tbackground "\multicolumn{5}{l}{\emph{Hispanic:}} \\" _n 
* file write Tbackground "~~HS Dropouts                " " & " %4.2f (`mu2_1979_1')    " & " %4.2f (`mu2_1997_1')    " & " %4.2f (`=`mu2_1997_1'-`mu2_1979_1'')      " & `star2_diff_1'   \\ "  _n 
* file write Tbackground "~~HS Graduates               " " & " %4.2f (`mu2_1979_2')    " & " %4.2f (`mu2_1997_2')    " & " %4.2f (`=`mu2_1997_2'-`mu2_1979_2'')      " & `star2_diff_2'   \\ "  _n 
* file write Tbackground "~~Some College               " " & " %4.2f (`mu2_1979_3')    " & " %4.2f (`mu2_1997_3')    " & " %4.2f (`=`mu2_1997_3'-`mu2_1979_3'')      " & `star2_diff_3'   \\ "  _n 
* file write Tbackground "~~College Graduates          " " & " %4.2f (`mu2_1979_4')    " & " %4.2f (`mu2_1997_4')    " & " %4.2f (`=`mu2_1997_4'-`mu2_1979_4'')      " & `star2_diff_4'   \\ "  _n 
* file write Tbackground "~~All Education Levels       " " & " %4.2f (`mu2_1979_all')  " & " %4.2f (`mu2_1997_all')  " & " %4.2f (`=`mu2_1997_all'-`mu2_1979_all'')  " & `star2_diff_all' \\ "  _n 
* file write Tbackground "\vspace{-6pt}  \\" _n                                                                                                         
* file write Tbackground "\multicolumn{5}{l}{\emph{Foreign Born:}} \\" _n 
* file write Tbackground "~~HS Dropouts                " " & " %4.2f (`mu3_1979_1')    " & " %4.2f (`mu3_1997_1')    " & " %4.2f (`=`mu3_1997_1'-`mu3_1979_1'')      " & `star3_diff_1'   \\ "  _n 
* file write Tbackground "~~HS Graduates               " " & " %4.2f (`mu3_1979_2')    " & " %4.2f (`mu3_1997_2')    " & " %4.2f (`=`mu3_1997_2'-`mu3_1979_2'')      " & `star3_diff_2'   \\ "  _n 
* file write Tbackground "~~Some College               " " & " %4.2f (`mu3_1979_3')    " & " %4.2f (`mu3_1997_3')    " & " %4.2f (`=`mu3_1997_3'-`mu3_1979_3'')      " & `star3_diff_3'   \\ "  _n 
* file write Tbackground "~~College Graduates          " " & " %4.2f (`mu3_1979_4')    " & " %4.2f (`mu3_1997_4')    " & " %4.2f (`=`mu3_1997_4'-`mu3_1979_4'')      " & `star3_diff_4'   \\ "  _n 
* file write Tbackground "~~All Education Levels       " " & " %4.2f (`mu3_1979_all')  " & " %4.2f (`mu3_1997_all')  " & " %4.2f (`=`mu3_1997_all'-`mu3_1979_all'')  " & `star3_diff_all' \\ "  _n 
* file write Tbackground "\vspace{-6pt}  \\" _n                                                                                                         
* file write Tbackground "\multicolumn{5}{l}{\emph{Mother's education:}} \\" _n 
* file write Tbackground "~~HS Dropouts                " " & " %4.2f (`mu4_1979_1')    " & " %4.2f (`mu4_1997_1')    " & " %4.2f (`=`mu4_1997_1'-`mu4_1979_1'')      " & `star1_diff_1'   \\ "  _n 
* file write Tbackground "~~HS Graduates               " " & " %4.2f (`mu4_1979_2')    " & " %4.2f (`mu4_1997_2')    " & " %4.2f (`=`mu4_1997_2'-`mu4_1979_2'')      " & `star1_diff_2'   \\ "  _n 
* file write Tbackground "~~Some College               " " & " %4.2f (`mu4_1979_3')    " & " %4.2f (`mu4_1997_3')    " & " %4.2f (`=`mu4_1997_3'-`mu4_1979_3'')      " & `star1_diff_3'   \\ "  _n 
* file write Tbackground "~~College Graduates          " " & " %4.2f (`mu4_1979_4')    " & " %4.2f (`mu4_1997_4')    " & " %4.2f (`=`mu4_1997_4'-`mu4_1979_4'')      " & `star1_diff_4'   \\ "  _n 
* file write Tbackground "~~All Education Levels       " " & " %4.2f (`mu4_1979_all')  " & " %4.2f (`mu4_1997_all')  " & " %4.2f (`=`mu4_1997_all'-`mu4_1979_all'')  " & `star1_diff_all' \\ "  _n 
* file write Tbackground "\vspace{-6pt}  \\" _n                                                                                                         
* file write Tbackground "\multicolumn{5}{l}{\emph{Father's education:}} \\" _n 
* file write Tbackground "~~HS Dropouts                " " & " %4.2f (`mu5_1979_1')    " & " %4.2f (`mu5_1997_1')    " & " %4.2f (`=`mu5_1997_1'-`mu5_1979_1'')      " & `star2_diff_1'   \\ "  _n 
* file write Tbackground "~~HS Graduates               " " & " %4.2f (`mu5_1979_2')    " & " %4.2f (`mu5_1997_2')    " & " %4.2f (`=`mu5_1997_2'-`mu5_1979_2'')      " & `star2_diff_2'   \\ "  _n 
* file write Tbackground "~~Some College               " " & " %4.2f (`mu5_1979_3')    " & " %4.2f (`mu5_1997_3')    " & " %4.2f (`=`mu5_1997_3'-`mu5_1979_3'')      " & `star2_diff_3'   \\ "  _n 
* file write Tbackground "~~College Graduates          " " & " %4.2f (`mu5_1979_4')    " & " %4.2f (`mu5_1997_4')    " & " %4.2f (`=`mu5_1997_4'-`mu5_1979_4'')      " & `star2_diff_4'   \\ "  _n 
* file write Tbackground "~~All Education Levels       " " & " %4.2f (`mu5_1979_all')  " & " %4.2f (`mu5_1997_all')  " & " %4.2f (`=`mu5_1997_all'-`mu5_1979_all'')  " & `star2_diff_all' \\ "  _n 
* file write Tbackground "\vspace{-6pt}  \\" _n                                                                                                         
* file write Tbackground "\multicolumn{5}{l}{\emph{Family Income:}} \\" _n 
* file write Tbackground "~~HS Dropouts                " " & " %4.2f (`mu6_1979_1')    " & " %4.2f (`mu6_1997_1')    " & " %4.2f (`=`mu6_1997_1'-`mu6_1979_1'')      " & `star3_diff_1'   \\ "  _n 
* file write Tbackground "~~HS Graduates               " " & " %4.2f (`mu6_1979_2')    " & " %4.2f (`mu6_1997_2')    " & " %4.2f (`=`mu6_1997_2'-`mu6_1979_2'')      " & `star3_diff_2'   \\ "  _n 
* file write Tbackground "~~Some College               " " & " %4.2f (`mu6_1979_3')    " & " %4.2f (`mu6_1997_3')    " & " %4.2f (`=`mu6_1997_3'-`mu6_1979_3'')      " & `star3_diff_3'   \\ "  _n 
* file write Tbackground "~~College Graduates          " " & " %4.2f (`mu6_1979_4')    " & " %4.2f (`mu6_1997_4')    " & " %4.2f (`=`mu6_1997_4'-`mu6_1979_4'')      " & `star3_diff_4'   \\ "  _n 
* file write Tbackground "~~All Education Levels       " " & " %4.2f (`mu6_1979_all')  " & " %4.2f (`mu6_1997_all')  " & " %4.2f (`=`mu6_1997_all'-`mu6_1979_all'')  " & `star3_diff_all' \\ "  _n 
* file write Tbackground "\vspace{-6pt}  \\" _n                                                                                                         
* file write Tbackground "\multicolumn{5}{l}{\emph{Share lived in female-headed HH:}} \\" _n                                                                     
* file write Tbackground "~~HS Dropouts                " " & " %4.2f (`mu7_1979_1')    " & " %4.2f (`mu7_1997_1')    " & " %4.2f (`=`mu7_1997_1'-`mu7_1979_1'')      " & `star4_diff_1'   \\ "  _n 
* file write Tbackground "~~HS Graduates               " " & " %4.2f (`mu7_1979_2')    " & " %4.2f (`mu7_1997_2')    " & " %4.2f (`=`mu7_1997_2'-`mu7_1979_2'')      " & `star4_diff_2'   \\ "  _n 
* file write Tbackground "~~Some College               " " & " %4.2f (`mu7_1979_3')    " & " %4.2f (`mu7_1997_3')    " & " %4.2f (`=`mu7_1997_3'-`mu7_1979_3'')      " & `star4_diff_3'   \\ "  _n 
* file write Tbackground "~~College Graduates          " " & " %4.2f (`mu7_1979_4')    " & " %4.2f (`mu7_1997_4')    " & " %4.2f (`=`mu7_1997_4'-`mu7_1979_4'')      " & `star4_diff_4'   \\ "  _n 
* file write Tbackground "~~All Education Levels       " " & " %4.2f (`mu7_1979_all')  " & " %4.2f (`mu7_1997_all')  " & " %4.2f (`=`mu7_1997_all'-`mu7_1979_all'')  " & `star4_diff_all' \\ "  _n 
* file write Tbackground "\multicolumn{5}{l}{\emph{Median AFQT score:}} \\" _n 
* file write Tbackground "~~HS Dropouts                " " & " %4.2f (`med_1979_1')    " & " %4.2f (`med_1997_1')    " & " %4.2f (`=`med_1997_1'-`med_1979_1'')      " & `starMed_diff_1'   \\ "  _n 
* file write Tbackground "~~HS Graduates               " " & " %4.2f (`med_1979_2')    " & " %4.2f (`med_1997_2')    " & " %4.2f (`=`med_1997_2'-`med_1979_2'')      " & `starMed_diff_2'   \\ "  _n 
* file write Tbackground "~~Some College               " " & " %4.2f (`med_1979_3')    " & " %4.2f (`med_1997_3')    " & " %4.2f (`=`med_1997_3'-`med_1979_3'')      " & `starMed_diff_3'   \\ "  _n 
* file write Tbackground "~~College Graduates          " " & " %4.2f (`med_1979_4')    " & " %4.2f (`med_1997_4')    " & " %4.2f (`=`med_1997_4'-`med_1979_4'')      " & `starMed_diff_4'   \\ "  _n 
* file write Tbackground "~~All Education Levels       " " & " %4.2f (`med_1979_all')  " & " %4.2f (`med_1997_all')  " & " %4.2f (`=`med_1997_all'-`med_1979_all'')  " & `starMed_diff_all' \\ "  _n 
* file write Tbackground "\vspace{-6pt}  \\" _n                                                                                                         
* file write Tbackground "\multicolumn{5}{l}{\emph{Standard deviation of AFQT score:}} \\" _n                                                                     
* file write Tbackground "~~HS Dropouts                " " & " %4.2f (`sd_1979_1')     " & " %4.2f (`sd_1997_1')     " & " %4.2f (`=`sd_1997_1'-`sd_1979_1'')       " & `starSD_diff_1'   \\ "  _n 
* file write Tbackground "~~HS Graduates               " " & " %4.2f (`sd_1979_2')     " & " %4.2f (`sd_1997_2')     " & " %4.2f (`=`sd_1997_2'-`sd_1979_2'')       " & `starSD_diff_2'   \\ "  _n 
* file write Tbackground "~~Some College               " " & " %4.2f (`sd_1979_3')     " & " %4.2f (`sd_1997_3')     " & " %4.2f (`=`sd_1997_3'-`sd_1979_3'')       " & `starSD_diff_3'   \\ "  _n 
* file write Tbackground "~~College Graduates          " " & " %4.2f (`sd_1979_4')     " & " %4.2f (`sd_1997_4')     " & " %4.2f (`=`sd_1997_4'-`sd_1979_4'')       " & `starSD_diff_4'   \\ "  _n 
* file write Tbackground "~~All Education Levels       " " & " %4.2f (`sd_1979_all')   " & " %4.2f (`sd_1997_all')   " & " %4.2f (`=`sd_1997_all'-`sd_1979_all'')   " & `starSD_diff_all' \\ "  _n 
* file write Tbackground "\multicolumn{5}{l}{\emph{Sample sizes:}} \\" _n 
* file write Tbackground "~~\$N\$ HS Dropouts          " " & " %6.0fc (`N_1979_1')     " & " %6.0fc (`N_1997_1')    " & & \\ "  _n 
* file write Tbackground "~~\$N\$ HS Graduates         " " & " %6.0fc (`N_1979_2')     " & " %6.0fc (`N_1997_2')    " & & \\ "  _n 
* file write Tbackground "~~\$N\$ Some College         " " & " %6.0fc (`N_1979_3')     " & " %6.0fc (`N_1997_3')    " & & \\ "  _n 
* file write Tbackground "~~\$N\$ College Graduates    " " & " %6.0fc (`N_1979_4')     " & " %6.0fc (`N_1997_4')    " & & \\ "  _n 
* file write Tbackground "\multicolumn{5}{l}{\emph{Number of persons:}} \\" _n 
file write Tbackground "\vspace{-6pt}  \\" _n                                                                                                         
file write Tbackground "%\$N\$ at age 16              " " & " %6.0fc (`N_1979_age16')   " & " %6.0fc (`N_1997_age16')  " & & \\ "  _n 
file write Tbackground "\$N\$ at age 29              " " & " %6.0fc (`N_1979_age29')   " & " %6.0fc (`N_1997_age29')  " & & \\ "  _n 
file write Tbackground "%\$NT\$ at age 29              " " & " %6.0fc (`NT_1979_age29')   " & " %6.0fc (`NT_1997_age29')  " & & \\ "  _n 
file write Tbackground "\bottomrule " _n 
file write Tbackground "\end{tabular} " _n 
file write Tbackground "\footnotesize{Notes: Education is highest grade completed by the respondent's biological parents. Family income is in 1,000's of 1982-84\\$. All demographic and family variables are measured as of the first survey round in both cohorts except female-headed household, which is from age 14 in NLSY97. The AFQT distribution is normalized so that the distribution including all cohorts is mean-zero, variance one. For median AFQT score, the significance comes from bootstrapped standard errors of the median (500 replications). For standard deviations of AFQT score, the significance comes from two-tailed F-tests of the ratio of the variances. Statistics weighted by NLSY sampling weights. Significance reported at the 1\% (***), 5\% (**), and 10\% (*) levels. Sample size for statistical analysis varied for some variables due to missing values (see Appendix Table \ref{tab:sample} for more on sample creation.)}" _n
file write Tbackground "\end{threeparttable} " _n 
file write Tbackground "} " _n 
file write Tbackground "\end{table} " _n 
file close Tbackground

*------------------------------------------------
* Table: Educational Distribution and Grad Prob by Age
*------------------------------------------------
foreach age in 2512 2812 {
	foreach var in gradHS startCol grad4yr grad4yrCond HSdropout HSgraduate BAdropout BAgraduate yearsToCol monthsToCol {
		qui mean `var' [aw=weight] if agemo==`age', over(cohortFlag)
		matrix m = e(b)\e(_N)
		foreach cohort in 1979 1997 {
			local mu_`var'_`cohort'_`age' = el(m,1,colnumb(m,"`var':`cohort'"))
			* local        N_`cohort'_`age' = el(m,2,colnumb(m,"`var':`cohort'"))
		}
		local mu_`var'_diff_`age' = `mu_`var'_1997_`age'' - `mu_`var'_1979_`age''
		qui test[`var']1979 = [`var']1997
		star `r(p)' mu_`var'_star_`age'
	}
}

capture file close Tdegree
file open Tdegree using "${tbls_loc}Tdegree_29.tex", write replace
file write Tdegree "\begin{table}[ht]" _n 
file write Tdegree "\caption{Schooling attainment and graduation probabilities at age 29}" _n 
file write Tdegree "\label{tab:degree}" _n 
file write Tdegree "\centering" _n 
file write Tdegree "\scalebox{1.0}[1.0]{% " _n 
file write Tdegree "\begin{threeparttable}" _n 
file write Tdegree "\begin{tabular}{lrrr@{}l}" _n 
file write Tdegree "\toprule " _n 
file write Tdegree "Variable & NLSY79 & NLSY97 & \multicolumn{2}{c}{97--79} \\" _n 
file write Tdegree "\midrule " _n 
file write Tdegree "\multicolumn{5}{l}{\emph{Schooling Attainment:}} \\" _n 
file write Tdegree "~~\% HS Dropouts                     "  " & " %4.2f    (`mu_HSdropout_1979_2812') " & " %4.2f   (`mu_HSdropout_1997_2812') " & " %4.2f    (`mu_HSdropout_diff_2812')  " &    `mu_HSdropout_star_2812' \\ " _n
file write Tdegree "~~\% HS Graduates                    "  " & " %4.2f   (`mu_HSgraduate_1979_2812') " & " %4.2f  (`mu_HSgraduate_1997_2812') " & " %4.2f   (`mu_HSgraduate_diff_2812')  " &   `mu_HSgraduate_star_2812' \\ " _n
file write Tdegree "~~\% Some College                    "  " & " %4.2f    (`mu_BAdropout_1979_2812') " & " %4.2f   (`mu_BAdropout_1997_2812') " & " %4.2f    (`mu_BAdropout_diff_2812')  " &    `mu_BAdropout_star_2812' \\ " _n
file write Tdegree "~~\% College Graduates               "  " & " %4.2f   (`mu_BAgraduate_1979_2812') " & " %4.2f  (`mu_BAgraduate_1997_2812') " & " %4.2f   (`mu_BAgraduate_diff_2812')  " &   `mu_BAgraduate_star_2812' \\ " _n
file write Tdegree "\vspace{-6pt}  \\" _n                                                                                                         
* file write Tdegree "\multicolumn{5}{l}{\emph{Graduation Probabilities at age 26:}} \\" _n 
* file write Tdegree "~~Pr(Grad HS)                        "  " & " %4.2f       (`mu_gradHS_1979_2512') " & " %4.2f      (`mu_gradHS_1997_2512') " & " %4.2f       (`mu_gradHS_diff_2512')  " &       `mu_gradHS_star_2512' \\ " _n
* file write Tdegree "~~Pr(Start College)                  "  " & " %4.2f     (`mu_startCol_1979_2512') " & " %4.2f    (`mu_startCol_1997_2512') " & " %4.2f     (`mu_startCol_diff_2512')  " &     `mu_startCol_star_2512' \\ " _n
* file write Tdegree "~~Pr(Grad College)                   "  " & " %4.2f      (`mu_grad4yr_1979_2512') " & " %4.2f     (`mu_grad4yr_1997_2512') " & " %4.2f      (`mu_grad4yr_diff_2512')  " &      `mu_grad4yr_star_2512' \\ " _n
* file write Tdegree "~~Pr(Grad College $\vert$ Start Col) "  " & " %4.2f  (`mu_grad4yrCond_1979_2512') " & " %4.2f (`mu_grad4yrCond_1997_2512') " & " %4.2f  (`mu_grad4yrCond_diff_2512')  " &  `mu_grad4yrCond_star_2512' \\ " _n
file write Tdegree "\multicolumn{5}{l}{\emph{Graduation Probabilities and Time to Degree:}} \\" _n 
file write Tdegree "%~~Pr(Grad HS)                        "  " & " %4.2f       (`mu_gradHS_1979_2812') " & " %4.2f      (`mu_gradHS_1997_2812') " & " %4.2f       (`mu_gradHS_diff_2812')  " &       `mu_gradHS_star_2812' \\ " _n
file write Tdegree "~~Pr(Start College)                  "  " & " %4.2f     (`mu_startCol_1979_2812') " & " %4.2f    (`mu_startCol_1997_2812') " & " %4.2f     (`mu_startCol_diff_2812')  " &     `mu_startCol_star_2812' \\ " _n
file write Tdegree "%~~Pr(Grad College)                   "  " & " %4.2f      (`mu_grad4yr_1979_2812') " & " %4.2f     (`mu_grad4yr_1997_2812') " & " %4.2f      (`mu_grad4yr_diff_2812')  " &      `mu_grad4yr_star_2812' \\ " _n
file write Tdegree "~~Pr(Grad College $\vert$ Start Col) "  " & " %4.2f  (`mu_grad4yrCond_1979_2812') " & " %4.2f (`mu_grad4yrCond_1997_2812') " & " %4.2f  (`mu_grad4yrCond_diff_2812')  " &  `mu_grad4yrCond_star_2812' \\ " _n
file write Tdegree "~~Time to College Degree (years)     "  " & " %4.2f   (`mu_yearsToCol_1979_2812') " & " %4.2f  (`mu_yearsToCol_1997_2812') " & " %4.2f   (`mu_yearsToCol_diff_2812')  " &   `mu_yearsToCol_star_2812' \\ " _n
file write Tdegree "%~~Time to College Degree (months)   "  " & " %4.2f  (`mu_monthsToCol_1979_2812') " & " %4.2f (`mu_monthsToCol_1997_2812') " & " %4.2f  (`mu_monthsToCol_diff_2812')  " &  `mu_monthsToCol_star_2812' \\ " _n
* file write Tdegree "\multicolumn{5}{l}{\emph{Number of Persons at age 29 (count):}} \\" _n 
* file write Tdegree "~~\$N\$ All Education Levels         "  " & " %6.0fc              (`N_1979_2812') " & " %6.0fc             (`N_1997_2812') " & "  " &   \\ " _n
file write Tdegree "\bottomrule " _n 
file write Tdegree "\end{tabular} " _n 
file write Tdegree "\footnotesize{Notes: \emph{HS Graduates} included in this table are those who have either a GED or a diploma but who never attended college. \emph{Some College} are those who attended college but did not graduate with a 4-year degree. \emph{College Graduates} are those who graduated with a 4-year degree. As in \citet{bound2012}, time to college degree is defined as the number of calendar months between high school graduation and 4-year college graduation. Statistics utilize NLSY sampling weights. Significance reported at the 1\% (***), 5\% (**), and 10\% (*) levels.}" _n 
file write Tdegree "\end{threeparttable} " _n 
file write Tdegree "} " _n 
file write Tdegree "\end{table} " _n 
file close Tdegree



*----------------------------------
* Table: At age 29: Average experience & wage returns evaluated at these averages
*----------------------------------
local v = 1
foreach var in anySchoolt totExpert schoolOnlyt workK12t workColleget workPTonlyt workFTonlyt {
* foreach var in workFTonlyt {
	* Experience at age 29
	qui mean `var' [aw=weight] if agemo==2812 & workFTonly==1 , over(cohortFlag)
	matrix m = e(b)
	foreach cohort in 1979 1997 {
		local mu`v'_`cohort'_all = el(m,1,colnumb(m,"`var':`cohort'"))
	}
	qui test[`var']1979 = [`var']1997
    star `r(p)' star`v'_diff_all 
	
	* 3 calcs: average wage w/ above exp; average wage w/ below exp; wage premia defined as diff
	foreach cohort in 1979 1997 {
		qui sum lnWage [aw=weight] if agemo==2812 & workFTonly==1 & inrange(`var',`mu`v'_`cohort'_all'   ,`mu`v'_`cohort'_all'+12)	
		local  wageAbove`v'_`cohort'_all = `r(mean)'
		local    seAbove`v'_`cohort'_all = `=`r(sd)'/sqrt(`r(N)')'
		local     nAbove`v'_`cohort'_all = `r(N)'

		qui sum lnWage [aw=weight] if agemo==2812 & workFTonly==1 & inrange(`var',`mu`v'_`cohort'_all'-12,`mu`v'_`cohort'_all'   )	
		local  wageBelow`v'_`cohort'_all = `r(mean)'
		local    seBelow`v'_`cohort'_all = `=`r(sd)'/sqrt(`r(N)')'
		local     nBelow`v'_`cohort'_all = `r(N)'

		local wagePremia`v'_`cohort'_all =    `wageAbove`v'_`cohort'_all'   - `wageBelow`v'_`cohort'_all'
		local   sePremia`v'_`cohort'_all = sqrt(`seAbove`v'_`cohort'_all'^2 +   `seBelow`v'_`cohort'_all'^2)
	}
	
	* Wage premia: diff between wageAbove and wageBelow; SE defined based on above SEs
	local wagePremia`v'_diff_all =    `wagePremia`v'_1997_all'   - `wagePremia`v'_1979_all'
	local   sePremia`v'_diff_all = sqrt(`sePremia`v'_1997_all'^2 +   `sePremia`v'_1979_all'^2)

	* For t-test, what is df? For now, use minimum of n's
	local dfUse = min(`nAbove`v'_1979_all',`nBelow`v'_1979_all',`nAbove`v'_1997_all',`nBelow`v'_1979_all')
	local pValPremia`v'_diff_all = 1-t(`dfUse',`=`wagePremia`v'_diff_all'/`sePremia`v'_diff_all'')
	star `pValPremia`v'_diff_all' starPremia`v'_diff_all 
	
local ++v
}

file open Texp using "${tbls_loc}Texp_29.tex", write replace
file write Texp "\begin{table}[ht]" _n 
file write Texp "\caption{Changes in school and work experience}\label{tab:exp}" _n 
file write Texp "\centering" _n 
file write Texp "\scalebox{1.0}[1.0]{% " _n 
file write Texp "\begin{threeparttable}" _n 
file write Texp "\begin{tabular}{lrrr@{}l}" _n 
file write Texp "\toprule " _n 
file write Texp "Variable & NLSY79 & NLSY97 & \multicolumn{2}{c}{97--79} \\" _n 
file write Texp "\midrule " _n 
file write Texp "\multicolumn{5}{l}{\emph{Overall:}}                                               \\" _n
file write Texp "~~Total months of schooling       " " & " %4.2f (`mu1_1979_all') " & " %4.2f (`mu1_1997_all') " & " %4.2f (`=`mu1_1997_all'-`mu1_1979_all'') " & `star1_diff_all' \\" _n
file write Texp "~~Total months of work experience " " & " %4.2f (`mu2_1979_all') " & " %4.2f (`mu2_1997_all') " & " %4.2f (`=`mu2_1997_all'-`mu2_1979_all'') " & `star2_diff_all' \\" _n
file write Texp "\vspace{-6pt}                                                                         \\ " _n
file write Texp "\multicolumn{5}{l}{\emph{By Type:}}                                               \\" _n
file write Texp "~~Months of school only           " " & " %4.2f (`mu3_1979_all') " & " %4.2f (`mu3_1997_all') " & " %4.2f (`=`mu3_1997_all'-`mu3_1979_all'') " & `star3_diff_all' \\" _n
file write Texp "~~Months of work in high school   " " & " %4.2f (`mu4_1979_all') " & " %4.2f (`mu4_1997_all') " & " %4.2f (`=`mu4_1997_all'-`mu4_1979_all'') " & `star4_diff_all' \\" _n
file write Texp "~~Months of work in college       " " & " %4.2f (`mu5_1979_all') " & " %4.2f (`mu5_1997_all') " & " %4.2f (`=`mu5_1997_all'-`mu5_1979_all'') " & `star5_diff_all' \\" _n
file write Texp "~~Months of part-time work        " " & " %4.2f (`mu6_1979_all') " & " %4.2f (`mu6_1997_all') " & " %4.2f (`=`mu6_1997_all'-`mu6_1979_all'') " & `star6_diff_all' \\" _n
file write Texp "~~Months of full-time work        " " & " %4.2f (`mu7_1979_all') " & " %4.2f (`mu7_1997_all') " & " %4.2f (`=`mu7_1997_all'-`mu7_1979_all'') " & `star7_diff_all' \\" _n
file write Texp "\bottomrule " _n 
file write Texp "\end{tabular} " _n 
file write Texp "\footnotesize{Notes: All counts begin at age 16, thus the average individual in the NLSY79 had a total of 40.5 months of school after turning 16. Statistics weighted by NLSY sampling weights. Significance reported at the 1\% (***), 5\% (**), and 10\% (*) levels.}" _n
file write Texp "\end{threeparttable} " _n 
file write Texp "} " _n 
file write Texp "\end{table} " _n 
file close Texp

capture file close TwagepremiaDiscrete
file open TwagepremiaDiscrete using "${tbls_loc}TwagepremiaDiscrete_29.tex", write replace
file write TwagepremiaDiscrete "\begin{table}[ht]" _n 
file write TwagepremiaDiscrete "\caption{Changes in wage premia for experience and educational attainment at age 29 for full-time workers}" _n 
file write TwagepremiaDiscrete "\label{tab:wagepremiaDiscrete}" _n 
file write TwagepremiaDiscrete "\centering" _n 
file write TwagepremiaDiscrete "\scalebox{1.0}[1.0]{% " _n 
file write TwagepremiaDiscrete "\begin{threeparttable}" _n 
file write TwagepremiaDiscrete "\begin{tabular}{lrrr@{}l}" _n 
file write TwagepremiaDiscrete "\toprule " _n 
file write TwagepremiaDiscrete "Variable & NLSY79 & NLSY97 & \multicolumn{2}{c}{97--79} \\" _n 
file write TwagepremiaDiscrete "\midrule " _n 
file write TwagepremiaDiscrete "\multicolumn{5}{l}{\emph{Average log wage premia for one more year of experience:}} \\" _n 
file write TwagepremiaDiscrete "~~Year of School   "  " & " %5.3f (`wagePremia3_1979_all') " & " %5.3f (`wagePremia3_1997_all') " & " %5.3f (`wagePremia3_diff_all')  " &  `starPremia3_diff_all' \\ " _n
file write TwagepremiaDiscrete "~~Work in HS       "  " & " %5.3f (`wagePremia4_1979_all') " & " %5.3f (`wagePremia4_1997_all') " & " %5.3f (`wagePremia4_diff_all')  " &  `starPremia4_diff_all' \\ " _n
file write TwagepremiaDiscrete "~~Work in college  "  " & " %5.3f (`wagePremia5_1979_all') " & " %5.3f (`wagePremia5_1997_all') " & " %5.3f (`wagePremia5_diff_all')  " &  `starPremia5_diff_all' \\ " _n
file write TwagepremiaDiscrete "~~Work part time   "  " & " %5.3f (`wagePremia6_1979_all') " & " %5.3f (`wagePremia6_1997_all') " & " %5.3f (`wagePremia6_diff_all')  " &  `starPremia6_diff_all' \\ " _n
file write TwagepremiaDiscrete "~~Work full time   "  " & " %5.3f (`wagePremia7_1979_all') " & " %5.3f (`wagePremia7_1997_all') " & " %5.3f (`wagePremia7_diff_all')  " &  `starPremia7_diff_all' \\ " _n
* file write TwagepremiaDiscrete "\vspace{-6pt}  \\" _n                                                                                                         
* file write TwagepremiaDiscrete "\multicolumn{5}{l}{\emph{Average log wages by highest educational attainment:}} \\" _n 
* file write TwagepremiaDiscrete "~~HS Dropouts       "  " & " %4.2f  (`mu_lnWage_1979_1') " & " %4.2f  (`mu_lnWage_1997_1') " & " %4.2f  (`mu_lnWage_diff_1')  " &  `mu_lnWage_star_1' \\ " _n
* file write TwagepremiaDiscrete "~~HS Graduates      "  " & " %4.2f  (`mu_lnWage_1979_2') " & " %4.2f  (`mu_lnWage_1997_2') " & " %4.2f  (`mu_lnWage_diff_2')  " &  `mu_lnWage_star_2' \\ " _n
* file write TwagepremiaDiscrete "~~Some College      "  " & " %4.2f  (`mu_lnWage_1979_3') " & " %4.2f  (`mu_lnWage_1997_3') " & " %4.2f  (`mu_lnWage_diff_3')  " &  `mu_lnWage_star_3' \\ " _n
* file write TwagepremiaDiscrete "~~College Graduates "  " & " %4.2f  (`mu_lnWage_1979_4') " & " %4.2f  (`mu_lnWage_1997_4') " & " %4.2f  (`mu_lnWage_diff_4')  " &  `mu_lnWage_star_4' \\ " _n
* file write TwagepremiaDiscrete "\vspace{-6pt}  \\" _n                                                                                                         
* file write TwagepremiaDiscrete "\multicolumn{5}{l}{\emph{Average log wage premia for highest educational attainment:}} \\" _n 
* file write TwagepremiaDiscrete "~~High School Wage Premium  "  " & " %4.2f  (`hswp_1979') " & " %4.2f  (`hswp_1997') " & " %4.2f  (`hswp_diff')  " &  `hswp_star' \\ " _n
* file write TwagepremiaDiscrete "~~Some College Wage Premium "  " & " %4.2f  (`scwp_1979') " & " %4.2f  (`scwp_1997') " & " %4.2f  (`scwp_diff')  " &  `scwp_star' \\ " _n
* file write TwagepremiaDiscrete "~~College Wage Premium      "  " & " %4.2f   (`cwp_1979') " & " %4.2f   (`cwp_1997') " & " %4.2f   (`cwp_diff')  " &   `cwp_star' \\ " _n
* file write TwagepremiaDiscrete "\bottomrule " _n 
file write TwagepremiaDiscrete "\end{tabular} " _n 
file write TwagepremiaDiscrete "\footnotesize{Notes: The sample is conditional on working full-time. Estimates for work experience are coefficients from separate bivariate regressions of log wage on each cumulative experience term. \emph{HS Graduates} included in this table are those who never attended college. \emph{Some College} are those who attended college but did not graduate with a 4-year degree. \emph{College Graduates} are those who graduated with a 4-year degree. \emph{High School Wage Premium} refers to the log wage difference between \emph{HS Graduates} and \emph{HS Dropouts}. \emph{Some College Wage Premium} refers to the log wage difference between \emph{Some College} and \emph{HS Graduates}. \emph{College Wage Premium} refers to the log wage difference between \emph{College Graduates} and \emph{HS Graduates}. Statistics weighted by NLSY sampling weights. Significance reported at the 1\% (***), 5\% (**), and 10\% (*) levels.}" _n 
file write TwagepremiaDiscrete "\end{threeparttable} " _n 
file write TwagepremiaDiscrete "} " _n 
file write TwagepremiaDiscrete "\end{table} " _n 
file close TwagepremiaDiscrete


*------------------------------------------------
* Table: Average growth in FT wages due to XP by final educ
* JA: Relied heavily on this Stata FAQ about Chow tests in order to do this in one reg
*     https://www.stata.com/support/faqs/statistics/chow-tests/
*------------------------------------------------
* Wage returns at all ages by educ level (Note: 5 is a proxy for ALL)
* foreach deg in 1 2 3 4 5 {
foreach deg in 5 {
	* gen flagger1 = workFTonly==1 & monthAlt==1 & ~mi(lnWage)
	* bys id (year month): egen flagger2 = max(flagger1)
	* foreach cohort in 1979 1997 {
		* if `deg'<5 qui count if flagger2 & highDegAttain==`deg' & cohortFlag==`cohort' & firstObs
		* else       qui count if flagger2 &                        cohortFlag==`cohort' & firstObs
		* local   en2_`cohort'_`deg' = `r(N)'
	* }
	* drop flagger*
	foreach skill in anySchool workK12 workCollege workCollegeEarly workCollegeLate workPTonly workFTonly {
		* if `deg'<5 qui count if workFTonly==1 & agemo==2812 & highDegAttain==`deg' & cohortFlag==1979 & ~mi(lnWage)
		* else       qui count if workFTonly==1 & agemo==2812                        & cohortFlag==1979 & ~mi(lnWage)
		* local   en`skill'_1979_`deg' = `r(N)'
		
		gen `skill'tYears97 = `skill'tYears*(cohortFlag==1997)
		if `deg'<5 qui reg lnWage c.`skill'tYears c.`skill'tYears97 cohortFlag [aw=weight] if workFTonly==1 & agemo==2812 & highDegAttain==`deg'
		else       qui reg lnWage c.`skill'tYears c.`skill'tYears97 cohortFlag [aw=weight] if workFTonly==1 & agemo==2812

		* local   en`skill'_1997_`deg' = `e(N)' - `en`skill'_1979_`deg''
		
		local b_`skill'_1979_`deg' =  _b[`skill'tYears]
		local b_`skill'_1997_`deg' =  _b[`skill'tYears] + _b[`skill'tYears97]
		local b_`skill'_diff_`deg' =  _b[`skill'tYears97]
		
		qui test _b[`skill'tYears97]=0
		star `r(p)' b_`skill'_star_`deg'
		
		drop `skill'tYears97
	}
}
* Add code to run slightly different regression for early vs late: including both in the same one (vs a bivariate one)
gen workCollegeEarlytYears97 = workCollegeEarlytYears*(cohortFlag==1997)
gen workCollegeLatetYears97  = workCollegeLatetYears*(cohortFlag==1997)

reg lnWage c.workCollegeEarlytYears c.workCollegeEarlytYears97 c.workCollegeLatetYears c.workCollegeLatetYears97 cohortFlag [aw=weight] if workFTonly==1 & agemo==2812

local b_workCollegeEarlyV2_1979_5 =  _b[workCollegeEarlytYears]
local b_workCollegeEarlyV2_1997_5 =  _b[workCollegeEarlytYears] + _b[workCollegeEarlytYears97]
local b_workCollegeEarlyV2_diff_5 =  _b[workCollegeEarlytYears97]

qui test _b[workCollegeEarlytYears97]=0
star `r(p)' b_workCollegeEarlyV2_star_5

local b_workCollegeLateV2_1979_5 =  _b[workCollegeLatetYears]
local b_workCollegeLateV2_1997_5 =  _b[workCollegeLatetYears] + _b[workCollegeLatetYears97]
local b_workCollegeLateV2_diff_5 =  _b[workCollegeLatetYears97]

qui test _b[workCollegeLatetYears97]=0
star `r(p)' b_workCollegeLateV2_star_5

capture drop *tYears97

foreach deg in 1 2 3 4 {
	di "`deg'"
	foreach cohort in 1979 1997 {
		qui sum lnWage [aw=weight] if workFTonly==1 & agemo==2812 & highDegAttain==`deg' & cohortFlag==`cohort'
		local mu_lnWage_`cohort'_`deg' = `r(mean)'
		local sd_lnWage_`cohort'_`deg' = `r(sd)'
		local en_lnWage_`cohort'_`deg' = `r(N)'
	}
	local mu_lnWage_diff_`deg' = `mu_lnWage_1997_`deg'' - `mu_lnWage_1979_`deg''
	local sd_lnWage_diff_`deg' = `sd_lnWage_1997_`deg'' - `sd_lnWage_1979_`deg''

	qui mean lnWage [aw=weight] if workFTonly==1 & agemo==2812 & highDegAttain==`deg', over(cohortFlag)
	matrix mm = r(table)
	foreach cohort in 1979 1997 {
		local semu_lnWage_`cohort'_`deg' = el(mm, 2,colnumb(mm,"`var':`cohort'"))
	}
	local semu_lnWage_diff_`deg' = sqrt(`semu_lnWage_1979_`deg''^2 + `semu_lnWage_1997_`deg''^2)
	
	qui test[`var']1979 = [`var']1997
    star `r(p)' mu_lnWage_star_`deg'
	
	qui sdtest lnWage if workFTonly==1 & agemo==2812 & highDegAttain==`deg', by(cohortFlag) // weights not allowed
	star `r(p)' sd_lnWage_star_`deg' 
}

foreach cohort in 1979 1997 {
	local hswp_`cohort' = `mu_lnWage_`cohort'_2' - `mu_lnWage_`cohort'_1'
	local scwp_`cohort' = `mu_lnWage_`cohort'_3' - `mu_lnWage_`cohort'_2'
	local  cwp_`cohort' = `mu_lnWage_`cohort'_4' - `mu_lnWage_`cohort'_2'
}

* Need to double check that the following 6 lines do indeed provide the correct
*  values to check for significance. They should, even if the order is slightly
*  off, ie we're saying we're looking at the change in the CWP, so that could
*  mean either we're interested in how the CWP was in 79 vs 97
*  OR we're interested in comparing the change in HS returns over time to the
*     change in college returns over time. 
* We get the same first moments either way...what about second moments?
local hswp_diff = `hswp_1997' - `hswp_1979'
local scwp_diff = `scwp_1997' - `scwp_1979'
local  cwp_diff =  `cwp_1997' -  `cwp_1979'

local sehswp_diff = sqrt(`semu_lnWage_diff_2'^2 + `semu_lnWage_diff_1'^2)
local sescwp_diff = sqrt(`semu_lnWage_diff_3'^2 + `semu_lnWage_diff_2'^2)
local  secwp_diff = sqrt(`semu_lnWage_diff_4'^2 + `semu_lnWage_diff_2'^2)

star `hswp_diff'/`sehswp_diff' hswp_star 
star `scwp_diff'/`sescwp_diff' scwp_star 
star  `cwp_diff'/`secwp_diff'  cwp_star


capture file close Twagepremia
file open Twagepremia using "${tbls_loc}Twagepremia_29.tex", write replace
file write Twagepremia "\begin{table}[ht]" _n 
file write Twagepremia "\caption{Changes in wage premia for experience and educational attainment at age 29 for full-time workers}" _n 
file write Twagepremia "\label{tab:wagepremia}" _n 
file write Twagepremia "\centering" _n 
file write Twagepremia "\scalebox{1.0}[1.0]{% " _n 
file write Twagepremia "\begin{threeparttable}" _n 
file write Twagepremia "\begin{tabular}{lrrr@{}l}" _n 
file write Twagepremia "\toprule " _n 
file write Twagepremia "Variable & NLSY79 & NLSY97 & \multicolumn{2}{c}{97--79} \\" _n 
file write Twagepremia "\midrule " _n 
file write Twagepremia "\multicolumn{5}{l}{\emph{Average log wage premia for one more year of experience:}} \\" _n 
file write Twagepremia "~~Year of School   "  " & " %5.3f   (`b_anySchool_1979_5') " & " %5.3f   (`b_anySchool_1997_5') " & " %5.3f   (`b_anySchool_diff_5')  " &   `b_anySchool_star_5' \\ " _n
file write Twagepremia "~~Work in HS       "  " & " %5.3f     (`b_workK12_1979_5') " & " %5.3f     (`b_workK12_1997_5') " & " %5.3f     (`b_workK12_diff_5')  " &     `b_workK12_star_5' \\ " _n
file write Twagepremia "~~Work in college  "  " & " %5.3f (`b_workCollege_1979_5') " & " %5.3f (`b_workCollege_1997_5') " & " %5.3f (`b_workCollege_diff_5')  " & `b_workCollege_star_5' \\ " _n
file write Twagepremia "%~~~~Early college work"  " & " %5.3f (`b_workCollegeEarly_1979_5') " & " %5.3f (`b_workCollegeEarly_1997_5') " & " %5.3f (`b_workCollegeEarly_diff_5')  " & `b_workCollegeEarly_star_5' \\ " _n
file write Twagepremia "%~~~~Late college work "  " & " %5.3f (`b_workCollegeLate_1979_5') " & " %5.3f (`b_workCollegeLate_1997_5') " & " %5.3f (`b_workCollegeLate_diff_5')  " & `b_workCollegeLate_star_5' \\ " _n
file write Twagepremia "~~~~Early college work"  " & " %5.3f (`b_workCollegeEarlyV2_1979_5') " & " %5.3f (`b_workCollegeEarlyV2_1997_5') " & " %5.3f (`b_workCollegeEarlyV2_diff_5')  " & `b_workCollegeEarlyV2_star_5' \\ " _n
file write Twagepremia "~~~~Late college work "  " & " %5.3f (`b_workCollegeLateV2_1979_5') " & " %5.3f (`b_workCollegeLateV2_1997_5') " & " %5.3f (`b_workCollegeLateV2_diff_5')  " & `b_workCollegeLateV2_star_5' \\ " _n
file write Twagepremia "~~Work part time   "  " & " %5.3f  (`b_workPTonly_1979_5') " & " %5.3f  (`b_workPTonly_1997_5') " & " %5.3f  (`b_workPTonly_diff_5')  " &  `b_workPTonly_star_5' \\ " _n
file write Twagepremia "~~Work full time   "  " & " %5.3f  (`b_workFTonly_1979_5') " & " %5.3f  (`b_workFTonly_1997_5') " & " %5.3f  (`b_workFTonly_diff_5')  " &  `b_workFTonly_star_5' \\ " _n
file write Twagepremia "\vspace{-6pt}  \\" _n                                                                                                         
file write Twagepremia "\multicolumn{5}{l}{\emph{Average log wages by highest educational attainment:}} \\" _n 
file write Twagepremia "~~HS Dropouts       "  " & " %4.2f  (`mu_lnWage_1979_1') " & " %4.2f  (`mu_lnWage_1997_1') " & " %4.2f  (`mu_lnWage_diff_1')  " &  `mu_lnWage_star_1' \\ " _n
file write Twagepremia "~~HS Graduates      "  " & " %4.2f  (`mu_lnWage_1979_2') " & " %4.2f  (`mu_lnWage_1997_2') " & " %4.2f  (`mu_lnWage_diff_2')  " &  `mu_lnWage_star_2' \\ " _n
file write Twagepremia "~~Some College      "  " & " %4.2f  (`mu_lnWage_1979_3') " & " %4.2f  (`mu_lnWage_1997_3') " & " %4.2f  (`mu_lnWage_diff_3')  " &  `mu_lnWage_star_3' \\ " _n
file write Twagepremia "~~College Graduates "  " & " %4.2f  (`mu_lnWage_1979_4') " & " %4.2f  (`mu_lnWage_1997_4') " & " %4.2f  (`mu_lnWage_diff_4')  " &  `mu_lnWage_star_4' \\ " _n
file write Twagepremia "\vspace{-6pt}  \\" _n                                                                                                         
file write Twagepremia "\multicolumn{5}{l}{\emph{Average log wage premia for highest educational attainment:}} \\" _n 
file write Twagepremia "~~High School Wage Premium  "  " & " %4.2f  (`hswp_1979') " & " %4.2f  (`hswp_1997') " & " %4.2f  (`hswp_diff')  " &  `hswp_star' \\ " _n
file write Twagepremia "~~Some College Wage Premium "  " & " %4.2f  (`scwp_1979') " & " %4.2f  (`scwp_1997') " & " %4.2f  (`scwp_diff')  " &  `scwp_star' \\ " _n
file write Twagepremia "~~College Wage Premium      "  " & " %4.2f   (`cwp_1979') " & " %4.2f   (`cwp_1997') " & " %4.2f   (`cwp_diff')  " &   `cwp_star' \\ " _n
file write Twagepremia "\bottomrule " _n 
file write Twagepremia "\end{tabular} " _n 
file write Twagepremia "\footnotesize{Notes: The sample is conditional on working full-time. Estimates for work experience are coefficients from separate bivariate regressions of log wage on each cumulative experience term. The exception is for the breakout of Work in college. \emph{Early college work} refers to work done as a Freshman or Sophomore (no more than 16 months of college, ie 4 semesters), while \emph{Late college work} refers to work done as a Junior or Senior (more than 16 months of college). The premia for these two experiences are from a joint regression. \emph{HS Graduates} included in this table are those who never attended college. \emph{Some College} are those who attended college but did not graduate with a 4-year degree. \emph{College Graduates} are those who graduated with a 4-year degree. \emph{High School Wage Premium} refers to the log wage difference between \emph{HS Graduates} and \emph{HS Dropouts}. \emph{Some College Wage Premium} refers to the log wage difference between \emph{Some College} and \emph{HS Graduates}. \emph{College Wage Premium} refers to the log wage difference between \emph{College Graduates} and \emph{HS Graduates}. Statistics weighted by NLSY sampling weights. Significance reported at the 1\% (***), 5\% (**), and 10\% (*) levels.}" _n 
file write Twagepremia "\end{threeparttable} " _n 
file write Twagepremia "} " _n 
file write Twagepremia "\end{table} " _n 
file close Twagepremia

*------------------------------------------------
* Table: Local labor market conditions
*------------------------------------------------
local v = 1
foreach var in empPct incPerCapita numBAperCapita posBA tuitionFlagship {
    foreach x in 1612 2212 2512 2812 {
		qui mean `var' [aw=weight] if agemo==`x' , over(cohortFlag)
		matrix m = e(b)
		foreach cohort in 1979 1997 {
			local mu`v'_`cohort'_`x' = el(m,1,colnumb(m,"`var':`cohort'"))
		}
		qui test[`var']1979 = [`var']1997
		star `r(p)' star`v'_diff_`x'
    }
local ++v
}

capture file close Tlocal
file open Tlocal using "${tbls_loc}Tlocal_29.tex", write replace
file write Tlocal "\begin{table}[ht]" _n 
file write Tlocal "\caption{Local labor market conditions at various ages}" _n 
file write Tlocal "\label{tab:locallabmktbyage}" _n 
file write Tlocal "\centering" _n 
file write Tlocal "\scalebox{1.0}[1.0]{% " _n 
file write Tlocal "\begin{threeparttable}" _n 
file write Tlocal "\begin{tabular}{lrrr@{}l}" _n 
file write Tlocal "\toprule " _n 
file write Tlocal "Variable \phantom{extraspacehere} & NLSY79 & NLSY97 & \multicolumn{2}{c}{97--79} \\" _n 
file write Tlocal "\midrule " _n 
file write Tlocal "\multicolumn{5}{l}{\emph{County Employment Rate:}} \\" _n 
file write Tlocal "~~At age 16                     " " & " %4.2f (`mu1_1979_1612')  " & " %4.2f (`mu1_1997_1612')  " & " %4.2f (`=`mu1_1997_1612'-`mu1_1979_1612'')  " & `star1_diff_1612' \\ "  _n 
file write Tlocal "~~At age 22                     " " & " %4.2f (`mu1_1979_2212')  " & " %4.2f (`mu1_1997_2212')  " & " %4.2f (`=`mu1_1997_2212'-`mu1_1979_2212'')  " & `star1_diff_2212' \\ "  _n 
file write Tlocal "~~At age 26                     " " & " %4.2f (`mu1_1979_2512')  " & " %4.2f (`mu1_1997_2512')  " & " %4.2f (`=`mu1_1997_2512'-`mu1_1979_2512'')  " & `star1_diff_2512' \\ "  _n 
file write Tlocal "~~At age 29                     " " & " %4.2f (`mu1_1979_2812')  " & " %4.2f (`mu1_1997_2812')  " & " %4.2f (`=`mu1_1997_2812'-`mu1_1979_2812'')  " & `star1_diff_2812' \\ "  _n 
* file write Tlocal "~~At age 32                     " " & " %4.2f (`mu1_1979_3112')  " & " %4.2f (`mu1_1997_3112')  " & " %4.2f (`=`mu1_1997_3112'-`mu1_1979_3112'')  " & `star1_diff_3112' \\ "  _n 
file write Tlocal "\vspace{-6pt}  \\" _n                                                                                                         
file write Tlocal "\multicolumn{5}{l}{\emph{County Ave. Income per Worker:}} \\" _n
file write Tlocal "~~At age 16                     " " & " %4.2f (`mu2_1979_1612')  " & " %4.2f (`mu2_1997_1612')  " & " %4.2f (`=`mu2_1997_1612'-`mu2_1979_1612'')  " & `star2_diff_1612' \\ "  _n 
file write Tlocal "~~At age 22                     " " & " %4.2f (`mu2_1979_2212')  " & " %4.2f (`mu2_1997_2212')  " & " %4.2f (`=`mu2_1997_2212'-`mu2_1979_2212'')  " & `star2_diff_2212' \\ "  _n 
file write Tlocal "~~At age 26                     " " & " %4.2f (`mu2_1979_2512')  " & " %4.2f (`mu2_1997_2512')  " & " %4.2f (`=`mu2_1997_2512'-`mu2_1979_2512'')  " & `star2_diff_2512' \\ "  _n 
file write Tlocal "~~At age 29                     " " & " %4.2f (`mu2_1979_2812')  " & " %4.2f (`mu2_1997_2812')  " & " %4.2f (`=`mu2_1997_2812'-`mu2_1979_2812'')  " & `star2_diff_2812' \\ "  _n 
file write Tlocal "\vspace{-6pt}  \\" _n                                                                                                         
* file write Tlocal "~~At age 32                     " " & " %4.2f (`mu2_1979_3112')  " & " %4.2f (`mu2_1997_3112')  " & " %4.2f (`=`mu2_1997_3112'-`mu2_1979_3112'')  " & `star2_diff_3112' \\ "  _n 
file write Tlocal "\multicolumn{5}{l}{\emph{Number of four-year colleges in county (per 100,000 people):}} \\" _n 
file write Tlocal "~~At age 16                     " " & " %4.2f (`mu3_1979_1612')  " & " %4.2f (`mu3_1997_1612')  " & " %4.2f (`=`mu3_1997_1612'-`mu3_1979_1612'')  " & `star3_diff_1612' \\ "  _n 
file write Tlocal "\vspace{-6pt}  \\" _n                                                                                                         
file write Tlocal "\multicolumn{5}{l}{\emph{Share of youth with at least one four-year college in county:}} \\" _n 
file write Tlocal "~~At age 16                     " " & " %4.2f (`mu4_1979_1612')  " & " %4.2f (`mu4_1997_1612')  " & " %4.2f (`=`mu4_1997_1612'-`mu4_1979_1612'')  " & `star4_diff_1612' \\ "  _n 
file write Tlocal "\vspace{-6pt}  \\" _n                                                                                                         
file write Tlocal "\multicolumn{5}{l}{\emph{Average tuition of state flagship university:}} \\" 
file write Tlocal "~~At age 16                     " " & " %4.2f (`mu5_1979_1612')  " & " %4.2f (`mu5_1997_1612')  " & " %4.2f (`=`mu5_1997_1612'-`mu5_1979_1612'')  " & `star5_diff_1612' \\ "  _n 
file write Tlocal "\bottomrule " _n 
file write Tlocal "\end{tabular} " _n 
file write Tlocal "\footnotesize{Notes: Employment rate in the respondent's county of residence at each age is the number of employees reported by employers divided by population. Income per worker is the total wage and salary income of the county (in 1,000's of 1982-84\\$) divided by the number of workers. Number of colleges and college tuition are computed as of 1988 and 2005 for the respective NLSY panels. That is, we report college information for years 1988 and 2005 in the youth's county of residence at age 16. Summary statistics weighted by NLSY sampling weights. Significance reported at the 1\% (***), 5\% (**), and 10\% (*) levels.}" _n 
file write Tlocal "\end{threeparttable} " _n 
file write Tlocal "} " _n 
file write Tlocal "\end{table} " _n 
file close Tlocal

log close
