*-------------------------------------
* Generate date Graduated High School 
*-------------------------------------
genera Diploma_date = 239+Months_to_HS_diploma
genera GED_date     = 239+Months_to_GED

format GED_date     %tm
format Diploma_date %tm
label  variable Diploma_date "Date received HS Diploma"
label  variable GED_date     "Date received GED"

gen Diploma_year = 1960+floor(Diploma_date/12)
gen GED_year     = 1960+floor(GED_date/12)

generat HS_date = min(Diploma_date,GED_date)
replace HS_date = Diploma_date if ~mi(Diploma_date) &  mi(GED_date)
replace HS_date = GED_date     if  mi(Diploma_date) & ~mi(GED_date)

format  HS_date %tm
label   variable HS_date "Date received HS Diploma OR GED (or earliest one if both)"

gen HS_year = 1960+floor(HS_date/12)

* Do I need these lines of code???
* gen first_int_missed_range = First_year_missed_int-Diploma_year
* gen last_int_missed_range = Last_year_missed_int-Diploma_year

*------------------------------------------
* Generate date received degree variables  
*------------------------------------------
genera BA_date   = 239+Months_to_BA_degree
genera AA_date   = 239+Months_to_AA_degree
genera Prof_date = 239+Months_to_Prof_degree
genera PhD_date  = 239+Months_to_PhD_degree
genera MA_date   = 239+Months_to_MA_degree

generat Grad_date = min(MA_date,Prof_date,PhD_date)
replace Grad_date = min(MA_date,Prof_date         ) if ~mi(MA_date) & ~mi(Prof_date) &  mi(PhD_date)
replace Grad_date = min(MA_date          ,PhD_date) if ~mi(MA_date) &  mi(Prof_date) & ~mi(PhD_date)
replace Grad_date = min(        Prof_date,PhD_date) if  mi(MA_date) & ~mi(Prof_date) & ~mi(PhD_date)
replace Grad_date = MA_date                         if ~mi(MA_date) &  mi(Prof_date) &  mi(PhD_date)
replace Grad_date = Prof_date                       if  mi(MA_date) & ~mi(Prof_date) &  mi(PhD_date)
replace Grad_date = PhD_date                        if  mi(MA_date) &  mi(Prof_date) & ~mi(PhD_date)

format Grad_date %tm
format BA_date   %tm
format AA_date   %tm
format Prof_date %tm
format PhD_date  %tm
format MA_date   %tm
label variable Grad_date "Date received Graduate Degree (or earliest of graduate degrees if multiple)"
label variable age       "Age (in years) on Jan 1, 1997"
label variable BA_date   "Date received BA degree"
label variable AA_date   "Date received AA degree"
label variable MA_date   "Date received MA degree"
label variable PhD_date  "Date received PhD degree"
label variable Prof_date "Date received Professional degree"

gener BA_year   = floor(BA_date/12+1960)
gener AA_year   = floor(AA_date/12+1960)
gener PhD_year  = floor(PhD_date/12+1960)
gener MA_year   = floor(MA_date/12+1960)
gener Prof_year = floor(Prof_date/12+1960)
gener Grad_year = floor(Grad_date/12+1960)
label variable AA_year "Year received AA degree"
label variable BA_year "Year received BA degree"
label variable MA_year "Year received MA degree"
label variable Prof_year "Year received Prof degree"
label variable PhD_year "Year received PhD degree"
label variable Grad_year "Year received 1st advanced (graduate) degree"

format BA_date %10.0g
format AA_date %10.0g

gen BA_month      = mod(BA_date,12)+1
gen AA_month      = mod(AA_date,12)+1
gen GED_month     = mod(GED_date,12)+1
gen Diploma_month = mod(Diploma_date,12)+1
gen HS_month      = mod(HS_date,12)+1
gen PhD_month     = mod(PhD_date,12)+1
gen MA_month      = mod(MA_date,12)+1
gen Prof_month    = mod(Prof_date,12)+1
gen Grad_month    = mod(Grad_date,12)+1

format BA_date %tm
format AA_date %tm

