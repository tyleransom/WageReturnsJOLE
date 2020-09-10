****************************************************************************
* Create variables work status, armed forces status and wage
*  as well occupation and industries associated with wage vars and
*  activity variables
*
* Searchable ToC
* [1] Macros and such
* [2] Initial cleaning
* [3] Fill-in pre1978 weekly employment info
* [4] Create job index; lists job id and relevant stats
* [5] Create variables for weeks worked, hours worked, and military
* [5.1] Weeks Worked
* [5.2] Hours Worked
* [5.3] Weeks Military
* [6] Match wages, occupation, and industry
* [6.1] Clean wages: deflate, combine
* [6.2] Calculate wages
* [6.3] Occupation and industry categorical variables
* [7] Supplement work history weekly arrays with weeks_worked_recall
* [8] Create primary activity variable                           
****************************************************************************

****************************************************************************
* [1] Macros and such
*****************************************************************************

local months Jan Feb Mar Apr May Jun Jul Aug Sep Oct Nov Dec

local rangeJan = "1/4"
local rangeFeb = "5/8"
local rangeMar = "9/13"
local rangeApr = "14/17"
local rangeMay = "18/22"
local rangeJun = "23/26"
local rangeJul = "27/31"
local rangeAug = "32/35"
local rangeSep = "36/39"
local rangeOct = "40/44"
local rangeNov = "45/48"
local rangeDec = "49/52"
local rangeDecAlt = "49/53"

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

gen byte numWeeksJan = 4
gen byte numWeeksFeb = 4
gen byte numWeeksMar = 5
gen byte numWeeksApr = 4
gen byte numWeeksMay = 5
gen byte numWeeksJun = 4
gen byte numWeeksJul = 5
gen byte numWeeksAug = 4
gen byte numWeeksSep = 4
gen byte numWeeksOct = 5
gen byte numWeeksNov = 4
gen byte numWeeksDec = 4
replace numWeeksDec = 5 if inlist(year,1978, 1984, 1989, 1995, 2000, 2006, 2012)

*****************************************************************************
* [2] Initial cleaning
*****************************************************************************

*============================================================================
* Mapping between job_current and job1-job5
* Matches based on which entries have missing values 
* IS THERE A BETTER MAPPING POSSIBLE????
*
* Note on var names: job1-job5 and job_current:
*   http://www.nlsinfo.org/nlsy79/docs/79html/79text/jobsemps.htm
*    This codebook states that:
*    "Every employer for whom a respondent worked since the last interview, 
*    including the CPS employer, is identified within the data set by a 
*    yearly job number, for example, Job #1, Job #5, with the number 
*    reflecting the order in which the job was reported."
*   The yearly job number is just a mapping between the years
*    1979-1994 and the numbers 1-16. What this enables is that
*    anytime the number "801" appears, it refers to job 1 in year
*    8, aka 1986.
*============================================================================

gen byte job_current= 0
forvalues X=5(-1)1 {
	replace job_current= `X' if wage_job_current<. & wage_job_current==wage_job`X' & (occupation_job`X'>=. | industry_job`X'>=. | hrs_per_wk_job`X'>=.)
}
forvalues X=1(1)5 {
	replace job_current= `X' if wage_job_current<. & wage_job_current==wage_job`X' & job_current==0 & occupation_job_current==occupation_job`X' & industry_job_current==industry_job`X' & hrs_per_wk_job_current==hrs_per_wk_job`X'
}
forvalues X=1(1)5 {
	replace job_current= `X' if wage_job_current<. & wage_job_current==wage_job`X' & job_current==0 & year==1994 // this is for consistency sake
}

*============================================================================
* Occupation/Industry
*   -Many occupation/industry codes are stored in the job_current
*    field instead of the job1-job5 field. Impute current into 1-5.
*   -Occupation and industry codes for job1 in 1993 and job_current for 1994
*    use the 1980 Census classification. The values for the respective yrs are in:
*        occupation_job_80census
*        industry_job_80census
*   Various sources state that mapping b/t the 70s and 80s census codes is
*   sketchy at best. Thus, these values will not be used, which means for
*   1993 only job_current is used and for 1994 only job1 is used.
*  EDIT: JA, 1/2019, the current variables seem to be coded up for 70s up
*   until 2002, in which they're coded for 2000s, so comment the below out...
*============================================================================

* * Overwrite 1993 missing values (.) with (.z)
* qui replace occupation_job1      = .z              if year==1993 & occupation_job1==.
* qui replace industry_job1        = .z              if year==1993 & industry_job1==.

* * Fill in missing occupation and industry codes for job1-job5
* *      with valid occupation and industry codes in job_current for years <=1993
* forvalues X=1/5 {
	* qui replace occupation_job`X' = occupation_job_current if occupation_job_current<. & occupation_job`X'>=. & job_current==`X' & year<=1993
	* qui replace industry_job`X'   = industry_job_current   if industry_job_current  <. & industry_job`X'  >=. & job_current==`X' & year<=1993
* }

*============================================================================
* Hrs Per Week
*   -Often hrs per week is stored in current job instead of job#,
*    but mostly it is in both????
*============================================================================

forvalues X=1/5 {
	qui replace hrs_per_wk_job`X' = hrs_per_wk_job_current if hrs_per_wk_job_current<. & hrs_per_wk_job`X'>=. & job_current==`X'
	qui replace class_job`X'      = class_job_current      if class_job_current<.      & class_job`X'>=.      & job_current==`X'
}

*============================================================================
* Dual jobs cleanup
*============================================================================

