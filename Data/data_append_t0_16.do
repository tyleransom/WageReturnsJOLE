version 14.1
clear all
set more off
capture log using data_append_t0_16.log, replace

********************************************************************
* This do-file appends the 79 and 97 datasets for ease of comparison
*  for tabulations, etc.
* It also creates the time-changing variables as well as the
*   interaction terms.
********************************************************************

!unzip -u    y79/Geocode/y79_all2.dta.zip
use                      y79_all2.dta
!rm                      y79_all2.dta
!unzip -u    y97/Geocode/y97_all2.dta.zip
append using             y97_all2.dta, generate(cohortFlag)
!rm                      y97_all2.dta

recode  cohortFlag (0 = 1979) (1 = 1997)
lab var cohortFlag "Cohort Flag (1979 or 1997)"

recode  born19?? (.=0)

drop if age<=15

tempfile holder2

sort    cohortFlag id year month

*consolidate the cohort-specific variables:
generat famInc   = famInc1978
replace famInc   = famInc1996 if cohortFlag==1997
generat m_famInc = m_famInc1978
replace m_famInc = m_famInc1996 if cohortFlag==1997

replace femaleHeadHH14 = femaleHeadHH1997 if cohortFlag==1997
replace HHsize1979     = HHsize1997 if cohortFlag==1997

keep  cohortFlag id year month age birthMonth birthYear female white black hispanic race region weight oversampleRace annualHrsWrk missInt afqt asvabAR asvabCS asvabMK asvabNO asvabPC asvabWK m_afqt m_asvabAR m_asvabCS m_asvabMK m_asvabNO m_asvabPC m_asvabWK hgcMoth m_hgcMoth hgcFath m_hgcFath foreignBorn famInc m_famInc liveWithMom14 femaleHeadHH14 HHsize19?? born1957 born1958 born1959 born1960 born1961 born1962 born1963 born1964 born1980 born1981 born1982 born1983 born1984 ageAtMissInt yearMissInt everMissInt missIntCum missIntLength everMiss3plusInt everReturnAfter3plusMissInt missIntLastSpell fedMinWage cpi hgc gradeCurrent  enrK12 enrCollege enr2yr enr4yr enrGradSch weeksEmployed wage wageAlt wageAltMean comp compAlt wageMedian wageAltMedian compMedian compAltMedian annualWageMean annualWageMed annualWageMin annualWageMax annualWageMain annualCompMean annualCompMed annualCompMin annualCompMax annualCompMain annualOccMin annualOccMax annualOccMain annualIndMin annualIndMax annualIndMain weeksWorked avgHrs hoursWorked weeksMilitary workFT workPT military work workSch workK12 workCollege other activity gradGraduate yrGradGraduate grad4yr yrGrad4yr grad2yr yrGrad2yr gradHS yrGradHS gradDiploma yrGradDiploma gradGED yrGradGED annualHrsWrkCalc annualHrsWrkCalcCalc annualHrsWrkRaw annualHrsWrkOld  BA_year BA_month Diploma_year Diploma_month GED_year GED_month HS_year HS_month R*interviewDate wageJobCPS wageJobMain compJobCPS compJobMain occJobCPS occJobMain indJobCPS indJobMain hoursJobCPS hoursJobMain weeksSelfEmployed selfEmployedJobCPS selfEmployedJobMain high_grade_comp_May Highest_degree_ever empPct empPctFinal incPerCapita incPerCapitaFinal numBAperCapita numAAperCapita tuitionFlagship
order cohortFlag id year month age birthMonth birthYear female white black hispanic race region weight oversampleRace annualHrsWrk missInt afqt asvabAR asvabCS asvabMK asvabNO asvabPC asvabWK m_afqt m_asvabAR m_asvabCS m_asvabMK m_asvabNO m_asvabPC m_asvabWK hgcMoth m_hgcMoth hgcFath m_hgcFath foreignBorn famInc m_famInc liveWithMom14 femaleHeadHH14 HHsize19?? born1957 born1958 born1959 born1960 born1961 born1962 born1963 born1964 born1980 born1981 born1982 born1983 born1984 ageAtMissInt yearMissInt everMissInt missIntCum missIntLength everMiss3plusInt everReturnAfter3plusMissInt missIntLastSpell fedMinWage cpi hgc gradeCurrent  enrK12 enrCollege enr2yr enr4yr enrGradSch weeksEmployed wage wageAlt wageAltMean comp compAlt wageMedian wageAltMedian compMedian compAltMedian annualWageMean annualWageMed annualWageMin annualWageMax annualWageMain annualCompMean annualCompMed annualCompMin annualCompMax annualCompMain annualOccMin annualOccMax annualOccMain annualIndMin annualIndMax annualIndMain weeksWorked avgHrs hoursWorked weeksMilitary workFT workPT military work workSch workK12 workCollege other activity gradGraduate yrGradGraduate grad4yr yrGrad4yr grad2yr yrGrad2yr gradHS yrGradHS gradDiploma yrGradDiploma gradGED yrGradGED annualHrsWrkCalc annualHrsWrkCalcCalc annualHrsWrkRaw annualHrsWrkOld  BA_year BA_month Diploma_year Diploma_month GED_year GED_month HS_year HS_month R*interviewDate wageJobCPS wageJobMain compJobCPS compJobMain occJobCPS occJobMain indJobCPS indJobMain hoursJobCPS hoursJobMain weeksSelfEmployed selfEmployedJobCPS selfEmployedJobMain high_grade_comp_May Highest_degree_ever empPct empPctFinal incPerCapita incPerCapitaFinal numBAperCapita numAAperCapita tuitionFlagship