drop Months_to_BA_degree Months_to_AA_degree Months_to_MA_degree Months_to_Prof_degree Months_to_PhD_degree Months_to_HS_diploma

do SchoolYrtoGrade_impute
do BA_impute
do Diploma_impute

*-------------------------------------------------------------
* Get the Schooling Status for each person -- NOTE "college"  
* now refers to college OR grad schoolto match up with 79 data
* (TMR, 1/17/12)                                              
*-------------------------------------------------------------
local months Jan Feb Mar Apr May Jun Jul Aug Sep Oct Nov Dec
local SchoolMonths Jan Feb Mar Apr May Sep Oct Nov Dec
foreach month of local months {
    gen Enrolled_K12_`month'         = School_Enrollment_Status_`month'==2
    gen Enrolled_college_`month'     = inrange(College_enrollment_`month',2,4)
    gen Enrolled_2yr_`month'         = inrange(College_enrollment_`month',2,2)
    gen Enrolled_4yr_`month'         = inrange(College_enrollment_`month',3,3)
    gen Enrolled_grad_school_`month' = inrange(College_enrollment_`month',4,4)
}   
foreach month of local SchoolMonths {
    replace Enrolled_K12_`month'         = 1 if ~mi(School_Yr_to_Grade) & Enrolled_K12_`month'==0 & year<=1997
}

egen Months_in_K12         = rowtotal(Enrolled_K12_Jan Enrolled_K12_Feb Enrolled_K12_Mar Enrolled_K12_Apr Enrolled_K12_May Enrolled_K12_Jun Enrolled_K12_Jul Enrolled_K12_Aug Enrolled_K12_Sep Enrolled_K12_Oct Enrolled_K12_Nov Enrolled_K12_Dec)
egen Months_in_college     = rowtotal(Enrolled_college_Jan Enrolled_college_Feb Enrolled_college_Mar Enrolled_college_Apr Enrolled_college_May Enrolled_college_Jun Enrolled_college_Jul Enrolled_college_Aug Enrolled_college_Sep Enrolled_college_Oct Enrolled_college_Nov Enrolled_college_Dec)
egen Months_in_2yr         = rowtotal(Enrolled_2yr_Jan Enrolled_2yr_Feb Enrolled_2yr_Mar Enrolled_2yr_Apr Enrolled_2yr_May Enrolled_2yr_Jun Enrolled_2yr_Jul Enrolled_2yr_Aug Enrolled_2yr_Sep Enrolled_2yr_Oct Enrolled_2yr_Nov Enrolled_2yr_Dec)
egen Months_in_4yr         = rowtotal(Enrolled_4yr_Jan Enrolled_4yr_Feb Enrolled_4yr_Mar Enrolled_4yr_Apr Enrolled_4yr_May Enrolled_4yr_Jun Enrolled_4yr_Jul Enrolled_4yr_Aug Enrolled_4yr_Sep Enrolled_4yr_Oct Enrolled_4yr_Nov Enrolled_4yr_Dec)
egen Months_in_grad_school = rowtotal(Enrolled_grad_school_Jan Enrolled_grad_school_Feb Enrolled_grad_school_Mar Enrolled_grad_school_Apr Enrolled_grad_school_May Enrolled_grad_school_Jun Enrolled_grad_school_Jul Enrolled_grad_school_Aug Enrolled_grad_school_Sep Enrolled_grad_school_Oct Enrolled_grad_school_Nov Enrolled_grad_school_Dec)
gen  Months_in_school      = Months_in_K12 + Months_in_college
gen  weeksSchool           = floor(Months_in_school*52/12)

gen In_K12 = inrange(Months_in_K12,1,.)
gen In_college = inrange(Months_in_college,1,.) | inrange(Months_in_grad_school,1,.)
gen In_grad_school = inrange(Months_in_grad_school,1,.)