* There are some instances where the same job_id appears
* in the same week but in different 'dual job' variables.
* Replace all duplicates with missings (.z)
forvalues X=1/53 {
    qui replace job_number5_wk`X' = .z if job_number5_wk`X'<. & (job_number5_wk`X'==labor_force_status_wk`X' | job_number5_wk`X'==job_number2_wk`X' | job_number5_wk`X'==job_number3_wk`X' | job_number5_wk`X'==job_number4_wk`X')
	qui replace job_number4_wk`X' = .z if job_number4_wk`X'<. & (job_number4_wk`X'==labor_force_status_wk`X' | job_number4_wk`X'==job_number2_wk`X' | job_number4_wk`X'==job_number3_wk`X')
	qui replace job_number3_wk`X' = .z if job_number3_wk`X'<. & (job_number3_wk`X'==labor_force_status_wk`X' | job_number3_wk`X'==job_number2_wk`X')
	qui replace job_number2_wk`X' = .z if job_number2_wk`X'<. & (job_number2_wk`X'==labor_force_status_wk`X') 
}

*****************************************************************************
* [3] Fill in pre 1978 weekly job history (yes, I said weekly)
*     Use start/stop dates of first job_after_sch and job1-job5 to determine
*     the months individuals were working
*     Then make the light(?) assumption that they worked every week during that 
*     month.
*****************************************************************************

*============================================================================
* Create jobFlag variables that store the job number. These are essentially
*  dummies but instead of being 0,1, they are missing,jobnumber (i.e., ./101)
*============================================================================

* Create date vars for early jobs. Only use date vars that have valid begin and end.
gen     beg_job_after_sch_date = mdy(beg_job_after_sch_mo,1,beg_job_after_sch_yr) if !mi(beg_job_after_sch_yr) & !mi(beg_job_after_sch_mo) & !mi(end_job_after_sch_yr) & !mi(end_job_after_sch_mo)
gen     end_job_after_sch_date = mdy(end_job_after_sch_mo,1,end_job_after_sch_yr) if !mi(beg_job_after_sch_yr) & !mi(beg_job_after_sch_mo) & !mi(end_job_after_sch_yr) & !mi(end_job_after_sch_mo)

foreach month in `months' {

	by id: gen     jobFlag0`month' = 100 if inrange( mdy(scalar`month',1,year) ,  beg_job_after_sch_date[10] ,  min( end_job_after_sch_date[10], mdy(12,31,1977))  ) & !mi(beg_job_after_sch_date[10])

	* by id: gen     jobFlag0`month' = 100 if beg_job_after_sch_yr[10]==year & beg_job_after_sch_mo[10]<=scalar`month' & ( end_job_after_sch_yr[10]>year | (end_job_after_sch_yr[10]==year & end_job_after_sch_mo[10]>=scalar`month')) & year<=1977
	* by id: replace jobFlag0`month' = 100 if beg_job_after_sch_yr[10]< year & end_job_after_sch_yr[10]> year & year<=1977
	* by id: replace jobFlag0`month' = 100 if beg_job_after_sch_yr[10]< year & end_job_after_sch_yr[10]==year & end_job_after_sch_mo[10]>=scalar`month' & year<=1977

	by id: gen     jobFlag1`month' = 101 if beg_1job_yr[10]==year & beg_1job_mo[10]<=scalar`month' & ( end_1job_yr[10]>year | (end_1job_yr[10]==year & end_1job_mo[10]>=scalar`month')) & year<=1977
	by id: replace jobFlag1`month' = 101 if beg_1job_yr[10]< year & end_1job_yr[10]> year & year<=1977
	by id: replace jobFlag1`month' = 101 if beg_1job_yr[10]< year & end_1job_yr[10]==year & end_1job_mo[10]>=scalar`month' & year<=1977
	
	by id: gen     jobFlag2`month' = 102 if beg_2job_yr[10]==year & beg_2job_mo[10]<=scalar`month' & ( end_2job_yr[10]>year | (end_2job_yr[10]==year & end_2job_mo[10]>=scalar`month')) & year<=1977
	by id: replace jobFlag2`month' = 102 if beg_2job_yr[10]< year & end_2job_yr[10]> year & year<=1977
	by id: replace jobFlag2`month' = 102 if beg_2job_yr[10]< year & end_2job_yr[10]==year & end_2job_mo[10]>=scalar`month' & year<=1977
	
	by id: gen     jobFlag3`month' = 103 if beg_3job_yr[10]==year & beg_3job_mo[10]<=scalar`month' & ( end_3job_yr[10]>year | (end_3job_yr[10]==year & end_3job_mo[10]>=scalar`month')) & year<=1977
	by id: replace jobFlag3`month' = 103 if beg_3job_yr[10]< year & end_3job_yr[10]> year & year<=1977
	by id: replace jobFlag3`month' = 103 if beg_3job_yr[10]< year & end_3job_yr[10]==year & end_3job_mo[10]>=scalar`month' & year<=1977
	
	by id: gen     jobFlag4`month' = 104 if beg_4job_yr[10]==year & beg_4job_mo[10]<=scalar`month' & ( end_4job_yr[10]>year | (end_4job_yr[10]==year & end_4job_mo[10]>=scalar`month')) & year<=1977
	by id: replace jobFlag4`month' = 104 if beg_4job_yr[10]< year & end_4job_yr[10]> year & year<=1977
	by id: replace jobFlag4`month' = 104 if beg_4job_yr[10]< year & end_4job_yr[10]==year & end_4job_mo[10]>=scalar`month' & year<=1977
	
	by id: gen     jobFlag5`month' = 105 if beg_5job_yr[10]==year & beg_5job_mo[10]<=scalar`month' & ( end_5job_yr[10]>year | (end_5job_yr[10]==year & end_5job_mo[10]>=scalar`month')) & year<=1977
	by id: replace jobFlag5`month' = 105 if beg_5job_yr[10]< year & end_5job_yr[10]> year & year<=1977
	by id: replace jobFlag5`month' = 105 if beg_5job_yr[10]< year & end_5job_yr[10]==year & end_5job_mo[10]>=scalar`month' & year<=1977
}

* foreach month in `months' {
* by id: gen     jobberFlag0`month' = 100 if inrange( mdy(scalar`month',1,year) ,  beg_job_after_sch_date[10] ,  min( end_job_after_sch_date[10], mdy(12,31,1977))  ) & !mi(beg_job_after_sch_date[10])
* by id: gen     jobberFlag1`month' = 101 if inrange( mdy(scalar`month',1,year) ,  mdy(beg_1job_mo[10],1,beg_1job_yr[10]) ,  min( mdy(end_1job_mo[10],1,end_1job_yr[10]), mdy(12,31,1977))  ) & !mi(beg_1job_yr[10]) & !mi(beg_1job_mo[10])
* by id: gen     jobberFlag2`month' = 102 if inrange( mdy(scalar`month',1,year) ,  mdy(beg_2job_mo[10],1,beg_2job_yr[10]) ,  min( mdy(end_2job_mo[10],1,end_2job_yr[10]), mdy(12,31,1977))  ) & !mi(beg_2job_yr[10]) & !mi(beg_2job_mo[10])
* by id: gen     jobberFlag3`month' = 103 if inrange( mdy(scalar`month',1,year) ,  mdy(beg_3job_mo[10],1,beg_3job_yr[10]) ,  min( mdy(end_3job_mo[10],1,end_3job_yr[10]), mdy(12,31,1977))  ) & !mi(beg_3job_yr[10]) & !mi(beg_3job_mo[10])
* by id: gen     jobberFlag4`month' = 104 if inrange( mdy(scalar`month',1,year) ,  mdy(beg_4job_mo[10],1,beg_4job_yr[10]) ,  min( mdy(end_4job_mo[10],1,end_4job_yr[10]), mdy(12,31,1977))  ) & !mi(beg_4job_yr[10]) & !mi(beg_4job_mo[10])
* by id: gen     jobberFlag5`month' = 105 if inrange( mdy(scalar`month',1,year) ,  mdy(beg_5job_mo[10],1,beg_5job_yr[10]) ,  min( mdy(end_5job_mo[10],1,end_5job_yr[10]), mdy(12,31,1977))  ) & !mi(beg_5job_yr[10]) & !mi(beg_5job_mo[10])
* }

* It's possible that the 'job_after_sch' is the same as job1-job5
* Unclear if there's a way to verify this. As such, assume perfect overlap 
* and only use info from 'job_after_sch' if there is no job info for job1-job5.
* foreach month in `months' {
	* replace jobFlag0`month'=. if jobFlag1`month'<. | jobFlag2`month'<. | jobFlag3`month'<. | jobFlag4`month'<. | jobFlag5`month'<.
* }

*============================================================================
* Now, collapse the jobs and create vars employer1-employer3 for each month
*  that contain the job number of the employers (3 is the max; this is 
*  checked by the assert statement below)
*============================================================================

foreach month in `months' {
	forvalues X = 0/5 {
		gen temp`X' = jobFlag`X'`month'
	}
	
	egen    temp_min = rowmin(temp0-temp5)
	gen     employer1`month' = temp_min
	forvalues X = 0/5 {
		replace temp`X'=.z if temp`X'==temp_min & temp_min>0
	}
	drop temp_min
	
	egen    temp_min = rowmin(temp0-temp5)
	gen     employer2`month' = temp_min
	forvalues X = 0/5 {
		replace temp`X'=.z if temp`X'==temp_min & temp_min>0
	}
	drop temp_min
	
	egen    temp_min = rowmin(temp0-temp5)
	gen     employer3`month' = temp_min
	forvalues X = 0/5 {
		replace temp`X'=.z if temp`X'==temp_min & temp_min>0
		assert temp`X'>=.
	}
	drop temp_min temp0-temp5
}

*============================================================================
* Fill in the weekly arrays
*  Put the 3 employer id's in any given month in the first 3 job 
*  history variables each week of that month
*============================================================================

foreach month in `months' {
	forvalues X = `range`month'' {
		replace labor_force_status_wk`X' = employer1`month' if employer1`month'<.
		replace job_number2_wk`X'        = employer2`month' if employer2`month'<.
		replace job_number3_wk`X'        = employer3`month' if employer3`month'<.
	}
}

*****************************************************************************
* [4] Create job index that matches job number to job characteristics
*     and then merge back in
*****************************************************************************
 
*============================================================================
* Create a dataset that contains all of the wage, occ and ind data
*  matched by the job_id number.
* Add on job 100 to refer to the "1st job after school" job
*============================================================================

preserve

