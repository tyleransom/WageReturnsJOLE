/*----------------------------------------------------------------------------------*\ 
|       Codes from the employment status data                                        |
|------------------------------------------------------------------------------------|
|  0: No information reported to account for week; job dates indeterminate           |
|  1: Not associated with an employer, not actively searching for an employer job    |
|  2: Not working (unemployment vs. out of labor force cannot be determined)         |
|  3: Associated with an employer, periods not working for the employer are missing  |
|  4: Unemployed                                                                     |
|  5: Out of the labor force                                                         |
|  6: Active military service                                                        |
| (): 4-8 digit employer code if employed                                            |
\*----------------------------------------------------------------------------------*/
local months Jan Feb Mar Apr May Jun Jul Aug Sep Oct Nov Dec

scalar scalarJan = 1
scalar scalarFeb = 2
scalar scalarMar = 3
scalar scalarApr = 4
scalar scalarMay = 5
scalar scalarJun = 6
scalar scalarJul = 7
scalar scalarAug = 8
scalar scalarSep = 9
scalar scalarOct = 10
scalar scalarNov = 11
scalar scalarDec = 12
 
* Deflate wages
foreach x of numlist 1/13 {
    qui replace Hrly_comp_Job`x'_ = Hrly_comp_Job`x'_/cpi
    qui replace Hrly_wage_Job`x'_ = Hrly_wage_Job`x'_/cpi
}
replace fedMinWage = fedMinWage/cpi // Deflate the federal minimum wage

* Fix "hours per week at Job X" variable
capture noisily drop Hrs_week_Job*
foreach x of numlist 1/13 {
    ren Hrs_per_week_Job`x'_ Hrs_week_Job`x'_
}

sum Hrs_week_Job?_ Hrs_week_Job??_

* replace "9702" etc. in Employment Status Array with "199702" etc.
foreach x of numlist 1/53 {
    qui replace Emp_Status_Week_`x'_ = 199701 if Emp_Status_Week_`x'_==9701
    qui replace Emp_Status_Week_`x'_ = 199702 if Emp_Status_Week_`x'_==9702
    qui replace Emp_Status_Week_`x'_ = 199703 if Emp_Status_Week_`x'_==9703
    qui replace Emp_Status_Week_`x'_ = 199704 if Emp_Status_Week_`x'_==9704
    qui replace Emp_Status_Week_`x'_ = 199705 if Emp_Status_Week_`x'_==9705
    qui replace Emp_Status_Week_`x'_ = 199706 if Emp_Status_Week_`x'_==9706
    qui replace Emp_Status_Week_`x'_ = 199707 if Emp_Status_Week_`x'_==9707
    qui replace Emp_Status_Week_`x'_ = 199708 if Emp_Status_Week_`x'_==9708
    qui replace Emp_Status_Week_`x'_ = 199709 if Emp_Status_Week_`x'_==9709
    qui replace Emp_Status_Week_`x'_ = 199710 if Emp_Status_Week_`x'_==9710
    qui replace Emp_Status_Week_`x'_ = 199711 if Emp_Status_Week_`x'_==9711
    qui replace Emp_Status_Week_`x'_ = 199712 if Emp_Status_Week_`x'_==9712
    qui replace Emp_Status_Week_`x'_ = 199713 if Emp_Status_Week_`x'_==9713
    qui replace Emp_Status_Week_`x'_ = 199801 if Emp_Status_Week_`x'_==9801
    qui replace Emp_Status_Week_`x'_ = 199802 if Emp_Status_Week_`x'_==9802
    qui replace Emp_Status_Week_`x'_ = 199803 if Emp_Status_Week_`x'_==9803
    qui replace Emp_Status_Week_`x'_ = 199804 if Emp_Status_Week_`x'_==9804
    qui replace Emp_Status_Week_`x'_ = 199805 if Emp_Status_Week_`x'_==9805
    qui replace Emp_Status_Week_`x'_ = 199806 if Emp_Status_Week_`x'_==9806
    qui replace Emp_Status_Week_`x'_ = 199807 if Emp_Status_Week_`x'_==9807
    qui replace Emp_Status_Week_`x'_ = 199808 if Emp_Status_Week_`x'_==9808
    qui replace Emp_Status_Week_`x'_ = 199809 if Emp_Status_Week_`x'_==9809
    qui replace Emp_Status_Week_`x'_ = 199810 if Emp_Status_Week_`x'_==9810
    qui replace Emp_Status_Week_`x'_ = 199811 if Emp_Status_Week_`x'_==9811
    qui replace Emp_Status_Week_`x'_ = 199812 if Emp_Status_Week_`x'_==9812
    qui replace Emp_Status_Week_`x'_ = 199813 if Emp_Status_Week_`x'_==9813
}

tab year, sum(Hrly_comp_Job1_)

* Backfill the Employer ID, Wage rates, and Industry/Occupation codes for people who missed interviews
gsort ID -year
foreach x of numlist 1/13 {
    by ID: replace Emp`x'_ID         = Emp`x'_ID[_n-1]         if ~mi(Emp`x'_ID[_n-1]) & Emp`x'_ID[_n]==.n
    by ID: replace Emp`x'_ID         = Emp`x'_ID[_n-1]         if ~mi(Emp`x'_ID[_n-1]) & inlist(year,1994,1995,1996,2012,2014)
    by ID: replace Hrs_week_Job`x'_  = Hrs_week_Job`x'_[_n-1]  if ~mi(Hrs_week_Job`x'_[_n-1]) & Hrs_week_Job`x'_[_n]==.n
    by ID: replace Hrs_week_Job`x'_  = Hrs_week_Job`x'_[_n-1]  if ~mi(Hrs_week_Job`x'_[_n-1]) & inlist(year,1994,1995,1996,2012,2014)
    by ID: replace Hrly_wage_Job`x'_ = Hrly_wage_Job`x'_[_n-1] if ~mi(Hrly_wage_Job`x'_[_n-1]) & Hrly_wage_Job`x'_[_n]==.n
    by ID: replace Hrly_wage_Job`x'_ = Hrly_wage_Job`x'_[_n-1] if ~mi(Hrly_wage_Job`x'_[_n-1]) & inlist(year,1994,1995,1996,2012,2014)
    by ID: replace Hrly_comp_Job`x'_ = Hrly_comp_Job`x'_[_n-1] if ~mi(Hrly_comp_Job`x'_[_n-1]) & Hrly_comp_Job`x'_[_n]==.n
    by ID: replace Hrly_comp_Job`x'_ = Hrly_comp_Job`x'_[_n-1] if ~mi(Hrly_comp_Job`x'_[_n-1]) & inlist(year,1994,1995,1996,2012,2014)
    by ID: replace Hrly_comp_Job`x'_ = Hrly_comp_Job`x'_[_n+1] if Hrly_comp_Job`x'_[_n]==.i & ~mi(Hrly_comp_Job`x'_[_n+1]) & Emp`x'_ID[_n]==Emp`x'_ID[_n+1]
    by ID: replace Hrly_wage_Job`x'_ = Hrly_wage_Job`x'_[_n+1] if Hrly_wage_Job`x'_[_n]==.i & ~mi(Hrly_wage_Job`x'_[_n+1]) & Emp`x'_ID[_n]==Emp`x'_ID[_n+1]
    by ID: replace Hrly_comp_Job`x'_ = Hrly_comp_Job`x'_[_n-1] if Hrly_comp_Job`x'_[_n]==.i & ~mi(Hrly_comp_Job`x'_[_n-1]) & Emp`x'_ID[_n]==Emp`x'_ID[_n-1]
    by ID: replace Hrly_wage_Job`x'_ = Hrly_wage_Job`x'_[_n-1] if Hrly_wage_Job`x'_[_n]==.i & ~mi(Hrly_wage_Job`x'_[_n-1]) & Emp`x'_ID[_n]==Emp`x'_ID[_n-1]
}

foreach x of numlist 1/13 {
    by ID: replace Job`x'_Industry      = Job`x'_Industry[_n-1]      if ~mi(Job`x'_Industry[_n-1]     ) & Job`x'_Industry[_n]==.n
    by ID: replace Job`x'_Industry      = Job`x'_Industry[_n-1]      if ~mi(Job`x'_Industry[_n-1]     ) & inlist(year,1994,1995,1996,2012,2014)
    by ID: replace Job`x'_Occupation    = Job`x'_Occupation[_n-1]    if ~mi(Job`x'_Occupation[_n-1]   ) & Job`x'_Occupation[_n]==.n
    by ID: replace Job`x'_Occupation    = Job`x'_Occupation[_n-1]    if ~mi(Job`x'_Occupation[_n-1]   ) & inlist(year,1994,1995,1996,2012,2014)
    by ID: replace Job`x'_self_employed = Job`x'_self_employed[_n-1] if ~mi(Job`x'_self_employed[_n-1]) & Job`x'_self_employed[_n]==.n
    by ID: replace Job`x'_self_employed = .                          if ~mi(Job`x'_self_employed[_n-1]) & inrange(year,1994,1999)
}
sort ID year

* move forward 2015 responses into 2016 for those who interviewed R17 in early 2016
foreach x of numlist 1/13 {
    by ID: replace Emp`x'_ID         = Emp`x'_ID[_n-1]         if ~mi(Emp`x'_ID[_n-1])         & inlist(year,2016)
    by ID: replace Hrs_week_Job`x'_  = Hrs_week_Job`x'_[_n-1]  if ~mi(Hrs_week_Job`x'_[_n-1] ) & inlist(year,2016)
    by ID: replace Hrly_wage_Job`x'_ = Hrly_wage_Job`x'_[_n-1] if ~mi(Hrly_wage_Job`x'_[_n-1]) & inlist(year,2016)
    by ID: replace Hrly_comp_Job`x'_ = Hrly_comp_Job`x'_[_n-1] if ~mi(Hrly_comp_Job`x'_[_n-1]) & inlist(year,2016)
    by ID: replace Job`x'_Industry   = Job`x'_Industry[_n-1]   if ~mi(Job`x'_Industry[_n-1]  ) & inlist(year,2016)
    by ID: replace Job`x'_Occupation = Job`x'_Occupation[_n-1] if ~mi(Job`x'_Occupation[_n-1]) & inlist(year,2016)
}

tab year, sum(Hrly_comp_Job1_)

* Generate Self Employed Weekly Status
foreach x of numlist 1/53 {
    generat Self_employed_Week`x'_ = 0
    foreach y of numlist 1/13 {
        replace Self_employed_Week`x'_ = 1 if Job`y'_self_employed==1 & Emp_Status_Week_`x'_==Emp`y'_ID
    }
}

* Generate Employment status in the week before interview
gen Emp_Status_Week_Bef_Interview = .
foreach x of numlist 1/53 {
    replace Emp_Status_Week_Bef_Interview = Emp_Status_Week_`x'_ if inlist(yw(year,`x'),wofd(R1interviewDay)-1,wofd(R2interviewDay)-1,wofd(R3interviewDay)-1,wofd(R4interviewDay)-1,wofd(R5interviewDay)-1,wofd(R6interviewDay)-1,wofd(R7interviewDay)-1,wofd(R8interviewDay)-1,wofd(R9interviewDay)-1,wofd(R10interviewDay)-1,wofd(R11interviewDay)-1,wofd(R12interviewDay)-1,wofd(R13interviewDay)-1,wofd(R14interviewDay)-1,wofd(R15interviewDay)-1,wofd(R16interviewDay)-1,wofd(R17interviewDay)-1)
}

* Generate the Job ID as of the week before interview 
gen JobID_current = Emp_Status_Week_Bef_Interview if inrange(Emp_Status_Week_Bef_Interview,7,.)

* Generate the wage at the main job worked in the week before interview
gen wage_job_current = .
gen comp_job_current = .
foreach x of numlist 1/13 {
    replace wage_job_current = Hrly_wage_Job`x'_ if Emp`x'_ID==JobID_current
    replace comp_job_current = Hrly_comp_Job`x'_ if Emp`x'_ID==JobID_current
}