bys cohortFlag id: gen firstObs     = (_n==1)
lab def RACE 1 "White" 2 "Black" 3 "Hispanic"
lab val race RACE

*=====================================================================
* Wages:*
*  Use monthly imputed wage variable OR
*  'main' wage from Boehm
*
*  Flag/drop wages that are obviously miscoded or otherwise outlying:
*   1: drop all wages above the top_limit, $50/hr (in 1982-1984 dollars)
*      and below $2/hr
*   2: drop wages if selfEmployed
*   3: ignore missing wages
*  Convert wages from cents to dollars
*=====================================================================
* Create Hybrid wage variable - This will be the main variable
foreach V in  wage occ ind hours selfEmployed {
	gen     `V'JobHybrid  = `V'JobCPS  if cohortFlag==1979
	replace `V'JobHybrid  = `V'JobMain if cohortFlag==1997
}

replace wageAlt       = wageAltMean   if cohortFlag==1979
replace comp          = wage          if cohortFlag==1979
replace compAlt       = wageAltMean   if cohortFlag==1979
replace compMedian    = wageMedian    if cohortFlag==1979
replace compAltMedian = wageAltMedian if cohortFlag==1979
replace compJobCPS    = wageJobCPS    if cohortFlag==1979
replace compJobMain   = wageJobMain   if cohortFlag==1979
generat compJobHybrid = wageJobCPS    if cohortFlag==1979
replace compJobHybrid = compJobMain   if cohortFlag==1997

* Wage variables of potential interest that should be cleaned
local wages     wage wageAlt wageMedian wageAltMedian  wageJobCPS wageJobMain  wageJobHybrid comp compAlt compMedian compAltMedian compJobCPS compJobMain  compJobHybrid
tab activity cohortFlag

scalar top_limit   = 5000
scalar bot_limit   = 200

capture noisily drop tester*

* Drop wages below 200 or above 5000 (actual dropping happens later)
foreach X in `wages' {
	bys cohortFlag id year: gen `X'OutOfRange = ~inrange(`X',bot_limit,top_limit) & ~mi(`X')
	* replace `X' = .z         if `X'OutOfRange==1

	count if `X'OutOfRange==1 & cohortFlag==1979
	count if `X'OutOfRange==1 & cohortFlag==1997
}

* Self-employed
gen selfEmployedJob = (weeksSelfEmployed>0)
foreach X in  CPS Main Hybrid {
	* replace wageJob`X' = .z if selfEmployedJob`X'==1
	* replace compJob`X' = .z if selfEmployedJob`X'==1
	count if selfEmployedJob`X'==1 & cohortFlag==1979
	count if selfEmployedJob`X'==1 & cohortFlag==1997
}

