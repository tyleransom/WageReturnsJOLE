version 14.1
capture log close
set more off
log using ipeds_all_combine.log, replace

clear all

*============================================================================
* ...
*============================================================================

* County data is inconsistent at best. Strat:
*  Clean up countynm (get rid of county; capitalize it all)
*  Find the mode countynm by unitid-zip (some unitids change zip)
*  Compare that countynm with the counties that are in that zip from zipctyAB
*  and keep the matches; for those without, random

* UPDATE: Find the mode zip code for each program
*  ID the county that most of the zip code is in and use that

* 1) Find mode county by unitid zip; match with zipctyAB and keep if match
* 2) If no match, find modezip for unitid, match with "first" county in zip

*----------------------------------------------------------------
* Find 51 flagship instnms and unitids
*----------------------------------------------------------------
insheet using statefipsflagship.csv, clear
rename flagship instnm

replace instnm = upper(instnm)
gen city = instnm if _n==1
do college_clean
drop city

* Rename to match up with year 2000 (year chosen at random)
replace instnm="OHIO ST U"                                     if instnm=="OHIO ST U COLUMBUS"        
replace instnm="PENNSYLVANIA ST U"                             if instnm=="PENNSYLVANIA ST U PARK"
replace instnm="U MASSACHUSETTS"                               if instnm=="U MASSACHUSETTS AMHERST"
replace instnm="U MICHIGAN ANN ARBOR"                          if instnm=="U MICHIGAN"
replace instnm="U OKLAHOMA NORMAN"                             if instnm=="U OKLAHOMA"
replace instnm="U SOUTH CAROLINA COLUMBIA"                     if instnm=="U SOUTH CAROLINA"
replace instnm="LOUISIANA ST U AG MECH HEBERT LAWS CENTER"     if instnm=="LOUISIANA ST U A M COLLEGE"
replace instnm="RUTGERS U NEW BRUNSWICK"                       if instnm=="RUTGERS U NEW BRUNSWICK PISCATAWAY"
replace instnm="U ARKANSAS LITTLE ROCK"                        if instnm=="U ARKANSAS"
replace instnm="U ILLINOIS URBANA"                             if instnm=="U ILLINOIS URBANA CHAMPAIGN"
replace instnm="U MONTANA MISSOULA"                            if instnm=="U MONTANA"
replace instnm="U VERMONT ST AGRICULTURAL COLLEGE"             if instnm=="U VERMONT"
replace instnm="U WASHINGTON SEATTLE"                          if instnm=="U WASHINGTON"

tempfile holderflag
save `holderflag', replace

!unzip -u ipeds_inst_final.dta.zip
use if year==2000 using ipeds_inst_final, clear
!rm ipeds_inst_final.dta

merge m:1 instnm using `holderflag', assert(master match) keep(match) nogen

* Note: U of DC is only institution to not offer a doctor's degree
tab hloffer

keep unitid state stabbr
gen flagship=1

tempfile holderflag2
save `holderflag2', replace

*-----------------------
* Grab fips data
* --Merge state and county
* --Choose one county per zip
* --For now, keeping the lowest fips5; eventually get pop data to get the most pop
*-----------------------
insheet using statefips.csv, clear
keep fips stabbr
rename fips fips2
merge 1:m stabbr using zipctyAB, assert(master match) keep(match) nogen
gen fips5 = fips2*1000+fips3
order zipcode fips2 fips3 fips5 stabbr countyname
sort  zipcode fips2 fips3 fips5

bys zipcode (fips5): keep if _n==1
isid zipcode
compress
tempfile holderzipfips
save `holderzipfips', replace

contract fips5 stabbr countyname
drop _freq
drop if mi(countyname)
gsort stabbr countyname -fips5
by    stabbr countyname: drop if _n==2
isid stabbr countyname
tempfile holderonlyfips
save `holderonlyfips', replace

*------------------------------------------------------
* Clean IPEDS data and merge in fips data in stages
*------------------------------------------------------
* use unitid year instnm city stabbr zip countynm hloffer using ipeds_inst_final, clear 
!unzip ipeds_inst_final.dta.zip
use ipeds_inst_final, clear
!rm ipeds_inst_final.dta
replace countynm = upper(countynm)
replace countynm = regexr(countynm," COUNTY$","")
replace countynm = regexr(countynm," MUNICIPIO$","")
replace countynm = regexr(countynm," CO$","")
replace countynm = regexr(countynm,"^COUNTY OF ","")

bys unitid (year): egen modezip = mode(zip), minmode

* First: just merge on current zip (only missing 7 times, mostly for cert programs)
drop if mi(zip)
rename zip zipcode
merge m:1 zipcode using `holderzipfips', keep(master match) keepusing(fips5 countyname) gen(merge1)
rename countyname countyname_1
rename fips5      fips5_1

