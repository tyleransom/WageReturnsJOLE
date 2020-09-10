version 14.1
capture log close
set more off
log using import_census.log, replace

*****************************************************************************
* Create county population file containing total, male and female pop
*  for each county, both working age (20-64) and total.
* Each decade requires unique formatting
*****************************************************************************
*============================================================================
* 1970s
*  variable race_sex: 1 = White males
*                     2 = White females
*                     3 = Black males
*                     4 = Black females
*                     5 = Other race males
*                     6 = Other race females
*============================================================================
insheet using 1970s/pop_sex_age_race1970_1979.csv, comma clear	
rename v1  year
rename v2  fips_stco
rename v3  race_sex
rename v4  age00_04
rename v5  age05_09
rename v6  age10_14
rename v7  age15_19
rename v8  age20_24
rename v9  age25_29
rename v10 age30_34
rename v11 age35_39
rename v12 age40_44
rename v13 age45_49
rename v14 age50_54
rename v15 age55_59
rename v16 age60_64
rename v17 age65_69
rename v18 age70_74
rename v19 age75_79
rename v20 age80_84
rename v21 age85plus

egen popAll  = rowtotal(age00_04-age85plus)
egen popWork = rowtotal(age15_19-age60_64)

drop age*

reshape wide popAll popWork, i(year fips_stco) j(race_sex)

egen popAllTotal   = rowtotal(popAll?)
gen  popAllMale    = popAll1 + popAll3 + popAll5
gen  popAllFemale  = popAll2 + popAll4 + popAll6
egen popWorkTotal  = rowtotal(popWork?)
gen  popWorkMale   = popWork1 + popWork3 + popWork5
gen  popWorkFemale = popWork2 + popWork4 + popWork6

drop popAll? popWork?

gen fips_st = floor(fips_stco/1000)
gen fips_co = fips_stco-fips_st*1000
order fips_st fips_co year
drop fips_stco

tempfile holder1970s
save `holder1970s'

*============================================================================
* 1980s
*============================================================================
forvalues X = 1980/1989 {
	insheet using 1980s/pop_sex_age_race`X'.csv, clear double
	drop in 1/6
	replace v3 ="1" if v3=="White male"
	replace v3 ="2" if v3=="White female"
	replace v3 ="3" if v3=="Black male"
	replace v3 ="4" if v3=="Black female"
	replace v3 ="5" if v3=="Other races male"
	replace v3 ="6" if v3=="Other races female"
	destring _all, replace
	
	rename v1  year
	rename v2  fips_stco
	rename v3  race_sex
	rename v4  age00_04
	rename v5  age05_09
	rename v6  age10_14
	rename v7  age15_19
	rename v8  age20_24
	rename v9  age25_29
	rename v10 age30_34
	rename v11 age35_39
	rename v12 age40_44
	rename v13 age45_49
	rename v14 age50_54
	rename v15 age55_59
	rename v16 age60_64
	rename v17 age65_69
	rename v18 age70_74
	rename v19 age75_79
	rename v20 age80_84
	rename v21 age85plus
	
	egen popAll  = rowtotal(age00_04-age85plus)
	egen popWork = rowtotal(age15_19-age60_64)

	drop age*

	reshape wide popAll popWork, i(year fips_stco) j(race_sex)

	egen popAllTotal   = rowtotal(popAll*)
	gen  popAllMale    = popAll1 + popAll3 + popAll5
	gen  popAllFemale  = popAll2 + popAll4 + popAll6
	egen popWorkTotal  = rowtotal(popWork*)
	gen  popWorkMale   = popWork1 + popWork3 + popWork5
	gen  popWorkFemale = popWork2 + popWork4 + popWork6

	drop popAll? popWork?
	
	tempfile holder`X'
	save `holder`X''
}

use `holder1980', replace
forvalues X = 1981/1989 {
	append using `holder`X''
}

gen fips_st = floor(fips_stco/1000)
gen fips_co = fips_stco-fips_st*1000
order fips_st fips_co year
drop fips_stco