* Generate the self-employment status at the main job worked in the week before interview
gen self_employed_job_current = .
foreach x of numlist 1/13 {
    replace self_employed_job_current = Job`x'_self_employed==1 if Emp`x'_ID==JobID_current
}

* Generate current Industry, Occupation and Internship (based on the CV_currentJOB_FLG variable)
gen ind_job_current = .
gen occ_job_current = .
gen internship_job_current = .
foreach x of numlist 1/13 {
    replace ind_job_current        = Job`x'_Industry   if Emp`x'_ID==JobID_current
    replace occ_job_current        = Job`x'_Occupation if Emp`x'_ID==JobID_current
    replace internship_job_current = Job`x'_Internship if Emp`x'_ID==JobID_current
}

* Generate the wage at the main job worked as defined by CV_MAINJOB_FLG
gen wage_job_main = .
gen comp_job_main = .
foreach x of numlist 1/13 {
    replace wage_job_main = Hrly_wage_Job`x'_ if Main_job==`x'
    replace comp_job_main = Hrly_comp_Job`x'_ if Main_job==`x'
}

* Generate self-employed status at the main job worked as defined by CV_MAINJOB_FLG
gen self_employed_job_main = .
foreach x of numlist 1/13 {
    replace self_employed_job_main = Job`x'_self_employed==1 if Main_job==`x'
}

* Generate an Main Industry, Occupation and Internship (based on the CV_MAINJOB_FLG variable)
gen ind_job_main = .
gen occ_job_main = .
gen internship_job_main = .
foreach x of numlist 1/13 {
    replace ind_job_main        = Job`x'_Industry   if Main_job==`x'
    replace occ_job_main        = Job`x'_Occupation if Main_job==`x'
    replace internship_job_main = Job`x'_Internship if Main_job==`x'
}

* This loop generates weekly dummies for if someone was in the labor force or not (i.e. employed or unemployed)
foreach x of numlist 1/53 {
    qui gen byte Labor_force_Week_`x' = inrange(Emp_Status_Week_`x'_,3,4) | inrange(Emp_Status_Week_`x'_,7,.)
    qui replace  Labor_force_Week_`x' = . if Emp_Status_Week_`x'_==.
}

* This loop generates weekly dummies for if someone was NOT in the labor force or not (i.e. uncertain status, military, or out of labor force)
foreach x of numlist 1/53 {
    qui gen byte No_Labor_force_Week_`x' = ~mi(Emp_Status_Week_`x'_) & inlist(Emp_Status_Week_`x'_,0,1,2,5,6)
    qui replace  No_Labor_force_Week_`x' = . if Emp_Status_Week_`x'_==.
}

* This loop generates weekly dummies for if someone was with a particular employer (>6 is the ID; 3 is 'missing' ID)
foreach x of numlist 1/53 {
    qui gen byte Employed_Week_`x' = (Emp_Status_Week_`x'_==3 | inrange(Emp_Status_Week_`x'_,7,.))
    qui replace  Employed_Week_`x' = . if Emp_Status_Week_`x'_==. | Labor_force_Week_`x' ==0
}

* This loop generates weekly dummies for if the person was missing an employer ID
foreach x of numlist 1/53 {
    qui gen byte Employed_noID_Week_`x' = Emp_Status_Week_`x'_==3
}

* This loop generates weekly dummies for if the employment status was unknown (0)
foreach x of numlist 1/53 {
    qui gen byte Emp_Status_Missing0_Week_`x' = (Emp_Status_Week_`x'_==0)
}

* This loop generates weekly dummies for if the employment status was coded as -5 (missed interview)
foreach x of numlist 1/53 {
    qui gen byte Emp_Status_MissingDotA_Week_`x' = (Emp_Status_Week_`x'_==.n)
}

* This loop generates weekly dummies for if the employment status was coded as -3 (invalid skip)
foreach x of numlist 1/53 {
    qui gen byte Emp_Status_MissingDotI_Week_`x' = (Emp_Status_Week_`x'_==.i)
}

* This loop generates weekly dummies for if the employment status was coded as -4 (valid skip)
foreach x of numlist 1/53 {
    qui gen byte Emp_Status_MissingDotV_Week_`x' = (Emp_Status_Week_`x'_==.v)
}

* This loop generates weekly dummies for if the employment status was coded as -2 (don't know)
foreach x of numlist 1/53 {
    qui gen byte Emp_Status_MissingDotD_Week_`x' = (Emp_Status_Week_`x'_==.d)
}

* This loop generates weekly dummies for if the employment status was coded as -1 (refused)
foreach x of numlist 1/53 {
    qui gen byte Emp_Status_MissingDotR_Week_`x' = (Emp_Status_Week_`x'_==.r)
}

* This loop generates weekly dummies for if the employment status was coded as . (general missing; this is a check for reshape errors)
foreach x of numlist 1/53 {
    qui gen byte Emp_Status_MissingDot_Week_`x' = (Emp_Status_Week_`x'_==.)
}

* This loop generates weekly dummies for if the person was in the military
foreach x of numlist 1/53 {
    qui gen byte Military_Week_`x' = (Emp_Status_Week_`x'_==6)
}

* This loop generates weekly dummies for if the labor force status changed from the previous week
local i=2
local j=1
while `i'<=53  {
    gen byte switch_labor_status_week`i' = (Emp_Status_Week_`i'_ ~= Emp_Status_Week_`j'_)
    local j=`j'+1
    local i=`i'+1
}

* These commands get total number of weeks spent in labor force status "x"
qui egen weeks_employed               = rowtotal(Employed_Week_? Employed_Week_??)
qui egen weeks_in_labor_force         = rowtotal(Labor_force_Week_? Labor_force_Week_??)
qui egen Weeks_Employed_noID          = rowtotal(Employed_noID_Week_? Employed_noID_Week_??)
qui egen Weeks_Emp_Status_Missing0    = rowtotal(Emp_Status_Missing0_Week_? Emp_Status_Missing0_Week_??)
qui egen Weeks_Emp_Status_MissingDotA = rowtotal(Emp_Status_MissingDotA_Week_? Emp_Status_MissingDotA_Week_??)
qui egen Weeks_Emp_Status_MissingDotI = rowtotal(Emp_Status_MissingDotI_Week_? Emp_Status_MissingDotI_Week_??)
qui egen Weeks_Emp_Status_MissingDotV = rowtotal(Emp_Status_MissingDotV_Week_? Emp_Status_MissingDotV_Week_??)
qui egen Weeks_Emp_Status_MissingDotD = rowtotal(Emp_Status_MissingDotD_Week_? Emp_Status_MissingDotD_Week_??)
qui egen Weeks_Emp_Status_MissingDotR = rowtotal(Emp_Status_MissingDotR_Week_? Emp_Status_MissingDotR_Week_??)
qui egen Weeks_Emp_Status_MissingDot  = rowtotal(Emp_Status_MissingDot_Week_? Emp_Status_MissingDot_Week_??)
qui egen Number_labor_status_switches = rowtotal(switch_labor_status_week? switch_labor_status_week??)

* Need to make a slight correction for weeks employed, etc. in 2015, since the number of weeks reported depends on the interview date
qui gen potential_LF_weeks         = 52-Weeks_Emp_Status_MissingDotV                     if year==2015 & inrange(Interview_date,ym(2015,9),ym(2015,12))
qui gen weeks_employed_prime       = floor(52*(weeks_employed/potential_LF_weeks))       if year==2015 & inrange(Interview_date,ym(2015,9),ym(2015,12))
qui gen weeks_in_labor_force_prime = floor(52*(weeks_in_labor_force/potential_LF_weeks)) if year==2015 & inrange(Interview_date,ym(2015,9),ym(2015,12))
qui gen Weeks_Employed_noID_prime  = floor(52*(Weeks_Employed_noID/potential_LF_weeks))  if year==2015 & inrange(Interview_date,ym(2015,9),ym(2015,12))

replace weeks_employed       = weeks_employed_prime       if year==2015 & inrange(Interview_date,ym(2015,9),ym(2015,12))
replace weeks_in_labor_force = weeks_in_labor_force_prime if year==2015 & inrange(Interview_date,ym(2015,9),ym(2015,12))
replace Weeks_Employed_noID  = Weeks_Employed_noID_prime  if year==2015 & inrange(Interview_date,ym(2015,9),ym(2015,12))


* * * * * * * * * * * * * * * * * * * Need to adjust this for Job 13???

* Hand-code Job 11 information for year 2002 and ID 6337 (the only person to ever report 11 new jobs in one year)
capture noisily drop Hrs_week_Job11_
generat Hrs_week_Job11_ = .v
replace Hrs_week_Job11_ = .n if Hrs_week_Job10_==.n
replace Hrs_week_Job11_ = 40 if ID==6337 & year==2002

* Generate Job 1 ID
foreach x of numlist 1/53 {
    capture noisily drop Job1ID_Week`x'_
    qui gen Job1ID_Week`x'_ = Emp_Status_Week_`x'_ if inrange(Emp_Status_Week_`x'_,7,.)
}

* Check for duplicate multi-job-week Job IDs
foreach x of numlist 1/53 {
    qui replace Job2ID_Week`x'_ = . if Job2ID_Week`x'_==Job1ID_Week`x'_ & ~mi(Job2ID_Week`x'_) & ~mi(Job1ID_Week`x'_)
    qui replace Job3ID_Week`x'_ = . if Job3ID_Week`x'_==Job1ID_Week`x'_ & ~mi(Job3ID_Week`x'_) & ~mi(Job1ID_Week`x'_)
    qui replace Job4ID_Week`x'_ = . if Job4ID_Week`x'_==Job1ID_Week`x'_ & ~mi(Job4ID_Week`x'_) & ~mi(Job1ID_Week`x'_)
    qui replace Job5ID_Week`x'_ = . if Job5ID_Week`x'_==Job1ID_Week`x'_ & ~mi(Job5ID_Week`x'_) & ~mi(Job1ID_Week`x'_)
    qui replace Job6ID_Week`x'_ = . if Job6ID_Week`x'_==Job1ID_Week`x'_ & ~mi(Job6ID_Week`x'_) & ~mi(Job1ID_Week`x'_)
    qui replace Job7ID_Week`x'_ = . if Job7ID_Week`x'_==Job1ID_Week`x'_ & ~mi(Job7ID_Week`x'_) & ~mi(Job1ID_Week`x'_)
    qui replace Job8ID_Week`x'_ = . if Job8ID_Week`x'_==Job1ID_Week`x'_ & ~mi(Job8ID_Week`x'_) & ~mi(Job1ID_Week`x'_)
}

* Get number of primary job switches in a year
local i=2
local j=1
while `i'<=52  {
    gen switch_Job1ID`i' = (Job1ID_Week`i'_ ~= Job1ID_Week`j'_) & ~mi(Job1ID_Week`i'_) & ~mi(Job1ID_Week`j'_)
    local j=`j'+1
    local i=`i'+1
}

egen num_primary_job_switches = rowtotal(switch_Job1ID? switch_Job1ID??)

foreach x of numlist 1/53 {
    * Mono Jobs Weekly Array
    qui gen byte mono_jobs_week`x'  = ~mi(Job1ID_Week`x'_) &  mi(Job2ID_Week`x'_) &  mi(Job3ID_Week`x'_) &  mi(Job4ID_Week`x'_) &  mi(Job5ID_Week`x'_) &  mi(Job6ID_Week`x'_) &  mi(Job7ID_Week`x'_) &  mi(Job8ID_Week`x'_)
    * Dual Jobs Weekly Array
    qui gen byte dual_jobs_week`x'  = ~mi(Job1ID_Week`x'_) & ~mi(Job2ID_Week`x'_) &  mi(Job3ID_Week`x'_) &  mi(Job4ID_Week`x'_) &  mi(Job5ID_Week`x'_) &  mi(Job6ID_Week`x'_) &  mi(Job7ID_Week`x'_) &  mi(Job8ID_Week`x'_)
    * Trio Jobs Weekly Array
    qui gen byte trio_jobs_week`x'  = ~mi(Job1ID_Week`x'_) & ~mi(Job2ID_Week`x'_) & ~mi(Job3ID_Week`x'_) &  mi(Job4ID_Week`x'_) &  mi(Job5ID_Week`x'_) &  mi(Job6ID_Week`x'_) &  mi(Job7ID_Week`x'_) &  mi(Job8ID_Week`x'_)
    * Quad Jobs Weekly Array
    qui gen byte quad_jobs_week`x'  = ~mi(Job1ID_Week`x'_) & ~mi(Job2ID_Week`x'_) & ~mi(Job3ID_Week`x'_) & ~mi(Job4ID_Week`x'_) &  mi(Job5ID_Week`x'_) &  mi(Job6ID_Week`x'_) &  mi(Job7ID_Week`x'_) &  mi(Job8ID_Week`x'_)
    * Five Jobs Weekly Array
    qui gen byte five_jobs_week`x'  = ~mi(Job1ID_Week`x'_) & ~mi(Job2ID_Week`x'_) & ~mi(Job3ID_Week`x'_) & ~mi(Job4ID_Week`x'_) & ~mi(Job5ID_Week`x'_) &  mi(Job6ID_Week`x'_) &  mi(Job7ID_Week`x'_) &  mi(Job8ID_Week`x'_)
    * Six Jobs Weekly Array
    qui gen byte six_jobs_week`x'   = ~mi(Job1ID_Week`x'_) & ~mi(Job2ID_Week`x'_) & ~mi(Job3ID_Week`x'_) & ~mi(Job4ID_Week`x'_) & ~mi(Job5ID_Week`x'_) & ~mi(Job6ID_Week`x'_) &  mi(Job7ID_Week`x'_) &  mi(Job8ID_Week`x'_)
    * Seven Jobs Weekly Array
    qui gen byte seven_jobs_week`x' = ~mi(Job1ID_Week`x'_) & ~mi(Job2ID_Week`x'_) & ~mi(Job3ID_Week`x'_) & ~mi(Job4ID_Week`x'_) & ~mi(Job5ID_Week`x'_) & ~mi(Job6ID_Week`x'_) & ~mi(Job7ID_Week`x'_) &  mi(Job8ID_Week`x'_)
    * Eight Jobs Weekly Array
    qui gen byte eight_jobs_week`x' = ~mi(Job1ID_Week`x'_) & ~mi(Job2ID_Week`x'_) & ~mi(Job3ID_Week`x'_) & ~mi(Job4ID_Week`x'_) & ~mi(Job5ID_Week`x'_) & ~mi(Job6ID_Week`x'_) & ~mi(Job7ID_Week`x'_) & ~mi(Job8ID_Week`x'_)
}

