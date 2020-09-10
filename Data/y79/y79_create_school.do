*****************************************************************************
* Create variables enroll_status, hgc, and degree
*  completion dummies
*
* Searchable ToC
* [1] Enrollment
* [1.1] enrSchool pre first interview
* [1.2] enrSchool based on enroll_status_curr/prev/2prev
* [1.3] enrSchool fill-ins post first interview
* [1.4] Assume students do not go to K12 in the summer months (July, August)
* [1.5] Create annual school activity status
* [2] hgc - Highest grade completed by year
* [2.1] Generate hgc: use highest grade completed as
* [2.2] Hand edit observations that still have .n's and .i's before last duration
* [2.3] Other edits
* [3] Determine graduation/degree completion dates
* [3.1] Use dates of degree reception and school attendance
* [3.2] Get the date that individuals received HS, AA, BA, Grad and Other degrees
* [3.3] Generate absorbing dummies that turn on (and stay on)
* [4] Break out monthly enrollment: enrK12, enrCollege, enrGradSch
* [4.1] Create annual school activity status
*****************************************************************************
set more off
local months "Jan Feb Mar Apr May Jun Jul Aug Sep Oct Nov Dec"

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

*****************************************************************************
* [1] Enrollment
*****************************************************************************

*============================================================================
* [1.1] enrSchool pre first interview
*============================================================================

*--------------------------------------------
* Create date variables, ie mdy(X_mo,1,X_yr)
*--------------------------------------------
gen    interview_date = mdy(interview_mo,1,year) if year>=1979 & interview_mo<.
format interview_date %td
* Replace missing months with modal months:
*  beg_sch_last_k12, end_sch_last_k12, beg_1col & end_sch

