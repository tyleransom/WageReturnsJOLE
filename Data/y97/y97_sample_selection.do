version 11.1
clear all
set more off
capture log close

set mem 3g
set maxvar 20000

log using "y97_sample_selection.log", replace

**************************************************
* Same drops happen here as in y97_create_trim (wherein
*  we create our final dataset)
**************************************************


!unzip -u y97_all_balanced.dta.zip
use y97_all_balanced.dta, clear
!rm y97_all_balanced.dta

*=================================================
* Frequency stats and droppings
*=================================================
xtset id uniqueTime
xtsum id if inrange(year,1997,2016)
xtsum id if inrange(age,16,36) & female==0 
xtsum id if inrange(age,16,36) & female==0 & mixed==0

* -------------------------------------------------------------------------
* get number of people in each birth cohort for potential survey definition
* -------------------------------------------------------------------------

* If t0=13:
* yob    ages_interviewed  #ints (years) by 36  # ints (years) when incorporating retrospective info
* -------------------------------------------------------------------------------------------
* 84        12~31                19                 19
* 83        13~32                20                 20
* 82        14~33                20                 21
* 81        15~34                20                 22
* 80        16~35                20                 23

* If t0=16:
* yob    ages_interviewed  #ints (years) by 36  # ints (years) when incorporating retrospective info
* -------------------------------------------------------------------------------------------
* 84        12~31                16                 16
* 83        13~32                17                 17
* 82        14~33                18                 18
* 81        15~34                19                 29
* 80        16~35                20                 21

bys id (uniqueTime): gen firstPer = _n==1
tab birthYear if female==0 & mixed==0 & firstPer

*=================================================
* Frequency stats and droppings
*=================================================
*** "Drop" females and over-samples
* One cohort
qui count if uniqueTime==1301
scalar r0 = r(N)
qui count if uniqueTime==1301  &  female
scalar r1 = r(N)             
qui count if uniqueTime==1301  & !female &  mixed
scalar r2 = r(N)              
qui count if uniqueTime==1301  & !female & !mixed
scalar r3 = r(N)                                

disp "Starting persons  (one cohort) "  r0
disp "Drop females      (one cohort) "  r1
disp "Drop mixed race   (one cohort) "  r2
disp "Resulting persons (one cohort) "  r3


qui count if uniqueTime==1301 & !female & birthYear==1980 & !mixed
scalar r80 = r(N)
qui count if uniqueTime==1301 & !female & birthYear==1981 & !mixed
scalar r81 = r(N)
qui count if uniqueTime==1301 & !female & birthYear==1982 & !mixed
scalar r82 = r(N)
qui count if uniqueTime==1301 & !female & birthYear==1983 & !mixed
scalar r83 = r(N)
qui count if uniqueTime==1301 & !female & birthYear==1984 & !mixed
scalar r84 = r(N)

* for 97:
* yob    ages_interviewed  #ints (years) by 36  # ints (years) when incorporating retrospective info
* -------------------------------------------------------------------------------------------
* 84        12~31                16                 16
* 83        13~32                17                 17
* 82        14~33                18                 18
* 81        15~34                19                 19
* 80        16~35                20                 21

* rounds ~= waves: rounds is a proxy for how many years were you surveyed, whereas waves referes to 
*                  how often the survey was done, which moved to every other year
disp "Survey waves:            " 17
disp "Survey Person-years:     " r84*16 + r83*17 + r82*18 + r81*19 + r80*20
disp "Add Retro data:          " r84*0  + r83*0  + r82*0  + r81*0  + r80*1 
disp "Potential person-years:  " r84*16 + r83*17 + r82*18 + r81*19 + r80*20 + r80*1
disp "Potential person-months: " (r84*16 + r83*17 + r82*18 + r81*19 + r80*20)*12


drop if mixed