* How many jobs in week x was the person working?
foreach x of numlist 1/53 {
    qui gen byte num_jobs_week`x' = 1*mono_jobs_week`x' + 2*dual_jobs_week`x' + 3*trio_jobs_week`x' + 4*quad_jobs_week`x' + 5*five_jobs_week`x' + 6*six_jobs_week`x' + 7*seven_jobs_week`x' + 8*eight_jobs_week`x'
}

foreach x of numlist 1/53 {
    qui replace num_jobs_week`x' = 0 if Employed_Week_`x'==0
}

* Get number of unique Emp IDs for each person for each year
rowsort Job1ID_Week1_ Job1ID_Week2_ Job1ID_Week3_ Job1ID_Week4_ Job1ID_Week5_ Job1ID_Week6_ Job1ID_Week7_ Job1ID_Week8_ Job1ID_Week9_ Job1ID_Week10_ Job1ID_Week11_ Job1ID_Week12_ Job1ID_Week13_ Job1ID_Week14_ Job1ID_Week15_ Job1ID_Week16_ Job1ID_Week17_ Job1ID_Week18_ Job1ID_Week19_ Job1ID_Week20_ Job1ID_Week21_ Job1ID_Week22_ Job1ID_Week23_ Job1ID_Week24_ Job1ID_Week25_ Job1ID_Week26_ Job1ID_Week27_ Job1ID_Week28_ Job1ID_Week29_ Job1ID_Week30_ Job1ID_Week31_ Job1ID_Week32_ Job1ID_Week33_ Job1ID_Week34_ Job1ID_Week35_ Job1ID_Week36_ Job1ID_Week37_ Job1ID_Week38_ Job1ID_Week39_ Job1ID_Week40_ Job1ID_Week41_ Job1ID_Week42_ Job1ID_Week43_ Job1ID_Week44_ Job1ID_Week45_ Job1ID_Week46_ Job1ID_Week47_ Job1ID_Week48_ Job1ID_Week49_ Job1ID_Week50_ Job1ID_Week51_ Job1ID_Week52_ Job1ID_Week53_ Job2ID_Week1_ Job2ID_Week2_ Job2ID_Week3_ Job2ID_Week4_ Job2ID_Week5_ Job2ID_Week6_ Job2ID_Week7_ Job2ID_Week8_ Job2ID_Week9_ Job2ID_Week10_ Job2ID_Week11_ Job2ID_Week12_ Job2ID_Week13_ Job2ID_Week14_ Job2ID_Week15_ Job2ID_Week16_ Job2ID_Week17_ Job2ID_Week18_ Job2ID_Week19_ Job2ID_Week20_ Job2ID_Week21_ Job2ID_Week22_ Job2ID_Week23_ Job2ID_Week24_ Job2ID_Week25_ Job2ID_Week26_ Job2ID_Week27_ Job2ID_Week28_ Job2ID_Week29_ Job2ID_Week30_ Job2ID_Week31_ Job2ID_Week32_ Job2ID_Week33_ Job2ID_Week34_ Job2ID_Week35_ Job2ID_Week36_ Job2ID_Week37_ Job2ID_Week38_ Job2ID_Week39_ Job2ID_Week40_ Job2ID_Week41_ Job2ID_Week42_ Job2ID_Week43_ Job2ID_Week44_ Job2ID_Week45_ Job2ID_Week46_ Job2ID_Week47_ Job2ID_Week48_ Job2ID_Week49_ Job2ID_Week50_ Job2ID_Week51_ Job2ID_Week52_ Job2ID_Week53_ Job3ID_Week1_ Job3ID_Week2_ Job3ID_Week3_ Job3ID_Week4_ Job3ID_Week5_ Job3ID_Week6_ Job3ID_Week7_ Job3ID_Week8_ Job3ID_Week9_ Job3ID_Week10_ Job3ID_Week11_ Job3ID_Week12_ Job3ID_Week13_ Job3ID_Week14_ Job3ID_Week15_ Job3ID_Week16_ Job3ID_Week17_ Job3ID_Week18_ Job3ID_Week19_ Job3ID_Week20_ Job3ID_Week21_ Job3ID_Week22_ Job3ID_Week23_ Job3ID_Week24_ Job3ID_Week25_ Job3ID_Week26_ Job3ID_Week27_ Job3ID_Week28_ Job3ID_Week29_ Job3ID_Week30_ Job3ID_Week31_ Job3ID_Week32_ Job3ID_Week33_ Job3ID_Week34_ Job3ID_Week35_ Job3ID_Week36_ Job3ID_Week37_ Job3ID_Week38_ Job3ID_Week39_ Job3ID_Week40_ Job3ID_Week41_ Job3ID_Week42_ Job3ID_Week43_ Job3ID_Week44_ Job3ID_Week45_ Job3ID_Week46_ Job3ID_Week47_ Job3ID_Week48_ Job3ID_Week49_ Job3ID_Week50_ Job3ID_Week51_ Job3ID_Week52_ Job3ID_Week53_ Job4ID_Week1_ Job4ID_Week2_ Job4ID_Week3_ Job4ID_Week4_ Job4ID_Week5_ Job4ID_Week6_ Job4ID_Week7_ Job4ID_Week8_ Job4ID_Week9_ Job4ID_Week10_ Job4ID_Week11_ Job4ID_Week12_ Job4ID_Week13_ Job4ID_Week14_ Job4ID_Week15_ Job4ID_Week16_ Job4ID_Week17_ Job4ID_Week18_ Job4ID_Week19_ Job4ID_Week20_ Job4ID_Week21_ Job4ID_Week22_ Job4ID_Week23_ Job4ID_Week24_ Job4ID_Week25_ Job4ID_Week26_ Job4ID_Week27_ Job4ID_Week28_ Job4ID_Week29_ Job4ID_Week30_ Job4ID_Week31_ Job4ID_Week32_ Job4ID_Week33_ Job4ID_Week34_ Job4ID_Week35_ Job4ID_Week36_ Job4ID_Week37_ Job4ID_Week38_ Job4ID_Week39_ Job4ID_Week40_ Job4ID_Week41_ Job4ID_Week42_ Job4ID_Week43_ Job4ID_Week44_ Job4ID_Week45_ Job4ID_Week46_ Job4ID_Week47_ Job4ID_Week48_ Job4ID_Week49_ Job4ID_Week50_ Job4ID_Week51_ Job4ID_Week52_ Job4ID_Week53_ Job5ID_Week1_ Job5ID_Week2_ Job5ID_Week3_ Job5ID_Week4_ Job5ID_Week5_ Job5ID_Week6_ Job5ID_Week7_ Job5ID_Week8_ Job5ID_Week9_ Job5ID_Week10_ Job5ID_Week11_ Job5ID_Week12_ Job5ID_Week13_ Job5ID_Week14_ Job5ID_Week15_ Job5ID_Week16_ Job5ID_Week17_ Job5ID_Week18_ Job5ID_Week19_ Job5ID_Week20_ Job5ID_Week21_ Job5ID_Week22_ Job5ID_Week23_ Job5ID_Week24_ Job5ID_Week25_ Job5ID_Week26_ Job5ID_Week27_ Job5ID_Week28_ Job5ID_Week29_ Job5ID_Week30_ Job5ID_Week31_ Job5ID_Week32_ Job5ID_Week33_ Job5ID_Week34_ Job5ID_Week35_ Job5ID_Week36_ Job5ID_Week37_ Job5ID_Week38_ Job5ID_Week39_ Job5ID_Week40_ Job5ID_Week41_ Job5ID_Week42_ Job5ID_Week43_ Job5ID_Week44_ Job5ID_Week45_ Job5ID_Week46_ Job5ID_Week47_ Job5ID_Week48_ Job5ID_Week49_ Job5ID_Week50_ Job5ID_Week51_ Job5ID_Week52_ Job5ID_Week53_ Job6ID_Week1_ Job6ID_Week2_ Job6ID_Week3_ Job6ID_Week4_ Job6ID_Week5_ Job6ID_Week6_ Job6ID_Week7_ Job6ID_Week8_ Job6ID_Week9_ Job6ID_Week10_ Job6ID_Week11_ Job6ID_Week12_ Job6ID_Week13_ Job6ID_Week14_ Job6ID_Week15_ Job6ID_Week16_ Job6ID_Week17_ Job6ID_Week18_ Job6ID_Week19_ Job6ID_Week20_ Job6ID_Week21_ Job6ID_Week22_ Job6ID_Week23_ Job6ID_Week24_ Job6ID_Week25_ Job6ID_Week26_ Job6ID_Week27_ Job6ID_Week28_ Job6ID_Week29_ Job6ID_Week30_ Job6ID_Week31_ Job6ID_Week32_ Job6ID_Week33_ Job6ID_Week34_ Job6ID_Week35_ Job6ID_Week36_ Job6ID_Week37_ Job6ID_Week38_ Job6ID_Week39_ Job6ID_Week40_ Job6ID_Week41_ Job6ID_Week42_ Job6ID_Week43_ Job6ID_Week44_ Job6ID_Week45_ Job6ID_Week46_ Job6ID_Week47_ Job6ID_Week48_ Job6ID_Week49_ Job6ID_Week50_ Job6ID_Week51_ Job6ID_Week52_ Job6ID_Week53_ Job7ID_Week1_ Job7ID_Week2_ Job7ID_Week3_ Job7ID_Week4_ Job7ID_Week5_ Job7ID_Week6_ Job7ID_Week7_ Job7ID_Week8_ Job7ID_Week9_ Job7ID_Week10_ Job7ID_Week11_ Job7ID_Week12_ Job7ID_Week13_ Job7ID_Week14_ Job7ID_Week15_ Job7ID_Week16_ Job7ID_Week17_ Job7ID_Week18_ Job7ID_Week19_ Job7ID_Week20_ Job7ID_Week21_ Job7ID_Week22_ Job7ID_Week23_ Job7ID_Week24_ Job7ID_Week25_ Job7ID_Week26_ Job7ID_Week27_ Job7ID_Week28_ Job7ID_Week29_ Job7ID_Week30_ Job7ID_Week31_ Job7ID_Week32_ Job7ID_Week33_ Job7ID_Week34_ Job7ID_Week35_ Job7ID_Week36_ Job7ID_Week37_ Job7ID_Week38_ Job7ID_Week39_ Job7ID_Week40_ Job7ID_Week41_ Job7ID_Week42_ Job7ID_Week43_ Job7ID_Week44_ Job7ID_Week45_ Job7ID_Week46_ Job7ID_Week47_ Job7ID_Week48_ Job7ID_Week49_ Job7ID_Week50_ Job7ID_Week51_ Job7ID_Week52_ Job7ID_Week53_ Job8ID_Week1_ Job8ID_Week2_ Job8ID_Week3_ Job8ID_Week4_ Job8ID_Week5_ Job8ID_Week6_ Job8ID_Week7_ Job8ID_Week8_ Job8ID_Week9_ Job8ID_Week10_ Job8ID_Week11_ Job8ID_Week12_ Job8ID_Week13_ Job8ID_Week14_ Job8ID_Week15_ Job8ID_Week16_ Job8ID_Week17_ Job8ID_Week18_ Job8ID_Week19_ Job8ID_Week20_ Job8ID_Week21_ Job8ID_Week22_ Job8ID_Week23_ Job8ID_Week24_ Job8ID_Week25_ Job8ID_Week26_ Job8ID_Week27_ Job8ID_Week28_ Job8ID_Week29_ Job8ID_Week30_ Job8ID_Week31_ Job8ID_Week32_ Job8ID_Week33_ Job8ID_Week34_ Job8ID_Week35_ Job8ID_Week36_ Job8ID_Week37_ Job8ID_Week38_ Job8ID_Week39_ Job8ID_Week40_ Job8ID_Week41_ Job8ID_Week42_ Job8ID_Week43_ Job8ID_Week44_ Job8ID_Week45_ Job8ID_Week46_ Job8ID_Week47_ Job8ID_Week48_ Job8ID_Week49_ Job8ID_Week50_ Job8ID_Week51_ Job8ID_Week52_ Job8ID_Week53_, generate(s1-s424)

