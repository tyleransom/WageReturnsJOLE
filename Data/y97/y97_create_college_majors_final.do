version 11.2
clear all
set mem 12g
set more off
capture log close

log using "y97_create_college_majors_final.log", replace

use /afs/econ.duke.edu/data/vjh3/WageReturns/Data/y97/y97_coll_major.dta

lab def vl_Majors   0 "None/Don't Know"   1 "Agriculture/Natural resources"   2 "Anthropology"   3 "Archaeology"   4 "Architecture/Environmental design"   5 "Area studies"   6 "Biological sciences"   7 "Business management"   8 "Communications"   9 "Computer/Information science"  10 "Criminology"  11 "Economics"  12 "Education"  13 "Engineering"  14 "English"  15 "Ethnic studies"  16 "Fine and applied arts"  17 "Foreign languages"  18 "History"  19 "Home economics"  20 "Interdisciplinary studies"  21 "Mathematics"  22 "Nursing"  23 "Other health professions"  24 "Philosophy"  25 "Physical sciences"  26 "Political science and government"  27 "Pre-dental"  28 "Pre-law"  29 "Pre-med"  30 "Pre-vet"  31 "Psychology"  32 "Sociology"  33 "Theology/religious studies"  36 "Nutrition/Dietetics"  37 "Hotel/Hospitality management"  99 "Other field (SPECIFY)" 999 "UNCODABLE"
lab val finalMajor vl_Majors

gen STEM      = inlist(finalMajor,6,9,13,21,22,25,27,29,30,36)
gen Business  = inlist(finalMajor,7)
gen Hum       = inlist(finalMajor,5,8,14,15,16,17,24,28,33)
gen Econ      = inlist(finalMajor,11)
gen SocSci    = inlist(finalMajor,2,3,10,18,26,31,32)
gen Other     = inlist(finalMajor,0,1,4,12,19,20,23,37) | inrange(finalMajor,38,.)
gen MissMajor = mi(finalMajor) & everGrad4yr

lab val STEM      vl_Majors
lab val Business  vl_Majors
lab val Hum       vl_Majors
lab val Econ      vl_Majors
lab val SocSci    vl_Majors
lab val Other     vl_Majors
lab val MissMajor vl_Majors

gen MajorAgg = .
replace MajorAgg = 1 if STEM     
replace MajorAgg = 2 if Business 
replace MajorAgg = 3 if Hum      
replace MajorAgg = 4 if Econ     
replace MajorAgg = 5 if SocSci   
replace MajorAgg = 6 if Other    
replace MajorAgg = 7 if MissMajor

lab def vl_MajorAgg 1 "STEM" 2 "Business" 3 "Humanities" 4 "Economics" 5 "Social Sciences" 6 "Other" 7 "Missing Major"
lab val MajorAgg vl_MajorAgg

keep if ~female & everGrad4yr & year==1997
tab finalMajor if STEM     
tab finalMajor if Business 
tab finalMajor if Hum      
tab finalMajor if Econ     
tab finalMajor if SocSci   
tab finalMajor if Other    
tab finalMajor if MissMajor

tab MajorAgg

tab finalMajor

ren finalMajor collegeMajorField
ren MajorAgg collegeMajorUberField
gen cohortFlag = 1997
keep if year == 1997
ren ID id

keep id cohortFlag collegeMajorField collegeMajorUberField
save /afs/econ.duke.edu/data/vjh3/WageReturns/Data/y97/y97_college_majors_final, replace

log close
