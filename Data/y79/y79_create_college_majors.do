version 11.1
clear all
set more off
capture log close

log using "y79_create_college_majors.log", replace

use y79_college_majors, clear

gen     collegeMajor = college1major
replace collegeMajor = college2major if mi(college1major) & !mi(college2major)
replace collegeMajor = college3major if mi(college1major) &  mi(college2major) & !mi(college3major)

gen     collegeMajorField =         floor(collegeMajor/100)
replace collegeMajorField = 99 if inrange(collegeMajor,2400,9999)

label define collegeField  0 "None, General Studies"
label define collegeField  1 "Agriculture and Natural Resources", add
label define collegeField  2 "Architecture and Environmental Design", add
label define collegeField  3 "Area Studies", add
label define collegeField  4 "Biological Sciences", add
label define collegeField  5 "Business and Management", add
label define collegeField  6 "Communications", add
label define collegeField  7 "Computer and Information Sciences", add
label define collegeField  8 "Education", add
label define collegeField  9 "Engineering", add
label define collegeField 10 "Fine and Applied Arts", add
label define collegeField 11 "Foreign Languages", add
label define collegeField 12 "Health Professions", add
label define collegeField 13 "Home Economics", add
label define collegeField 14 "Law", add
label define collegeField 15 "Letters", add
label define collegeField 16 "Library Science", add
label define collegeField 17 "Mathematics", add
label define collegeField 18 "Military Sciences", add
label define collegeField 19 "Physical Sciences", add
label define collegeField 20 "Psychology", add
label define collegeField 21 "Public Affairs and Services", add
label define collegeField 22 "Social Sciences", add
label define collegeField 23 "Theology", add
label define collegeField 99 "Other Field", add

label values collegeMajorField collegeField
* STEM
* 4 Biological Sciences
* 7 Computer and Information Sciences
* 9 Engineering
* 17 Mathematics
* 19 Physical Sciences
* 1203 Nursing

* Business
* 5 Business and Management

* Humanities
* 3 Area Studies
* 6 Communications
* 10 Fine and Applied Arts
* 11 Foreign Languages
* 14 Law
* 15 Letters
* 16 Library Science
* 23 Theology

* Econ
* 2204 Econ

* Social Science
* 20 Psychology
* 21 Public Affairs and Services
* 22 Social Sciences;                    ~2204 Econ


* Other
* 0 None, General Studies
* 1 Agriculture and Natural Resources
* 2 Architecture and Environmental Design
* 8 Education
* 12 Health Professions;                 ~1203 Nursing
* 13 Home Economics
* 18 Military Sciences
* 99 Other Field


* Group into categories: STEM, business, humanities
* what to with 2
* or           12
gen     collegeMajorUberField = 1 if inlist(collegeMajorField,4,7,9,17,19)         | collegeMajor==1203
replace collegeMajorUberField = 2 if inlist(collegeMajorField,5)
replace collegeMajorUberField = 3 if inlist(collegeMajorField,3,6,10,11,14,15,16,23)
replace collegeMajorUberField = 4 if                                                 collegeMajor==2204
replace collegeMajorUberField = 5 if inlist(collegeMajorField,20,21,22)            & collegeMajor!=2204
replace collegeMajorUberField = 6 if inlist(collegeMajorField,0,1,2,8,12,13,18,99) & collegeMajor!=1203

label define collegeField2 1 "STEM"
label define collegeField2 2 "Business", add
label define collegeField2 3 "Humanities", add
label define collegeField2 4 "Econ", add
label define collegeField2 5 "SocSci", add
label define collegeField2 6 "Other", add
label define collegeField2 7 "Unknown (missing)", add

label values collegeMajorUberField collegeField2

preserve
	keep if !mi(collegeMajor)
	bysort id (year): keep if _n==_N
	save y79_college_major_final, replace
restore

log close