* This loop generates a dummy for how many times the EmpID changed in a given year
local i=2
local j=1
while `i'<=424  {
    gen byte new_emp_week`i' = (s`i' ~= s`j') & ~mi(s`i') & ~mi(s`j')
    local j=`j'+1
    local i=`i'+1
}

egen total_employers = rowtotal(new_emp_week? new_emp_week?? new_emp_week???)
replace total_employers = total_employers+1 if ~mi(s1) & new_emp_week2==0

* Create employer-week job array
forvalues x=1/53 {
    forvalues Y = 1/13 {
        qui gen byte employed_Job`Y'_week`x' = ((Job1ID_Week`x'_==Emp`Y'_ID & ~mi(Job1ID_Week`x'_)) + (Job2ID_Week`x'_==Emp`Y'_ID & ~mi(Job2ID_Week`x'_)) + (Job3ID_Week`x'_==Emp`Y'_ID & ~mi(Job3ID_Week`x'_)) + (Job4ID_Week`x'_==Emp`Y'_ID & ~mi(Job4ID_Week`x'_)) + (Job5ID_Week`x'_==Emp`Y'_ID & ~mi(Job5ID_Week`x'_)) + (Job6ID_Week`x'_==Emp`Y'_ID & ~mi(Job6ID_Week`x'_)) + (Job7ID_Week`x'_==Emp`Y'_ID & ~mi(Job7ID_Week`x'_)) + (Job8ID_Week`x'_==Emp`Y'_ID & ~mi(Job8ID_Week`x'_)) >= 1)
    }
}
* Get Weeks worked per job
forvalues Y=1/13 {
    gen byte weeks_employed_Job`Y' = 0
    forvalues x = 1/53 {
        qui replace weeks_employed_Job`Y' = weeks_employed_Job`Y' + (Job1ID_Week`x'_==Emp`Y'_ID & ~mi(Job1ID_Week`x'_)) + (Job2ID_Week`x'_==Emp`Y'_ID & ~mi(Job2ID_Week`x'_)) + (Job3ID_Week`x'_==Emp`Y'_ID & ~mi(Job3ID_Week`x'_)) + (Job4ID_Week`x'_==Emp`Y'_ID & ~mi(Job4ID_Week`x'_)) + (Job5ID_Week`x'_==Emp`Y'_ID & ~mi(Job5ID_Week`x'_)) + (Job6ID_Week`x'_==Emp`Y'_ID & ~mi(Job6ID_Week`x'_)) + (Job7ID_Week`x'_==Emp`Y'_ID & ~mi(Job7ID_Week`x'_)) + (Job8ID_Week`x'_==Emp`Y'_ID & ~mi(Job8ID_Week`x'_))
    }
}
* Create Weekly Wage Array
forvalues x=1/53 {
    forvalues Y = 1/13 {
        qui generat wage_bill_week`x'_`Y' = Hrly_wage_Job`Y'_*employed_Job`Y'_week`x'*Hrs_week_Job`Y'_
        qui generat comp_bill_week`x'_`Y' = Hrly_comp_Job`Y'_*employed_Job`Y'_week`x'*Hrs_week_Job`Y'_
    }
}
forvalues x=1/53 {
    forvalues Y = 1/13 {
        qui generat total_hrs_week`x'_`Y' = employed_Job`Y'_week`x'*Hrs_week_Job`Y'_
    }
}
forvalues x=1/53 {
    egen wage_num_week`x' = rowtotal(wage_bill_week`x'_1 wage_bill_week`x'_2 wage_bill_week`x'_3 wage_bill_week`x'_4 wage_bill_week`x'_5 wage_bill_week`x'_6 wage_bill_week`x'_7 wage_bill_week`x'_8 wage_bill_week`x'_9 wage_bill_week`x'_10 wage_bill_week`x'_11)
    egen comp_num_week`x' = rowtotal(comp_bill_week`x'_1 comp_bill_week`x'_2 comp_bill_week`x'_3 comp_bill_week`x'_4 comp_bill_week`x'_5 comp_bill_week`x'_6 comp_bill_week`x'_7 comp_bill_week`x'_8 comp_bill_week`x'_9 comp_bill_week`x'_10 comp_bill_week`x'_11)
}
forvalues x=1/53 {
    egen wage_dem_week`x' = rowtotal(total_hrs_week`x'_1 total_hrs_week`x'_2 total_hrs_week`x'_3 total_hrs_week`x'_4 total_hrs_week`x'_5 total_hrs_week`x'_6 total_hrs_week`x'_7 total_hrs_week`x'_8 total_hrs_week`x'_9 total_hrs_week`x'_10 total_hrs_week`x'_11)
    egen comp_dem_week`x' = rowtotal(total_hrs_week`x'_1 total_hrs_week`x'_2 total_hrs_week`x'_3 total_hrs_week`x'_4 total_hrs_week`x'_5 total_hrs_week`x'_6 total_hrs_week`x'_7 total_hrs_week`x'_8 total_hrs_week`x'_9 total_hrs_week`x'_10 total_hrs_week`x'_11)
}
forvalues x=1/53 {
    gen wage_week`x' = wage_num_week`x'/wage_dem_week`x'
    gen comp_week`x' = comp_num_week`x'/comp_dem_week`x'
}