* flag months for people after R17 interview date
gen R17intflag = R17interviewDate<=ym(year,month) & ~mi(R17interviewDate)
* flag months for people after last valid interview date
gen yrmo = year*100+month
gen yrmo_last = year(last_int_day)*100+month(last_int_day)
gen lastintflag = yrmo>=yrmo_last
* flag everything after the beginning of long missed interview spells
*long_miss_flag (already created)
* flag right-censored interview spells
tab max_nonmissing_int_year year if year>=2015
gen rightcens_spell = year>max_nonmissing_int_year
* flag observations after someone "illegally" went to college (without a Diploma)
*mdy(month,1,year>lastValidSchoolDate) 

*** Drop observations after last (valid) interview, after start of long missed interview spell, right-censored interview spell, or after attending school out of sequence ...  and more counts
count    if !female &  ( R17intflag==1 | lastintflag==1 | long_miss_flag==1 | rightcens_spell==1 | (mdy(month,1,year)>lastValidSchoolDate) ) & uniqueTime>=1601 & uniqueTime<=3512
scalar s0 = r(N)
xtsum id if !female &    R17intflag==0 & lastintflag==0 & long_miss_flag==0 & rightcens_spell==0 & (mdy(month,1,year)<=lastValidSchoolDate)  & uniqueTime>=1601 & uniqueTime<=3512
scalar s1 = r(N)
scalar s2 = r(Tbar)
xtsum id if !female &    R17intflag==0 & lastintflag==0 & long_miss_flag==0 & rightcens_spell==0 & (mdy(month,1,year)<=lastValidSchoolDate)  & ageMo==0 & uniqueTime>=1601 & uniqueTime<=3512
scalar s3 = r(N)
scalar s4 = r(n)

disp "Drop missing int months " s0
disp "Final months "            s1
disp "Final Tbar "              s2

disp "Final years "             s3
disp "Final persons "           s4
disp "Drop missing int years "  s4*20-s3

xtsum id if !female & R17intflag==0 & lastintflag==0 & long_miss_flag==0 & rightcens_spell==0 & mdy(month,1,year<=lastValidSchoolDate) & ageMo==0 & uniqueTime>=1601 & uniqueTime<=1612
xtsum id if !female & R17intflag==0 & lastintflag==0 & long_miss_flag==0 & rightcens_spell==0 & mdy(month,1,year<=lastValidSchoolDate) & ageMo==0 & uniqueTime>=2801 & uniqueTime<=2812
xtsum id if !female & R17intflag==0 & lastintflag==0 & long_miss_flag==0 & rightcens_spell==0 & mdy(month,1,year<=lastValidSchoolDate) & ageMo==0 & uniqueTime>=3101 & uniqueTime<=3112
xtsum id if !female & R17intflag==0 & lastintflag==0 & long_miss_flag==0 & rightcens_spell==0 & mdy(month,1,year<=lastValidSchoolDate) & ageMo==0 & uniqueTime>=3501 & uniqueTime<=3512

xtsum id if !female & R17intflag==0 & lastintflag==0 & long_miss_flag==0 & rightcens_spell==0 & mdy(month,1,year<=lastValidSchoolDate) & uniqueTime>=1601 & uniqueTime<=1612
xtsum id if !female & R17intflag==0 & lastintflag==0 & long_miss_flag==0 & rightcens_spell==0 & mdy(month,1,year<=lastValidSchoolDate) & uniqueTime>=2801 & uniqueTime<=2812
xtsum id if !female & R17intflag==0 & lastintflag==0 & long_miss_flag==0 & rightcens_spell==0 & mdy(month,1,year<=lastValidSchoolDate) & uniqueTime>=2812 & uniqueTime<=2812
xtsum id if !female & R17intflag==0 & lastintflag==0 & long_miss_flag==0 & rightcens_spell==0 & mdy(month,1,year<=lastValidSchoolDate) & uniqueTime>=3101 & uniqueTime<=3101
xtsum id if !female & R17intflag==0 & lastintflag==0 & long_miss_flag==0 & rightcens_spell==0 & mdy(month,1,year<=lastValidSchoolDate) & uniqueTime>=3112 & uniqueTime<=3112
xtsum id if !female & R17intflag==0 & lastintflag==0 & long_miss_flag==0 & rightcens_spell==0 & mdy(month,1,year<=lastValidSchoolDate) & uniqueTime>=3501 & uniqueTime<=3512

log close