forvalues Z=1/5 {
	gen     job`Z' = (year-1978)*100+`Z' if !missInt & year>=1979 & /// 
	                 (wage_job`Z'<. | wage_alt_job`Z'<. | occupation_job`Z'<. | industry_job`Z'<. | payrate_job`Z'<. | time_payrate_job`Z'<. | hrs_per_wk_job`Z'<.)
}

* Adding in job id 100 - use 1977 to store data since it's empty for these variables
*  Note that this is still within the preserve statement, this is just a placeholder
replace job1 = 100 if beg_job_after_sch_yr<. & year==1977
replace industry_job1     = industry_job_after_sch1979     if year==1977
replace occupation_job1   = occupation_job_after_sch1979   if year==1977
replace hrs_per_wk_job1   = hrs_wk_job_after_sch1979       if year==1977
gen     hrs_per_day_job1  = hrs_day_job_after_sch1979      if year==1977
replace payrate_job1      = payrate_job_after_sch1979      if year==1977
replace time_payrate_job1 = time_payrate_job_after_sch1979 if year==1977
replace class_job1        = .z                             if year==1977

* Create wage for job id 100 from payrate data
replace wage_job1 = payrate_job1                       if time_payrate_job1 == 1 & year==1977
replace wage_job1 = payrate_job1/hrs_per_day_job1      if time_payrate_job1 == 2 & year==1977
replace wage_job1 = payrate_job1/hrs_per_wk_job1       if time_payrate_job1 == 3 & year==1977
replace wage_job1 = payrate_job1/(2*hrs_per_wk_job1)   if time_payrate_job1 == 4 & year==1977
replace wage_job1 = payrate_job1/(4.3*hrs_per_wk_job1) if time_payrate_job1 == 5 & year==1977
replace wage_job1 = payrate_job1/(52*hrs_per_wk_job1)  if time_payrate_job1 == 6 & year==1977
replace wage_job1 = payrate_job1                       if time_payrate_job1 == 7 & year==1977

keep id year job1-job5 wage_job1-wage_job5 wage_alt_job1-wage_alt_job5 occupation_job1-occupation_job5 industry_job1-industry_job5 payrate_job1-payrate_job5 time_payrate_job1-time_payrate_job5 hrs_per_wk_job1-hrs_per_wk_job5 class_job1-class_job5
order id year job1-job5
reshape long job wage_job wage_alt_job occupation_job industry_job payrate_job time_payrate_job hrs_per_wk_job class_job, i(id year) j(job_number)
keep if job<.
drop job_number year
save y79_job_index, replace
restore

*============================================================================
* Generate a job_id variable that lists each job held
* in a given year. Doing this has shown that the
* largest number of jobs in a given year is 11.
*============================================================================

* Gen temp var to copy in labor_force_status_wk and job_number#_wk
* Turn all non-work periods into .z
forvalues X=1/53 {
	gen temp_wk`X'=labor_force_status_wk`X'
	qui replace temp_wk`X'=.z if temp_wk`X'<10 | temp_wk`X'>=.
}
forvalues X=1/53 {
	scalar Z = `X'+53 // causes temp_wk to go from 54-106
	local W = Z
	gen temp_wk`W'=job_number2_wk`X'
	qui replace temp_wk`W'=.z if temp_wk`W'>=.
}
forvalues X=1/53 {
	scalar Z = `X'+2*53 // causes temp_wk to go from 107-159
	local W = Z
	gen temp_wk`W'=job_number3_wk`X'
	qui replace temp_wk`W'=.z if temp_wk`W'>=.
}
forvalues X=1/53 {
	scalar Z = `X'+3*53 // causes temp_wk to go from 160-212
	local W = Z
	gen temp_wk`W'=job_number4_wk`X'
	qui replace temp_wk`W'=.z if temp_wk`W'>=.
}
forvalues X=1/53 {
	scalar Z = `X'+4*53 // causes temp_wk to go from 213-265
	local W = Z
	gen temp_wk`W'=job_number5_wk`X'
	qui replace temp_wk`W'=.z if temp_wk`W'>=.
}

* Finds the rowmin of the labor_force_status which
* is the job id of the lowest job #. Then replaces all
* values that equal the rowmin with .z, and then repeats
* finding the next rowmin.
forvalues Y=1/11 {
	disp c(current_time)
    egen temp_min = rowmin(temp_wk1-temp_wk265)
	gen job_id`Y'=temp_min
	forvalues X=1/265 {
		qui replace temp_wk`X'=.z if temp_wk`X'==temp_min & temp_min>0
	}
	drop temp_min
}

* Check all values are now coded .z and drop temp_wks
forvalues X=1/265 {
	assert temp_wk`X'==.z
	drop   temp_wk`X'
}

order id year dob_mo1979 dob_yr1979 race_screen sex job_id1-job_id11

*============================================================================
* Create simple annual flag for whether on not the
*  respondent participated in a work-study program in year
*============================================================================

forvalues W = 1/4 {
	gen temp`W'work = (beg_`W'work_study_pre1978_yr>=year) & (end_`W'work_study_pre1978_yr<=year) & (year<=1978)
}
egen workStudy = rowmax(temp1work-temp4work)
drop temp1work-temp4work
lab var workStudy "PARTICIPATED IN SOME WORK STUDY IN YEAR"

*============================================================================
* Merge jobs into the previously created job_index file
*============================================================================
forvalues Y=1/11 {
	preserve
	use y79_job_index, clear
	rename job                   job_id`Y'
	rename wage_job              wage_id`Y'
	rename wage_alt_job          wage_alt_id`Y'
	rename occupation_job        occupation_id`Y'
	rename industry_job          industry_id`Y'
	rename payrate_job           payrate_id`Y'
	rename time_payrate_job      time_payrate_id`Y'
	rename hrs_per_wk_job        hrs_per_wk_id`Y'
	rename class_job             class_id`Y'
	tempfile holder1
	save `holder1', replace
	restore
	
	merge m:1 id job_id`Y' using `holder1'
	drop if _merge==2
	drop _merge
}

order id year dob_mo1979 dob_yr1979 race_screen sex job_id1-job_id11 wage_id1 wage_id2 wage_id3 wage_id4 wage_id5 wage_id6 wage_id7 wage_id8 wage_id9 wage_id10 wage_id11 wage_alt_id1 wage_alt_id2 wage_alt_id3 wage_alt_id4 wage_alt_id5 wage_alt_id6 wage_alt_id7 wage_alt_id8 wage_alt_id9 wage_alt_id10 wage_alt_id11 occupation_id1 occupation_id2 occupation_id3 occupation_id4 occupation_id5 occupation_id6 occupation_id7 occupation_id8 occupation_id9 occupation_id10 occupation_id11 industry_id1 industry_id2 industry_id3 industry_id4 industry_id5 industry_id6 industry_id7 industry_id8 industry_id9 industry_id10 industry_id11 payrate_id1 payrate_id2 payrate_id3 payrate_id4 payrate_id5 payrate_id6 payrate_id7 payrate_id8 payrate_id9 payrate_id10 payrate_id11 time_payrate_id1 time_payrate_id2 time_payrate_id3 time_payrate_id4 time_payrate_id5 time_payrate_id6 time_payrate_id7 time_payrate_id8 time_payrate_id9 time_payrate_id10 time_payrate_id11 hrs_per_wk_id1 hrs_per_wk_id2 hrs_per_wk_id3 hrs_per_wk_id4 hrs_per_wk_id5 hrs_per_wk_id6 hrs_per_wk_id7 hrs_per_wk_id8 hrs_per_wk_id9 hrs_per_wk_id10 hrs_per_wk_id11 class_id1 class_id2 class_id3 class_id4 class_id5 class_id6 class_id7 class_id8 class_id9 class_id10 class_id11 


*****************************************************************************
* [5] Create variables for weeks worked, hours worked, military, and 
*     self-employed
*****************************************************************************

*============================================================================
* [5.1] Weeks Worked
*============================================================================

*---------
* Weekly
*---------

* Weekly dummies for if someone was with a particular employer 
*   >10 is the ID; 3 is 'missing' ID; dual jobs only have ID's
foreach X of numlist 1/53 {
	qui gen     workedWeek`X' = ( labor_force_status_wk`X' == 3 | (labor_force_status_wk`X' >10 & labor_force_status_wk`X'< .) | job_number2_wk`X'<. | job_number3_wk`X'<. | job_number4_wk`X'<. | job_number5_wk`X'<. )
	qui replace workedWeek`X' = . if labor_force_status_wk`X'==.
}
* Weekly dummies for if someone was in the labor force (Worked; or Unemployed==4)
foreach X of numlist 1/53 {
	qui gen laborForceWeek`X' = (workedWeek`X' | labor_force_status_wk`X' == 4)
	qui replace laborForceWeek`X' = . if labor_force_status_wk`X'==.
}

*----------
* Monthly
*----------