forvalues x=1/53 {
    gen wagerWeek`x'=.z
    gen comprWeek`x'=.z
    * First, rely on the job reported in 'Emp_Status_Week_X_'
    forvalues y = 1/13 {
        qui replace wagerWeek`x' = Hrly_wage_Job`y'_  if mi(wagerWeek`x') & ~mi(Hrly_wage_Job`y'_) & ~mi(Emp`y'_ID) & Emp_Status_Week_`x'_==Emp`y'_ID
        qui replace comprWeek`x' = Hrly_comp_Job`y'_  if mi(comprWeek`x') & ~mi(Hrly_comp_Job`y'_) & ~mi(Emp`y'_ID) & Emp_Status_Week_`x'_==Emp`y'_ID
    }
    * If there is no valid wage or job in that array, attempt to find any 
    *  other valid wage from the job_number2X-job_number5X arrays
    forvalues y = 1/13 {
        qui replace wagerWeek`x' = Hrly_wage_Job`y'_ if mi(wagerWeek`x') & ~mi(Hrly_wage_Job`y'_) & ~mi(Emp`y'_ID) & (Job2ID_Week`x'_==Emp`y'_ID | Job3ID_Week`x'_==Emp`y'_ID | Job4ID_Week`x'_==Emp`y'_ID | Job5ID_Week`x'_==Emp`y'_ID | Job6ID_Week`x'_==Emp`y'_ID | Job7ID_Week`x'_==Emp`y'_ID | Job8ID_Week`x'_==Emp`y'_ID )
        qui replace comprWeek`x' = Hrly_comp_Job`y'_ if mi(comprWeek`x') & ~mi(Hrly_comp_Job`y'_) & ~mi(Emp`y'_ID) & (Job2ID_Week`x'_==Emp`y'_ID | Job3ID_Week`x'_==Emp`y'_ID | Job4ID_Week`x'_==Emp`y'_ID | Job5ID_Week`x'_==Emp`y'_ID | Job6ID_Week`x'_==Emp`y'_ID | Job7ID_Week`x'_==Emp`y'_ID | Job8ID_Week`x'_==Emp`y'_ID )
    }
}

drop wage_bill_week*
drop comp_bill_week*

egen mostWeeksEmployed = rowmax(weeks_employed_Job? weeks_employed_Job??)

* Create an Annual Wage (based on mean across jobs, median across jobs, min across jobs and max across jobs)
forvalues Y=1/13 {
    qui generat temp_comp`Y' = Hrly_comp_Job`Y'_*weeks_employed_Job`Y'
    qui generat temp_wage`Y' = Hrly_wage_Job`Y'_*weeks_employed_Job`Y'
}
forvalues Y=1/13 {
    qui generat temp_denom_comp_week`Y' = (~mi(Hrly_comp_Job`Y'_))*weeks_employed_Job`Y'
    qui generat temp_denom_wage_week`Y' = (~mi(Hrly_wage_Job`Y'_))*weeks_employed_Job`Y'
}
egen temp_numer_wage  = rowtotal(temp_wage? temp_wage??)
egen temp_numer_comp  = rowtotal(temp_comp? temp_comp??)
egen temp_denom_wage  = rowtotal(temp_denom_wage_week? temp_denom_wage_week??)
egen temp_denom_comp  = rowtotal(temp_denom_comp_week? temp_denom_comp_week??)
gen  annual_mean_wage = temp_numer_wage/temp_denom_wage
gen  annual_mean_comp = temp_numer_comp/temp_denom_comp
drop temp_wage* temp_comp* temp_denom* temp_numer*

*egen annual_mean_wage = rowmean(Hrly_wage_Job1_ Hrly_wage_Job2_ Hrly_wage_Job3_ Hrly_wage_Job4_ Hrly_wage_Job5_ Hrly_wage_Job6_ Hrly_wage_Job7_ Hrly_wage_Job8_ Hrly_wage_Job9_ Hrly_wage_Job10_ Hrly_wage_Job11_ Hrly_wage_Job12_ Hrly_wage_Job13_ Hrly_comp_Job1_ Hrly_comp_Job2_ Hrly_comp_Job3_ Hrly_comp_Job4_ Hrly_comp_Job5_ Hrly_comp_Job6_ Hrly_comp_Job7_ Hrly_comp_Job8_ Hrly_comp_Job9_ Hrly_comp_Job10_ Hrly_comp_Job11_ Hrly_comp_Job12_ Hrly_comp_Job13_)
egen annual_median_wage     = rowmedian(Hrly_wage_Job1_ Hrly_wage_Job2_ Hrly_wage_Job3_ Hrly_wage_Job4_ Hrly_wage_Job5_ Hrly_wage_Job6_ Hrly_wage_Job7_ Hrly_wage_Job8_ Hrly_wage_Job9_ Hrly_wage_Job10_ Hrly_wage_Job11_ Hrly_wage_Job12_ Hrly_wage_Job13_ )
egen annual_median_comp     = rowmedian(Hrly_comp_Job1_ Hrly_comp_Job2_ Hrly_comp_Job3_ Hrly_comp_Job4_ Hrly_comp_Job5_ Hrly_comp_Job6_ Hrly_comp_Job7_ Hrly_comp_Job8_ Hrly_comp_Job9_ Hrly_comp_Job10_ Hrly_comp_Job11_ Hrly_comp_Job12_ Hrly_comp_Job13_ )
egen annual_least_wage      = rowmin   (Hrly_wage_Job1_ Hrly_wage_Job2_ Hrly_wage_Job3_ Hrly_wage_Job4_ Hrly_wage_Job5_ Hrly_wage_Job6_ Hrly_wage_Job7_ Hrly_wage_Job8_ Hrly_wage_Job9_ Hrly_wage_Job10_ Hrly_wage_Job11_ Hrly_wage_Job12_ Hrly_wage_Job13_ )
egen annual_least_comp      = rowmin   (Hrly_comp_Job1_ Hrly_comp_Job2_ Hrly_comp_Job3_ Hrly_comp_Job4_ Hrly_comp_Job5_ Hrly_comp_Job6_ Hrly_comp_Job7_ Hrly_comp_Job8_ Hrly_comp_Job9_ Hrly_comp_Job10_ Hrly_comp_Job11_ Hrly_comp_Job12_ Hrly_comp_Job13_ )
egen annual_most_wage       = rowmax   (Hrly_wage_Job1_ Hrly_wage_Job2_ Hrly_wage_Job3_ Hrly_wage_Job4_ Hrly_wage_Job5_ Hrly_wage_Job6_ Hrly_wage_Job7_ Hrly_wage_Job8_ Hrly_wage_Job9_ Hrly_wage_Job10_ Hrly_wage_Job11_ Hrly_wage_Job12_ Hrly_wage_Job13_ )
egen annual_most_comp       = rowmax   (Hrly_comp_Job1_ Hrly_comp_Job2_ Hrly_comp_Job3_ Hrly_comp_Job4_ Hrly_comp_Job5_ Hrly_comp_Job6_ Hrly_comp_Job7_ Hrly_comp_Job8_ Hrly_comp_Job9_ Hrly_comp_Job10_ Hrly_comp_Job11_ Hrly_comp_Job12_ Hrly_comp_Job13_ )
gen annual_first_valid_wage = .n
gen annual_first_valid_comp = .n
gen annual_main_wage        = .n
gen annual_main_comp        = .n

forvalues Y=1/13 {
    qui replace annual_first_valid_comp = Hrly_comp_Job`Y'_ if ~mi(Hrly_comp_Job`Y'_) & mi(annual_first_valid_comp)
    qui replace annual_first_valid_wage = Hrly_wage_Job`Y'_ if ~mi(Hrly_wage_Job`Y'_) & mi(annual_first_valid_wage)
    
    qui replace annual_main_comp = Hrly_comp_Job`Y'_ if weeks_employed_Job`Y' == mostWeeksEmployed & ~mi(weeks_employed_Job`Y')
    qui replace annual_main_wage = Hrly_wage_Job`Y'_ if weeks_employed_Job`Y' == mostWeeksEmployed & ~mi(weeks_employed_Job`Y')
}

*-----------------------------------------
* Create an Annual Industry and Occupation (based on argmedian across jobs, argmin across jobs and argmax across jobs)
*-----------------------------------------
gen annual_industry_median        = .
gen annual_industry_min           = .
gen annual_industry_max           = .
gen annual_industry_main          = .
gen annual_industry_first_valid   = .
gen annual_occupation_median      = .
gen annual_occupation_min         = .
gen annual_occupation_max         = .
gen annual_occupation_main        = .
gen annual_occupation_first_valid = .
gen internship_min                = .
gen internship_max                = .
gen internship_main               = .
gen internship_first_valid        = .

foreach x of numlist 13(-1)1 {
    replace annual_industry_median      = Job`x'_Industry if Hrly_wage_Job`x'_==annual_median_wage | Hrly_comp_Job`x'_==annual_median_comp
}
foreach x of numlist 13(-1)1 {
    replace annual_industry_min         = Job`x'_Industry if Hrly_wage_Job`x'_==annual_least_wage | Hrly_comp_Job`x'_==annual_least_comp
}
foreach x of numlist 13(-1)1 {
    replace annual_industry_max         = Job`x'_Industry if Hrly_wage_Job`x'_==annual_most_wage | Hrly_comp_Job`x'_==annual_most_comp
}
foreach x of numlist 13(-1)1 {
    replace annual_industry_main        = Job`x'_Industry if Hrly_wage_Job`x'_==annual_main_wage | Hrly_comp_Job`x'_==annual_main_comp
}
foreach x of numlist 13(-1)1 {
    replace annual_industry_first_valid = Job`x'_Industry if Hrly_wage_Job`x'_==annual_first_valid_wage | Hrly_comp_Job`x'_==annual_first_valid_comp
}

foreach x of numlist 13(-1)1 {
    replace annual_occupation_median      = Job`x'_Occupation if Hrly_wage_Job`x'_==annual_median_wage | Hrly_comp_Job`x'_==annual_median_comp
}
foreach x of numlist 13(-1)1 {
    replace annual_occupation_min         = Job`x'_Occupation if Hrly_wage_Job`x'_==annual_least_wage | Hrly_comp_Job`x'_==annual_least_comp
}
foreach x of numlist 13(-1)1 {
    replace annual_occupation_max         = Job`x'_Occupation if Hrly_wage_Job`x'_==annual_most_wage | Hrly_comp_Job`x'_==annual_most_comp
}
foreach x of numlist 13(-1)1 {
    replace annual_occupation_main        = Job`x'_Occupation if Hrly_wage_Job`x'_==annual_main_wage | Hrly_comp_Job`x'_==annual_main_comp
}
foreach x of numlist 13(-1)1 {
    replace annual_occupation_first_valid = Job`x'_Occupation if Hrly_wage_Job`x'_==annual_first_valid_wage | Hrly_comp_Job`x'_==annual_first_valid_comp
}


foreach x of numlist 13(-1)1 {
    replace internship_min = Job`x'_Internship if Hrly_wage_Job`x'_==annual_least_wage | Hrly_comp_Job`x'_==annual_least_comp
}
foreach x of numlist 13(-1)1 {
    replace internship_max = Job`x'_Internship if Hrly_wage_Job`x'_==annual_most_wage | Hrly_comp_Job`x'_==annual_most_comp
}
foreach x of numlist 13(-1)1 {
    replace internship_main = Job`x'_Internship if Hrly_wage_Job`x'_==annual_main_wage | Hrly_comp_Job`x'_==annual_main_comp
}
foreach x of numlist 13(-1)1 {
    replace internship_first_valid = Job`x'_Internship if Hrly_wage_Job`x'_==annual_first_valid_wage | Hrly_comp_Job`x'_==annual_first_valid_comp
}

gen internship = (Job1_Internship==1 | Job2_Internship==1 | Job3_Internship==1 | Job4_Internship==1 | Job5_Internship==1 | Job6_Internship==1 | Job7_Internship==1 | Job8_Internship==1 | Job9_Internship==1 | Job10_Internship==1 | Job11_Internship==1 | Job12_Internship==1 | Job13_Internship==1)

replace annual_occupation_median = annual_occupation_max if annual_occupation_min==annual_occupation_max
replace annual_industry_median   = annual_industry_max if annual_industry_min==annual_industry_max


* Create categorical variables for industries and occupations at highest level of aggregation
gen annual_occ_min         = .
gen annual_occ_median      = .
gen annual_occ_max         = .
gen annual_occ_main        = .
gen annual_occ_first_valid = .

local types = "min median max main first_valid"

foreach x of local types {
    qui replace annual_occ_`x' = 1  if inrange(annual_occupation_`x',  10,950 )
    qui replace annual_occ_`x' = 2  if inrange(annual_occupation_`x',1000,1960)
    qui replace annual_occ_`x' = 3  if inrange(annual_occupation_`x',2000,2960)
    qui replace annual_occ_`x' = 4  if inrange(annual_occupation_`x',3000,3950)
    qui replace annual_occ_`x' = 5  if inrange(annual_occupation_`x',4000,4960)
    qui replace annual_occ_`x' = 6  if inrange(annual_occupation_`x',5000,5930)
    qui replace annual_occ_`x' = 7  if inrange(annual_occupation_`x',6000,6940)
    qui replace annual_occ_`x' = 8  if inrange(annual_occupation_`x',7000,7850)
    qui replace annual_occ_`x' = 9  if inrange(annual_occupation_`x',7900,8960)
    qui replace annual_occ_`x' = 10 if inrange(annual_occupation_`x',9000,9990)
}

lab def vlOccupations 1 "EXECUTIVE AND MANAGEMENT" 2 "MATH, COMPUTER, ENGINEERING, PHYSICAL & SOCIAL SCIENTISTS" 3 "COUNSELORS, LAWYERS, TEACHERS, ENTERTAINERS, MEDIA WORKERS" 4 "HEALTH CARE AND PROTECTIVE SERVICES" 5 "FOOD PREP, CLEANING, PERSONAL CARE, SALES" 6 "OFFICE AND ADMINISTRATIVE SUPPORT WORKERS" 7 "FARMING, FISHING, FORESTRY AND CONSTRUCTION" 8 "INSTALLATION, MAINTENANCE, PRODUCTION, FOOD PREP" 9 "SETTER, OPERATORS, TENDERS" 10 "TRANSPORTATION/MATERIAL MOVERS, MILITARY, SPECIAL CODES"

lab val annual_occ_min vlOccupations
lab val annual_occ_median vlOccupations
lab val annual_occ_max vlOccupations

gen annual_ind_min = .
gen annual_ind_median = .
gen annual_ind_max = .
gen annual_ind_main = .
gen annual_ind_first_valid = .

foreach x of local types {
    qui replace annual_ind_`x' = 1  if inrange(annual_industry_`x', 170,770 )
    qui replace annual_ind_`x' = 2  if inrange(annual_industry_`x',1070,3990)
    qui replace annual_ind_`x' = 3  if inrange(annual_industry_`x',4070,5790)
    qui replace annual_ind_`x' = 4  if inrange(annual_industry_`x',5890,5890)
    qui replace annual_ind_`x' = 5  if inrange(annual_industry_`x',6070,6780)
    qui replace annual_ind_`x' = 6  if inrange(annual_industry_`x',6870,7190)
    qui replace annual_ind_`x' = 7  if inrange(annual_industry_`x',7270,7790)
    qui replace annual_ind_`x' = 8  if inrange(annual_industry_`x',7860,8470)
    qui replace annual_ind_`x' = 9  if inrange(annual_industry_`x',8560,9290)
    qui replace annual_ind_`x' = 10 if inrange(annual_industry_`x',9370,9990)
}

