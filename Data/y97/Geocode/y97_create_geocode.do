version 14.1
clear all
set maxvar 32000
set more off
capture log close
log using "y97_create_geocode.log", replace

*****************************************************************************
* Merge geocode into the monthly data with interview month
*  and impute location for time between interviews
*****************************************************************************
*============================================================================
* Impute location according to the following rules:
*  (1) If someone switches location between consecutive interviews,
*    - assume i is in the new location the month after interview_{t}
*      (as opposed to the month before interview_{t+1}
*  (2) If someone switches location sometime in a missing interview spell,
*    - assume i is in the new location the month after interview_{t}
*      (as opposed to the month before interview_{t+1}
*============================================================================
capture confirm file "y97_geocode_raw.dta.zip"
if _rc==0 {
	!unzip y97_geocode_raw.dta.zip
    use y97_geocode_raw.dta, clear
	!rm y97_geocode_raw.dta
}
else {
	use y97_geocode_raw.dta, clear
}

*----------------------------------------------------------------------------
* Before the merge, backfill gaps in missed interviews. Doing this before
*  the merge is needed because of the way observations are dropped.
*----------------------------------------------------------------------------
preserve
    * fix problem that arises from misalignment of interview year and survey year
    * fix it by copying the last survey year
    tempfile holderExpand
    keep if year==2015
    replace year = 2016
    sort id year
    save `holderExpand'
restore
merge 1:1 id year using `holderExpand', nogen

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

keep id year fips_st fips_co unemp
compress
tempfile holder1
save `holder1'

!unzip -u ../y97_all.dta.zip
use id year month birthYear R14* R15* R16* R17* Interview_date missInt using y97_all.dta, clear
!rm y97_all.dta
replace Interview_date = R17interviewDate if year==2016 & mi(Interview_date)
sort id year

isid id year month
merge m:1 id year using `holder1'
* assert _merge!=1
drop if _merge==2 
drop _merge

*============================================================================
* Impute monthly counties
*============================================================================
generat intThisMonth = month(Interview_date)==month & year(dofm(Interview_date))==year
* replace intThisMonth = 1 if month(R17interviewDay)==month & year(R17interviewDay)==2016 & year==2016
*l id year month fips* intThisMonth  R17interview* if id==65 & inrange(year,2015,2016)

gsort id -year -month
    by id: gen     fips_co2 = fips_co        if intThisMonth  | _n==1
    by id: replace fips_co2 = fips_co2[_n-1] if !intThisMonth & _n> 1
    by id: replace fips_co2 = fips_co2[_n-1] if mi(fips_co2)  & _n> 1
    
    by id: gen     fips_st2 = fips_st        if intThisMonth  | _n==1
    by id: replace fips_st2 = fips_st2[_n-1] if !intThisMonth & _n> 1
    by id: replace fips_st2 = fips_st2[_n-1] if mi(fips_st2)  & _n> 1
sort id year month

* recode fips* (-4 = .v)

order id year month missInt Interview_date intThisMonth fips_st fips_co fips_st2 fips_co2 
save y97_geocode2, replace

*============================================================================
* Merge in county characteristics (empPct and incPerCapita; final versions)
*============================================================================
drop fips_st fips_co
rename fips_st2    fips_st
rename fips_co2    fips_co

* Hand edits
replace fips_co=86 if fips_st==12 & fips_co==25 // For example when Dade County, Florida (FIPS code 12025) became Miami-Dade County in 1997, it received the new FIPS code of 12086, http://coweeta.uga.edu/trends/datadictionary/fipscode.html

tab year
merge m:1 fips_st fips_co year using ../../county_data, keepusing(year fips_st fips_co AreaName cbsa incPerCapitaFinal incPerCapita empPctFinal empPct empTot empTotMSA)

gen m_empPct       = mi(empPctFinal)
gen m_incPerCapita = mi(incPerCapitaFinal)

replace fips_co = -99 if m_empPct | m_incPerCapita
replace fips_st = -99 if (m_empPct | m_incPerCapita) & (fips_st==0 | fips_st>56)

drop if _merge==2
drop AreaName-_merge

tab year
merge m:1 fips_st fips_co year using ../../county_data, keepusing(year fips_st fips_co AreaName cbsa incPerCapitaFinal incPerCapita empPctFinal empPct empTot empTotMSA)
* assert _merge!=1
drop if _merge==2
drop _merge

*============================================================================
* Merge in monthly unemployment rate from BLS (not NLSY-provided rate)
*============================================================================
tempfile county_unemp
preserve
    use ../../county_unemp_monthly, clear
    ren state fips_st
    ren county fips_co
    save `county_unemp', replace
restore

merge m:1 fips_st fips_co year month using `county_unemp', keepusing(urate)
drop if _merge==2
drop _merge

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
	
	replace year=2005
	
	merge m:1 year fips_st fips_co using ../../county_data, assert(using match) keep(match) nogen keepusing(numBA numAA numBAperCapita numAAperCapita tuitionFlagship)
	keep id numBA numBAperCapita numAA numAAperCapita tuitionFlagship
	
	tempfile holder2005
	save `holder2005'
restore

merge m:1 id using `holder2005', assert(match) nogen

mdesc numBA numBAperCapita numAA numAAperCapita tuitionFlagship


* *============================================================================
* * Merge in IPEDS data on number of colleges in county, etc.
* *============================================================================
* * year            int     %9.0g                 year
* * fips5           float   %9.0g
* * numBA           long    %9.0g                 (count) BAplus
* * numAA           long    %9.0g                 (count) AAonly
* * tuitionBApublic float   %9.0g                 (mean) publicTuition2BA
* * tuitionBApriv~e float   %9.0g                 (mean) privateTuition2BA
* * tuitionAApublic float   %9.0g                 (mean) publicTuition2AA
* * tuitionAApriv~e float   %9.0g                 (mean) privateTuition2AA

* tempfile ipeds
* preserve
    * use ../../ipeds_final, clear
    * keep if year==2005
    * drop year
    * gen fips_st16 = floor(fips5/1000)
    * gen fips_co16 = fips5 - 1000*fips_st
    * l fips5 fips_st fips_co in 1/50, sep(0)
    * save `ipeds', replace
* restore

* tempfile ipeds_state
* preserve
    * use ../../ipeds_final, clear
    * keep if year==2005
    * drop year
    * gen fips_st16 = floor(fips5/1000)
    * collapse tuitionFlagship, by(fips_st16)
    * l fips_st tuitionFlagship in 1/50, sep(0)
    * save `ipeds_state', replace
* restore

* tempfile county_pop
* preserve
    * use ../../county_population, clear
    * keep fips_st fips_co year popAllTotal
    * keep if year==2005
    * drop year
    * l fips_st fips_co in 1/50, sep(0)
    * ren popAllTotal countyPopAge16
    * ren fips_st fips_st16
    * ren fips_co fips_co16
    * save `county_pop', replace
* restore

* gen year16 = birthYear+16
* bys id: gen fips_stA = fips_st if year==year16 & month==9
* bys id: gen fips_coA = fips_co if year==year16 & month==9
* bys id: egen fips_st16 = max(fips_stA)
* bys id: egen fips_co16 = max(fips_coA)
* merge m:1 fips_st16 fips_co16 using `ipeds', keep(master match) keepusing(numBA numAA) nogen
* merge m:1 fips_st16           using `ipeds_state', keep(master match) keepusing(tuitionFlagship) nogen
* merge m:1 fips_st16 fips_co16 using `county_pop', keep(master match) keepusing(countyPopAge16) nogen

* mdesc numBA numAA tuition*
* recode numBA numAA (. = 0)
* mdesc numBA numAA tuition*

* gen numBAperCapita = numBA/countyPopAge16
* gen numAAperCapita = numAA/countyPopAge16

tab year
save y97_geocode3, replace
! chmod 774 *.dta
!zip -m y97_geocode3.dta.zip y97_geocode3.dta

log close