egen weeksWorkedJan = rowtotal(workedWeek1  workedWeek2  workedWeek3  workedWeek4              )
egen weeksWorkedFeb = rowtotal(workedWeek5  workedWeek6  workedWeek7  workedWeek8              )
egen weeksWorkedMar = rowtotal(workedWeek9  workedWeek10 workedWeek11 workedWeek12 workedWeek13)
egen weeksWorkedApr = rowtotal(workedWeek14 workedWeek15 workedWeek16 workedWeek17             )
egen weeksWorkedMay = rowtotal(workedWeek18 workedWeek19 workedWeek20 workedWeek21 workedWeek22)
egen weeksWorkedJun = rowtotal(workedWeek23 workedWeek24 workedWeek25 workedWeek26             )
egen weeksWorkedJul = rowtotal(workedWeek27 workedWeek28 workedWeek29 workedWeek30 workedWeek31)
egen weeksWorkedAug = rowtotal(workedWeek32 workedWeek33 workedWeek34 workedWeek35             )
egen weeksWorkedSep = rowtotal(workedWeek36 workedWeek37 workedWeek38 workedWeek39             )
egen weeksWorkedOct = rowtotal(workedWeek40 workedWeek41 workedWeek42 workedWeek43 workedWeek44)
egen weeksWorkedNov = rowtotal(workedWeek45 workedWeek46 workedWeek47 workedWeek48             )
egen weeksWorkedDec = rowtotal(workedWeek49 workedWeek50 workedWeek51 workedWeek52 workedWeek53)

*----------
* Annual
*----------

* From weekly labor status vars
egen    annualWeeksWorkedCalc = rowtotal(workedWeek1-workedWeek53) if year>=1978 & year<=1994
replace annualWeeksWorkedCalc = 52 if annualWeeksWorkedCalc==53 // for consistency

* Use calc weeks worked, unless missing, in which case use svy
gen     annualWeeksWorked = annualWeeksWorkedCalc 
replace annualWeeksWorked = weeks_worked_annual_svy if (annualWeeksWorkedCalc==0 | annualWeeksWorkedCalc>=.) & year>=1978 & year<=1994
replace annualWeeksWorked = weeks_worked_recall     if year>=1975 & year<=1977
replace annualWeeksWorked = 0 if annualWeeksWorked>=. & year<=1977

*----------------
* Other measures
*----------------

* Weeks in Labor Force - Note, no unemployment data pre 1978
egen weeksLabForce = rowtotal(laborForceWeek1-laborForceWeek53) if year>=1978 & year<=1994
replace weeksLabForce = 52 if weeksLabForce>=53 & weeksLabForce<. // for consistency
recode weeksLabForce (. = 0) if year<=1977

* Weeks Unemployed (in LF)
gen weeksUnemployed = weeksLabForce - annualWeeksWorked

* Weeks associated with an employer but no ID
gen weeksAssocEmployer = 0 
forvalues X=1/53 {
	qui replace weeksAssocEmployer = weeksAssocEmployer + (labor_force_status_wk`X'==3)
}

* Weeks worked per job and most weeks for a job
forvalues Y=1/11 {
	gen weeksWorked_id`Y' = 0
	forvalues X = 1/53 {
		qui replace weeksWorked_id`Y' = weeksWorked_id`Y' + (labor_force_status_wk`X'==job_id`Y' & job_id`Y'<.) + (job_number2_wk`X'==job_id`Y' & job_id`Y'<.) + (job_number3_wk`X'==job_id`Y' & job_id`Y'<.) + (job_number4_wk`X'==job_id`Y' & job_id`Y'<.) + (job_number5_wk`X'==job_id`Y' & job_id`Y'<.)
	}
	qui replace weeksWorked_id`Y' = 52 if weeksWorked_id`Y'==53
	qui replace weeksWorked_id`Y' = .z if year<1978 | year>1994
}
egen mostWeeksWorked = rowmax(weeksWorked_id1-weeksWorked_id11)

*============================================================================
* [5.2] Hours Worked
*============================================================================

*----------
* Weekly
*----------

* 2 vars - (1) the NLS created var hrs_all_jobs_wk`X'
*          (2) create hoursWorkedCalc`X' which adds up the hours
*              worked at a job if that job was reported worked that week
*              using dual job info

forvalues X = 1/53 {
	gen hoursWorkedCalcWeek`X' = 0
	forvalues Y = 1/11 {
		replace hoursWorkedCalcWeek`X' = hoursWorkedCalcWeek`X' + hrs_per_wk_id`Y'  if hrs_per_wk_id`Y'<. & job_id`Y'<. & (labor_force_status_wk`X'==job_id`Y' | job_number2_wk`X'==job_id`Y' | job_number3_wk`X'==job_id`Y' | job_number4_wk`X'==job_id`Y' | job_number5_wk`X'==job_id`Y' )
	}
}
forvalues X = 1/53 {
	gen     hoursWorkedWeek`X' = hoursWorkedCalcWeek`X'
	replace hoursWorkedWeek`X' = hrs_all_jobs_wk`X' if hrs_all_jobs_wk`X'>0 & hrs_all_jobs_wk`X'<. & (hoursWorkedCalcWeek`X'==0 | hoursWorkedCalcWeek`X'>160)
	replace hoursWorkedWeek`X' = 160 if hoursWorkedWeek`X'>160 & hoursWorkedWeek`X'<.
	* replace hoursWorkedWeek`X' = hrs_per_wk_recall if year<=1977 // NEED TO FIGURE OUT PRE-1977
	* recode  hoursWorkedWeek`X' (. = 0) if year<=1977
}

*----------
* Monthly
*----------

egen hoursWorkedJan = rowtotal(hoursWorkedWeek1  hoursWorkedWeek2  hoursWorkedWeek3  hoursWorkedWeek4                   )
egen hoursWorkedFeb = rowtotal(hoursWorkedWeek5  hoursWorkedWeek6  hoursWorkedWeek7  hoursWorkedWeek8                   )
egen hoursWorkedMar = rowtotal(hoursWorkedWeek9  hoursWorkedWeek10 hoursWorkedWeek11 hoursWorkedWeek12 hoursWorkedWeek13)
egen hoursWorkedApr = rowtotal(hoursWorkedWeek14 hoursWorkedWeek15 hoursWorkedWeek16 hoursWorkedWeek17                  )
egen hoursWorkedMay = rowtotal(hoursWorkedWeek18 hoursWorkedWeek19 hoursWorkedWeek20 hoursWorkedWeek21 hoursWorkedWeek22)
egen hoursWorkedJun = rowtotal(hoursWorkedWeek23 hoursWorkedWeek24 hoursWorkedWeek25 hoursWorkedWeek26                  )
egen hoursWorkedJul = rowtotal(hoursWorkedWeek27 hoursWorkedWeek28 hoursWorkedWeek29 hoursWorkedWeek30 hoursWorkedWeek31)
egen hoursWorkedAug = rowtotal(hoursWorkedWeek32 hoursWorkedWeek33 hoursWorkedWeek34 hoursWorkedWeek35                  )
egen hoursWorkedSep = rowtotal(hoursWorkedWeek36 hoursWorkedWeek37 hoursWorkedWeek38 hoursWorkedWeek39                  )
egen hoursWorkedOct = rowtotal(hoursWorkedWeek40 hoursWorkedWeek41 hoursWorkedWeek42 hoursWorkedWeek43 hoursWorkedWeek44)
egen hoursWorkedNov = rowtotal(hoursWorkedWeek45 hoursWorkedWeek46 hoursWorkedWeek47 hoursWorkedWeek48                  )
egen hoursWorkedDec = rowtotal(hoursWorkedWeek49 hoursWorkedWeek50 hoursWorkedWeek51 hoursWorkedWeek52 hoursWorkedWeek53)

foreach month in `months' {
	replace hoursWorked`month' = numWeeks`month'*100 if hoursWorked`month'>numWeeks`month'*100
	gen     avgHrs`month'      = hoursWorked`month'/weeksWorked`month'
}

*----------
* Annual
*----------

egen annualHrsWrkCalc = rowtotal(hoursWorkedWeek1-hoursWorkedWeek53)

* Use calc hrs, unless missing, in which case use svy
gen     annualHrsWrk = annualHrsWrkCalc 
replace annualHrsWrk = hours_worked_annual_svy if (annualHrsWrkCalc==0 | annualHrsWrkCalc>=.)
replace annualHrsWrk = hrs_per_wk_recall*weeks_worked_recall if year<=1977

* Average
* gen     avgHrsWrk = annualHrsWrk/weeksWorked
* replace avgHrsWrk = hrs_per_wk_id1 if year<=1977
* replace avgHrsWrk = 0 if avgHrsWrk >=.