lab def vlIndustries 1 "AGRICULTURE, FORESTRY, FISHING, MINING, UTILITIES, CONSTRUCTION" 2 "MANUFACTURING" 3 "WHOLESALE & RETAIL TRADE" 4 "ARTS, ENTERTAINMENT AND RECREATION SERVICES" 5 "TRANSPORTATION, WAREHOUSING, INFORMATION AND COMMUNICATION" 6 "FIRE" 7 "PROFESSIONAL AND RELATED SERVICES" 8 "EDUCATIONAL, HEALTH, AND SOCIAL SERVICES" 9 "ENTERTAINMENT, ACCOMODATIONS, AND FOOD & OTHER SERVICES" 10 "PUBLIC ADMINISTRATION, MILITARY & SPECIAL CODES"
lab val annual_ind_min vlIndustries
lab val annual_ind_median vlIndustries
lab val annual_ind_max vlIndustries

codebook annual_occ_* annual_ind_*

/*-----------------------------------------*\
| Hours per week at various jobs            |
\*-----------------------------------------*/
egen total_hours_week           = rowtotal(Hrs_week_Job?_ Hrs_week_Job??_), missing
egen avg_hours_week_across_jobs = rowmean (Hrs_week_Job?_ Hrs_week_Job??_)

/*-----------------------------------------*\
| Length of employment (longest job)        |
\*-----------------------------------------*/
* egen longest_job  = rowmax(Emp1_length_weeks_rounded Emp2_length_weeks_rounded Emp3_length_weeks_rounded Emp4_length_weeks_rounded Emp5_length_weeks_rounded Emp6_length_weeks_rounded Emp7_length_weeks_rounded Emp8_length_weeks_rounded Emp9_length_weeks_rounded Emp10_length_weeks_rounded Emp11_length_weeks_rounded)
* egen shortest_job = rowmin(Emp1_length_weeks_rounded Emp2_length_weeks_rounded Emp3_length_weeks_rounded Emp4_length_weeks_rounded Emp5_length_weeks_rounded Emp6_length_weeks_rounded Emp7_length_weeks_rounded Emp8_length_weeks_rounded Emp9_length_weeks_rounded Emp10_length_weeks_rounded Emp11_length_weeks_rounded)

/*-----------------------------------------*\
| Hours per week for each year              |
\*-----------------------------------------*/
* main variable is CVC_HOURS_WK_YR_ALL -- total hours worked in the year across all jobs
egen    Hrs_worked_tot           = rowtotal(Hours_week1_ Hours_week2_ Hours_week3_ Hours_week4_ Hours_week5_ Hours_week6_ Hours_week7_ Hours_week8_ Hours_week9_ Hours_week10_ Hours_week11_ Hours_week12_ Hours_week13_ Hours_week14_ Hours_week15_ Hours_week16_ Hours_week17_ Hours_week18_ Hours_week19_ Hours_week20_ Hours_week21_ Hours_week22_ Hours_week23_ Hours_week24_ Hours_week25_ Hours_week26_ Hours_week27_ Hours_week28_ Hours_week29_ Hours_week30_ Hours_week31_ Hours_week32_ Hours_week33_ Hours_week34_ Hours_week35_ Hours_week36_ Hours_week37_ Hours_week38_ Hours_week39_ Hours_week40_ Hours_week41_ Hours_week42_ Hours_week43_ Hours_week44_ Hours_week45_ Hours_week46_ Hours_week47_ Hours_week48_ Hours_week49_ Hours_week50_ Hours_week51_ Hours_week52_ Hours_week53_)
qui gen Hrs_worked_tot_prime     = floor(52*(Hrs_worked_tot/potential_LF_weeks))     if year==2015 & inrange(Interview_date,ym(2015,9),ym(2015,12))
replace Hrs_worked_tot           = Hrs_worked_tot_prime                              if year==2015 & inrange(Interview_date,ym(2015,9),ym(2015,12))
generat Created_Hours_Worked     = Total_Hours_Worked                                                                                              // this creates an identical variable to the BLS-created annual hours worked for comparison purposes
qui gen Total_Hours_Worked_prime = floor(52*(Total_Hours_Worked/potential_LF_weeks)) if year==2015 & inrange(Interview_date,ym(2015,9),ym(2015,12))
replace Total_Hours_Worked       = Total_Hours_Worked_prime                          if year==2015 & inrange(Interview_date,ym(2015,9),ym(2015,12))
replace Total_Hours_Worked       = Hrs_worked_tot                                    if mi(Total_Hours_Worked) | Total_Hours_Worked==0              // replace the created annual hours worked with the sum of the reported weekly hours worked if the created one is missing
replace Total_Hours_Worked       = 5000                                              if Total_Hours_Worked>5000 & ~mi(Total_Hours_Worked)

* Annual Hours from weekly job and hours per week at job, using dual job info
gen annualHrsWrkCalcCalc = 0
forvalues Y = 1/13 {
    generat Hrs_week_alt_Job`Y'_ = Hrs_week_Job`Y'_
    replace Hrs_week_alt_Job`Y'_ = 0 if mi(Hrs_week_Job`Y'_)
    replace annualHrsWrkCalcCalc = annualHrsWrkCalcCalc + weeks_employed_Job`Y'*Hrs_week_alt_Job`Y'_
}

forvalues x = 1/53 {
    egen HrsWrkCalcCalc_week`x' = rowtotal(total_hrs_week`x'_1 total_hrs_week`x'_2 total_hrs_week`x'_3 total_hrs_week`x'_4 total_hrs_week`x'_5 total_hrs_week`x'_6 total_hrs_week`x'_7 total_hrs_week`x'_8 total_hrs_week`x'_9 total_hrs_week`x'_10 total_hrs_week`x'_11)
}

forvalues x = 1/53 {
    generat hours_week_use`x' = max(HrsWrkCalcCalc_week`x',Hours_week`x'_) if ~mi(Hours_week`x'_)
    replace hours_week_use`x' = HrsWrkCalcCalc_week`x'                     if  mi(Hours_week`x'_)
    replace hours_week_use`x' = 160                                        if inrange(hours_week_use`x',160,.)
}

generat annualHrsWrkUse = max(annualHrsWrkCalcCalc,Hrs_worked_tot,Created_Hours_Worked) if ~mi(Created_Hours_Worked)
replace annualHrsWrkUse = max(annualHrsWrkCalcCalc,Hrs_worked_tot)                      if  mi(Created_Hours_Worked)

generat Total_Hours_Worked_Old = Total_Hours_Worked
replace Total_Hours_Worked     = annualHrsWrkUse

genera Avg_hrs_worked = Total_Hours_Worked/weeks_employed
recode Avg_hrs_worked (. = 0)


/*-----------------------------------------*\
| Get the Primary Activity for each person  |
\*-----------------------------------------*/
lab def vlprimact 1 "School Only" 2 "School and PT" 3 "Part-Time Work" 4 "Full-Time Work" 5 "Military" 6 "Other Act." 7 "Miss Interview"

/*-------------------------*\
| Monthly stuff to get:     |
|                           |
| school enrollment status  |
| military participation    |
| weeks worked              |
| hours worked              |
| wage                      |
| graduation status         |
\*-------------------------*/
gen byte num_weeks_Jan = 4
gen byte num_weeks_Feb = 4
gen byte num_weeks_Mar = 5
gen byte num_weeks_Apr = 4
gen byte num_weeks_May = 5
gen byte num_weeks_Jun = 4
gen byte num_weeks_Jul = 5
gen byte num_weeks_Aug = 4
gen byte num_weeks_Sep = 4
gen byte num_weeks_Oct = 5
gen byte num_weeks_Nov = 4
gen byte num_weeks_Dec = 4
replace  num_weeks_Dec = 5 if inlist(year,1994,2000,2005,2011,2016)

egen byte weeks_worked_Jan = rowtotal(Employed_Week_1  Employed_Week_2  Employed_Week_3  Employed_Week_4                  )
egen byte weeks_worked_Feb = rowtotal(Employed_Week_5  Employed_Week_6  Employed_Week_7  Employed_Week_8                  )
egen byte weeks_worked_Mar = rowtotal(Employed_Week_9  Employed_Week_10 Employed_Week_11 Employed_Week_12 Employed_Week_13)
egen byte weeks_worked_Apr = rowtotal(Employed_Week_14 Employed_Week_15 Employed_Week_16 Employed_Week_17                 )
egen byte weeks_worked_May = rowtotal(Employed_Week_18 Employed_Week_19 Employed_Week_20 Employed_Week_21 Employed_Week_22)
egen byte weeks_worked_Jun = rowtotal(Employed_Week_23 Employed_Week_24 Employed_Week_25 Employed_Week_26                 )
egen byte weeks_worked_Jul = rowtotal(Employed_Week_27 Employed_Week_28 Employed_Week_29 Employed_Week_30 Employed_Week_31)
egen byte weeks_worked_Aug = rowtotal(Employed_Week_32 Employed_Week_33 Employed_Week_34 Employed_Week_35                 )
egen byte weeks_worked_Sep = rowtotal(Employed_Week_36 Employed_Week_37 Employed_Week_38 Employed_Week_39                 )
egen byte weeks_worked_Oct = rowtotal(Employed_Week_40 Employed_Week_41 Employed_Week_42 Employed_Week_43 Employed_Week_44)
egen byte weeks_worked_Nov = rowtotal(Employed_Week_45 Employed_Week_46 Employed_Week_47 Employed_Week_48                 )
egen byte weeks_worked_Dec = rowtotal(Employed_Week_49 Employed_Week_50 Employed_Week_51 Employed_Week_52 Employed_Week_53)

egen hours_worked_Jan = rowtotal(hours_week_use1  hours_week_use2  hours_week_use3  hours_week_use4                  )
egen hours_worked_Feb = rowtotal(hours_week_use5  hours_week_use6  hours_week_use7  hours_week_use8                  )
egen hours_worked_Mar = rowtotal(hours_week_use9  hours_week_use10 hours_week_use11 hours_week_use12 hours_week_use13)
egen hours_worked_Apr = rowtotal(hours_week_use14 hours_week_use15 hours_week_use16 hours_week_use17                 )
egen hours_worked_May = rowtotal(hours_week_use18 hours_week_use19 hours_week_use20 hours_week_use21 hours_week_use22)
egen hours_worked_Jun = rowtotal(hours_week_use23 hours_week_use24 hours_week_use25 hours_week_use26                 )
egen hours_worked_Jul = rowtotal(hours_week_use27 hours_week_use28 hours_week_use29 hours_week_use30 hours_week_use31)
egen hours_worked_Aug = rowtotal(hours_week_use32 hours_week_use33 hours_week_use34 hours_week_use35                 )
egen hours_worked_Sep = rowtotal(hours_week_use36 hours_week_use37 hours_week_use38 hours_week_use39                 )
egen hours_worked_Oct = rowtotal(hours_week_use40 hours_week_use41 hours_week_use42 hours_week_use43 hours_week_use44)
egen hours_worked_Nov = rowtotal(hours_week_use45 hours_week_use46 hours_week_use47 hours_week_use48                 )
egen hours_worked_Dec = rowtotal(hours_week_use49 hours_week_use50 hours_week_use51 hours_week_use52 hours_week_use53)

egen wageJan = rowmean(wage_week1  wage_week2  wage_week3  wage_week4             )
egen wageFeb = rowmean(wage_week5  wage_week6  wage_week7  wage_week8             )
egen wageMar = rowmean(wage_week9  wage_week10 wage_week11 wage_week12 wage_week13)
egen wageApr = rowmean(wage_week14 wage_week15 wage_week16 wage_week17            )
egen wageMay = rowmean(wage_week18 wage_week19 wage_week20 wage_week21 wage_week22)
egen wageJun = rowmean(wage_week23 wage_week24 wage_week25 wage_week26            )
egen wageJul = rowmean(wage_week27 wage_week28 wage_week29 wage_week30 wage_week31)
egen wageAug = rowmean(wage_week32 wage_week33 wage_week34 wage_week35            )
egen wageSep = rowmean(wage_week36 wage_week37 wage_week38 wage_week39            )
egen wageOct = rowmean(wage_week40 wage_week41 wage_week42 wage_week43 wage_week44)
egen wageNov = rowmean(wage_week45 wage_week46 wage_week47 wage_week48            )
egen wageDec = rowmean(wage_week49 wage_week50 wage_week51 wage_week52 wage_week53)

