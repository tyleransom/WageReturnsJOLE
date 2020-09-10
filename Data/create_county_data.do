version 14.1
clear all
set more off
capture log close
log using create_county_data.log, replace

*============================================================================
* Create matrices and macros
*============================================================================
tempfile holder1 holder2 holder3 holder4
tempfile state1 state2 national1 national2

capture drop matrix _all
matrix input MM = ///
( 901, 3  , 540, 0   \ ///
  903, 5  , 580, 560 \ /// 
  907, 15 , 790, 820 \ ///
  909, 19 , 515, 0   \ ///
  911, 31 , 680, 0   \ ///
  913, 35 , 640, 0   \ ///
  918, 53 , 570, 730 \ ///
  919, 59 , 600, 610 \ ///
  921, 69 , 840, 0   \ ///
  923, 81 , 595, 0   \ ///
  929, 89 , 690, 0   \ ///
  931, 95 , 830, 0   \ ///
  933, 121, 750, 0   \ ///
  939, 143, 590, 0   \ ///
  941, 149, 670, 0   \ ///
  942, 153, 683, 685 \ ///
  944, 775, 161, 0   \ ///
  945, 163, 530, 678 \ ///
  947, 165, 660, 0   \ ///
  949, 175, 620, 0   \ ///
  951, 177, 630, 0   \ ///
  953, 191, 520, 0   \ ///
  955, 195, 720, 0   \ ///
  958, 199, 735, 0   )
matrix list MM

*============================================================================
* BEA data  
*============================================================================
use fips_st fips_co AreaName popAllBEA year incPerCapita empTot if year>1969 using BEA/BEAcountyFIPS.dta, clear
gen income = popAllBEA*incPerCapita

*----------------------------------------------------------------------------
* Create state and national averages
*----------------------------------------------------------------------------
preserve
	collapse (sum) popAllBEA empTot income, by(year fips_st)
	gen fips_co  = -99
	gen AreaName = "State Wide"
	save `state1', replace
	collapse (sum) popAllBEA empTot income, by(year)
	gen fips_st  = -99
	gen fips_co  = -99
	gen AreaName = "National"
	save `national1', replace
restore
append using `state1' `national1'
sort  year fips_st fips_co
order year fips_st fips_co
replace incPerCapita = income/popAllBEA if fips_co==-99