foreach stub in beg_sch_last_k12 end_sch_last_k12 end_sch beg_1col beg_2col beg_3col end_1col end_2col end_3col recd_diploma recd_high_deg recd_1degree recd_2degree recd_3degree recd_4degree {
	egen    temp_mode = mode(`stub'_mo), minmode
	gen     `stub'_date = mdy( `stub'_mo, 1, `stub'_yr)
	replace `stub'_date = mdy( temp_mode, 1, `stub'_yr) if `stub'_mo>=. & `stub'_yr<.
	format  `stub'_date %td
	drop    temp_mode
}

* Clean dates
by id: replace beg_1col_date        =end_sch_date[10]          if year==1979 & beg_1col_date[10]        >end_sch_date[10]         
by id: replace end_sch_last_k12_date=beg_1col_date[10]         if year==1979 & end_sch_last_k12_date[10]>beg_1col_date[10]        
by id: replace beg_sch_last_k12_date=end_sch_last_k12_date[10] if year==1979 & beg_sch_last_k12_date[10]>end_sch_last_k12_date[10]

*----------------------------------------------------------------------------
* Determine monthly enrollment status pre first interview
*  Report dates that: beg K12, end K12, beg College, end all sch
*   Create different groups based which dates they provided. Also account for 
*   those who never attended school and those who had errors in reporting
* Note: period [10] is 1979, first year of data reporting
*----------------------------------------------------------------------------
by id: gen byte flag0 = (beg_sch_last_k12_yr[10]==.v)                                                                               
by id: gen byte flag1 = (beg_sch_last_k12_yr[10]<.  ) & (end_sch_last_k12_yr[10]==.v)                                               
by id: gen byte flag2 = (beg_sch_last_k12_yr[10]<.  ) & (end_sch_last_k12_yr[10]<.  ) & (beg_1col_yr[10]==.v)                       
by id: gen byte flag3 = (beg_sch_last_k12_yr[10]<.  ) & (end_sch_last_k12_yr[10]<.  ) & (beg_1col_yr[10]<.  ) & (end_sch_yr[10]==.v)
by id: gen byte flag4 = (beg_sch_last_k12_yr[10]<.  ) & (end_sch_last_k12_yr[10]<.  ) & (beg_1col_yr[10]<.  ) & (end_sch_yr[10]<.  )
gen byte        flag9 = (flag0==0) & (flag1==0) & (flag2==0) & (flag3==0) & (flag4==0)                                              

foreach month in `months' {

	gen byte enrSchool`month'=.z

	*-------------------------------------
	* Values without any formal schooling
	*-------------------------------------
	* Not in school before interview_1979/mo
	by id: replace enrSchool`month' = 0 if mdy(scalar`month',1,year)<=interview_date[10] & flag0
	
	*------------------
	* Valid entries
	*------------------
	* In K12 before beg_sch_last_k12_yr/mo
	by id: replace enrSchool`month' = 1 if inrange( mdy(scalar`month',1,year), 0                        , beg_sch_last_k12_date[10] ) & (flag1 | flag2 | flag3 | flag4)
	
	* In K12 between beg_sch_last_k12_yr/mo and end_sch_last_k12_yr/mo or interview_1979/mo
	by id: replace enrSchool`month' = 1 if inrange( mdy(scalar`month',1,year), beg_sch_last_k12_date[10], end_sch_last_k12_date[10] ) & (flag2 | flag3 | flag4)
	by id: replace enrSchool`month' = 1 if inrange( mdy(scalar`month',1,year), beg_sch_last_k12_date[10], interview_date[10]        ) & flag1
	
	* Not in school between end_sch_last_k12_yr/mo and beg_1col_yr/mo or interview_1979/mo
	by id: replace enrSchool`month' = 0 if inrange( mdy(scalar`month',1,year), end_sch_last_k12_date[10], beg_1col_date[10]         ) & (flag3 | flag4)
	by id: replace enrSchool`month' = 0 if inrange( mdy(scalar`month',1,year), end_sch_last_k12_date[10], interview_date[10]        ) & flag2
	
	* In college between beg_1col and end_sch_yr/mo or interview_1979/mo
	by id: replace enrSchool`month' = 1 if inrange( mdy(scalar`month',1,year), beg_1col_date[10]        , end_sch_date[10]          ) & flag4 
	by id: replace enrSchool`month' = 1 if inrange( mdy(scalar`month',1,year), beg_1col_date[10]        , interview_date[10]        ) & flag3
	
	* Not in school between end_sch_yr/mo and interview_1979/mo
	by id: replace enrSchool`month' = 0 if inrange( mdy(scalar`month',1,year), end_sch_date[10]         , interview_date[10]        ) & flag4

	*-------------------------
	* Error prone values (flag9)
	*-------------------------
	* In school before interview_1979/mo if enroll_current[10]==1
	*   Assumes 18-21 year-olds are in school continously before this instance
	by id: replace enrSchool`month' = 1 if enroll_current[10]==1                     & mdy(scalar`month',1,year)<=interview_date[10] & flag9

	* In school before end_sch_yr, not in school between end_sch_yr/mo and interview_1979/yr 
	*  if enroll_current[10]==0 & end_sch_yr[10]<.
	by id: replace enrSchool`month' = 1 if enroll_current[10]==0 & end_sch_yr[10]<.  & inrange(mdy(scalar`month',1,year),.               ,end_sch_date[10]  ) & flag9
	by id: replace enrSchool`month' = 0 if enroll_current[10]==0 & end_sch_yr[10]<.  & inrange(mdy(scalar`month',1,year),end_sch_date[10],interview_date[10]) & flag9

	* Hand-edits, end_sch_yr==.d or .i
	by id: replace enrSchool`month' = 1 if id==589  & year<=1977
	by id: replace enrSchool`month' = 0 if id==589  & year>=1978 & mdy(scalar`month',1,year)<=interview_date[10]
	by id: replace enrSchool`month' = 1 if id==646  & year<=1976
	by id: replace enrSchool`month' = 0 if id==646  & year>=1977 & mdy(scalar`month',1,year)<=interview_date[10]
	by id: replace enrSchool`month' = 1 if id==7712 & mdy(scalar`month',1,year)<=mdy(5,1,1978)
	by id: replace enrSchool`month' = 0 if id==7712 & mdy(scalar`month',1,year)> mdy(5,1,1978) & mdy(scalar`month',1,year)<=interview_date[10]
	by id: replace enrSchool`month' = 1 if id==9908 & year<=1977
	by id: replace enrSchool`month' = 0 if id==9908 & year>=1978 & mdy(scalar`month',1,year)<=interview_date[10]

	* Remaining 18-21 year olds, rough fillins
	by id: replace enrSchool`month' = 1 if flag9 & inlist(end_sch_yr[10],.d,.i) & ( mdy(scalar`month',1,year)<=beg_sch_last_k12_date[10] & !mi(beg_sch_last_k12_date[10]) )
	by id: replace enrSchool`month' = 1 if flag9 & inlist(end_sch_yr[10],.d,.i) & ( mdy(scalar`month',1,year)<=end_sch_last_k12_date[10] & !mi(end_sch_last_k12_date[10]) )
	by id: replace enrSchool`month' = 1 if flag9 & inlist(end_sch_yr[10],.d,.i) & ( mdy(scalar`month',1,year)<=beg_1col_date[10]         & !mi(beg_1col_date[10])         )
	by id: replace enrSchool`month' = 1 if flag9 & inlist(end_sch_yr[10],.d,.i) & ( mdy(scalar`month',1,year)<=interview_date[10]        & !mi(beg_1col_date[10])         )
	
	by id: replace enrSchool`month' = 1 if flag9 & inlist(end_sch_yr[10],.d,.i) & mi(enrSchool`month') & age<=16 & mdy(scalar`month',1,year)<=interview_date[10]
	by id: replace enrSchool`month' = 0 if flag9 & inlist(end_sch_yr[10],.d,.i) & mi(enrSchool`month') & age> 16 & mdy(scalar`month',1,year)<=interview_date[10]
	
	by id: gen temp_test = mdy(scalar`month',1,year)<=interview_date[10]
	assert ~mi(enrSchool`month') if temp_test
	drop temp_test
}

*============================================================================
* [1.2] enrSchool based on enroll_status_curr/prev/2prev
*  These variables were only reported if the interview took place and for the
*   most part only report a 1. There are many .v's and .n's that should be 0.
*============================================================================
*----------------------------------------------------------------------------
* Update the enrSchool`month' variables with the enroll_status_`month'_vars
*  Wait to do updates for years before 1981. This is because these variables
*  do not report schooling before 2nd interview.
* EDIT JA, 1/2019: Later years have extra vars: 3prev and 1next.
*----------------------------------------------------------------------------
foreach month in `months' {
	by id: replace enrSchool`month' = 0 if (enroll_status_`month'_1next[_n-1]==0  | enroll_status_`month'_curr==0  | enroll_status_`month'_prev[_n+1]==0  | enroll_status_`month'_2prev[_n+2]==0  | enroll_status_`month'_3prev[_n+3]==0 )
	by id: replace enrSchool`month' = 0 if (enroll_status_`month'_1next[_n-1]==.v | enroll_status_`month'_curr==.v | enroll_status_`month'_prev[_n+1]==.v | enroll_status_`month'_2prev[_n+2]==.v | enroll_status_`month'_3prev[_n+3]==.v) & year>=1981
	by id: replace enrSchool`month' = 1 if (enroll_status_`month'_1next[_n-1]==1  | enroll_status_`month'_curr==1  | enroll_status_`month'_prev[_n+1]==1  | enroll_status_`month'_2prev[_n+2]==1  | enroll_status_`month'_3prev[_n+3]==1  )
	label var enrSchool`month' "MONTHLY ENROLLMENT IN ANY SCHOOL - `month'"
}