egen wageMedianJan = rowmedian(wage_week1  wage_week2  wage_week3  wage_week4             )
egen wageMedianFeb = rowmedian(wage_week5  wage_week6  wage_week7  wage_week8             )
egen wageMedianMar = rowmedian(wage_week9  wage_week10 wage_week11 wage_week12 wage_week13)
egen wageMedianApr = rowmedian(wage_week14 wage_week15 wage_week16 wage_week17            )
egen wageMedianMay = rowmedian(wage_week18 wage_week19 wage_week20 wage_week21 wage_week22)
egen wageMedianJun = rowmedian(wage_week23 wage_week24 wage_week25 wage_week26            )
egen wageMedianJul = rowmedian(wage_week27 wage_week28 wage_week29 wage_week30 wage_week31)
egen wageMedianAug = rowmedian(wage_week32 wage_week33 wage_week34 wage_week35            )
egen wageMedianSep = rowmedian(wage_week36 wage_week37 wage_week38 wage_week39            )
egen wageMedianOct = rowmedian(wage_week40 wage_week41 wage_week42 wage_week43 wage_week44)
egen wageMedianNov = rowmedian(wage_week45 wage_week46 wage_week47 wage_week48            )
egen wageMedianDec = rowmedian(wage_week49 wage_week50 wage_week51 wage_week52 wage_week53)

egen wageAltJan = rowmean(wagerWeek1  wagerWeek2  wagerWeek3  wagerWeek4             )
egen wageAltFeb = rowmean(wagerWeek5  wagerWeek6  wagerWeek7  wagerWeek8             )
egen wageAltMar = rowmean(wagerWeek9  wagerWeek10 wagerWeek11 wagerWeek12 wagerWeek13)
egen wageAltApr = rowmean(wagerWeek14 wagerWeek15 wagerWeek16 wagerWeek17            )
egen wageAltMay = rowmean(wagerWeek18 wagerWeek19 wagerWeek20 wagerWeek21 wagerWeek22)
egen wageAltJun = rowmean(wagerWeek23 wagerWeek24 wagerWeek25 wagerWeek26            )
egen wageAltJul = rowmean(wagerWeek27 wagerWeek28 wagerWeek29 wagerWeek30 wagerWeek31)
egen wageAltAug = rowmean(wagerWeek32 wagerWeek33 wagerWeek34 wagerWeek35            )
egen wageAltSep = rowmean(wagerWeek36 wagerWeek37 wagerWeek38 wagerWeek39            )
egen wageAltOct = rowmean(wagerWeek40 wagerWeek41 wagerWeek42 wagerWeek43 wagerWeek44)
egen wageAltNov = rowmean(wagerWeek45 wagerWeek46 wagerWeek47 wagerWeek48            )
egen wageAltDec = rowmean(wagerWeek49 wagerWeek50 wagerWeek51 wagerWeek52 wagerWeek53)

egen wageAltMedianJan = rowmedian(wagerWeek1  wagerWeek2  wagerWeek3  wagerWeek4             )
egen wageAltMedianFeb = rowmedian(wagerWeek5  wagerWeek6  wagerWeek7  wagerWeek8             )
egen wageAltMedianMar = rowmedian(wagerWeek9  wagerWeek10 wagerWeek11 wagerWeek12 wagerWeek13)
egen wageAltMedianApr = rowmedian(wagerWeek14 wagerWeek15 wagerWeek16 wagerWeek17            )
egen wageAltMedianMay = rowmedian(wagerWeek18 wagerWeek19 wagerWeek20 wagerWeek21 wagerWeek22)
egen wageAltMedianJun = rowmedian(wagerWeek23 wagerWeek24 wagerWeek25 wagerWeek26            )
egen wageAltMedianJul = rowmedian(wagerWeek27 wagerWeek28 wagerWeek29 wagerWeek30 wagerWeek31)
egen wageAltMedianAug = rowmedian(wagerWeek32 wagerWeek33 wagerWeek34 wagerWeek35            )
egen wageAltMedianSep = rowmedian(wagerWeek36 wagerWeek37 wagerWeek38 wagerWeek39            )
egen wageAltMedianOct = rowmedian(wagerWeek40 wagerWeek41 wagerWeek42 wagerWeek43 wagerWeek44)
egen wageAltMedianNov = rowmedian(wagerWeek45 wagerWeek46 wagerWeek47 wagerWeek48            )
egen wageAltMedianDec = rowmedian(wagerWeek49 wagerWeek50 wagerWeek51 wagerWeek52 wagerWeek53)

egen compJan = rowmean(comp_week1  comp_week2  comp_week3  comp_week4             )
egen compFeb = rowmean(comp_week5  comp_week6  comp_week7  comp_week8             )
egen compMar = rowmean(comp_week9  comp_week10 comp_week11 comp_week12 comp_week13)
egen compApr = rowmean(comp_week14 comp_week15 comp_week16 comp_week17            )
egen compMay = rowmean(comp_week18 comp_week19 comp_week20 comp_week21 comp_week22)
egen compJun = rowmean(comp_week23 comp_week24 comp_week25 comp_week26            )
egen compJul = rowmean(comp_week27 comp_week28 comp_week29 comp_week30 comp_week31)
egen compAug = rowmean(comp_week32 comp_week33 comp_week34 comp_week35            )
egen compSep = rowmean(comp_week36 comp_week37 comp_week38 comp_week39            )
egen compOct = rowmean(comp_week40 comp_week41 comp_week42 comp_week43 comp_week44)
egen compNov = rowmean(comp_week45 comp_week46 comp_week47 comp_week48            )
egen compDec = rowmean(comp_week49 comp_week50 comp_week51 comp_week52 comp_week53)

egen compMedianJan = rowmedian(comp_week1  comp_week2  comp_week3  comp_week4             )
egen compMedianFeb = rowmedian(comp_week5  comp_week6  comp_week7  comp_week8             )
egen compMedianMar = rowmedian(comp_week9  comp_week10 comp_week11 comp_week12 comp_week13)
egen compMedianApr = rowmedian(comp_week14 comp_week15 comp_week16 comp_week17            )
egen compMedianMay = rowmedian(comp_week18 comp_week19 comp_week20 comp_week21 comp_week22)
egen compMedianJun = rowmedian(comp_week23 comp_week24 comp_week25 comp_week26            )
egen compMedianJul = rowmedian(comp_week27 comp_week28 comp_week29 comp_week30 comp_week31)
egen compMedianAug = rowmedian(comp_week32 comp_week33 comp_week34 comp_week35            )
egen compMedianSep = rowmedian(comp_week36 comp_week37 comp_week38 comp_week39            )
egen compMedianOct = rowmedian(comp_week40 comp_week41 comp_week42 comp_week43 comp_week44)
egen compMedianNov = rowmedian(comp_week45 comp_week46 comp_week47 comp_week48            )
egen compMedianDec = rowmedian(comp_week49 comp_week50 comp_week51 comp_week52 comp_week53)

egen compAltJan = rowmean(comprWeek1  comprWeek2  comprWeek3  comprWeek4             )
egen compAltFeb = rowmean(comprWeek5  comprWeek6  comprWeek7  comprWeek8             )
egen compAltMar = rowmean(comprWeek9  comprWeek10 comprWeek11 comprWeek12 comprWeek13)
egen compAltApr = rowmean(comprWeek14 comprWeek15 comprWeek16 comprWeek17            )
egen compAltMay = rowmean(comprWeek18 comprWeek19 comprWeek20 comprWeek21 comprWeek22)
egen compAltJun = rowmean(comprWeek23 comprWeek24 comprWeek25 comprWeek26            )
egen compAltJul = rowmean(comprWeek27 comprWeek28 comprWeek29 comprWeek30 comprWeek31)
egen compAltAug = rowmean(comprWeek32 comprWeek33 comprWeek34 comprWeek35            )
egen compAltSep = rowmean(comprWeek36 comprWeek37 comprWeek38 comprWeek39            )
egen compAltOct = rowmean(comprWeek40 comprWeek41 comprWeek42 comprWeek43 comprWeek44)
egen compAltNov = rowmean(comprWeek45 comprWeek46 comprWeek47 comprWeek48            )
egen compAltDec = rowmean(comprWeek49 comprWeek50 comprWeek51 comprWeek52 comprWeek53)

egen compAltMedianJan = rowmedian(comprWeek1  comprWeek2  comprWeek3  comprWeek4             )
egen compAltMedianFeb = rowmedian(comprWeek5  comprWeek6  comprWeek7  comprWeek8             )
egen compAltMedianMar = rowmedian(comprWeek9  comprWeek10 comprWeek11 comprWeek12 comprWeek13)
egen compAltMedianApr = rowmedian(comprWeek14 comprWeek15 comprWeek16 comprWeek17            )
egen compAltMedianMay = rowmedian(comprWeek18 comprWeek19 comprWeek20 comprWeek21 comprWeek22)
egen compAltMedianJun = rowmedian(comprWeek23 comprWeek24 comprWeek25 comprWeek26            )
egen compAltMedianJul = rowmedian(comprWeek27 comprWeek28 comprWeek29 comprWeek30 comprWeek31)
egen compAltMedianAug = rowmedian(comprWeek32 comprWeek33 comprWeek34 comprWeek35            )
egen compAltMedianSep = rowmedian(comprWeek36 comprWeek37 comprWeek38 comprWeek39            )
egen compAltMedianOct = rowmedian(comprWeek40 comprWeek41 comprWeek42 comprWeek43 comprWeek44)
egen compAltMedianNov = rowmedian(comprWeek45 comprWeek46 comprWeek47 comprWeek48            )
egen compAltMedianDec = rowmedian(comprWeek49 comprWeek50 comprWeek51 comprWeek52 comprWeek53)

foreach x of local months {
    replace hours_worked_`x' = 400 if inrange(hours_worked_`x',400,.) & num_weeks_`x'==4
    replace hours_worked_`x' = 500 if inrange(hours_worked_`x',500,.) & num_weeks_`x'==5
    gen    avgHrs`x' = hours_worked_`x'/weeks_worked_`x'
}

egen byte weeksMilitaryJan = rowtotal(Military_Week_1  Military_Week_2  Military_Week_3  Military_Week_4                  )
egen byte weeksMilitaryFeb = rowtotal(Military_Week_5  Military_Week_6  Military_Week_7  Military_Week_8                  )
egen byte weeksMilitaryMar = rowtotal(Military_Week_9  Military_Week_10 Military_Week_11 Military_Week_12 Military_Week_13)
egen byte weeksMilitaryApr = rowtotal(Military_Week_14 Military_Week_15 Military_Week_16 Military_Week_17                 )
egen byte weeksMilitaryMay = rowtotal(Military_Week_18 Military_Week_19 Military_Week_20 Military_Week_21 Military_Week_22)
egen byte weeksMilitaryJun = rowtotal(Military_Week_23 Military_Week_24 Military_Week_25 Military_Week_26                 )
egen byte weeksMilitaryJul = rowtotal(Military_Week_27 Military_Week_28 Military_Week_29 Military_Week_30 Military_Week_31)
egen byte weeksMilitaryAug = rowtotal(Military_Week_32 Military_Week_33 Military_Week_34 Military_Week_35                 )
egen byte weeksMilitarySep = rowtotal(Military_Week_36 Military_Week_37 Military_Week_38 Military_Week_39                 )
egen byte weeksMilitaryOct = rowtotal(Military_Week_40 Military_Week_41 Military_Week_42 Military_Week_43 Military_Week_44)
egen byte weeksMilitaryNov = rowtotal(Military_Week_45 Military_Week_46 Military_Week_47 Military_Week_48                 )
egen byte weeksMilitaryDec = rowtotal(Military_Week_49 Military_Week_50 Military_Week_51 Military_Week_52 Military_Week_53)