* Convert cents to dollars
foreach X in `wages' {
	replace `X' = `X'/100 if !mi(`X')
}
replace fedMinWage = fedMinWage/100

* create "current month" wage variables for relevant wages
gen current = inlist(mdy(month,1,year),dofm(R1interviewDate),dofm(R2interviewDate),dofm(R3interviewDate),dofm(R4interviewDate),dofm(R5interviewDate),dofm(R6interviewDate),dofm(R7interviewDate),dofm(R8interviewDate),dofm(R9interviewDate),dofm(R10interviewDate),dofm(R11interviewDate),dofm(R12interviewDate),dofm(R13interviewDate),dofm(R14interviewDate),dofm(R15interviewDate),dofm(R16interviewDate),dofm(R17interviewDate),dofm(R18interviewDate))

gen wageCurrent       = wage          if current
gen wageCurrentHybrid = wageJobHybrid if current
gen wageCurrentMain   = wageJobMain   if current
gen wageCurrentAlt    = wageAlt       if current
gen compCurrent       = comp          if current
gen compCurrentHybrid = compJobHybrid if current
gen compCurrentMain   = compJobMain   if current
gen compCurrentAlt    = compAlt       if current

* Top-code annual hours at 5000
replace annualHrsWrk = 5000 if annualHrsWrk>5000 & annualHrsWrk<.

*-------------------------------------------------------------------------------
* Create period variable (=1 for each person in first period, regardless of age)
*  and uniqueid to xtset data
*-------------------------------------------------------------------------------
gen monthAlt = ( month-(birthMonth-1) )*( year-age==birthYear ) + ( month+(12-birthMonth+1) )*( year-age==birthYear+1  )

gen yearmo = year*100+month
gen agemo  =  age*100+monthAlt
gen ageInMonths = age*12+monthAlt
bys cohortFlag id (year month): gen period = _n
gen uniqueid = (cohortFlag-1900)*100000 + id

* Check Stata
bys uniqueid (year month): gen period2 = _n
assert period==period2
drop period2

xtset uniqueid period

*=====================================================================
* Create education, experience and activity variables
*=====================================================================
*-----------------------------
* New activity variable
*-----------------------------
* Deciding not to model attrition
drop if activity==7
assert  activity~=7

tab activity cohortFlag

* Create a new, more-detailed activity variable. Keep the old one and label
*  it as activity_simple
gen activity_simple = activity

replace activity = 11 if activity_simple==1 & gradHS==1
replace activity = 12 if activity_simple==2 & gradHS==1
replace activity = 13 if activity_simple==3 & gradHS==1
replace activity = 14 if activity_simple==4 & gradHS==1
replace activity = 15 if activity_simple==5 & gradHS==1
replace activity = 16 if activity_simple==6 & gradHS==1

replace activity = 21 if activity_simple==1 & grad4yr==1
replace activity = 22 if activity_simple==2 & grad4yr==1
replace activity = 23 if activity_simple==3 & grad4yr==1
replace activity = 24 if activity_simple==4 & grad4yr==1
replace activity = 25 if activity_simple==5 & grad4yr==1
replace activity = 26 if activity_simple==6 & grad4yr==1

bys cohortFlag id: replace activity = 7  if gradHS[_n]==1  & gradHS[_n-1]==0
bys cohortFlag id: replace activity = 17 if grad4yr[_n]==1 & grad4yr[_n-1]==0

lab def vlactivityStoch ///
1  "School Only, no HS Diploma or GED" ///
2  "Work in school, no HS Diploma or GED" ///
3  "Part-time Work, no HS Diploma or GED" ///
4  "Full-time Work, no HS Diploma or GED" ///
5  "Military, no HS Diploma or GED" ///
6  "Other Activities, no HS Diploma or GED" ///
7  "HS Grad this month, regardless of work/military/school" ///
  ///
11 "School Only, HS Grad or GED Holder" ///
12 "Work in school, HS Grad or GED Holder" ///
13 "Part-time Work, HS Grad or GED Holder" ///
14 "Full-time Work, HS Grad or GED Holder" ///
15 "Military, HS Grad or GED Holder" ///
16 "Other Activities, HS Grad or GED Holder" ///
17 "4yr Grad this month, regardless of work/military/school" ///
  ///
21 "School Only, 4yr College Grad" ///
22 "Work in school, 4yr College Grad" ///
23 "Part-time Work, 4yr College Grad" ///
24 "Full-time Work, 4yr College Grad" ///
25 "Military, 4yr College Grad" ///
26 "Other Activities, 4yr College Grad" ///

lab val activity vlactivityStoch

* What month did they graduate?
bys cohortFlag id (year month): gen monthGradHS = gradHS[_n]==1 & gradHS[_n-1]==0
bys cohortFlag id (year month): gen monthGradBA = grad4yr[_n]==1 & grad4yr[_n-1]==0

* What is activity experience of people at various ages?
foreach oldie in workSch military other enrK12 enrCollege enr2yr enr4yr workFT workPT workK12 workCollege {
	replace `oldie' = 0 if inlist(activity,7,17)
}
gen     schoolOnly  = inlist(activity,1,11,21)
gen     anySchool   = inlist(activity,1,2,11,12,21,22)
gen     workPTonly  = inlist(activity,3,13,23)
gen     workFTonly  = inlist(activity,4,14,24)
replace workCollege = inlist(activity,12,22)
gen     workGradSch = inlist(activity,22)