*============================================================================
* [1.3] enrSchool fill-ins post first interview
*============================================================================
*----------------------------------------------------------------------------
* 1979-1980 (between first & second int)
*  For enroll_since_dli==1
*    If currently enrolled, assume enrolled b/t 1st int and 2nd int
*    Else, enrolled b/t 1st int and end_sch_date, 
*       not enrolled b/t end_sch_date and 2nd int
*----------------------------------------------------------------------------
foreach month in `months' {
	by id: replace enrSchool`month' = !inlist( "`month'", "Jul", "Aug") if inrange(mdy(scalar`month',1,year), interview_date[10], interview_date[11]) & mi(enrSchool`month') & enroll_since_dli[11]==1 & enroll_current[11]==1
	by id: replace enrSchool`month' = !inlist( "`month'", "Jul", "Aug") if inrange(mdy(scalar`month',1,year), interview_date[10], end_sch_date[11]  ) & mi(enrSchool`month') & enroll_since_dli[11]==1 & enroll_current[11]==0
	by id: replace enrSchool`month' = 0                                 if inrange(mdy(scalar`month',1,year), end_sch_date[11]  , interview_date[11]) & mi(enrSchool`month') & enroll_since_dli[11]==1 & enroll_current[11]==0
}
* Now that data has been filled in b/t 1st and 2nd interview, use the
*  rest of the enroll_status vars
* EDIT JA, 1/2019: 3prev and 1next only begin post 1994
foreach month in `months' {
	by id: replace enrSchool`month' = 0 if (enroll_status_`month'_curr==.v | enroll_status_`month'_prev[_n+1]==.v | enroll_status_`month'_2prev[_n+2]==.v) & year<1981 & mi(enrSchool`month')
}

*----------------------------------------------------------------------------
* 1980-1994
* For enroll_since_dli==1, 
*   Fillin enrollment periods based on the school dates
* EDIT: JA 1/2019, adding in additional years, so 1980-2014 (25-->45)
*----------------------------------------------------------------------------
* forvalues X = 11/25 {
forvalues X = 11/45 {
	foreach month in `months' {
		disp "`X' `month'"
		* Enrolled between valid beg and end college dates
		by id: replace enrSchool`month' = !inlist( "`month'", "Jul", "Aug") if inrange(mdy(scalar`month',1,year), beg_1col_date[`X'], end_1col_date[`X'] ) & mi(enrSchool`month') & !mi(beg_1col_date[`X']) & !mi(end_1col_date[`X'])
		by id: replace enrSchool`month' = !inlist( "`month'", "Jul", "Aug") if inrange(mdy(scalar`month',1,year), beg_2col_date[`X'], end_2col_date[`X'] ) & mi(enrSchool`month') & !mi(beg_2col_date[`X']) & !mi(end_1col_date[`X'])
		by id: replace enrSchool`month' = !inlist( "`month'", "Jul", "Aug") if inrange(mdy(scalar`month',1,year), beg_3col_date[`X'], end_3col_date[`X'] ) & mi(enrSchool`month') & !mi(beg_3col_date[`X']) & !mi(end_1col_date[`X'])
		* Enrolled between valid beg college date and end_sch_date (not currently enrolled)
		by id: replace enrSchool`month' = !inlist( "`month'", "Jul", "Aug") if inrange(mdy(scalar`month',1,year), beg_1col_date[`X'], end_sch_date[`X']  ) & mi(enrSchool`month') & !mi(beg_1col_date[`X']) &  mi(end_1col_date[`X']) & !mi(end_sch_date[`X'])
		by id: replace enrSchool`month' = !inlist( "`month'", "Jul", "Aug") if inrange(mdy(scalar`month',1,year), beg_2col_date[`X'], end_sch_date[`X']  ) & mi(enrSchool`month') & !mi(beg_2col_date[`X']) &  mi(end_1col_date[`X']) & !mi(end_sch_date[`X'])
		by id: replace enrSchool`month' = !inlist( "`month'", "Jul", "Aug") if inrange(mdy(scalar`month',1,year), beg_3col_date[`X'], end_sch_date[`X']  ) & mi(enrSchool`month') & !mi(beg_3col_date[`X']) &  mi(end_1col_date[`X']) & !mi(end_sch_date[`X'])
		* Enrolled between valid beg college date and interview date (currently enrolled)     
		by id: replace enrSchool`month' = !inlist( "`month'", "Jul", "Aug") if inrange(mdy(scalar`month',1,year), beg_1col_date[`X'], interview_date[`X']) & mi(enrSchool`month') & !mi(beg_1col_date[`X']) &  mi(end_1col_date[`X']) &  mi(end_sch_date[`X'])
		by id: replace enrSchool`month' = !inlist( "`month'", "Jul", "Aug") if inrange(mdy(scalar`month',1,year), beg_2col_date[`X'], interview_date[`X']) & mi(enrSchool`month') & !mi(beg_2col_date[`X']) &  mi(end_1col_date[`X']) &  mi(end_sch_date[`X'])
		by id: replace enrSchool`month' = !inlist( "`month'", "Jul", "Aug") if inrange(mdy(scalar`month',1,year), beg_3col_date[`X'], interview_date[`X']) & mi(enrSchool`month') & !mi(beg_3col_date[`X']) &  mi(end_1col_date[`X']) &  mi(end_sch_date[`X'])	
	}
}