*============================================================================
* [5.3] Weeks Military 
*============================================================================

*---------
* Weekly
*---------

forvalues X = 1/53 {
	gen militaryWeek`X' = (labor_force_status_wk`X'==7)
}

*---------
* Monthly
*---------

egen weeksMilitaryJan = rowtotal(militaryWeek1  militaryWeek2  militaryWeek3  militaryWeek4                )
egen weeksMilitaryFeb = rowtotal(militaryWeek5  militaryWeek6  militaryWeek7  militaryWeek8                )
egen weeksMilitaryMar = rowtotal(militaryWeek9  militaryWeek10 militaryWeek11 militaryWeek12 militaryWeek13)
egen weeksMilitaryApr = rowtotal(militaryWeek14 militaryWeek15 militaryWeek16 militaryWeek17               )
egen weeksMilitaryMay = rowtotal(militaryWeek18 militaryWeek19 militaryWeek20 militaryWeek21 militaryWeek22)
egen weeksMilitaryJun = rowtotal(militaryWeek23 militaryWeek24 militaryWeek25 militaryWeek26               )
egen weeksMilitaryJul = rowtotal(militaryWeek27 militaryWeek28 militaryWeek29 militaryWeek30 militaryWeek31)
egen weeksMilitaryAug = rowtotal(militaryWeek32 militaryWeek33 militaryWeek34 militaryWeek35               )
egen weeksMilitarySep = rowtotal(militaryWeek36 militaryWeek37 militaryWeek38 militaryWeek39               )
egen weeksMilitaryOct = rowtotal(militaryWeek40 militaryWeek41 militaryWeek42 militaryWeek43 militaryWeek44)
egen weeksMilitaryNov = rowtotal(militaryWeek45 militaryWeek46 militaryWeek47 militaryWeek48               )
egen weeksMilitaryDec = rowtotal(militaryWeek49 militaryWeek50 militaryWeek51 militaryWeek52 militaryWeek53)

* For years pre1978, simply use start/stop dates and assume that
*  indiv is in military the entire month
foreach month in `months' {
	replace weeksMilitary`month' = numWeeks`month' if beg_1military_yr==year & beg_1military_mo<=scalar`month' & ( end_1military_yr>year | (end_1military_yr==year & end_1military_mo>=scalar`month')) & year<=1977
	replace weeksMilitary`month' = numWeeks`month' if beg_2military_yr==year & beg_2military_mo<=scalar`month' & ( end_2military_yr>year | (end_2military_yr==year & end_2military_mo>=scalar`month')) & year<=1977

	replace weeksMilitary`month' = numWeeks`month' if beg_1military_yr< year & end_1military_yr> year & year<=1977
	replace weeksMilitary`month' = numWeeks`month' if beg_2military_yr< year & end_2military_yr> year & year<=1977
	
	replace weeksMilitary`month' = numWeeks`month' if beg_1military_yr< year & end_1military_yr==year & end_1military_mo>=scalar`month' & year<=1977
	replace weeksMilitary`month' = numWeeks`month' if beg_2military_yr< year & end_2military_yr==year & end_2military_mo>=scalar`month' & year<=1977
}

*---------
* Annual
*---------

egen    weeksMilitary = rowtotal(militaryWeek1-militaryWeek53)      if year>=1978 & year<=1994
egen    tempMilitary  = rowtotal(weeksMilitaryJan-weeksMilitaryDec) if year<=1977
replace weeksMilitary = tempMilitary                                if year<=1977
recode  weeksMilitary (. = 0) if year<=1977
drop    tempMilitary


*============================================================================
* [5.4] Weeks Self-Employed
*============================================================================

*---------
* Weekly
*  Self employed if any job held in the week was indentified as self-employed
*---------
forvalues X = 1/53 {
	gen selfEmployedWeek`X' = 0
	forvalues Y = 1/11 {
		replace selfEmployedWeek`X' = 1 if class_id`Y'==3 & !mi(job_id`Y') & (labor_force_status_wk`X'==job_id`Y' | job_number2_wk`X'==job_id`Y' | job_number3_wk`X'==job_id`Y' | job_number4_wk`X'==job_id`Y' | job_number5_wk`X'==job_id`Y' )
	}		
}

*---------
* Monthly
*---------
egen weeksSelfEmployedJan = rowtotal(selfEmployedWeek1  selfEmployedWeek2  selfEmployedWeek3  selfEmployedWeek4                )
egen weeksSelfEmployedFeb = rowtotal(selfEmployedWeek5  selfEmployedWeek6  selfEmployedWeek7  selfEmployedWeek8                )
egen weeksSelfEmployedMar = rowtotal(selfEmployedWeek9  selfEmployedWeek10 selfEmployedWeek11 selfEmployedWeek12 selfEmployedWeek13)
egen weeksSelfEmployedApr = rowtotal(selfEmployedWeek14 selfEmployedWeek15 selfEmployedWeek16 selfEmployedWeek17               )
egen weeksSelfEmployedMay = rowtotal(selfEmployedWeek18 selfEmployedWeek19 selfEmployedWeek20 selfEmployedWeek21 selfEmployedWeek22)
egen weeksSelfEmployedJun = rowtotal(selfEmployedWeek23 selfEmployedWeek24 selfEmployedWeek25 selfEmployedWeek26               )
egen weeksSelfEmployedJul = rowtotal(selfEmployedWeek27 selfEmployedWeek28 selfEmployedWeek29 selfEmployedWeek30 selfEmployedWeek31)
egen weeksSelfEmployedAug = rowtotal(selfEmployedWeek32 selfEmployedWeek33 selfEmployedWeek34 selfEmployedWeek35               )
egen weeksSelfEmployedSep = rowtotal(selfEmployedWeek36 selfEmployedWeek37 selfEmployedWeek38 selfEmployedWeek39               )
egen weeksSelfEmployedOct = rowtotal(selfEmployedWeek40 selfEmployedWeek41 selfEmployedWeek42 selfEmployedWeek43 selfEmployedWeek44)
egen weeksSelfEmployedNov = rowtotal(selfEmployedWeek45 selfEmployedWeek46 selfEmployedWeek47 selfEmployedWeek48               )
egen weeksSelfEmployedDec = rowtotal(selfEmployedWeek49 selfEmployedWeek50 selfEmployedWeek51 selfEmployedWeek52 selfEmployedWeek53)

* For years pre1978, no information

*---------
* Annual
*---------
egen    weeksSelfEmployed = rowtotal(selfEmployedWeek1-selfEmployedWeek53)      if year>=1978 & year<=1994
* egen    tempSelfEmployed  = rowtotal(weeksSelfEmployedJan-weeksSelfEmployedDec) if year<=1977
* replace weeksSelfEmployed = tempSelfEmployed                                if year<=1977
* recode  weeksSelfEmployed (. = 0) if year<=1977
* drop    tempSelfEmployed

*****************************************************************************
* [6] Match wages, occupation, industry, hrs_per_wk, and class
*****************************************************************************

*============================================================================
* [6.1] Clean wages: deflate, combine
*============================================================================

*---------------
* Deflate Wages - No longer deflating wages in create_work. Moved to data_append
*---------------

forvalues Z=1/5 {
	replace wage_job`Z'     = wage_job`Z'/cpi     if wage_job`Z'<.
	replace wage_alt_job`Z' = wage_alt_job`Z'/cpi if wage_alt_job`Z'<.
}
forvalues Y=1/11 {
	replace wage_id`Y'     = wage_id`Y'/cpi     if wage_id`Y'<.
	replace wage_alt_id`Y' = wage_alt_id`Y'/cpi if wage_alt_id`Y'<.
}
replace fedMinWage = fedMinWage/cpi
replace wage_job_current = wage_job_current/cpi

*----------------------------------------------------------
* Years 1988-1993 report an alt wage for each job.
*   Pick one wage of the wage_id or wage_alt_id variables:
*     wage_id unless missing or >200/hr in 1982-84$
*----------------------------------------------------------

forvalues Y = 1/11 {
	replace wage_id`Y' = wage_alt_id`Y' if wage_alt_id`Y'<. & ( wage_id`Y'>=. | (wage_id`Y'>20000 & wage_alt_id`Y'<=20000) )
}

*============================================================================
* [6.2] Calculate wages - weekly, monthly, annual, CPS, and "Main"
*============================================================================