tempfile holder1980s
save `holder1980s'

*============================================================================
* 1990s
*  sex (1=male 2=female)
*  valueXX is pop of age XX
*============================================================================
local state_fips     01 02 04 05 06 08 09 10 11 12 13 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31 32 33 34 35 36 37 38 39 40 41 42 44 45 46 47 48 49 50 51 53 54 55 56
local state_fips_alt    02 04 05 06 08 09 10 11 12 13 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31 32 33 34 35 36 37 38 39 40 41 42 44 45 46 47 48 49 50 51 53 54 55 56

foreach X in `state_fips' {
	disp "`X'"
	infile using 1990s_dictionary.dct, using (1990s/CO-99-9-`X'.txt) clear
	reshape long value , i(fips_stco age sex) j(year)
	reshape wide value , i(fips_stco sex year) j(age)
	
	egen popAll  = rowtotal(value*)
	egen popWork = rowtotal(value15-value64)
	drop value*

	reshape wide popAll popWork, i(fips_stco year) j(sex)
	gen popAllTotal  = popAll1  + popAll2
	ren popAll1        popAllMale
	ren popAll2        popAllFemale
	gen popWorkTotal = popWork1 + popWork2
	ren popWork1       popWorkMale
	ren popWork2       popWorkFemale
	
	order popAllTotal popAllMale popAllFemale popWorkTotal popWorkMale popWorkFemale, after(year)

	tempfile holder`X'
	save `holder`X''
	
}

use `holder01'
foreach X in `state_fips_alt' {
	append using `holder`X''
}

gen fips_st = floor(fips_stco/1000)
gen fips_co = fips_stco-fips_st*1000
order fips_st fips_co year
drop fips_stco

tempfile holder1990s
save `holder1990s'

*============================================================================
* 2000s
*  sex (0=total 1=male 2=female)
*  agegrp (0=total 1=<4 2=5-9 3=10-14 4=15-19 ... 13=60-64 ... 18=85+)
*============================================================================
insheet using 2000s/pop_sex_age2000_2010.csv, clear comma
drop sumlev stname ctyname popestimate2000 popestimate2010
rename state  fips_st
rename county fips_co
rename estimatesbase2000 popestimate2000
rename census2010pop     popestimate2010
reshape long popestimate, i(fips_st fips_co sex agegrp) j(year)
reshape wide popestimate, i(fips_st fips_co sex year)   j(agegrp)

gen  popAll   = popestimate0
egen popWork  = rowtotal(popestimate4-popestimate13)

drop popestimate*
reshape wide popAll popWork, i(fips_st fips_co year) j(sex)
ren popAll0  popAllTotal
ren popAll1  popAllMale
ren popAll2  popAllFemale
ren popWork0 popWorkTotal
ren popWork1 popWorkMale
ren popWork2 popWorkFemale

order popAllTotal popAllMale popAllFemale popWorkTotal popWorkMale popWorkFemale, after(year)

tempfile holder2000s
save `holder2000s'

*============================================================================
* 2010s
* The key for the YEAR variable is as follows:
*   1 = 4/1/2010 Census population
*   2 = 4/1/2010 population estimates base
*   3 = 7/1/2010 population estimate
*   4 = 7/1/2011 population estimate
*   5 = 7/1/2012 population estimate
*   6 = 7/1/2013 population estimate
*   7 = 7/1/2014 population estimate
*   8 = 7/1/2015 population estimate
*   9 = 7/1/2016 population estimate
*   10 = 7/1/2017 population estimate
*  agegrp (0=total 1=<4 2=5-9 3=10-14 4=15-19 ... 13=60-64 ... 18=85+)
*============================================================================
insheet using 2010s/cc-est2017-alldata.csv, clear comma
keep state county year agegrp tot_pop tot_male tot_female
ren state  fips_st
ren county fips_co
reshape wide tot_pop tot_male tot_female, i(fips_st fips_co year) j(agegrp)
order tot_pop* tot_male* tot_female*, after(year)

gen popAllTotal    = tot_pop0
gen popAllMale     = tot_male0
gen popAllFemale   = tot_female0
egen popWorkTotal  = rowtotal(tot_pop4   -tot_pop13)
egen popWorkMale   = rowtotal(tot_male4  -tot_male13)
egen popWorkFemale = rowtotal(tot_female4-tot_female13)

drop tot_*

keep if inrange(year,4,10)
recode year (4 = 2011) (5 = 2012) (6 = 2013) (7 = 2014) (8 = 2015) (9 = 2016) (10 = 2017)

tempfile holder2010s
save `holder2010s'

*============================================================================
* All
*============================================================================
use `holder1970s'
append using `holder1980s' `holder1990s' `holder2000s' `holder2010s'

label var fips_st         "State FIPS code"
label var fips_co         "County FIPS code"
label var popAllTotal     "Total Population" 
label var popAllMale      "Male Population" 
label var popAllFemale    "Female Population" 
label var popWorkTotal    "Total Working Age Population (15-64)" 
label var popWorkMale     "Male Working Age Population (15-64)" 
label var popWorkFemale   "Female Working Age Population (15-64)" 
compress

sort fips_st fips_co year
save county_population.dta, replace

log close