* For those without a match, merge again using stabbr countynm
rename countynm countyname
	merge m:1 stabbr countyname using `holderonlyfips', keep(master match) gen(merge2)
rename countyname countynm
rename fips5 fips5_2
bys unitid (year): egen modefips5_2 = mode(fips5_2), minmode

gen fips5 = fips5_1
replace fips5 = fips5_2 if mi(fips5_1) & ~mi(fips5_2)
* We still have 5.8K/275K that don't have a fips5, though half (2.9K) are 
*  either in PR and/or less than Associates degree

*----------------------------------------------
* Get tuition in 1,000 constant 2010$ 
*----------------------------------------------
ssc install cpigen
cpigen
* https://www.usinflationcalculator.com/inflation/consumer-price-index-and-annual-percent-changes-from-1913-to-2008/
replace cpiu = 236.736/172.2 if year==2014
replace cpiu = 237.017/172.2 if year==2015
replace cpiu = 240.007/172.2 if year==2016
replace cpiu = 245.120/172.2 if year==2017

gen  cpiu2010a = cpiu if year==2010
egen cpiu2010b = max(cpiu2010a)
gen  cpiu2010  = cpiu/cpiu2010b

foreach X in 2 3 6 7 {
	replace tuition`X' = tuition`X'/(cpiu2010*1000)
}
label var tuition2      "Tuition and fees FT 1 yr undergrad, in-state (K, 2010$)" 
label var tuition3      "Tuition and fees FT 1 yr undergrad, out-of-state (K, 2010$)" 
label var tuition6      "Tuition and fees FT 1 yr grad, in-state (K, 2010$)" 
label var tuition7      "Tuition and fees FT 1 yr grad, out-of-state (K, 2010$)" 

drop cpi* tuition1 tuition5

*----------------------------------------------
* Merge in "flagship" ... er... flag
*----------------------------------------------
merge m:1 unitid stabbr using `holderflag2', keepusing(unitid stabbr flagship) assert(master match) nogen
recode flagship (. = 0)

*----------------------------------------------
* Save intermim1 version: unitid year is the unit of obs
*  Drop 'instnm' so file is 33% smaller
*----------------------------------------------
drop instnm
compress
label data "IPEDS Interim Data - UNITID Year"
save ipeds_interim1.dta, replace
!zip -m ipeds_interim1.dta.zip ipeds_interim1.dta

*============================================================================
* Create summary measures by county (fips5) and state (flagship tuition)
*============================================================================
gen AAonly = hloffer==2
gen AAplus = inrange(hloffer,2,9)
gen BAplus = inrange(hloffer,3,9)

gen public    = inst_control==1
gen forprofit = inst_control==2
gen nonprofit = inst_control==3 | inst_control==4

* For tuition, assume we only care about in-state...?
gen publicTuition2    = tuition2 if public
gen publicTuition2AA  = tuition2 if public & AAonly
gen publicTuition2BA  = tuition2 if public & BAplus

gen privateTuition2   = tuition2 if  forprofit | nonprofit
gen privateTuition2AA = tuition2 if (forprofit | nonprofit) & AAonly
gen privateTuition2BA = tuition2 if (forprofit | nonprofit) & BAplus

gen flagshipTuition = tuition2 if flagship==1
bys stabbr year: egen flagshipTuition2 = max(flagshipTuition)

* For 1988 and 2005 (and most years post 1988), flagship tuition data is valid
assert ~mi(flagshipTuition2) if ~inlist(stabbr,"AS", "CM", "FM", "GU", "MH", "MP", "PR", "PW") & ~inlist(stabbr, "M", "TT", "VI") & inlist(year,1988,2005)
* Issues: NH in 1990; NC in 1989; MS in 2000, 2001; FL in 1990, 2000
tab stabbr year if mi(flagshipTuition2) & ~inlist(stabbr,"AS", "CM", "FM", "GU", "MH", "MP", "PR", "PW") & ~inlist(stabbr, "M", "TT", "VI")

* Drop outlying territories
drop if inlist(stabbr,"AS", "CM", "FM", "GU", "MH", "MP", "PR", "PW") | inlist(stabbr, "AQ", "M", "TT", "TQ", "VI")


collapse (sum) numBA = BAplus (sum) numAA = AAonly (mean) tuitionBApublic = publicTuition2BA (mean) tuitionBAprivate = privateTuition2BA (mean) tuitionAApublic = publicTuition2AA (mean) tuitionAAprivate = privateTuition2AA (max) tuitionFlagship = flagshipTuition2 , by(fips5 year)
drop if mi(fips5) | mi(year)

sort  year fips5
order year fips5

save ipeds_final.dta, replace

log close