* Running cumulative choice variables
* Sum of these (+ graduation dummies) should equal agemo
bys uniqueid (period): gen schoolOnlyt  = sum(L.schoolOnly)
bys uniqueid (period): gen workScht     = sum(L.workSch)
bys uniqueid (period): gen workPTonlyt  = sum(L.workPTonly)
bys uniqueid (period): gen workFTonlyt  = sum(L.workFTonly)
bys uniqueid (period): gen militaryt    = sum(L.military)
bys uniqueid (period): gen othert       = sum(L.other)

* Running sums of interesting vars that are not perfect partitions
*  of choice space
* bys uniqueid (period): gen enrSchoolt    = sum(enrSchool)
bys uniqueid (period): gen enrK12t       = sum(L.enrK12)
bys uniqueid (period): gen enrColleget   = sum(L.enrCollege)
bys uniqueid (period): gen enr2yrt       = sum(L.enr2yr)
bys uniqueid (period): gen enr4yrt       = sum(L.enr4yr)
bys uniqueid (period): gen anySchoolt    = sum(L.anySchool)
bys uniqueid (period): gen workFTt       = sum(L.workFT)
bys uniqueid (period): gen workPTt       = sum(L.workPT)
bys uniqueid (period): gen workK12t      = sum(L.workK12)
bys uniqueid (period): gen workColleget  = sum(L.workCollege)
bys uniqueid (period): gen workGradScht  = sum(L.workGradSch)

bys uniqueid (period): gen cumHoursWorked = sum(hoursWorked)

* create high order and race interaction terms of mother's education, father's education, and family income
gen hgcMothBlack    = hgcMoth*black
gen hgcMothHisp     = hgcMoth*hispanic
gen hgcMothSq       = hgcMoth^2
gen hgcMothSqBlack  = hgcMoth^2*black
gen hgcMothSqHisp   = hgcMoth^2*hispanic
gen hgcMothCu       = hgcMoth^3
gen hgcMothCuBlack  = hgcMoth^3*black
gen hgcMothCuHisp   = hgcMoth^3*hispanic
gen hgcMothQr       = hgcMoth^4
gen hgcFathBlack    = hgcFath*black
gen hgcFathHisp     = hgcFath*hispanic
gen hgcFathSq       = hgcFath^2
gen hgcFathSqBlack  = hgcFath^2*black
gen hgcFathSqHisp   = hgcFath^2*hispanic
gen hgcFathCu       = hgcFath^3
gen hgcFathCuBlack  = hgcFath^3*black
gen hgcFathCuHisp   = hgcFath^3*hispanic
gen hgcFathQr       = hgcFath^4
gen famIncBlack     = famInc*black
gen famIncHisp      = famInc*hispanic
gen famIncSq        = famInc^2
gen famIncSqBlack   = famInc^2*black
gen famIncSqHisp    = famInc^2*hispanic
gen famIncCu        = famInc^3
gen famIncCuBlack   = famInc^3*black
gen famIncCuHisp    = famInc^3*hispanic
gen famIncQr        = famInc^4