*---------
* Weekly 
*---------
forvalues X = 1/53 {
	gen tempNumWage = 0
	gen tempDenWage = 0
	forvalues Y = 1/11 {
		qui replace tempNumWage = tempNumWage + wage_id`Y'*hrs_per_wk_id`Y' if  wage_id`Y'<. & hrs_per_wk_id`Y'<. & job_id`Y'<. & (labor_force_status_wk`X'==job_id`Y' | job_number2_wk`X'==job_id`Y' | job_number3_wk`X'==job_id`Y' | job_number4_wk`X'==job_id`Y' | job_number5_wk`X'==job_id`Y' )
		qui replace tempDenWage = tempDenWage + hrs_per_wk_id`Y'            if  wage_id`Y'<. & hrs_per_wk_id`Y'<. & job_id`Y'<. & (labor_force_status_wk`X'==job_id`Y' | job_number2_wk`X'==job_id`Y' | job_number3_wk`X'==job_id`Y' | job_number4_wk`X'==job_id`Y' | job_number5_wk`X'==job_id`Y' )
	}
	gen wageWeek`X' = tempNumWage/tempDenWage
	drop tempNumWage tempDenWage
}

forvalues X = 1/53 {
	gen wagerWeek`X'=.z
	* First, rely on the job reported in 'labor_force_status_wkX'
	forvalues Y = 1/11 {
		qui replace wagerWeek`X' = wage_id`Y' if mi(wagerWeek`X') & ~mi(wage_id`Y') & ~mi(job_id`Y') & labor_force_status_wk`X'==job_id`Y'
	}
	* If there is no valid wage or job in that array, attempt to find any 
	*  other valid wage from the job_number2X-job_number5X arrays
	forvalues Y = 1/11 {
		qui replace wagerWeek`X' = wage_id`Y' if mi(wagerWeek`X') & ~mi(wage_id`Y') & ~mi(job_id`Y') & (job_number2_wk`X'==job_id`Y' | job_number3_wk`X'==job_id`Y' | job_number4_wk`X'==job_id`Y' | job_number5_wk`X'==job_id`Y' )
	}
}

*---------
* Monthly
*---------

egen wageMeanJan = rowmean(wageWeek1  wageWeek2  wageWeek3  wageWeek4            )
egen wageMeanFeb = rowmean(wageWeek5  wageWeek6  wageWeek7  wageWeek8            )
egen wageMeanMar = rowmean(wageWeek9  wageWeek10 wageWeek11 wageWeek12 wageWeek13)
egen wageMeanApr = rowmean(wageWeek14 wageWeek15 wageWeek16 wageWeek17           )
egen wageMeanMay = rowmean(wageWeek18 wageWeek19 wageWeek20 wageWeek21 wageWeek22)
egen wageMeanJun = rowmean(wageWeek23 wageWeek24 wageWeek25 wageWeek26           )
egen wageMeanJul = rowmean(wageWeek27 wageWeek28 wageWeek29 wageWeek30 wageWeek31)
egen wageMeanAug = rowmean(wageWeek32 wageWeek33 wageWeek34 wageWeek35           )
egen wageMeanSep = rowmean(wageWeek36 wageWeek37 wageWeek38 wageWeek39           )
egen wageMeanOct = rowmean(wageWeek40 wageWeek41 wageWeek42 wageWeek43 wageWeek44)
egen wageMeanNov = rowmean(wageWeek45 wageWeek46 wageWeek47 wageWeek48           )
egen wageMeanDec = rowmean(wageWeek49 wageWeek50 wageWeek51 wageWeek52 wageWeek53)

egen wageAltMeanJan = rowmean(wagerWeek1  wagerWeek2  wagerWeek3  wagerWeek4            )
egen wageAltMeanFeb = rowmean(wagerWeek5  wagerWeek6  wagerWeek7  wagerWeek8            )
egen wageAltMeanMar = rowmean(wagerWeek9  wagerWeek10 wagerWeek11 wagerWeek12 wagerWeek13)
egen wageAltMeanApr = rowmean(wagerWeek14 wagerWeek15 wagerWeek16 wagerWeek17           )
egen wageAltMeanMay = rowmean(wagerWeek18 wagerWeek19 wagerWeek20 wagerWeek21 wagerWeek22)
egen wageAltMeanJun = rowmean(wagerWeek23 wagerWeek24 wagerWeek25 wagerWeek26           )
egen wageAltMeanJul = rowmean(wagerWeek27 wagerWeek28 wagerWeek29 wagerWeek30 wagerWeek31)
egen wageAltMeanAug = rowmean(wagerWeek32 wagerWeek33 wagerWeek34 wagerWeek35           )
egen wageAltMeanSep = rowmean(wagerWeek36 wagerWeek37 wagerWeek38 wagerWeek39           )
egen wageAltMeanOct = rowmean(wagerWeek40 wagerWeek41 wagerWeek42 wagerWeek43 wagerWeek44)
egen wageAltMeanNov = rowmean(wagerWeek45 wagerWeek46 wagerWeek47 wagerWeek48           )
egen wageAltMeanDec = rowmean(wagerWeek49 wagerWeek50 wagerWeek51 wagerWeek52 wagerWeek53)

egen wageMedianJan = rowmedian(wageWeek1  wageWeek2  wageWeek3  wageWeek4            )
egen wageMedianFeb = rowmedian(wageWeek5  wageWeek6  wageWeek7  wageWeek8            )
egen wageMedianMar = rowmedian(wageWeek9  wageWeek10 wageWeek11 wageWeek12 wageWeek13)
egen wageMedianApr = rowmedian(wageWeek14 wageWeek15 wageWeek16 wageWeek17           )
egen wageMedianMay = rowmedian(wageWeek18 wageWeek19 wageWeek20 wageWeek21 wageWeek22)
egen wageMedianJun = rowmedian(wageWeek23 wageWeek24 wageWeek25 wageWeek26           )
egen wageMedianJul = rowmedian(wageWeek27 wageWeek28 wageWeek29 wageWeek30 wageWeek31)
egen wageMedianAug = rowmedian(wageWeek32 wageWeek33 wageWeek34 wageWeek35           )
egen wageMedianSep = rowmedian(wageWeek36 wageWeek37 wageWeek38 wageWeek39           )
egen wageMedianOct = rowmedian(wageWeek40 wageWeek41 wageWeek42 wageWeek43 wageWeek44)
egen wageMedianNov = rowmedian(wageWeek45 wageWeek46 wageWeek47 wageWeek48           )
egen wageMedianDec = rowmedian(wageWeek49 wageWeek50 wageWeek51 wageWeek52 wageWeek53)

egen wageAltMedianJan = rowmedian(wagerWeek1  wagerWeek2  wagerWeek3  wagerWeek4            )
egen wageAltMedianFeb = rowmedian(wagerWeek5  wagerWeek6  wagerWeek7  wagerWeek8            )
egen wageAltMedianMar = rowmedian(wagerWeek9  wagerWeek10 wagerWeek11 wagerWeek12 wagerWeek13)
egen wageAltMedianApr = rowmedian(wagerWeek14 wagerWeek15 wagerWeek16 wagerWeek17           )
egen wageAltMedianMay = rowmedian(wagerWeek18 wagerWeek19 wagerWeek20 wagerWeek21 wagerWeek22)
egen wageAltMedianJun = rowmedian(wagerWeek23 wagerWeek24 wagerWeek25 wagerWeek26           )
egen wageAltMedianJul = rowmedian(wagerWeek27 wagerWeek28 wagerWeek29 wagerWeek30 wagerWeek31)
egen wageAltMedianAug = rowmedian(wagerWeek32 wagerWeek33 wagerWeek34 wagerWeek35           )
egen wageAltMedianSep = rowmedian(wagerWeek36 wagerWeek37 wagerWeek38 wagerWeek39           )
egen wageAltMedianOct = rowmedian(wagerWeek40 wagerWeek41 wagerWeek42 wagerWeek43 wagerWeek44)
egen wageAltMedianNov = rowmedian(wagerWeek45 wagerWeek46 wagerWeek47 wagerWeek48           )
egen wageAltMedianDec = rowmedian(wagerWeek49 wagerWeek50 wagerWeek51 wagerWeek52 wagerWeek53)

*---------------------------------------------------------------------
* Annual
* Will create 6 different wages (and associated occs and inds)
*  median     (wage_id1-wage_id9)
*  max        (wage_id1-wage_id9)
*  min        (wage_id1-wage_id9)
*  first_valid(wage_id1-wage_id9)
*  mean       weighted mean of wages by weeks worked
*  main       wage of job with highest weeks worked
*---------------------------------------------------------------------

