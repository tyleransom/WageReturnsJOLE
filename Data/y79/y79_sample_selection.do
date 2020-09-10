version 11.1
clear all
set more off
capture log close

set mem 3g
set maxvar 20000

log using "y79_sample_selection.log", replace

**************************************************
* Same drops happen here as in y79_create_trim (wherein
*  we create our final dataset)
* but here they are done correctly for one unified 79 cohort
**************************************************


!unzip -u y79_all_balanced.dta.zip
use y79_all_balanced.dta, clear
!rm y79_all_balanced.dta

*=================================================
* Frequency stats and droppings
*=================================================
*** "Drop" females and over-samples
* One cohort
qui count if uniqueTime==1301
scalar r0 = r(N)
qui count if uniqueTime==1301  &  female
scalar r1 = r(N)             
qui count if uniqueTime==1301  & !female &  birthYear< 1959
scalar r1a = r(N)           
qui count if uniqueTime==1301  & !female &  birthYear>=1959 & (oversamplePoor | oversampleMilitary)
scalar r2 = r(N)              
qui count if uniqueTime==1301  & !female &  birthYear>=1959 & !oversamplePoor & !oversampleMilitary
scalar r3 = r(N)                                

disp "Starting persons  (one cohort) "  r0
disp "Drop females      (one cohort) "  r1
disp "Drop older cohorts(one cohort) "  r1a
disp "Drop oversample   (one cohort) "  r2
disp "Resulting persons (one cohort) "  r3


* qui count if uniqueTime==1301 & !female & birthYear==1957 & !oversamplePoor & !oversampleMilitary
* scalar r57 = r(N)
* qui count if uniqueTime==1301 & !female & birthYear==1958 & !oversamplePoor & !oversampleMilitary
* scalar r58 = r(N)
qui count if uniqueTime==1301 & !female & birthYear==1959 & !oversamplePoor & !oversampleMilitary
scalar r59 = r(N)
qui count if uniqueTime==1301 & !female & birthYear==1960 & !oversamplePoor & !oversampleMilitary
scalar r60 = r(N)
qui count if uniqueTime==1301 & !female & birthYear==1961 & !oversamplePoor & !oversampleMilitary
scalar r61 = r(N)
qui count if uniqueTime==1301 & !female & birthYear==1962 & !oversamplePoor & !oversampleMilitary
scalar r62 = r(N)
qui count if uniqueTime==1301 & !female & birthYear==1963 & !oversamplePoor & !oversampleMilitary
scalar r63 = r(N)
qui count if uniqueTime==1301 & !female & birthYear==1964 & !oversamplePoor & !oversampleMilitary
scalar r64 = r(N)

* For 79:
*  dob   age_int  svy_rounds  final_rounds (with imputed data)
*  1964  14-35    20          20
*  1963  15-35    20          20
*  1962  16-35    20          20
*  1961  17-35    19          20
*  1960  18-35    18          20
*  1959  19-35    17          20
*  1958  20-35    16          20
*  1957  21-35    15          20

* rounds ~= waves: rounds is a proxy for how many years were you surveyed, whereas waves referes to 
*                  how often the survey was done, which moved to every other year
disp "Survey waves                         " 18
disp "Survey Person-years     (one cohort) " r64*20 + r63*20 + r62*20 + r61*19 + r60*18 + r59*17
disp "Add Retro data          (one cohort) " r64*0  + r63*0  + r62*0  + r61*1  + r60*2  + r59*3 
disp "Potential person-years  (one cohort) " r3*20
disp "Potential person-months (one cohort) " r3*20*12


drop if oversamplePoor | oversampleMilitary

*** Drop observations after last (valid) interview and more counts
* Youngins
count    if birthYear>=1959 & !female & ( mdy(month,1,year)> lastValidIntDate | mdy(month,1,year)> lastValidSchoolDate ) & uniqueTime>=1601 & uniqueTime<=3512
scalar s0 = r(N)
xtsum id if birthYear>=1959 & !female &   mdy(month,1,year)<=lastValidIntDate & mdy(month,1,year)<=lastValidSchoolDate   & uniqueTime>=1601 & uniqueTime<=3512
scalar s1 = r(N)
scalar s2 = r(Tbar)
xtsum id if birthYear>=1959 & !female &   mdy(month,1,year)<=lastValidIntDate & mdy(month,1,year)<=lastValidSchoolDate   & ageMo==0 & uniqueTime>=1601 & uniqueTime<=3512
scalar s3 = r(N)
scalar s4 = r(n)

disp "Drop missing int months " s0
disp "Final months "            s1
disp "Final Tbar "              s2

disp "Final years "             s3
disp "Final persons "           s4
disp "Drop missing int years "  s4*20-s3

xtsum id if birthYear>=1959 & !female &   mdy(month,1,year)<=lastValidIntDate & mdy(month,1,year)<=lastValidSchoolDate   & ageMo==0 & uniqueTime>=1601 & uniqueTime<=1612
xtsum id if birthYear>=1959 & !female &   mdy(month,1,year)<=lastValidIntDate & mdy(month,1,year)<=lastValidSchoolDate   & ageMo==0 & uniqueTime>=2801 & uniqueTime<=2812
xtsum id if birthYear>=1959 & !female &   mdy(month,1,year)<=lastValidIntDate & mdy(month,1,year)<=lastValidSchoolDate   & ageMo==0 & uniqueTime>=3101 & uniqueTime<=3112
xtsum id if birthYear>=1959 & !female &   mdy(month,1,year)<=lastValidIntDate & mdy(month,1,year)<=lastValidSchoolDate   & ageMo==0 & uniqueTime>=3501 & uniqueTime<=3512

drop     if mdy(month,1,year)>lastValidIntDate
drop     if mdy(month,1,year)>lastValidSchoolDate

log close