*-------------------------------------------------------------
* change HS dates for those who report graduation from HS but are enrolled in college before then (and not concurrently in HS)
*-------------------------------------------------------------
* 1. get last date enrolled in K12
local months Jan Feb Mar Apr May Jun Jul Aug Sep Oct Nov Dec
foreach month of local months {
    gen lastValidK12A`month' = mdy(month(date("`month'","M")),1,year) if Enrolled_K12_`month'==1
    bys ID (year): egen lastValidK12`month' = max(lastValidK12A`month')
}
egen lastValidK12 = rowmax(lastValidK12Jan lastValidK12Feb lastValidK12Mar lastValidK12Apr lastValidK12May lastValidK12Jun lastValidK12Jul lastValidK12Aug lastValidK12Sep lastValidK12Oct lastValidK12Nov lastValidK12Dec)
format lastValidK12 %td

* 2. flag the people who ever are enrolled in college before HS graduation (and not concurrently in HS)
foreach month of local months {
    gen byte collegeflag2`month' = ~mi(HS_date) & Enrolled_college_`month'==1 & Enrolled_K12_`month'==0 & mdy(month(date("`month'","M")),1,year)<=mdy(HS_month,1,HS_year)
    gen everColBefHSgradA`month' = collegeflag2`month'==1
    bys ID (year): egen everColBefHSgrad`month' = max(everColBefHSgradA`month')
}
egen everColBefHSgrad = rowmax(everColBefHSgradJan everColBefHSgradFeb everColBefHSgradMar everColBefHSgradApr everColBefHSgradMay everColBefHSgradJun everColBefHSgradJul everColBefHSgradAug everColBefHSgradSep everColBefHSgradOct everColBefHSgradNov everColBefHSgradDec)
replace everColBefHSgrad = 1 if inlist(ID,440,523,548,557,585,607,884,1345,1883,1914,1942,2121,2156,2232,2380,2887,3235,3321,3764,3793,3897,4123,4362,4372,4419,4431,4553,4564,4618,5036,5128,5143,5177,5452,5499,5769,6343,6417,6704,6977,6991,7193,7652,7939,8214,8405,8498)

* 3. change HS date for the people who ever are enrolled in college before HS graduation (and not concurrently in HS)
gen HS_year2  = year(lastValidK12)  if everColBefHSgrad
gen HS_month2 = month(lastValidK12) if everColBefHSgrad

replace HS_year  = HS_year2  if everColBefHSgrad
replace HS_month = HS_month2 if everColBefHSgrad

replace Diploma_year  = HS_year2  if everColBefHSgrad & ~mi(Diploma_year )
replace Diploma_month = HS_month2 if everColBefHSgrad & ~mi(Diploma_month)
replace GED_year  = HS_year2  if everColBefHSgrad & ~mi(GED_year )
replace GED_month = HS_month2 if everColBefHSgrad & ~mi(GED_month)

replace GED_year  = min(HS_year,GED_year)   if ~mi(GED_year)  & ~mi(HS_year)
replace GED_month = min(HS_month,GED_month) if ~mi(GED_month) & ~mi(HS_month)

replace Diploma_year  = min(HS_year,Diploma_year)   if ~mi(Diploma_year)  & ~mi(HS_year)
replace Diploma_month = min(HS_month,Diploma_month) if ~mi(Diploma_month) & ~mi(HS_month)

replace HS_date      = ym(HS_year,HS_month)
replace GED_date     = ym(GED_year,GED_month)
replace Diploma_date = ym(Diploma_year,Diploma_month)

bys ID (year): egen everEnrK12A = total(Months_in_K12)
gen everEnrK12 = everEnrK12A>0

*-------------------------------------------------------------
* Check enrollment histories of people who have a Diploma date
*-------------------------------------------------------------
capture noisily codebook ID if ~everEnrK12 & HS_date<.
capture noisily codebook ID if ~everEnrK12 & HS_date<. & everColBefHSgrad

*-----------------------------------------
* Get dates earned various college degrees 
*-----------------------------------------
bys ID (year): gen gradGraduate = (year>=Grad_year)
bys ID (year): gen grad4yr      = (year>=BA_year)
bys ID (year): gen grad2yr      = (year>=AA_year)
bys ID (year): gen gradDiploma  = (year>=Diploma_year)
bys ID (year): gen gradGED      = (year>=GED_year) // could do GED_year-1 to capture the people who start attending college w/no degree (and are off by 1 year)
bys ID (year): gen gradHS       = (year>=HS_year)
** Need to add GED as equivalent to "graduating HS" 
* check to see if people graduated from HS and got GED, or if they are mutually exclusive