* Wages
egen annualWageMed         = rowmedian(wage_id1-wage_id11)
egen annualWageMax         = rowmax(wage_id1-wage_id11)
egen annualWageMin         = rowmin(wage_id1-wage_id11)
gen  annualWageFirstValid  = .z
gen  annualWageMain        = .z
forvalues Y=1/11 {
	qui replace annualWageFirstValid = wage_id`Y'     if wage_id`Y'<. & annualWageFirstValid>=.
	qui replace annualWageMain       = wage_id`Y'     if weeksWorked_id`Y' == mostWeeksWorked & weeksWorked_id`Y'<.
}
forvalues Y=1/11 {
	qui gen     temp_wage`Y' = wage_id`Y'*weeksWorked_id`Y'
}
forvalues Y=1/11 {
	qui gen	    temp_week`Y' = (wage_id`Y'<.)*weeksWorked_id`Y'
}
egen temp_numer     = rowtotal(temp_wage1-temp_wage11)
egen temp_denom     = rowtotal(temp_week1-temp_week11)
gen  annualWageMean = temp_numer/temp_denom
drop temp_wage1-temp_wage11 temp_week1-temp_week11 temp_denom temp_num

label var annualWageMed         "ANNUAL WAGE - MEDIAN"
label var annualWageMax         "ANNUAL WAGE - MAX"
label var annualWageMin         "ANNUAL WAGE - MIN"
label var annualWageFirstValid  "ANNUAL WAGE - FIRST VALID"
label var annualWageMean        "ANNUAL WAGE - WEIGHTED MEAN"
label var annualWageMain        "ANNUAL WAGE - MOST WEEKS WORKED"

*------------------------------------------------------------------
* Much simpler annual wage based on job_current (called CPS) and
*  "Main", which is definied in Boehm WP 2013 
*------------------------------------------------------------------
* CPS
gen wageJobCPS = wage_job_current

* Main - Really more of a 'max' wage, but based on jobs reported in the
*  interview year, versus jobs appearing in a given calendar year
* Boehm Boehm Boehm Boehm, Boehm Boehm Boehm (sung to Star Wars theme)
egen wageJobMain = rowmax(wage_job1 wage_job2 wage_job3 wage_job4 wage_job5)
gen  mainJob79   = .
forvalues X=5(-1)1 {
	replace mainJob79 = `X' if wage_job`X'==wageJobMain
}

*============================================================================
* [6.3] Match Occupation, Industry, Hrs_Per_Wk, Class
*============================================================================
local types "Med Max Min FirstValid Mean Main"

foreach T in `types' {
	* Industry
	gen annualIndustry`T' = .z
	forvalues Y=11(-1)1 {
		qui replace annualIndustry`T'   = industry_id`Y'   if wage_id`Y'==annualWage`T'
	}
	label var annualIndustry`T' "INDUSTRY ASSOCIATED WITH annualWage`T'"
	
	* Occupation
	gen annualOccupation`T' = .z 
	forvalues Y=11(-1)1 {
		qui replace annualOccupation`T' = occupation_id`Y' if wage_id`Y'==annualWage`T'
	}
	label var annualOccupation`T' "OCCUPATION ASSOCIATED WITH annualWage`T'"
	
	* Hrs per week
	gen hrs_per_wk_`T' = .z
	forvalues Y=11(-1)1 {
		qui replace hrs_per_wk_`T' = hrs_per_wk_id`Y' if wage_id`Y'==annualWage`T'
	}
	label var hrs_per_wk_`T' "HRS PER WEEK ASSOCIATED WITH annualWage`T'"
	
	* Class
	gen class_`T' = .z
	forvalues Y=11(-1)1 {
		qui replace class_`T' = class_id`Y' if wage_id`Y'==annualWage`T'
	}
	label var class_`T' "CLASS ASSOCIATED WITH annualWage`T'"	
}

*---------------------------------------------------------------------
* Job characteristics of annual wages, both CPS and "Main" (see above)
*---------------------------------------------------------------------
* CPS
gen occJobCPS          = occupation_job_current
gen indJobCPS          = industry_job_current
gen hoursJobCPS        = hrs_per_wk_job_current
gen selfEmployedJobCPS = class_job_current==3

* "Main", per Boehm
gen     hoursJobMain        = hrs_per_wk_job1
gen     occJobMain          = occupation_job1
gen     indJobMain          = industry_job1
gen     selfEmployedJobMain = (class_job1==3)
forvalues X = 2/5 {
	replace hoursJobMain        = hrs_per_wk_job`X' if mainJob79 == `X'
	replace occJobMain          = occupation_job`X' if mainJob79 == `X'
	replace indJobMain          = industry_job`X'   if mainJob79 == `X'
	replace selfEmployedJobMain = (class_job`X'==3) if mainJob79 == `X'
}

*============================================================================
* [6.4] Create categorical variables for industries and occupations 
*        at highest level of aggregation
*       Source: http://www.nlsinfo.org/nlsy79/docs/79html/codesup/att370.htm
*============================================================================

* Industries
lab def vl_agg_industries 1 "AGRICULTURE, FORESTRY, FISHERIES, MINING, AND CONSTRUCTION" 2 "MANUFACTURING" 3 "TRANSPORTATION, COMMUNICATIONS, AND OTHER PUBLIC UTILITIES" 4 "WHOLESALE AND RETAIL TRADE" 5 "FINANCE, INSURANCE, AND REAL ESTATE" 6 "BUSINESS AND REPAIR SERVICES" 7 "PERSONAL SERVICES" 8 "ENTERTAINMENT AND RECREATION SERVICES" 9 "PROFESSIONAL AND RELATED SERVICES" 10 "PUBLIC ADMINISTRATION"

foreach T in `types' {
	gen         annualInd`T' = .z
	qui replace annualInd`T' = 1  if annualIndustry`T'>=17  & annualIndustry`T'<=77
	qui replace annualInd`T' = 2  if annualIndustry`T'>=107 & annualIndustry`T'<=398
	qui replace annualInd`T' = 3  if annualIndustry`T'>=407 & annualIndustry`T'<=479
	qui replace annualInd`T' = 4  if annualIndustry`T'>=507 & annualIndustry`T'<=698
	qui replace annualInd`T' = 5  if annualIndustry`T'>=707 & annualIndustry`T'<=718
	qui replace annualInd`T' = 6  if annualIndustry`T'>=727 & annualIndustry`T'<=759
	qui replace annualInd`T' = 7  if annualIndustry`T'>=769 & annualIndustry`T'<=798
	qui replace annualInd`T' = 8  if annualIndustry`T'>=807 & annualIndustry`T'<=809
	qui replace annualInd`T' = 9  if annualIndustry`T'>=828 & annualIndustry`T'<=897
	qui replace annualInd`T' = 10 if annualIndustry`T'>=907 & annualIndustry`T'<=937

	lab var annualInd`T' "AGGREGATED INDUSTRY ASSOCIATED WITH annualWage`T'"
	lab val annualInd`T' vl_agg_industries
}

* Occupations
lab def vl_agg_occupations 1 "PROFESSIONAL, TECHNICAL, AND KINDRED WORKERS" 2 "MANAGERS AND ADMINISTRATORS, EXCEPT FARM" 3 "SALES WORKERS" 4 "CLERICAL AND UNSKILLED WORKERS" 5 "CRAFTSMEN AND KINDRED WORKERS" 6 "OPERATIVES, EXCEPT TRANSPORT" 7 "TRANSPORT EQUIPMENT OPERATIVES" 8 "LABORERS, EXCEPT FARM" 9 "FARMERS, FARM MANAGERS, FARM LABORERS, AND FARM FOREMEN"   10 "SERVICE WORKERS (INCLUDING PRIVATE HOUSEHOLD)"

foreach T in `types' {
	gen         annualOcc`T' = .z
	qui replace annualOcc`T' = 1  if annualOccupation`T'>=1   & annualOccupation`T'<=195
	qui replace annualOcc`T' = 2  if annualOccupation`T'>=201 & annualOccupation`T'<=245
	qui replace annualOcc`T' = 3  if annualOccupation`T'>=260 & annualOccupation`T'<=280
	qui replace annualOcc`T' = 4  if annualOccupation`T'>=301 & annualOccupation`T'<=395
	qui replace annualOcc`T' = 5  if annualOccupation`T'>=401 & annualOccupation`T'<=580
	qui replace annualOcc`T' = 6  if annualOccupation`T'>=601 & annualOccupation`T'<=695
	qui replace annualOcc`T' = 7  if annualOccupation`T'>=701 & annualOccupation`T'<=715
	qui replace annualOcc`T' = 8  if annualOccupation`T'>=740 & annualOccupation`T'<=785
	qui replace annualOcc`T' = 9  if annualOccupation`T'>=801 & annualOccupation`T'<=824
	qui replace annualOcc`T' = 10 if annualOccupation`T'>=901 & annualOccupation`T'<=984
	
	lab var annualOcc`T' "AGGREGATED OCCUPATION ASSOCIATED WITH annualWage`T'"
	lab val annualOcc`T' vl_agg_occupations
}

*****************************************************************************
* [7] Supplement work history weekly arrays with weeks_worked_recall and
*       hrs_per_wk_recall for cohorts 1957-1959
*       Force all months to be a consecutive spell. Randomize start month
*       If mi hrs_per_wk_recall, assume PT, set hrs=10
*
*  Note: there is a variable weeks_worked_annual_svy that works well with
*        recall; on or after 17, each indiv has either weeks_worked_recall
*        or weeks_worked_annual_svy. Use these vars for ages 17-19.
*        Similarly true for hours_worked_annual_svy
*****************************************************************************
gen     monthsWorkedRecall = round(weeks_worked_recall/4.3,1)     if inlist(age,17,18,19)
replace monthsWorkedRecall = round(weeks_worked_annual_svy/4.3,1) if inlist(age,14,15,16,17,18,19) & mi(weeks_worked_recall)
replace monthsWorkedRecall = 12 if inrange(monthsWorkedRecall,12,.)

gen     avgHrsRecall       = hrs_per_wk_recall                               if inrange(monthsWorkedRecall,1,12)
replace avgHrsRecall       = hours_worked_annual_svy/weeks_worked_annual_svy if inrange(monthsWorkedRecall,1,12) & mi(hrs_per_wk_recall)
replace avgHrsRecall       = 50                                              if inrange(avgHrsRecall,50,.) 
replace avgHrsRecall       = 10                                              if inrange(monthsWorkedRecall,1,12) & mi(avgHrsRecall)

gen firstMonthWorkedRecall = round(runiform()*(12-monthsWorkedRecall),1)+1   if inrange(monthsWorkedRecall,1,12)

foreach month in `months' {
	gen workedRecall`month'=inrange(scalar`month',firstMonthWorkedRecall,firstMonthWorkedRecall+monthsWorkedRecall-1) & !mi(monthsWorkedRecall)
}
foreach month in `months' {
	gen     avgHrsRecall`month'= avgHrsRecall if workedRecall`month'==1
}