egen weeksSelfEmployedJan = rowtotal(Self_employed_Week1_  Self_employed_Week2_  Self_employed_Week3_  Self_employed_Week4_             )
egen weeksSelfEmployedFeb = rowtotal(Self_employed_Week5_  Self_employed_Week6_  Self_employed_Week7_  Self_employed_Week8_             )
egen weeksSelfEmployedMar = rowtotal(Self_employed_Week9_  Self_employed_Week10_ Self_employed_Week11_ Self_employed_Week12_ Self_employed_Week13_)
egen weeksSelfEmployedApr = rowtotal(Self_employed_Week14_ Self_employed_Week15_ Self_employed_Week16_ Self_employed_Week17_  )
egen weeksSelfEmployedMay = rowtotal(Self_employed_Week18_ Self_employed_Week19_ Self_employed_Week20_ Self_employed_Week21_ Self_employed_Week22_)
egen weeksSelfEmployedJun = rowtotal(Self_employed_Week23_ Self_employed_Week24_ Self_employed_Week25_ Self_employed_Week26_  )
egen weeksSelfEmployedJul = rowtotal(Self_employed_Week27_ Self_employed_Week28_ Self_employed_Week29_ Self_employed_Week30_ Self_employed_Week31_)
egen weeksSelfEmployedAug = rowtotal(Self_employed_Week32_ Self_employed_Week33_ Self_employed_Week34_ Self_employed_Week35_ )
egen weeksSelfEmployedSep = rowtotal(Self_employed_Week36_ Self_employed_Week37_ Self_employed_Week38_ Self_employed_Week39_ )
egen weeksSelfEmployedOct = rowtotal(Self_employed_Week40_ Self_employed_Week41_ Self_employed_Week42_ Self_employed_Week43_ Self_employed_Week44_)
egen weeksSelfEmployedNov = rowtotal(Self_employed_Week45_ Self_employed_Week46_ Self_employed_Week47_ Self_employed_Week48_ )
egen weeksSelfEmployedDec = rowtotal(Self_employed_Week49_ Self_employed_Week50_ Self_employed_Week51_ Self_employed_Week52_ Self_employed_Week53_)

*****************************************************************************
* Use Tot_Weeks_Worked_all and Total_Hours_Worked to replicate 'recall' 
*  caculations done in y79. Quote from y79_create_work.do
* "* [7] Supplement work history weekly arrays with weeks_worked_recall and
*       hrs_per_wk_recall for cohorts 1957-1959
*       Force all months to be a consecutive spell. Randomize start month
*       If mi hrs_per_wk_recall, assume PT, set hrs=10
*
*  Note: there is a variable weeks_worked_annual_svy that works well with
*        recall; on or after 17, each indiv has either weeks_worked_recall
*        or weeks_worked_annual_svy. Use these vars for ages 17-19.
*        Similarly true for hours_worked_annual_svy   "
*****************************************************************************
gen     monthsWorkedRecall = round(Tot_Weeks_Worked_all/4.3,1)     if inlist(age,12,13,14,15,16,17,18,19)
replace monthsWorkedRecall = 12 if inrange(monthsWorkedRecall,12,.)

gen     avgHrsRecall       = Total_Hours_Worked /Tot_Weeks_Worked_all if inrange(monthsWorkedRecall,1,12) & !mi(Total_Hours_Worked )
replace avgHrsRecall       = 50                                       if inrange(avgHrsRecall,50,.) 
replace avgHrsRecall       = 10                                       if inrange(monthsWorkedRecall,1,12) & mi(avgHrsRecall)

gen firstMonthWorkedRecall = round(runiform()*(12-monthsWorkedRecall),1)+1   if inrange(monthsWorkedRecall,1,12)

foreach month in `months' {
    gen workedRecall`month'=inrange(scalar`month',firstMonthWorkedRecall,firstMonthWorkedRecall+monthsWorkedRecall-1) & !mi(monthsWorkedRecall)
}
foreach month in `months' {
    gen     avgHrsRecall`month'= avgHrsRecall if workedRecall`month'==1
}

/*----------------------------------------------------------*\
| Create primary activity variable                           | 
|     Full-Time Work:                                        |
|       i.   max weeks worked in the month                   |
|       ii.  35+ hours worked per week worked                |
|       iii. Not in school that month                        |
|     Part-Time Work:                                        |
|       i.   not in full-time work                           |
|       ii.  >0   weeks worked  per month OR                 |
|       iii. >=42 hours worked per month                     |
|                                                            |
|     Military:                                              |
|     weeksMilitary>=weeksEmp AND                            |
|     not enrolled in school that month  --> 5               |
|     else, treat as others:                                 |
|       yes school                       -->                 |
|            no work                     --> 1               |
|            yes work                    --> 2               |
|       no school                        -->                 |
|                                        --> 3,4,6           |
\*----------------------------------------------------------*/

capture drop flag1 flag2
gen flag1 = yofd(dofm(R1interviewDate)) ==1998
gen flag2 = yofd(dofm(R17interviewDate))==2016

foreach x of local months {
    * Use School_Yr_to_Grade variable to determine school attendance if current month is before the interview date
    gen byte In_school`x' = ~mi(School_Yr_to_Grade) if year<=1996
    replace  In_school`x' = ~mi(School_Yr_to_Grade) if         mdy(scalar`x',1,year)<dofm(R1interviewDate) & year==1997
    replace  In_school`x' = ~mi(School_Yr_to_Grade) if flag1 & mdy(scalar`x',1,year)<dofm(R1interviewDate) & year==1998 // for the few people who had R1 interviews in 1998
    replace  In_school`x' = (Enrolled_K12_`x'==1 | Enrolled_college_`x'==1) if         mdy(scalar`x',1,year)>=dofm(R1interviewDate) & year==1997
    replace  In_school`x' = (Enrolled_K12_`x'==1 | Enrolled_college_`x'==1) if flag1 & mdy(scalar`x',1,year)>=dofm(R1interviewDate) & year==1998 // for the few people who had R1 interviews in 1998
    replace  In_school`x' = (Enrolled_K12_`x'==1 | Enrolled_college_`x'==1) if year>1997 & ~flag1
    replace  In_school`x' = (Enrolled_K12_`x'==1 | Enrolled_college_`x'==1) if year>1998 & flag1
}
foreach x of local months {
    gen byte Enr_K12`x' = In_school`x' & ~Enrolled_college_`x'
}
* impute Jul, Aug as "summer months" in the years before the interview date (Tyler, 9/18/2013)
foreach x in Jul Aug {
    replace In_school`x' = 0 if year<=1996
    replace In_school`x' = 0 if         mdy(scalar`x',1,year)<dofm(R1interviewDate) & year==1997
    replace In_school`x' = 0 if flag1 & mdy(scalar`x',1,year)<dofm(R1interviewDate) & year==1998 // for the few people who had R1 interviews in 1998
    replace Enr_K12`x'   = 0 if year<=1996
    replace Enr_K12`x'   = 0 if         mdy(scalar`x',1,year)<dofm(R1interviewDate) & year==1997
    replace Enr_K12`x'   = 0 if flag1 & mdy(scalar`x',1,year)<dofm(R1interviewDate) & year==1998 // for the few people who had R1 interviews in 1998
    
}

* Create annual school, work, military and other dummies
foreach x of local months {
    gen byte workFT`x'      = (weeks_worked_`x'==num_weeks_`x') & inrange(avgHrs`x',35,.)
    gen byte workPT`x'      = ~workFT`x' & (hours_worked_`x'>=42 | weeks_worked_`x'>=1)
    gen byte military`x'    = inrange(weeksMilitary`x',1,.) & weeksMilitary`x'>=weeks_worked_`x' & ~In_school`x'
    gen byte workSch`x'     = In_school`x' & (hours_worked_`x'>=8 | weeks_worked_`x'>=1)
    gen byte schOnly`x'     = In_school`x' &  hours_worked_`x'<8  & weeks_worked_`x'<1
    
    gen byte work`x'        = (workFT`x') | (workPT`x')
    
    gen byte workK12`x'     = workSch`x'*Enr_K12`x'
    gen byte workCollege`x' = workSch`x'*Enrolled_college_`x'
    
    gen byte other`x'       = ~In_school`x' & ~work`x' & ~military`x' // uses defn of workB
    
    * Label variables
    lab var workFT`x'      "WORKED FT"
    lab var workPT`x'      "WORKED PT"
    lab var work`x'        "WORKED"
    lab var workSch`x'     "WORKED AND ATTENDED SCHOOL"
    lab var workK12`x'     "WORKED AND ATTENDED K12"
    lab var workCollege`x' "WORKED AND ATTENDED COLLEGE"
    lab var military`x'    "SERVED IN MILITARY"
    lab var other`x'       "OTHER ACTIVITY"
    
    * Create activityC
    gen byte activity`x' = .
    replace  activity`x' = 1  if schOnly`x'                               // School Only
    replace  activity`x' = 2  if workSch`x'                               // School and Work using defn A
    replace  activity`x' = 3  if ~military`x' & ~In_school`x' & workPT`x' // Part-Time Work Only using defn A
    replace  activity`x' = 4  if ~military`x' & ~In_school`x' & workFT`x' // Full-Time Work Only
    replace  activity`x' = 5  if military`x'                              // Military
    replace  activity`x' = 6  if other`x'                                 // Other
    
    lab var activity`x' "ACTIVITY"
}

* Recall - Create annual school, work, military and other dummies
foreach x of local months {
    gen byte workFTRecall`x'      = (workedRecall`x'==1 & inrange(avgHrsRecall`x',35, .))
    gen byte workPTRecall`x'      = ~workFTRecall`x' & (workedRecall`x'==1 & inrange(avgHrsRecall`x',10,35))
    gen byte militaryRecall`x'    = inrange(weeksMilitary`x',1,.) & weeksMilitary`x'>=weeks_worked_`x' & ~In_school`x'
    gen byte workSchRecall`x'     = In_school`x' & workedRecall`x'==1
    gen byte schOnlyRecall`x'     = In_school`x' & workedRecall`x'==0
    
    gen byte workRecall`x'        = (workFTRecall`x') | (workPTRecall`x')
    
    gen byte workK12Recall`x'     = workSchRecall`x'*Enr_K12`x'
    gen byte workCollegeRecall`x' = workSchRecall`x'*Enrolled_college_`x'
    
    gen byte otherRecall`x'       = ~In_school`x' & ~workRecall`x' & ~militaryRecall`x' 
    
    * Label variables
    lab var workFTRecall`x'      "WORKED FT"
    lab var workPTRecall`x'      "WORKED PT"
    lab var workRecall`x'        "WORKED"
    lab var workSchRecall`x'     "WORKED AND ATTENDED SCHOOL"
    lab var workK12Recall`x'     "WORKED AND ATTENDED K12"
    lab var workCollegeRecall`x' "WORKED AND ATTENDED COLLEGE"
    lab var militaryRecall`x'    "SERVED IN MILITARY"
    lab var otherRecall`x'       "OTHER ACTIVITY"
    
    * Create activityC
    gen byte activityRecall`x' = .
    replace  activityRecall`x' = 1  if schOnlyRecall`x'                                           
    replace  activityRecall`x' = 2  if workSchRecall`x'                                     
    replace  activityRecall`x' = 3  if ~militaryRecall`x' & ~In_school`x' & workPTRecall`x' 
    replace  activityRecall`x' = 4  if ~militaryRecall`x' & ~In_school`x' & workFTRecall`x' 
    replace  activityRecall`x' = 5  if militaryRecall`x'                                    
    replace  activityRecall`x' = 6  if otherRecall`x'                                       
    
    lab var activityRecall`x' "ACTIVITY"
}