gen yrGradGraduate  = (year==Grad_year)
gen yrGrad4yr       = (year==BA_year)
gen yrGrad2yr       = (year==AA_year)
gen yrGradHS        = (year==HS_year)
gen yrGradDiploma   = (year==Diploma_year)
gen yrGradGED       = (year==GED_year)

*-----------------------------------------
* Edit college experience for outlying cases 
*-----------------------------------------
* force people who jumped the gun and went to college early to not be in college while they're still in HS
foreach month of local months {
    replace Enrolled_college_`month' = 0 if Enrolled_K12_`month'==1 & Enrolled_college_`month'==1 & mdy(month(date("`month'","M")),1,year)<=mdy(HS_month,1,HS_year) & ~mi(HS_year)
    replace Enrolled_2yr_`month'     = 0 if Enrolled_K12_`month'==1 & Enrolled_2yr_`month'==1     & mdy(month(date("`month'","M")),1,year)<=mdy(HS_month,1,HS_year) & ~mi(HS_year)
    replace Enrolled_4yr_`month'     = 0 if Enrolled_K12_`month'==1 & Enrolled_4yr_`month'==1     & mdy(month(date("`month'","M")),1,year)<=mdy(HS_month,1,HS_year) & ~mi(HS_year)
}
* eventually drop observations after someone reports being enrolled in college without a HS Diploma of any kind
foreach month of local months {
    gen byte collegeflag`month' = mi(HS_date) & Enrolled_college_`month'==1
    gen lastValidSchoolDateA`month' = mdy(month(date("`month'","M")),1,year) if collegeflag`month'
    bys ID (year): egen lastValidSchoolDate`month' = min(lastValidSchoolDateA`month')
}

egen lastValidSchoolDate = rowmin(lastValidSchoolDateJan lastValidSchoolDateFeb lastValidSchoolDateMar lastValidSchoolDateApr lastValidSchoolDateMay lastValidSchoolDateJun lastValidSchoolDateJul lastValidSchoolDateAug lastValidSchoolDateSep lastValidSchoolDateOct lastValidSchoolDateNov lastValidSchoolDateDec)
format lastValidSchoolDate %td

* anyone left with college enrollment before HS graduation will be taken away.
replace lastValidSchoolDate = mdy(9,1,1998) if ID==440
foreach month of local months {
    replace Enrolled_college_`month' = 0 if Enrolled_college_`month'==1 & mdy(month(date("`month'","M")),1,year)<=mdy(HS_month,1,HS_year) & ~mi(HS_year) & inlist(ID,548,557,585,884,1345,1883,1914,2121,2156,2232,2380,2887,3235,3764,3897,4372,4419,4553,4564,4618,5036,5128,5143,5452,5499,5769,6343,6417,6704,6991,7193,8214,8498)
    replace Enrolled_2yr_`month'     = 0 if Enrolled_2yr_`month'==1     & mdy(month(date("`month'","M")),1,year)<=mdy(HS_month,1,HS_year) & ~mi(HS_year) & inlist(ID,548,557,585,884,1345,1883,1914,2121,2156,2232,2380,2887,3235,3764,3897,4372,4419,4553,4564,4618,5036,5128,5143,5452,5499,5769,6343,6417,6704,6991,7193,8214,8498)
    replace Enrolled_4yr_`month'     = 0 if Enrolled_4yr_`month'==1     & mdy(month(date("`month'","M")),1,year)<=mdy(HS_month,1,HS_year) & ~mi(HS_year) & inlist(ID,548,557,585,884,1345,1883,1914,2121,2156,2232,2380,2887,3235,3764,3897,4372,4419,4553,4564,4618,5036,5128,5143,5452,5499,5769,6343,6417,6704,6991,7193,8214,8498)
}
l ID year Enrolled_K12_Aug Enrolled_college_Aug gradHS HS_date Diploma_date GED_* everColBefHSgrad lastValidSchoolDate if ID==12   & year==2002
