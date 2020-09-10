version 14.1
capture log close
set more off
log using ipeds_comp_combine.log, replace

clear all

*********************************************************************
* Merge all the relevant completions data into one dataset
*  Note, comp2009, for example, refers to completions b/t Jul 2008
*   and Jun 2009. Year is set equal to file extension, b/c final
*   data should be in school years, where the 2009 school year is
*   2008-2009.
*********************************************************************

forvalues X = 1984/2015 {	
	if `X'>=1984 & `X'<=2000 use unitid cipcode awlevel crace15 crace16                            using IndividualDo/comp`X'.dta, clear
	if `X'>=2001 & `X'<=2007 use unitid cipcode awlevel crace15 crace16 majornum                   using IndividualDo/comp`X'.dta, clear
	if `X'>=2008 & `X'<=2011 use unitid cipcode awlevel ctotalm ctotalw majornum                   using IndividualDo/comp`X'.dta, clear
	if `X'==2012             use unitid cipcode awlevel ctotalm ctotalw majornum cdistedp          using IndividualDo/comp`X'.dta, clear
	if `X'>=2013 & `X'<=2015 use unitid cipcode awlevel ctotalm ctotalw majornum ptotalde pmastrde using IndividualDo/comp`X'.dta, clear

	if `X'>=1984 & `X'<=2007 {
		rename crace15 ctotalm
		rename crace16 ctotalw
	}

	gen ctotalt = ctotalm + ctotalw
	label var ctotalt "Grand total"
	
	gen year = `X'
	
	compress
	tempfile holder`X'
	save `holder`X'', replace
}

clear
foreach X of numlist 1984/2015 {
	disp `X'
	append using `holder`X''
}

order unitid year cipcode awlevel majornum cdistedp ctotalm ctotalw ctotalt 
sort unitid year

*=============================
* Clean
*=============================

*--------------------
* CIP codes (cipcode)
*--------------------
*  In year 2002, various nests of degrees are reported, i.e.: 
*    13     = 'Education', 
*    1304   = 'Educational Administration and Supervision' and 
*    130402 = 'Administration of Special Education'. DROP nests
*  In every year, one nest is included that adds up all cipcodes
*   for each degree type for each school. This is diff in some years:
*    990000 = before 2002, 99 after 2002. DROP nest
* For some years, there is a category for unclassified: '959500'. Keep for now.

drop if cipcode < 10000 | cipcode==990000

* NEED TO MATCH CIPCODE1985 - CIPCODE1990 - CIPCODE2000 ??

*--------------------
* Award level (awlevel)
*--------------------

* Flags 12, 13, 14 and 15 are summary flags and can be deleted
drop if awlevel>=12 & awlevel<=15

* New classifications starting in 2008:
*  Flag 10 is First-Prof Degrees: Medical, Law, and Theology degrees. In 2008 these
*   are classified into masters and doctoral programs. The vast majority appear to go
*   into doctoral programs. Combine First-proffessional degrees with doctoral
*  Flags 17-19 are new claffifications of Doctorates and can be changed to 9.
*  Flag 11 were First-Prof certificates and are now claffified as post-masters

recode awlevel (10 17/19 = 9)
recode awlevel (11=8)

*=============================
* Label
*=============================

* label drop vlawlevel

label data "Relevant Completions 1984-2014"

label var year "year"

label define vlawlevel 1 "Award of less than 1 academic year"
label define vlawlevel 2 "Award of at least 1, but less than 2 academic years", add
label define vlawlevel 3 "Associate's degree", add
label define vlawlevel 4 "Award of at least 2, but less than 4 academic years", add
label define vlawlevel 5 "Bachelor's degree", add
label define vlawlevel 6 "Postbaccalaureate certificate", add
label define vlawlevel 7 "Master's degree", add
label define vlawlevel 8 "Post-master's certificate", add
label define vlawlevel 9 "Doctoral/Law degree", add
* label define vlawlevel 10 "First-professional degree (changes in 2008-2010)", add
* label define vlawlevel 11 "First-professional certificate (changes in 2008-2010)", add
label values awlevel vlawlevel

compress
save comp_all.dta, replace

log close
