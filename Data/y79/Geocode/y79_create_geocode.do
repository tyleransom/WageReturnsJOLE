version 14.1
clear all
set maxvar 32000
set more off
capture log close
log using "y79_create_geocode.log", replace

*****************************************************************************
* Merge geocode into the monthly data with interview month
*  and impute location for time between interviews
*****************************************************************************
*============================================================================
* Impute location according to the following rules:
*  (1) If someone switches location between consecutive interviews,
*	 - assume i is in the new location the month after interview_{t}
*	   (as opposed to the month before interview_{t+1}
*  (2) If someone switches location sometime in a missing interview spell,
*	 - assume i is in the new location the month after interview_{t}
*	   (as opposed to the month before interview_{t+1}
*============================================================================
*----------------------------------------------------------------------------
* Before the merge, backfill gaps in missed interviews. Doing this before
*  the merge is needed because the way observations are dropped.
* Also for skipped years, thus the fillin
*----------------------------------------------------------------------------
use y79_geocode_raw.dta, clear
* Need 9 more years to fillin
set obs `=_N+9'
replace id = 0 if mi(id)
replace year = 1997 if _n==_N
replace year = 1999 if _n==_N-1
replace year = 2001 if _n==_N-2
replace year = 2003 if _n==_N-3
replace year = 2005 if _n==_N-4
replace year = 2007 if _n==_N-5
replace year = 2009 if _n==_N-6
replace year = 2011 if _n==_N-7
replace year = 2013 if _n==_N-8
fillin id year
drop if id==0
drop _fillin

gen fips_co_old = fips_co
gen fips_st_old = fips_st

* If fips_st==0, replace fips_st and fips_co with 0.
*  Note: we can use state mean for fips_co==0 with valid fips_st
replace fips_co = .o if fips_st==0
replace fips_st = .o if fips_st==0

* Sort descending and backfill non-missing values
gsort id -year
by id: replace fips_co = fips_co[_n-1] if mi(fips_co) & !mi(fips_co[_n-1]) & _n>1
by id: replace fips_st = fips_st[_n-1] if mi(fips_st) & !mi(fips_st[_n-1]) & _n>1

* Sort ascending and fill missing values with last observed county
sort id year
by id: replace fips_co = fips_co[_n-1] if mi(fips_co) & !mi(fips_co[_n-1]) & _n>1
by id: replace fips_st = fips_st[_n-1] if mi(fips_st) & !mi(fips_st[_n-1]) & _n>1

* Note: The above gives every id-year obs a fips_co/st if they ever provided one,
*  ie, the only missings going forward are for those that never gave a fips

keep id year fips_st fips_co
compress
tempfile holder1
save `holder1'

!unzip -u ../y79_all.dta.zip
use id year month interview_date missInt birthMonth birthYear using y79_all.dta, clear
!rm y79_all.dta

sort id year

isid id year month
merge m:1 id year using `holder1', assert(using match) keep(match) nogen
* Note: since y79_all only goes through age 3612, it stops at year 2001
* Thus the obs between 2001-2014 in 'using' will be dropped here

*============================================================================
* Impute monthly counties, so that moves can occur once observed vs year end
*============================================================================
gen intThisMonth = month(interview_date)==month

gsort id -year -month
	by id: gen     fips_co2 = fips_co        if intThisMonth  | _n==1
	by id: replace fips_co2 = fips_co2[_n-1] if !intThisMonth & _n> 1
	by id: replace fips_co2 = fips_co2[_n-1] if mi(fips_co2)  & _n> 1
	
	by id: gen     fips_st2 = fips_st        if intThisMonth  | _n==1
	by id: replace fips_st2 = fips_st2[_n-1] if !intThisMonth & _n> 1
	by id: replace fips_st2 = fips_st2[_n-1] if mi(fips_st2)  & _n> 1
sort id year month

* recode fips* (-4 = .v)

order id year month missInt interview_date intThisMonth fips_st fips_co fips_st2 fips_co2 birthMonth birthYear 
save y79_geocode2, replace
!zip -m y79_geocode2.dta.zip y79_geocode2.dta

*============================================================================
* Merge in county characteristics (empPct and incPerCapita; final versions)
*============================================================================
local county_vars cbsa incPerCapitaFinal empPctFinal incPerCapita empPct empTot empTotMSA popAllTotal
drop fips_st fips_co
rename fips_st2    fips_st
rename fips_co2    fips_co

* Hand edits
*  For example when Dade County, Florida (FIPS code 12025) became Miami-Dade County in 1997, it received the new FIPS code of 12086, http://coweeta.uga.edu/trends/datadictionary/fipscode.html
replace fips_co=86 if fips_st==12 & fips_co==25 & year>=1990

* merge m:1 fips_st fips_co year using ../../county_data, keepusing(year fips_st fips_co AreaName cbsa incPerCapitaFinal empPctFinal incPerCapita empPct empTot empTotMSA)
* EDIT: JA 1/2019: Got rid of AreaName since it doubles the file size(string) w/o any clear benefit
merge m:1 fips_st fips_co year using ../../county_data, keep(master match) nogen keepusing(year fips_st fips_co `county_vars')

*----------------------------------------------------------------------------
* There are some NLSY obs that have county data but don't match:
* st   co     freq 
*  2   40      17   (AK - bad fips_co to start with); id==5682, always in AK, in co 40 til 1981, then in co 90; 40 is matched before 1980
*  2  210      13   (AK - bad fips_co to start with); id==5686, always in AK, all obs are GOOD, except last 12 obs in co 210
*  6  500 ??   71   (CA - max fips_co is 115)
* 12  500 ??   59   (FL - max fips_co is 133)
* 36  500 ??  482   (NY - max fips_co is 123)
* 36  550 ??   25   (NY - max fips_co is 123)
* Fips code 500 and 550 are most likely error codes of some sort. All obs
*  take place in years 1983-1986
*
* Edits:
*  fips_st in 60, 66, 72, 78 (American Somoa,Guam,Puerto Rico,Virgin Islands)
*  ->  use national average (Mainly just 66 and 78)
*  fips_st in 1-56 but no/invalid fips_co
*  ->  use state average (see above: 2,6,12,36)
*  fips_st = 0 --> treat these as missing (fix above)
*  -> national average: one fips_co for each indiv with fips_st==0
*  CHANGES ARE MADE IN THE county_data FILE TO CREATE FLAGS FOR -99
*----------------------------------------------------------------------------
mdesc `county_vars'
gen m_empPct       = mi(empPctFinal)
gen m_incPerCapita = mi(incPerCapitaFinal)

* Note, this technically means the data could be missing in nlsy OR county_data
*  and we'll replace with state/national averages
replace fips_co = -99 if  m_empPct | m_incPerCapita
replace fips_st = -99 if (m_empPct | m_incPerCapita) & (fips_st==0 | fips_st>56)

drop `county_vars'

* merge m:1 fips_st fips_co year using ../../county_data, keepusing(year fips_st fips_co AreaName cbsa incPerCapitaFinal empPctFinal incPerCapita empPct empTot empTotMSA)
merge m:1 fips_st fips_co year using ../../county_data, assert(using match) keep(match) nogen keepusing(year fips_st fips_co `county_vars')
mdesc empPct incPerCapita popAllTotal

*============================================================================
* Merge in monthly unemployment rate from BLS (not NLSY-provided rate)
* JA: 3/2019: urate is not needed
*============================================================================
* tempfile county_unemp
* preserve
    * use ../../county_unemp_monthly, clear
    * ren state fips_st
    * ren county fips_co
    * save `county_unemp', replace
* restore

* merge m:1 fips_st fips_co year month using `county_unemp', keep(master match) nogen keepusing(urate)

* rename empPctFinal       empPct
* rename incPerCapitaFinal incPerCapita

*============================================================================
* Merge in IPEDS data -- Specifically, we want to merge in one data point:
*   For y79, that will be data from 1988
*   For y97, that will be data from 2005
* This data is in county_data
* Note: Above, we created flags of -99 for st and co for missing obs in `county_data'
*       Values for those flags were created for IPEDS data in county_data; however
*       we need to grab the relevant year
*============================================================================
preserve
	bys id (year month): keep if ( year==birthYear+16 & month==9) | _n==_N
	bys id (year month): keep if _n==1
	
	replace year=1988
	
	merge m:1 year fips_st fips_co using ../../county_data, assert(using match) keep(match) nogen keepusing(numBA numAA numBAperCapita numAAperCapita tuitionFlagship)
	keep id numBA numBAperCapita numAA numAAperCapita tuitionFlagship
	
	tempfile holder88
	save `holder88'
restore

merge m:1 id using `holder88', assert(match) nogen

mdesc numBA numBAperCapita numAA numAAperCapita tuitionFlagship

compress
save y79_geocode3.dta, replace
!chmod 774 *.dta
!zip -m y79_geocode3.dta.zip y79_geocode3.dta

log close