*----------------------------------------------------------------------------
* 1980-1994
* For enroll_since_dli==1 AND return from missIntSpell
* as well as the interview date. 
* Assume that if enroll_current==1 then in school up to 
*   int date, else not in school up to int date
* EDIT: JA 1/2019, adding in additional years, so 1980-2014 (25-->45)
*----------------------------------------------------------------------------
* forvalues X = 11/25 {
forvalues X = 11/45 {
	foreach month in `months' {
		disp "`X' `month'"
		* Remaining: enrolled b/t dli and interview_date (currently enrolled)
		by id: replace enrSchool`month' = !inlist( "`month'", "Jul", "Aug") if inrange(mdy(scalar`month',1,year), interview_date[ `X'-missIntEndLength[`X']-1 ], interview_date[`X'] ) & mi(enrSchool`month') & missIntEnd[`X']==1 & enroll_since_dli[`X']==1 & mi(beg_1col_date[`X']) &  mi(end_sch_date[`X'])
		* Remaining: enrolled b/t dli and end_sch_date (not currently enrolled)
		by id: replace enrSchool`month' = !inlist( "`month'", "Jul", "Aug") if inrange(mdy(scalar`month',1,year), interview_date[ `X'-missIntEndLength[`X']-1 ], end_sch_date[`X']   ) & mi(enrSchool`month') & missIntEnd[`X']==1 & enroll_since_dli[`X']==1 & mi(beg_1col_date[`X']) & !mi(end_sch_date[`X'])
		* Everything else is 0; includes: times before beg_1col, times b/t col_spells, and time b/t end_sch_date and int_date
		by id: replace enrSchool`month' = 0                                 if inrange(mdy(scalar`month',1,year), interview_date[ `X'-missIntEndLength[`X']-1 ], interview_date[`X'] ) & mi(enrSchool`month') & missIntEnd[`X']==1 & enroll_since_dli[`X']==1                                                
	}
}

*----------------------------------------------------------------------------
* 1979-1994
*  For enroll_since_dli==1
*   Since values for the enroll_status vars are .v in the same year if not
*    enrolled in a month, need to go back and replace them with 0
*   To do this, replace all missings with 0's if:
*    2 consecutives interviews; replace all .v's b/t dates with 0s
*----------------------------------------------------------------------------
foreach month in `months' {
	bys id (year): replace enrSchool`month' = 0 if year>=1980 & enroll_since_dli==1       & missInt[_n-1]==0 & missInt      ==0 & mi(enrSchool`month') & inrange(mdy(scalar`month',1,year), interview_date[_n-1], interview_date)
	bys id (year): replace enrSchool`month' = 0 if year>=1979 & enroll_since_dli[_n+1]==1 & missInt      ==0 & missInt[_n+1]==0 & mi(enrSchool`month') & inrange(mdy(scalar`month',1,year), interview_date, interview_date[_n+1])
	
	* bys id (year): replace enrSchool`month' = 0 if year>=1980 & enroll_since_dli[_n+1]==1 & missInt      ==1 & missInt[_n+1]==0 & mi(enrSchool`month') & inrange(mdy(scalar`month',1,year), mdy(1,1,year) , interview_date[_n+1])
}	

*----------------------------------------------------------------------------
* For periods of missing interview, replace enroll_since_dli with 0 if
*  it is 0 in the interview immediately following the missInt spell
*----------------------------------------------------------------------------
gsort +id -year
by id: replace enroll_since_dli=0 if enroll_since_dli[_n]==.n & enroll_since_dli[_n-1]==0 
sort id year

*----------------------------------------------------------------------------
* 1980-1994
*  For enroll_since_dli==0
*    Use above imputation to replace missing enrSchool vars with 0's 
*----------------------------------------------------------------------------
foreach month in `months' {
	bys id (year): replace enrSchool`month'=0 if year>=1980 & enroll_since_dli      ==0 & missInt==1 & mi(enrSchool`month')
	bys id (year): replace enrSchool`month'=0 if year>=1980 & enroll_since_dli      ==0 & missInt==0 & mi(enrSchool`month') & scalar`month'<=interview_mo
	bys id (year): replace enrSchool`month'=0 if year>=1979 & enroll_since_dli[_n+1]==0 & missInt==0 & mi(enrSchool`month') & scalar`month'> interview_mo
}

* There are still handful of .n's, .v's and .z's that haven't been accounted for.

*============================================================================
* [1.4] Assume students do not go to K12 in the summer months (July, August)
*       before second interview_date (corresponds to beginning of monthly arrays)
*============================================================================
by id: replace enrSchoolJul = 0 if enrSchoolJul==1 & mdy(scalarJul,1,year)<=interview_date[11]
by id: replace enrSchoolAug = 0 if enrSchoolAug==1 & mdy(scalarAug,1,year)<=interview_date[11]

*============================================================================
* [1.5] Create annual school activity status
*============================================================================

* number of months in school by year
egen byte monthsSchool  = rowtotal(enrSchoolJan enrSchoolFeb enrSchoolMar enrSchoolApr enrSchoolMay enrSchoolJun enrSchoolJul enrSchoolAug enrSchoolSep enrSchoolOct enrSchoolNov enrSchoolDec)
lab var monthsSchool "# OF MONTHS ENROLLED IN ANY SCHOOL IN YEAR"

* number of weeks in school by year
gen byte weeksSchool = floor(monthsSchool*52/12)
label var weeksSchool "EST # OF WEEKS ENROLLED IN SCHOOL"

gen byte enrSchool = monthsSchool>=1
label var enrSchool "ANNUAL ENROLLMENT IN ANY SCHOOL"

***************************************************************************
* [2] hgc - Highest grade completed by year
***************************************************************************

*============================================================================
* [2.1] Generate hgc: use highest grade completed as
*  of may 1, survey year. Fill in gaps b/t valid
*  grades with a linear trend (ipolate).
*============================================================================

by id: ipolate high_grade_comp_May year, gen(hgc)
replace hgc = high_grade_comp_May if hgc==.
label var hgc "HIGHEST GRADE COMPLETED"
order hgc, before(enrSchool)

* gen       hgc = high_grade_comp_May
* *-------------------------------------
* * Fill-in hgc for valid skip (hgc==.v)
* *-------------------------------------
* replace hgc = 16 if id==4107 & year==1988

*============================================================================
* [2.2] Hand edit observations that still have .n's and .i's before last duration
*============================================================================
replace hgc=14 if id==1842  & year==1994
replace hgc=0  if id==2681  & year==1987
replace hgc=8  if id==3253  & year==1979
replace hgc=9  if id==3253  & year==1980
replace hgc=0  if id==4241  & year>=1980 & year<=1981
replace hgc=14 if id==4595  & year==1994
replace hgc=14 if id==5102  & year==1994
replace hgc=9  if id==5534  & year==1979
replace enrSchool=1 if id==5534  & year==1979 
replace hgc=12 if id==5957  & year==1994
replace hgc=11 if id==6528  & year>=1986 & year<=1990
replace hgc=12 if id==6877  & year>=1983 & year<=1990
replace hgc=0  if id==7047  &(year==1980 | year==1991)
replace hgc=8  if id==7209  & year>=1991 & year<=1994
replace hgc=10 if id==7291  & year>=1984 & year<=1990
replace hgc=13 if id==7350  & year>=1987 & year<=1990
replace hgc=10 if id==7778  & year>=1985 & year<=1990
replace hgc=9  if id==7807  & year==1990
replace hgc=10 if id==8002  & year==1979
replace hgc=11 if id==8066  & year>=1988 & year<=1990
replace hgc=11 if id==8199  & year>=1984 & year<=1992
replace hgc=10 if id==8261  & year==1979
replace hgc=12 if id==9498  & year>=1988 & year<=1990
replace hgc=20 if id==9590  & year==1990
replace hgc=12 if id==9979  & year>=1985 & year<=1990
replace hgc=18 if id==10276 & year==1990
replace hgc=8  if id==10447 & year>=1987 & year<=1990
replace hgc=10 if id==10460 & year==1990
replace hgc=8  if id==10483 & year>=1984 & year<=1990
replace hgc=9  if id==10485 & year>=1984 & year<=1990
replace hgc=16 if id==10636 & year>=1983 & year<=1984
replace hgc=10 if id==11055 & year==1984
replace hgc=10 if id==11167 & year>=1982 & year<=1984
replace hgc=12 if id==11297 & year==1984
replace hgc=12 if id==12553 & year==1982

* id's 12253, and 12461 are flagged b/c they use fairly large assumptions
* replace hgc=12 if id==12253 & year>=1982 & year<=1988        // stretch
* replace hgc=11 if id==12253 & year==1981                     // stretch
* replace hgc=10 if id==12253 & year==1980                     // stretch
* replace hgc=9  if id==12253 & year==1979                     // stretch
* replace enrSchool = 1 if id==12253 & year>=1980 & year<=1982 // stretch
* replace hgc=12 if id==12461 & year>=1987 & year<=1988
* replace hgc=12 if id==12461 & year>=1979 & year<=1986        // stretch

* some id's with problems (that have hopefully been fixed)
* 74, 600, 1046, 1109, 1309, 2536, 2624, 2904, 3401, 3434, 3521, 4479, 5240, 6282, 6641, 7076, 8005, 8032, 9639 , 11820, 11881, 12106, 12206
* 590, 1643, 1705, 2015, 3253, 3386, 4209, 4388, 4595, 4653, 5534, 5818, 5957, 6282, 6528, 6721, 7778,  BAD -- 12253, 12461

*============================================================================
* [2.3] Other edits
*  Fill in early values, fix decreasing values and recode missings
*============================================================================

* Fill in values for pre-1979
*  Use the enroll_status variable to update hgc
gsort +id -year
by id: replace hgc = ( hgc[_n-1]*(enrSchool[_n]==0) + (hgc[_n-1]-1)*(enrSchool[_n]==1) )*(hgc[_n-1]>0) if year[_n]<=1978
sort id year

* Observations that actually have hgc decrease at one point
by id: replace hgc = hgc[_n-1] if hgc[_n]<hgc[_n-1] & hgc[_n]<. & hgc[_n-1]<.

* Recode all hgc's for individuals missing observations as -9999
*  and for 2 observations that have too many missing hgc
replace hgc = -9999 if hgc>=.
replace hgc = -9999 if id==12253 | id==12461

*****************************************************************************
* [3] Determine graduation/degree completion dates
*   All _yr/_mo converted into _date near top of program
*****************************************************************************

*============================================================================
* [3.1] Use dates of degree reception and school attendance
* 1979-1984, asked when recd college degree, & beg_1col_yr and end_sch_yr
* In 1979-80, date exists
* In 1981-84, date does not exist
*  Assume that if end_sch_yr/mo exists, that is when they recd the degree(s)
*  Assume that if end_sch_yr/mo doesn't exist, they are still in school and
*   thus recd the degree in May (mode of receipt for all degrees)
*============================================================================
replace recd_1degree_date = end_sch_date   if year>=1981 & year<=1984 & type_1degree_recd<. & end_sch_date<.
replace recd_2degree_date = end_sch_date   if year>=1981 & year<=1984 & type_2degree_recd<. & end_sch_date<.

replace recd_1degree_date = interview_date if year>=1981 & year<=1984 & type_1degree_recd<. & end_sch_date>=.
replace recd_2degree_date = interview_date if year>=1981 & year<=1984 & type_2degree_recd<. & end_sch_date>=.

*============================================================================
* [3.2] Get the date that individuals received HS, AA, BA, Grad and Other degrees
*  Use the date associate with the earliest one received, if multiple
*============================================================================
gen     HS_date = recd_diploma_date  if recd_diploma_date<.
replace HS_date = recd_high_deg_date if recd_high_deg_date<. & high_deg_recd==1

* Classify as diploma if ever once reported diploma
by id: egen byte min_diploma_or_ged = min(diploma_or_ged)
gen     Diploma_date = HS_date if min_diploma_or_ged==1 | min_diploma_or_ged==3
gen     GED_date     = HS_date if min_diploma_or_ged==2
replace Diploma_date = HS_date if min_diploma_or_ged==. & HS_date<.

gen     AA_date    = recd_high_deg_date if recd_high_deg_date<. & high_deg_recd==2
replace AA_date    = recd_1degree_date  if recd_1degree_date<.  & type_1degree_recd==2
replace AA_date    = recd_2degree_date  if recd_2degree_date<.  & type_2degree_recd==2

gen     BA_date    = recd_high_deg_date if recd_high_deg_date<. & (high_deg_recd==3 | high_deg_recd==4)
replace BA_date    = recd_1degree_date  if recd_1degree_date<.  & type_1degree_recd==3
replace BA_date    = recd_2degree_date  if recd_2degree_date<.  & type_2degree_recd==3

gen     Grad_date  = recd_high_deg_date if recd_high_deg_date<. & (high_deg_recd==5 | high_deg_recd==6 | high_deg_recd==7)
replace Grad_date  = recd_1degree_date  if recd_1degree_date<.  & type_1degree_recd==5
replace Grad_date  = recd_2degree_date  if recd_2degree_date<.  & type_2degree_recd==5

gen     Other_date = recd_high_deg_date if recd_high_deg_date<. & high_deg_recd==8
replace Other_date = recd_1degree_date  if recd_1degree_date<.  & type_1degree_recd==8
replace Other_date = recd_2degree_date  if recd_2degree_date<.  & type_2degree_recd==8

*-----------------------------------------------------------------------
* Some individuals attain a certain level of degree w/o reporting dates
*  for attaining the requisite lower levels. Correct this.
*-----------------------------------------------------------------------

* Create flags if indiv ever gets HS or BA or Graduate degree
by id: egen temp_HS_flag   = min(HS_date)
by id: egen temp_BA_flag   = min(BA_date)
by id: egen temp_Grad_flag = min(Grad_date)

* For those that ever get a Graduate degree and don't report BA_date:
*  Assume that once completed 16 years of schooling, recd BA
by id: replace BA_date = mdy(5,1,year) if temp_BA_flag>=. & temp_Grad_flag<. & (high_grade_comp_raw[_n]==15 & high_grade_comp_raw[_n+1]==16 & interview_mo<5)
by id: replace BA_date = mdy(5,1,year) if temp_BA_flag>=. & temp_Grad_flag<. & (high_grade_comp_raw[_n]==16 & high_grade_comp_raw[_n+1]>=16 & interview_mo>=5)

* For those that ever get a BA degree and don't report HS_date:
*  Assume that once completed 12 years of schooling, recd HS
by id: replace HS_date      = mdy(5,1,year) if temp_HS_flag>=. & temp_BA_flag<. & (high_grade_comp_raw[_n]==11 & high_grade_comp_raw[_n+1]==12 & interview_mo<5)
by id: replace HS_date      = mdy(5,1,year) if temp_HS_flag>=. & temp_BA_flag<. & (high_grade_comp_raw[_n]==12 & high_grade_comp_raw[_n+1]>=12 & interview_mo>=5)
replace Diploma_date = HS_date if HS_date<. & Diploma_date>=. & GED_date>=.

drop temp_*_flag

*--------------------------------------------------------------------
* For each degree type, change the *_date variables to be in every 
*  period for an invididual rather than just the one in which it was 
*  reported. For those that report multiple dates/degrees of a given
*  degree type, use the earliest date
*--------------------------------------------------------------------

foreach degree in HS Diploma GED AA BA Grad Other {
	by id: egen temp_date = min(`degree'_date)
	replace `degree'_date=temp_date
	drop temp_date
	format `degree'_date %td
}

*------------------------------------------------------------------
* Hand-edits
*------------------------------------------------------------------

* Hand-edit those that remain that ever get a Graduate degree and 
*  don't report BA_date
replace BA_date   = mdy(5,1,1983)  if id==23
replace BA_date   = mdy(5,1,1986)  if id==69
replace BA_date   = mdy(5,1,1985)  if id==1135
replace BA_date   = mdy(5,1,1980)  if id==1504
replace BA_date   = mdy(5,1,1985)  if id==2038
replace BA_date   = mdy(5,1,1986)  if id==2113
replace BA_date   = mdy(5,1,1982)  if id==2139
replace BA_date   = mdy(5,1,1984)  if id==2534
replace BA_date   = mdy(5,1,1985)  if id==2851
replace BA_date   = mdy(5,1,1978)  if id==2915
replace BA_date   = Grad_date      if id==2941
replace Grad_date = mdy(10,1,1992) if id==2941
replace BA_date   = mdy(5,1,1984)  if id==3171
replace BA_date   = Grad_date      if id==3307
replace Grad_date = .              if id==3307
replace BA_date   = mdy(5,1,1979)  if id==3817
replace BA_date   = mdy(5,1,1981)  if id==5170
replace BA_date   = mdy(5,1,1985)  if id==6731
replace BA_date   = mdy(6,1,1986)  if id==7908
replace Grad_date = .              if id==7908
replace Grad_date = .              if id==8168
replace BA_date   = mdy(5,1,1982)  if id==8236
replace BA_date   = mdy(5,1,1979)  if id==8517
replace BA_date   = mdy(5,1,1979)  if id==8821
replace Grad_date = .              if id==9327
replace BA_date   = mdy(5,1,1980)  if id==9346
replace Grad_date = .              if id==11623
replace Grad_date = .              if id==11875
replace BA_date   = mdy(5,1,1985)  if id==11960
replace AA_date   = Grad_date      if id==11987
replace Grad_date = .              if id==11987
replace BA_date   = mdy(5,1,1979)  if id==12045
replace BA_date   = mdy(5,1,1986)  if id==12049
replace BA_date   = mdy(5,1,1979)  if id==12536

* Hand-edit those that remain that ever get a BA degree and 
*  don't report HS_date
replace HS_date   = mdy(5,1,1980) if id==210
replace HS_date   = mdy(5,1,1982) if id==1135
replace HS_date   = mdy(5,1,1979) if id==1144
replace HS_date   = mdy(5,1,1979) if id==2325
replace HS_date   = mdy(5,1,1980) if id==3422
replace HS_date   = mdy(5,1,1982) if id==3450
replace HS_date   = mdy(5,1,1979) if id==4137
replace HS_date   = mdy(5,1,1983) if id==5066
replace HS_date   = mdy(5,1,1976) if id==5590
replace HS_date   = mdy(5,1,1975) if id==5593
replace HS_date   = mdy(5,1,1976) if id==5597
replace HS_date   = mdy(5,1,1980) if id==6731
replace HS_date   = mdy(5,1,1975) if id==7722
replace HS_date   = mdy(5,1,1976) if id==7731
replace HS_date   = mdy(5,1,1976) if id==7762
replace HS_date   = mdy(5,1,1982) if id==8078
replace HS_date   = mdy(5,1,1978) if id==8807
replace HS_date   = mdy(5,1,1980) if id==9045
replace HS_date   = mdy(5,1,1976) if id==9691
replace HS_date   = mdy(5,1,1978) if id==9693
replace HS_date   = mdy(5,1,1976) if id==9694
replace HS_date   = mdy(5,1,1981) if id==10161
replace HS_date   = mdy(5,1,1979) if id==11960
replace HS_date   = mdy(5,1,1979) if id==11999
replace HS_date   = mdy(5,1,1978) if id==12340

* Hand-edit those that remain that ever get a AA degree and 
*  don't report HS_date
replace HS_date   = mdy(5,1,1979) if id==1145
replace HS_date   = mdy(5,1,1981) if id==1160
replace HS_date   = mdy(5,1,1979) if id==1191
replace HS_date   = mdy(5,1,1979) if id==2437
replace HS_date   = mdy(5,1,1982) if id==3191
replace HS_date   = mdy(5,1,1980) if id==3225
replace HS_date   = mdy(5,1,1981) if id==3458
replace HS_date   = mdy(5,1,1981) if id==4529
replace HS_date   = mdy(5,1,1982) if id==4613
replace HS_date   = mdy(5,1,1981) if id==4674
replace HS_date   = mdy(5,1,1981) if id==4840
replace HS_date   = mdy(5,1,1981) if id==4739
replace HS_date   = mdy(5,1,1978) if id==11967
replace HS_date   = mdy(5,1,1980) if id==1166 


* replace HS_date   = mdy(5,1,19) if id==2536 
* replace HS_date   = mdy(5,1,19) if id==5361 
* replace HS_date   = mdy(5,1,19) if id==6889 
* replace HS_date   = mdy(5,1,19) if id==8094 


* Other hand-edits
replace BA_date      = mdy(2,1,1983)  if id==910
replace BA_date      = .              if id==1037
replace Grad_date    = mdy(5,1,1985)  if id==2068
replace HS_date      = mdy(5,1,1974)  if id==2915
replace Diploma_date = mdy(5,1,1974)  if id==2915
replace Grad_date    = mdy(8,1,1983)  if id==3146
replace BA_date      = mdy(12,1,1978) if id==4255
replace BA_date      = .              if id==5264
replace BA_date      = .              if id==5718
replace BA_date      = .              if id==5976
replace Grad_date    = mdy(5,1,1986)  if id==9695
replace BA_date      = mdy(5,1,1984)  if id==9959
replace BA_date      = .              if id==11201

* * Hand edit those that get 15 or more years of school but don't report HS_date
replace HS_date   = mdy(5,1,1979) if id==1234
replace HS_date   = mdy(5,1,1979) if id==2756
replace HS_date   = mdy(5,1,1979) if id==3880
replace HS_date   = mdy(5,1,1980) if id==10123
replace HS_date   = mdy(5,1,1980) if id==10407
replace HS_date   = mdy(5,1,1979) if id==11964

* Hand edit those that get 19 or more years of school but don't report BA_date
replace BA_date   = mdy(5,1,1985) if id==2465
replace BA_date   = mdy(5,1,1985) if id==6842
replace BA_date   = mdy(5,1,1984) if id==9375
replace BA_date   = mdy(5,1,1985) if id==11418
replace BA_date   = mdy(5,1,1981) if id==12469

replace Diploma_date = HS_date if HS_date<. & Diploma_date>=. & GED_date>=.

* Generate annual and monthly graduation variables
foreach degree in HS Diploma GED AA BA Grad Other {
	gen `degree'_month = month( `degree'_date)
	gen `degree'_year  = year( `degree'_date)
}

*============================================================================
* [3.3] Generate absorbing dummies that turn on (and stay on)
*  in the year that the degree was awarded
*============================================================================

gen byte gradHS       = (year>=HS_year     )
gen byte gradDiploma  = (year>=Diploma_year)
gen byte gradGED      = (year>=GED_year    )
gen byte grad2yr      = (year>=AA_year     )
gen byte grad4yr      = (year>=BA_year     )
gen byte gradGraduate = (year>=Grad_year   )

gen byte yrGradHS       = (year==HS_year     )
gen byte yrGradDiploma  = (year==Diploma_year)
gen byte yrGradGED      = (year==GED_year    )
gen byte yrGrad2yr      = (year==AA_year     )
gen byte yrGrad4yr      = (year==BA_year     )
gen byte yrGradGraduate = (year==Grad_year   )

by id: egen byte everHS       = max(gradHS)
by id: egen byte everDiploma  = max(gradDiploma)
by id: egen byte everGED      = max(gradGED)
by id: egen byte ever2yr      = max(grad2yr)
by id: egen byte ever4yr      = max(grad4yr)
by id: egen byte everGraduate = max(gradGraduate)

*****************************************************************************
* [4] Break out monthly enrollment: enrK12, enrCollege, enrGradSch
* K12     if (before HS_date or HS_date is missing)
* College if  after HS_date and HS_date is NOT missing and (before BA_date or if BA_date is missing)
* GradSch if  after HS_date and HS_date is NOT missing and  after BA_date and BA_date is NOT missing
*****************************************************************************

foreach month in `months' {
	gen byte preHSflag`month'  = (HS_date<.) & (year< year(HS_date) | (year==year(HS_date) & scalar`month'<=month(HS_date)))
	gen byte missHSflag`month' = (HS_date>=.)
	gen byte preBAflag`month'  = (BA_date<.) & (year< year(BA_date) | (year==year(BA_date) & scalar`month'<=month(BA_date)))
	gen byte missBAflag`month' = (BA_date>=.)
}
foreach month in `months' {
	gen byte enrK12`month'     = enrSchool`month' *( preHSflag`month' | missHSflag`month')
	replace  enrK12`month'     = enrSchool`month' if mi(enrSchool`month')
}
foreach month in `months' {
	gen byte enrCollege`month' = enrSchool`month' *(~preHSflag`month' & ~missHSflag`month' & (preBAflag`month' | missBAflag`month'))
	replace  enrCollege`month' = enrSchool`month' if mi(enrSchool`month')
}
foreach month in `months' {
	gen byte enrGradSch`month' = enrSchool`month' *(~preHSflag`month' & ~missHSflag`month' & ~preBAflag`month' & ~missBAflag`month')
	replace  enrGradSch`month' = enrSchool`month' if mi(enrSchool`month')
}
* Redefine enrCollege to include GradSch
foreach month in `months' {
	replace enrCollege`month' = 1 if enrGradSch`month'==1
}

* Any individual that has hgc>=13 and no HS graduation date and is enrolled
*  in school is assumed to be in error; no evidence of them ever grad HS.
foreach month in `months' {
	gen byte collegeflag2`month' = (missHSflag`month') & (hgc>=13) & (enrSchool`month'==1)
	gen lastValidSchoolDateA`month' = mdy(scalar`month',1,year) if collegeflag2`month'
	bys id (year): egen lastValidSchoolDate`month' = min(lastValidSchoolDateA`month')
}