gen m_hgcMothBlack  = m_hgcMoth*black
gen m_hgcMothHisp   = m_hgcMoth*hispanic
gen m_hgcFathBlack  = m_hgcFath*black
gen m_hgcFathHisp   = m_hgcFath*hispanic
gen m_famIncBlack   = m_famInc*black
gen m_famIncHisp    = m_famInc*hispanic

* create potential experience: ageMo - anySchoolt - [baseline age]
gen potExpClassict  = ageInMonths - anySchoolt - 6*12
gen potExpClassicSq = potExpClassict^2
gen potExpClassicCu = potExpClassict^3
gen potExpt         = ageInMonths - anySchoolt - 16*12
gen potExpSq        = potExpt^2
gen potExpCu        = potExpt^3

* create race interactions of cumulative indicators (use convention hgcBlack, hgcHisp, schoolOnlytBlack, schoolOnlytHisp, hgcSq)
gen hgcBlack              = hgc*black
gen hgcHisp               = hgc*hispanic
gen hgcSq                 = hgc^2
gen schoolOnlyBlack       = schoolOnlyt*black
gen schoolOnlyHisp        = schoolOnlyt*hispanic
gen schoolOnlySq          = schoolOnlyt^2
gen schoolOnlySqBlack     = schoolOnlyt^2*black
gen schoolOnlySqHisp      = schoolOnlyt^2*hispanic
gen schoolOnlyCu          = schoolOnlyt^3
gen schoolOnlyCuBlack     = schoolOnlyt^3*black
gen schoolOnlyCuHisp      = schoolOnlyt^3*hispanic
gen schoolOnlyQr          = schoolOnlyt^4
gen anySchoolBlack        = anySchoolt*black
gen anySchoolHisp         = anySchoolt*hispanic
gen anySchoolSq           = anySchoolt^2
gen anySchoolSqBlack      = anySchoolt^2*black
gen anySchoolSqHisp       = anySchoolt^2*hispanic
gen anySchoolCu           = anySchoolt^3
gen anySchoolCuBlack      = anySchoolt^3*black
gen anySchoolCuHisp       = anySchoolt^3*hispanic
gen anySchoolQr           = anySchoolt^4
gen workK12Black          = workK12t*black
gen workK12Hisp           = workK12t*hispanic
gen workK12Sq             = workK12t^2
gen workK12schoolOnly     = workK12t*schoolOnlyt
gen workK12anySchool      = workK12t*anySchoolt 
gen workK12SqBlack        = workK12t^2*black
gen workK12SqHisp         = workK12t^2*hispanic
gen workK12Cu             = workK12t^3
gen workK12CuBlack        = workK12t^3*black
gen workK12CuHisp         = workK12t^3*hispanic
gen workK12Qr             = workK12t^4
gen workCollegeBlack      = workColleget*black
gen workCollegeHisp       = workColleget*hispanic
gen workCollegeSq         = workColleget^2
gen workCollegeschoolOnly = workColleget*schoolOnlyt
gen workCollegeanySchool  = workColleget*anySchoolt
gen workCollegeworkK12    = workColleget*workK12t
gen workCollegeSqBlack    = workColleget^2*black
gen workCollegeSqHisp     = workColleget^2*hispanic
gen workCollegeCu         = workColleget^3
gen workCollegeCuBlack    = workColleget^3*black
gen workCollegeCuHisp     = workColleget^3*hispanic
gen workCollegeQr         = workColleget^4
gen workGradSchBlack      = workGradScht*black
gen workGradSchHisp       = workGradScht*hispanic
gen workGradSchSq         = workGradScht^2
gen workGradSchschoolOnly = workGradScht*schoolOnlyt
gen workGradSchanySchool  = workGradScht*anySchoolt
gen workGradSchworkK12    = workGradScht*workK12t
gen workGradSchSqBlack    = workGradScht^2*black
gen workGradSchSqHisp     = workGradScht^2*hispanic
gen workGradSchCu         = workGradScht^3
gen workGradSchCuBlack    = workGradScht^3*black
gen workGradSchCuHisp     = workGradScht^3*hispanic
gen workGradSchQr         = workGradScht^4
gen workPTBlack           = workPTonlyt*black
gen workPTHisp            = workPTonlyt*hispanic
gen workPTSq              = workPTonlyt^2
gen workPTschoolOnly      = workPTonlyt*schoolOnlyt
gen workPTanySchool       = workPTonlyt*anySchoolt
gen workPTworkK12         = workPTonlyt*workK12t
gen workPTworkCollege     = workPTonlyt*workColleget
gen workPTworkGradSch     = workPTonlyt*workGradScht
gen workPTSqBlack         = workPTonlyt^2*black
gen workPTSqHisp          = workPTonlyt^2*hispanic
gen workPTCu              = workPTonlyt^3
gen workPTCuBlack         = workPTonlyt^3*black
gen workPTCuHisp          = workPTonlyt^3*hispanic
gen workPTQr              = workPTonlyt^4
gen workFTBlack           = workFTonlyt*black
gen workFTHisp            = workFTonlyt*hispanic
gen workFTSq              = workFTonlyt^2
gen workFTschoolOnly      = workFTonlyt*schoolOnlyt
gen workFTanySchool       = workFTonlyt*anySchoolt
gen workFTworkK12         = workFTonlyt*workK12t
gen workFTworkCollege     = workFTonlyt*workColleget
gen workFTworkGradSch     = workFTonlyt*workGradScht
gen workFTworkPT          = workFTonlyt*workPTonlyt
gen workFTSqBlack         = workFTonlyt^2*black
gen workFTSqHisp          = workFTonlyt^2*hispanic
gen workFTCu              = workFTonlyt^3
gen workFTCuBlack         = workFTonlyt^3*black
gen workFTCuHisp          = workFTonlyt^3*hispanic
gen workFTQr              = workFTonlyt^4
gen militaryBlack         = militaryt*black
gen militaryHisp          = militaryt*hispanic
gen militarySq            = militaryt^2
gen militarySqBlack       = militaryt^2*black
gen militarySqHisp        = militaryt^2*hispanic
gen militaryCu            = militaryt^3
gen militaryCuBlack       = militaryt^3*black
gen militaryCuHisp        = militaryt^3*hispanic
gen militaryQr            = militaryt^4
gen otherBlack            = othert*black
gen otherHisp             = othert*hispanic
gen otherSq               = othert^2
gen otherSqBlack          = othert^2*black
gen otherSqHisp           = othert^2*hispanic
gen otherCu               = othert^3
gen otherCuBlack          = othert^3*black
gen otherCuHisp           = othert^3*hispanic
gen otherQr               = othert^4

