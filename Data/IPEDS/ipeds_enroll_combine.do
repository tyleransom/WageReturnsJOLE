version 14.1
capture log close
set more off
log using ipeds_enroll_combine.log, replace

clear all

*********************************************************************
* Merge all the relevant enrollment data into one dataset
*********************************************************************
foreach X of numlist 1980 1986 1994(2)2014 {	
	if `X'==1980             use unitid field                  line          efrace15 efrace16 fteptr fteptc using IndividualDo/enrollMajor`X'.dta, clear
	if `X'>=1986 & `X'<=2000 use unitid cipcode section lstudy line          efrace15 efrace16               using IndividualDo/enrollMajor`X'.dta, clear
	if `X'>=2002 & `X'<=2006 use unitid cipcode section lstudy line efciplev efrace15 efrace16               using IndividualDo/enrollMajor`X'.dta, clear
	if `X'>=2008 & `X'<=2014 use unitid cipcode section lstudy line efciplev eftotlm eftotlw                 using IndividualDo/enrollMajor`X'.dta, clear

	* Changes: rename certain vars
	if `X'>=1986 & `X'<=1998 ren lstudy   lstudyA
	
	if `X'>=1980 & `X'<=2006 ren efrace15 eftotalm
	if `X'>=2008 & `X'<=2014 ren eftotlm  eftotalm
	
	if `X'>=1980 & `X'<=2006 ren efrace16 eftotalw	
	if `X'>=2008 & `X'<=2014 ren eftotlw  eftotalw
	
	* Changes: apply labels at more opportune times
	if `X'<=1986 capture label drop label_cipcode
	if `X'<=2000 capture label drop label_line
	
	gen eftotalt = eftotalm + eftotalw
	label var eftotalt "Grand total"
	
	gen year = `X'
	
	compress
	tempfile holder`X'
	save `holder`X'', replace
}

clear
foreach X of numlist 1980 1986 1994(2)2014 {
	disp `X'
	append using `holder`X''
}

order unitid year cipcode section lstudy lstudyA line eftotalm eftotalw eftotalt 
sort  unitid year cipcode line

*=============================
* Clean
*=============================
* There are a LOT of different flag variables in the dataset.
*  line is a very handy variable
*    8 total FT undergrads
*    9 total FT first-professional (Various Medical Doctoral Degrees (MD, DDS, PharmD, OD, DO, PodD, Chiro); Theology; Veterinary Med; Law)
*   11 total FT graduates
*  But that's not true for the early years (1980, 1986, 1994)
* for 1986 and 1994, there is no variable that defines all ftfirstprof or ftgraduate
*  ftfirstprof: add line== 9 through 10
*  ftgraduate:  add line==11 through 12
*  ptfirstprof: add line==23 through 24
*  ptgraduate:  add line==25 through 26
gen     flag = 101 if inlist(line,9,10)
replace flag = 102 if inlist(line,11,12)
replace flag = 103 if inlist(line,23,24)
replace flag = 104 if inlist(line,25,26)

preserve
	collapse (sum) eftotal* if inlist(year,1986,1994) & inlist(flag,101,102,103,104), by(unitid year cipcode section flag)
	ren flag line
	tempfile holder0
	save `holder0', replace
restore
append using `holder0'

gen ftundergrad = (line== 1 & year==1980) | (line==  8 & year>=1986)
gen ftfirstprof = (line==10 & year==1980) | (line==101 & inlist(year,1986,1994) ) | (line== 9 & year>=2000)
gen ftgraduate  = (line==11 & year==1980) | (line==102 & inlist(year,1986,1994) ) | (line==11 & year>=2000)

gen ptundergrad = (line==15 & year==1980) | (line== 22 & year>=1986)
gen ptfirstprof = (line==24 & year==1980) | (line==103 & inlist(year,1986,1994) ) | (line==23 & year>=2000)
gen ptgraduate  = (line==25 & year==1980) | (line==104 & inlist(year,1986,1994) ) | (line==25 & year>=2000)

* Checks
assert section~=2 & section~=3 if ftundergrad | ftfirstprof | ftgraduate
assert section~=1 & section~=3 if ptundergrad | ptfirstprof | ptgraduate

recode cipcode (400=40000) (600=520000) (1400=140000) (1804=510401) (1810=511201) (1824=512401) (2200=220101) (2600=260000) (2700=270000) (4000=400000) if year==1986

gen business = (cipcode==520000) | (field==500)

*=============================
* Label
*=============================
* label drop vlawlevel
label data "Enrollments by (some) Majors, 1980-2014"

label var year "year"

label define label_section 3 "All", add


compress
save enroll_all.dta, replace

log close