egen   lastValidSchoolDate = rowmin(lastValidSchoolDateJan lastValidSchoolDateFeb lastValidSchoolDateMar lastValidSchoolDateApr lastValidSchoolDateMay lastValidSchoolDateJun lastValidSchoolDateJul lastValidSchoolDateAug lastValidSchoolDateSep lastValidSchoolDateOct lastValidSchoolDateNov lastValidSchoolDateDec)
format lastValidSchoolDate %td

*============================================================================
* [4.1] Create annual school activity status
*============================================================================

* number of months and weeks in school by year
egen     monthsK12     = rowtotal(enrK12Jan enrK12Feb enrK12Mar enrK12Apr enrK12May enrK12Jun enrK12Jul enrK12Aug enrK12Sep enrK12Oct enrK12Nov enrK12Dec)
egen     monthsCollege = rowtotal(enrCollegeJan enrCollegeFeb enrCollegeMar enrCollegeApr enrCollegeMay enrCollegeJun enrCollegeJul enrCollegeAug enrCollegeSep enrCollegeOct enrCollegeNov enrCollegeDec)
egen     monthsGradSch = rowtotal(enrGradSchJan enrGradSchFeb enrGradSchMar enrGradSchApr enrGradSchMay enrGradSchJun enrGradSchJul enrGradSchAug enrGradSchSep enrGradSchOct enrGradSchNov enrGradSchDec)
gen      weeksK12      = floor(monthsK12*52/12)
gen      weeksCollege  = floor(monthsCollege*52/12)
gen      weeksGradSch  = floor(monthsGradSch*52/12)
gen byte enrK12        = monthsK12>=1
gen byte enrCollege    = monthsCollege>=1
gen byte enrGradSch    = monthsGradSch>=1

lab var monthsK12     "# OF MONTHS ENROLLED IN ANY K12 IN YEAR"
lab var monthsCollege "# OF MONTHS ENROLLED IN ANY COLLEGE IN YEAR"
lab var monthsGradSch "# OF MONTHS ENROLLED IN ANY GRADSCH IN YEAR"
lab var weeksK12      "# OF WEEKS ENROLLED IN ANY K12 IN YEAR"
lab var weeksCollege  "# OF WEEKS ENROLLED IN ANY COLLEGE IN YEAR"
lab var weeksGradSch  "# OF WEEKS ENROLLED IN ANY GRADSCH IN YEAR"
lab var enrK12        "ENROLLED AT LEAST ONE MONTH IN K12"
lab var enrCollege    "ENROLLED AT LEAST ONE MONTH IN COLLEGE"
lab var enrGradSch    "ENROLLED AT LEAST ONE MONTH IN GRADSCH"