tab activity cohortFlag

*-----------------------------------
* Generate various college variables
*-----------------------------------
* Gen absorbing dummy for having any degree
bys cohortFlag id: gen gradCol = max(grad2yr, grad4yr)

* Gen months enrCollege
by cohortFlag id: egen monthsCol = max(enrColleget)
by cohortFlag id: egen months2yr = max(enr2yrt)
by cohortFlag id: egen months4yr = max(enr4yrt)

* Gen month started college variable
generat enrCollege1    = (enrColleget==1) & enrCollege==1
generat enr2yr1        = (enr2yrt    ==1) & enr2yr==1
generat enr4yr1        = (enr4yrt    ==1) & enr4yr==1

* Gen month last attended college variable
by cohortFlag id: gen enrCollegeN = (enrColleget==monthsCol) & enrCollege==1
by cohortFlag id: gen enr2yrN     = (enr2yrt    ==months2yr) & enr2yr==1
by cohortFlag id: gen enr4yrN     = (enr4yrt    ==months4yr) & enr4yr==1

* Gen variables for date started college and date last attended college
* Started
generat BA_start_year  = year*enrCollege1
generat BA_start_month = month*enrCollege1
bys cohortFlag id: egen BAstartYr = max(BA_start_year)
bys cohortFlag id: egen BAstartMo = max(BA_start_month)
recode  BAstartYr (0=.)
recode  BAstartMo (0=.)
generat BAstartYrMo = ym(BAstartYr,BAstartMo)
format  BAstartYrMo %tm
generat BAstartDate = mdy(BAstartMo,1,BAstartYr)
format  BAstartDate %td
generat BAendDate = mdy(BA_month,1,BA_year)
format  BAendDate %td
generat ageBAstartYr1 = age if year==BAstartYr
bys cohortFlag id: egen ageBAstartYr = max(ageBAstartYr1)
generat ageBAendYr1 = age if year==BA_year
bys cohortFlag id: egen ageBAendYr = max(ageBAendYr1)