*----------------------------------------------------------------------------
* "Breakout" the BEA data
*----------------------------------------------------------------------------
forvalues Y = 1/24 {
	expand 2                   if fips_st==51 & fips_co==MM[ `Y',1], gen(counter)
	replace fips_co=MM[ `Y',2] if fips_st==51 & fips_co==MM[ `Y',1] & counter==0
	replace fips_co=MM[ `Y',3] if fips_st==51 & fips_co==MM[ `Y',1] & counter==1
	drop counter
	
	if MM[ `Y',4]~=0 {
		expand 2                   if fips_st==51 & fips_co==MM[ `Y',3], gen(counter)
		replace fips_co=MM[ `Y',4] if fips_st==51 & fips_co==MM[ `Y',3] & counter==1
		drop counter
	}
}
save `holder1', replace

*============================================================================
* Census data
*============================================================================
use Census/county_population.dta, clear
local varlist  popAllTotal popAllMale popAllFemale popWorkTotal popWorkMale popWorkFemale

*----------------------------------------------------------------------------
* Create state and national averages
*----------------------------------------------------------------------------
preserve
	collapse (sum) `varlist', by(year fips_st)
	gen fips_co  = -99
	gen AreaName = "State Wide"
	save `state1', replace
	collapse (sum) `varlist', by(year)
	gen fips_st  = -99
	gen fips_co  = -99
	gen AreaName = "National"
	save `national1', replace
restore
append using `state1' `national1'
sort  year fips_st fips_co
order year fips_st fips_co

*----------------------------------------------------------------------------
* Create better county values for Virginia
*----------------------------------------------------------------------------
forvalues Y =1/24 {
	foreach X in `varlist' {
		if MM[ `Y',4]==0 {
			bys year: egen `X'1  = total( `X') if fips_st==51 & inlist(fips_co, MM[ `Y',2], MM[ `Y',3] )
			qui replace `X'          = `X'1        if fips_st==51 & inlist(fips_co, MM[ `Y',2], MM[ `Y',3] )
		}
		else {
			bys year: egen `X'1  = total( `X') if fips_st==51 & inlist(fips_co, MM[ `Y',2], MM[ `Y',3], MM[ `Y',4] )
			qui replace `X'          = `X'1        if fips_st==51 & inlist(fips_co, MM[ `Y',2], MM[ `Y',3], MM[ `Y',4] )
		}
		qui drop `X'1
	}
	disp "`Y'"
}
save `holder2', replace

*============================================================================
* Bring in IPEDS county data
*============================================================================
use IPEDS/ipeds_final, clear
* drop if fips_st==-99 | fips_co==-99

gen fips_st = floor(fips5/1000)
gen fips_co = mod(fips5,1000)

sort year fips_st fips_co 
keep year fips_st fips_co numBA numAA tuitionFlagship

* No values for fips_??=-99; these will be created post-merge
tempfile holderIPEDS
save `holder3', replace

*============================================================================
* Bring in MSA crosswalk
*============================================================================
insheet using Census/countyxwalk.csv, comma clear
gen fips_st = floor(county/1000)
gen fips_co = county-fips_st*1000
keep fips_st fips_co cbsa

save `holder4', replace

*============================================================================
* Merge BEA, Census, IPEDS and MSA crosswalk
*============================================================================
use `holder1', clear
merge 1:1 fips_st fips_co year using `holder2'    , gen(mergeCensus)
merge 1:1 fips_st fips_co year using `holder3', gen(mergeIPEDS)
* About 30 of the 1500 counties in IPEDS are not in BEA/Census (chgs year to year)
* Also, a few of the master only counties have no/incomplete data, and thus are ignored
*   These are mostly in Alaska; Alaska is weird in the BEA/Census data
* However, in 1988 & 2005, there are no matched obs that have missing popAllTotal
isid fips_co fips_st year
merge m:1 fips_co fips_st using `holder4', gen(mergeMSA)

*============================================================================
* Last Data Edits
*============================================================================
* "weighted average" IPEDS data
bys year fips_st (fips_co): gen     numCounty = _N-1
bys year (fips_st fips_co): replace numCounty = _N-1-51 if fips_st==-99

foreach X in numBA numAA tuitionFlagship {
	gen tempWgt = `X'*popAllTotal if fips_co~=-99
	bys year fips_st (fips_co): egen tempWgt2 = total(tempWgt)
	bys year fips_st (fips_co): replace `X' = tempWgt2/popAllTotal if fips_co==-99

	bys year (fips_st fips_co): egen tempWgt3 = total(tempWgt)
	bys year (fips_st fips_co): replace `X' = tempWgt3/popAllTotal if fips_st==-99
	drop tempWgt*
	
	if "`X'"=="tuitionFlagship"  bys year fips_st (fips_co): replace `X' = `X'[1] if mi(`X') & fips_co~=-99 & year>=1987
	else {
		replace `X' = 0 if mi(`X') & fips_co~=-99 & year>=1987
		gen     `X'perCapita = `X'/popAllTotal             if fips_co~=-99
		replace `X'perCapita = `X'/(popAllTotal/numCounty) if fips_co==-99
	}
	assert ~mi(`X') if year>=1987
}

* Hand Edit
replace cbsa = 26820 if fips_st==16 & fips_co==23

* Switch to CBSA based vs county based
* gen income = incPerCapita*popAllBEA
bys cbsa year: egen incomeMSA       = total(income)             if cbsa<50000
bys cbsa year: egen popAllBEA_MSA   = total(popAllBEA)          if cbsa<50000
bys cbsa year: egen popWorkTotalMSA = total(popWorkTotal)       if cbsa<50000
bys cbsa year: egen empTotMSA       = total(empTot      )       if cbsa<50000
bys cbsa year: gen  incPerCapitaMSA = incomeMSA / popAllBEA_MSA if cbsa<50000

gen     incPerCapitaFinal = incPerCapita              if cbsa>=50000
replace incPerCapitaFinal = incPerCapitaMSA           if cbsa< 50000
gen     empPct            = empTot/popWorkTotal
gen     empPctFinal       = empTot/popWorkTotal       if cbsa>=50000
replace empPctFinal       = empTotMSA/popWorkTotalMSA if cbsa< 50000

* 95% match. Main problems are:
*  Alaska (2) and Virginia(51)
*   could be an error in the coding?? 

*============================================================================
* Deflate incPerCapita (Note: In current 1,000's of $ -> 1982-1984 1,000's of $
*============================================================================
do BLS/cpi.do

replace incPerCapita      = incPerCapita/cpi
replace incPerCapitaFinal = incPerCapitaFinal/cpi
replace incPerCapitaMSA   = incPerCapitaMSA/cpi

keep  year fips_st fips_co AreaName cbsa incPerCapitaFinal empPctFinal incPerCapita incPerCapitaMSA empPct empTot empTotMSA popAllTotal popWorkTotal popWorkTotalMSA numBA numAA numBAperCapita numAAperCapita tuitionFlagship
order year fips_st fips_co AreaName cbsa incPerCapitaFinal empPctFinal incPerCapita incPerCapitaMSA empPct empTot empTotMSA popAllTotal popWorkTotal popWorkTotalMSA numBA numAA numBAperCapita numAAperCapita tuitionFlagship
sort  year fips_st fips_co

drop if year>2016
compress
save county_data.dta, replace

log close