*****************************************************************************
* [8] Create primary activity variable                           
*      Full-Time Work:                                         
* 		i.   max weeks worked in the month                   
* 		ii.  35+ hours worked per week worked                
* 		iii. Not in school that month                        
*     Part-Time Work:                                        
*       i. 	 not in full-time work	                         
*       ii.  >0   weeks worked  per month OR                 
* 		iii. >=42 hours worked per month                     
*                                                            
*     Military:                                              
*     weeksMilitary>=weeksEmp AND                            
*     not enrolled in school that month  --> 5               
*     else, treat as others:                                 
*       yes school                       -->                 
*            no work                     --> 1               
*            yes work                    --> 2               
*       no school                        -->                 
*                                        --> 3,4,6           
*****************************************************************************

foreach x of local months {
	gen     workFT`x'      = (weeksWorked`x'==numWeeks`x') & (avgHrs`x'>=35 & avgHrs`x'<.)
	gen     workPT`x'      = (!workFT`x') & (hoursWorked`x'>=42 | weeksWorked`x'>=1)
	gen     military`x'    = (weeksMilitary`x'>0 & weeksMilitary`x'<. & weeksMilitary`x'>=weeksWorked`x' & enrK12`x'==0 & enrCollege`x'==0)
	gen     workSch`x'     = (hoursWorked`x'>=8 | weeksWorked`x'>=1)*(enrSchool`x'==1)
	
	gen     work`x'        = (workFT`x') | (workPT`x')
	
	gen     workK12`x'     = workSch`x'*(enrK12`x'==1)
	gen     workCollege`x' = workSch`x'*(enrCollege`x'==1)
	gen     workGradSch`x' = workSch`x'*(enrGradSch`x'==1)
	
	gen     other`x'       = enrSchool`x'==0 & !work`x' & !military`x'
	
	* Label variables
	lab var workFT`x'      "WORKED FT"
	lab var workPT`x'      "WORKED PT"
	lab var work`x'        "WORKED"
	lab var workSch`x'     "WORKED AND ATTENDED SCHOOL"
	lab var workK12`x'     "WORKED AND ATTENDED K12"
	lab var workCollege`x' "WORKED AND ATTENDED COLLEGE"
	lab var workGradSch`x' "WORKED AND ATTENDED GRAD SCHOOL"
	lab var military`x'    "SERVED IN MILITARY"
	lab var other`x'       "OTHER ACTIVITY"
	
	* Create activity
	gen activity`x' = .
	replace activity`x' = 1  if enrSchool`x'==1 & !workSch`x'            // School Only
	replace activity`x' = 2  if workSch`x'                               // School and Work 
	replace activity`x' = 3  if !military`x' & !enrSchool`x' & workPT`x' // Part-Time Work Only
	replace activity`x' = 4  if !military`x' & !enrSchool`x' & workFT`x' // Full-Time Work Only
	replace activity`x' = 5  if military`x'                              // Military
	replace activity`x' = 6  if other`x'                                 // Other
	
	lab var activity`x' "ACTIVITY"
}

* Activity based on recall
foreach x of local months {
	gen     workFTRecall`x'      = (                      workedRecall`x'==1 & inrange(avgHrsRecall`x',35, .) )
	gen     workPTRecall`x'      = (!workFTRecall`x') & ( workedRecall`x'==1 & inrange(avgHrsRecall`x',10,35) )
	gen     militaryRecall`x'    = (weeksMilitary`x'>0 & weeksMilitary`x'<. & weeksMilitary`x'>=weeksWorked`x' & enrK12`x'==0 & enrCollege`x'==0)
	gen     workSchRecall`x'     = (workedRecall`x'==1)*(enrSchool`x'==1)
	
	gen     workRecall`x'        = (workFTRecall`x') | (workPTRecall`x')
	
	gen     workK12Recall`x'     = workSchRecall`x'*(enrK12`x'==1)
	gen     workCollegeRecall`x' = workSchRecall`x'*(enrCollege`x'==1)
	gen     workGradSchRecall`x' = workSchRecall`x'*(enrGradSch`x'==1)
	
	gen     otherRecall`x'       = enrSchool`x'==0 & !workRecall`x' & !militaryRecall`x'
	
	* Label variables
	lab var workFTRecall`x'      "WORKED FT-RECALL"
	lab var workPTRecall`x'      "WORKED PT-RECALL"
	lab var workRecall`x'        "WORKED-RECALL"
	lab var workSchRecall`x'     "WORKED AND ATTENDED SCHOOL-RECALL"
	lab var workK12Recall`x'     "WORKED AND ATTENDED K12-RECALL"
	lab var workCollegeRecall`x' "WORKED AND ATTENDED COLLEGE-RECALL"
	lab var workGradSchRecall`x' "WORKED AND ATTENDED GRAD SCHOOL-RECALL"
	lab var militaryRecall`x'    "SERVED IN MILITARY-RECALL"
	lab var otherRecall`x'       "OTHER ACTIVITY-RECALL"
	
	* Create activity
	gen activityRecall`x' = .
	replace activityRecall`x' = 1  if enrSchool`x'==1 & !workSchRecall`x'                                      
	replace activityRecall`x' = 2  if workSchRecall`x'                                     
	replace activityRecall`x' = 3  if !militaryRecall`x' & !enrSchool`x' & workPTRecall`x' 
	replace activityRecall`x' = 4  if !militaryRecall`x' & !enrSchool`x' & workFTRecall`x' 
	replace activityRecall`x' = 5  if militaryRecall`x'                                    
	replace activityRecall`x' = 6  if otherRecall`x'                                       
	
	lab var activityRecall`x' "ACTIVITY-RECALL"
}