* Ended
generat BA_stop_year  = year*enrCollegeN
generat BA_stop_month = month*enrCollegeN
bys cohortFlag id: egen BAstopYr = max(BA_stop_year)
bys cohortFlag id: egen BAstopMo = max(BA_stop_month)
recode  BAstopYr (0=.)
recode  BAstopMo (0=.)
generat BAstopYrMo = ym(BAstopYr,BAstopMo)
format  BAstopYrMo %tm

* Gen months b/t start college and last attended college
gen monthsAtRiskCol = BAstopYrMo - BAstartYrMo + 1
recode monthsCol monthsAtRiskCol (0=.)

* Gen age first started college
generat ageFirstCol1 = age*enrCollege1
generat ageFirst2yr1 = age*enr2yr1
generat ageFirst4yr1 = age*enr4yr1
bys cohortFlag id: egen ageFirstCol = max(ageFirstCol1)
bys cohortFlag id: egen ageFirst2yr = max(ageFirst2yr1)
bys cohortFlag id: egen ageFirst4yr = max(ageFirst4yr1)

generat everCol = (ageFirstCol<=age) & (ageFirstCol>0)
generat ever2yr = (ageFirst2yr<=age) & (ageFirst2yr>0)
generat ever4yr = (ageFirst4yr<=age) & (ageFirst4yr>0)

*---------------------------------------
* Generate various work status variables
*---------------------------------------

* Gen "age at first post-grad FT job" variable(s)
* First get highest degree ever received variables
bys cohortFlag id: gen HSgradOnly   = (gradHS[_N]==1 & grad2yr[_N]==0 & grad4yr[_N]==0 & gradGraduate[_N]==0)
bys cohortFlag id: gen AAgradOnly   = (                grad2yr[_N]==1 & grad4yr[_N]==0 & gradGraduate[_N]==0)
bys cohortFlag id: gen BAgradOnly   = (                                 grad4yr[_N]==1 & gradGraduate[_N]==0)
bys cohortFlag id: gen GradgradOnly = (                                                  gradGraduate[_N]==1)
gen NoHSgradEver = 1-HSgradOnly-AAgradOnly-BAgradOnly-GradgradOnly

* Now get first month they were working full-time once the highest degree was received
generat firstFT1noHS = (activity==4 & gradHS==0)  if NoHSgradEver==1
recode  firstFT1noHS (0=.)
generat ageFirstFT1noHS = age*firstFT1noHS
generat firstFT1HS   = (activity==4 & gradHS==1) if HSgradOnly==1 | AAgradOnly==1
recode  firstFT1HS (0=.)
generat ageFirstFT1HS = age*firstFT1HS
generat firstFT1BA   = (activity==4 & grad4yr==1) if BAgradOnly==1 | GradgradOnly==1
recode  firstFT1BA (0=.)
generat ageFirstFT1BA = age*firstFT1BA
bys cohortFlag id: egen ageFirstFTnoHS = min(ageFirstFT1noHS) if NoHSgradEver==1
bys cohortFlag id: egen ageFirstFTHS = min(ageFirstFT1HS) if HSgradOnly==1 | AAgradOnly==1
bys cohortFlag id: egen ageFirstFTBA = min(ageFirstFT1BA) if BAgradOnly==1 | GradgradOnly==1
generat ageFirstFT = ageFirstFTnoHS if NoHSgradEver==1
replace ageFirstFT = ageFirstFTHS if HSgradOnly==1 | AAgradOnly==1
replace ageFirstFT = ageFirstFTBA if BAgradOnly==1 | GradgradOnly==1

generat everFirstFT = (ageFirstFT<=age)

drop firstObs
bys cohortFlag id: gen firstObs = (_n==1)

*---------------------------------------
* Z-score afqt/asvabs
*---------------------------------------
foreach X in  afqt asvabAR asvabCS asvabMK asvabNO asvabPC asvabWK {
	qui sum `X' if !m_`X' & firstObs & !female
	replace `X'=!m_`X'*(`X'-r(mean))/r(sd)
}

