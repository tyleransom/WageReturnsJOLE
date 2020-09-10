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
*----------------------------------------------------------------------------
use y79_geocode_raw.dta, clear
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

keep id year fips_st fips_co
compress
tempfile holder1
save `holder1'

use id year month interview_date missInt using y79_all.dta, clear
sort id year

isid id year month
merge m:1 id year using `holder1'
assert _merge!=1
drop if _merge==2 
drop _merge

*============================================================================
* Impute monthly counties
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

order id year month missInt interview_date intThisMonth fips_st fips_co fips_st2 fips_co2 
save y79_geocode2, replace

*============================================================================
* Merge in county characteristics (empPct and incPerCapita; final versions)
*============================================================================
drop fips_st fips_co
rename fips_st2    fips_st
rename fips_co2    fips_co

* Hand edits
*  For example when Dade County, Florida (FIPS code 12025) became Miami-Dade County in 1997, it received the new FIPS code of 12086, http://coweeta.uga.edu/trends/datadictionary/fipscode.html
replace fips_co=86 if fips_st==12 & fips_co==25 & year>=1990

merge m:1 fips_st fips_co year using ../county_data, keepusing(year fips_st fips_co AreaName cbsa incPerCapitaFinal empPctFinal incPerCapita empPct empTot empTotMSA)

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
*  -> national average? one fips_co for each indiv with fips_st==0
*----------------------------------------------------------------------------
gen m_empPct       = mi(empPctFinal)
gen m_incPerCapita = mi(incPerCapitaFinal)

replace fips_co = -99 if m_empPct | m_incPerCapita
replace fips_st = -99 if (m_empPct | m_incPerCapita) & (fips_st==0 | fips_st>56)

drop if _merge==2
drop AreaName-_merge

merge m:1 fips_st fips_co year using ../county_data, keepusing(year fips_st fips_co AreaName cbsa incPerCapitaFinal empPctFinal incPerCapita empPct empTot empTotMSA)
assert _merge!=1
drop if _merge==2
drop _merge

*============================================================================
* Merge in monthly unemployment rate from BLS (not NLSY-provided rate)
*============================================================================
tempfile county_unemp
preserve
    use ../county_unemp_monthly, clear
    ren state fips_st
    ren county fips_co
    save `county_unemp', replace
restore

merge m:1 fips_st fips_co year month using `county_unemp', keepusing(urate)
drop if _merge==2
drop _merge

* rename empPctFinal       empPct
* rename incPerCapitaFinal incPerCapita

compress
save y79_geocode3, replace

!chmod 774 *.dta
log close