* compress
* save        yCombined_t0_16.dta, replace

* Counts for dropped/excluded wages
*   Only keep current interview (this drops the other interviews)
*   Non-working observations
*   Drop self-employed
*   Truncated observations
*   Missing wages

* tab current cohortFlag if !female & current==1
* tab current cohortFlag if !female & current==1 &  inlist(activity,1,5,6,7,11,15,16,17,21,25,26) 
* tab current cohortFlag if !female & current==1 & ~inlist(activity,1,5,6,7,11,15,16,17,21,25,26) 
* tab current cohortFlag if !female & current==1 & ~inlist(activity,1,5,6,7,11,15,16,17,21,25,26) & selfEmployedJob==1
* tab current cohortFlag if !female & current==1 & ~inlist(activity,1,5,6,7,11,15,16,17,21,25,26) & selfEmployedJob==0 & wageOutOfRange==1
* tab current cohortFlag if !female & current==1 & ~inlist(activity,1,5,6,7,11,15,16,17,21,25,26) & selfEmployedJob==0 & wageOutOfRange==0 & ~mi(wage)
* recode cohortFlag (1979=19791) if born1961==1 | born1962==1 | born1963==1 | born1964==1
tab cohortFlag if ~female & ~born1957 & ~born1958 & ~inlist(activity,1,5,6,7,11,15,16,17,21,25,26) 
tab cohortFlag if ~female & ~born1957 & ~born1958 & ~inlist(activity,1,5,6,7,11,15,16,17,21,25,26) & selfEmployedJob==1
tab cohortFlag if ~female & ~born1957 & ~born1958 & ~inlist(activity,1,5,6,7,11,15,16,17,21,25,26) & selfEmployedJob==0 & wageOutOfRange==1
tab cohortFlag if ~female & ~born1957 & ~born1958 & ~inlist(activity,1,5,6,7,11,15,16,17,21,25,26) & selfEmployedJob==0 & wageOutOfRange==0 &  mi(wage)
tab cohortFlag if ~female & ~born1957 & ~born1958 & ~inlist(activity,1,5,6,7,11,15,16,17,21,25,26) & selfEmployedJob==0 & wageOutOfRange==0 & ~mi(wage)
* recode cohortFlag (19791=1979)

sum wage wageAlt wageJobMain wageJobHybrid
gen     wageNoSelf    = wage
gen     wageAltNoSelf = wageAlt

replace wage          = . if              inlist(activity,1,5,6,7,11,15,16,17,21,25,26) | wageOutOfRange==1                           
replace wageAlt       = . if              inlist(activity,1,5,6,7,11,15,16,17,21,25,26) | wageAltOutOfRange==1                           
replace wageNoSelf    = . if              inlist(activity,1,5,6,7,11,15,16,17,21,25,26) | wageOutOfRange==1         | selfEmployedJob==1       
replace wageAltNoSelf = . if              inlist(activity,1,5,6,7,11,15,16,17,21,25,26) | wageAltOutOfRange==1      | selfEmployedJob==1       
replace wageJobMain   = . if current~=1 | inlist(activity,1,5,6,7,11,15,16,17,21,25,26) | wageJobMainOutOfRange==1  | selfEmployedJobMain==1   
replace wageJobHybrid = . if current~=1 | inlist(activity,1,5,6,7,11,15,16,17,21,25,26) | wageJobHybridOutOfRange==1| selfEmployedJobHybrid==1 
sum wage wageAlt wageNoSelf wageAltNoSelf wageJobMain wageJobHybrid

*---------------------------------------
* re-scale number of colleges per capita variables, by multiplying by 100,000
* (this means they are "number of colleges per 100,000 people")
*---------------------------------------
foreach var in numBAperCapita numAAperCapita {
	replace `var' = `var'*1e5
}
gen byte numBAzero = numBAperCapita==0
gen byte numAAzero = numAAperCapita==0

keep if agemo<=3512

compress
save       yCombinedAnalysis_t0_16.dta, replace
!chmod 776 yCombined*.dta
!zip -m    yCombinedAnalysis_t0_16.dta.zip yCombinedAnalysis_t0_16.dta

log close
