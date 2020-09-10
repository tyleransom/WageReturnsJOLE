version 14.1
capture log close
set more off
log using ipeds_inst_combine.log, replace

clear all

*****************************************************************************
* Merge all the relevant institutional data into one dataset
*  Note, inst2009, for example, refers to inst char for the school year
*   starting in Fall 2009, the 2009-2010 school year. 
*  Problem:  However, the variable 'year' is supposed to refer to the 
*            2009-2010 school year as 2010.
*  Solution: at end of this do file, the year variable is advanced one period
*            resulting in a year range of 1985-2013.
*****************************************************************************

foreach X of numlist  1984/2015 {

	* Read data in, only keep relevant variables for each year
	if `X'>=1984 & `X'<=1985  use unitid instnm city stabbr zip countynm hloffer control affil    type status             excntl                                                using IndividualDo/inst`X'.dta, clear
	if `X'==1986              use unitid instnm city stabbr zip cntynm   hloffer control affil    protaffl othaffl sector excntl                                  tuition*      using IndividualDo/inst`X'.dta, clear
	if `X'>=1987 & `X'<=1994  use unitid instnm city stabbr zip countynm hloffer control affil    protaffl othaffl sector                                         tuition*      using IndividualDo/inst`X'.dta, clear
	if `X'==1995              use unitid instnm city stabbr zip countynm hloffer control affil    protaffl othaffl sector                                  locale tuition*      using IndividualDo/inst`X'.dta, clear
	if `X'>=1996 & `X'<=1997  use unitid instnm city stabbr zip countynm hloffer control affil    protaffl othaffl sector        opeind                    locale tuition*      using IndividualDo/inst`X'.dta, clear
	if `X'==1998              use unitid instnm city stabbr zip countynm hloffer control affil    relaffil         sector        opeflag act newid deathyr locale tuition*      using IndividualDo/inst`X'.dta, clear
	if `X'==1999              use unitid instnm city stabbr zip countynm hloffer control affil    relaffil         sector        opeflag act newid deathyr locale tuition* fee* using IndividualDo/inst`X'.dta, clear
	if `X'>=2000 & `X'<=2001  use unitid instnm city stabbr zip          hloffer control affil    relaffil         sector        opeflag act newid deathyr locale tuition* fee* using IndividualDo/inst`X'.dta, clear
	if `X'>=2002 & `X'<=2008  use unitid instnm city stabbr zip          hloffer control cntlaffi relaffil         sector        opeflag act newid deathyr locale tuition* fee* using IndividualDo/inst`X'.dta, clear
	if `X'>=2009 & `X'<=2015  use unitid instnm city stabbr zip countynm hloffer control cntlaffi relaffil         sector        opeflag act newid deathyr locale tuition* fee* using IndividualDo/inst`X'.dta, clear
	
	*-----------------------------
	* Zip code
	*-----------------------------
	
	* Read in zip, replace error values, then convert to consistent format
	if ( `X'>=1984 & `X'<=1986) | ( `X'>=1989 & `X'<=1990) | ( `X'>=1992 & `X'<=2001) {
	
		* Clean
		replace zip = 36849   if unitid==100849 & `X'==1986
		replace zip = 32742   if unitid==137379 & `X'==1986
		replace zip = 70808   if unitid==159638 & `X'==1986
		replace zip = 39225   if unitid==175999 & `X'==1986
		replace zip = 59601   if unitid==180470 & `X'==1986
		replace zip = 68503   if unitid==181747 & `X'==1986
		
		replace zip = 77272   if unitid==369215 & `X'==1992
		
		* Convert to consistent format
		replace zip = floor(zip/10000) if zip>100000
	}
	
	else {
		* Clean
		replace zip = "36606" if unitid==243911 & ( `X'==1987 | `X'==1988)	
		replace zip = "90706" if unitid==243975 & ( `X'==1987 | `X'==1988)	
		replace zip = "70112" if unitid==245096 & ( `X'==1987 | `X'==1988)	
		replace zip = "11355" if unitid==245670 & `X'==1987	
		replace zip = "11030" if unitid==245704 & `X'==1987	
		replace zip = "97232" if unitid==246035 & `X'==1987	
		replace zip = "78704" if unitid==246451 & `X'==1987	
		replace zip = "22801" if unitid==246497 & ( `X'==1987 | `X'==1988)	
		replace zip = "98121" if unitid==246530 & ( `X'==1987 | `X'==1988)	
		replace zip = "94578" if unitid==246974 & ( `X'==1987 | `X'==1988)	
		replace zip = "48213" if unitid==247241 & `X'==1987	
		replace zip = "06401" if unitid==248998 & `X'==1987	
		replace zip = "60194" if unitid==249070 & ( `X'==1987 | `X'==1988)	
		replace zip = "45503" if unitid==249186 & ( `X'==1987 | `X'==1988)	
		replace zip = "76011" if unitid==249247 & `X'==1987	
		replace zip = "74402" if unitid==251066 & `X'==1987	
		replace zip = "30303" if unitid==251206 & `X'==1987	
		replace zip = "07201" if unitid==251215 & `X'==1987	
		replace zip = "72205" if unitid==251224 & ( `X'==1987 | `X'==1988)	
		replace zip = "77701" if unitid==251242 & ( `X'==1987 | `X'==1988)	
		replace zip = "47715" if unitid==251251 & `X'==1987	
		replace zip = "33781" if unitid==260886 & `X'==1987	
		replace zip = "62704" if unitid==261348 & `X'==1987	
		
		replace zip = "61244" if unitid==143695 & `X'==1991
		replace zip = "80303" if unitid==381884 & `X'==1991
		
		replace zip = "11432" if unitid==383701 & `X'==2002
		replace zip = "39401" if unitid==438674 & ( `X'>=2002 & `X'<=2009)
		
		* Convert to consistent format
		replace zip = regexs(0) if (regexm(zip, "[0-9][0-9][0-9][0-9][0-9]"))
        destring zip, replace
	}

	*-----------------------------
	* County
	*-----------------------------
	if `X'==1986  rename cntynm countynm 
	
	*-----------------------------
	* Religion
	*-----------------------------
	if `X'==1984 | `X'==1985 {
		gen     religion = 0
		replace religion = affil if affil==24 | (affil>=26 & affil<.)
		replace religion = 99    if religion==0 & excntl==3	
	}
	else if `X'==1986 {
		gen     religion = 0
		replace religion = protaffl if protaffl>0 & protaffl<. & control~=3 & (protaffl~=8 | protaffl~=9)
		replace religion = othaffl  if othaffl>0  & othaffl<.  & control~=3 & (othaffl~=8  | othaffl~=9)
		replace religion = 30       if affil==4 
		replace religion = 80       if affil==5 
		replace religion = affil    if (affil>=30 & affil<=99)
		replace religion = 99       if religion==0 & (affil==6 | affil==7)
	}
	else if `X'>=1987 & `X'<=1997 {
		gen     religion = 0
		replace religion = protaffl if protaffl>0 & protaffl<. & control~=3 & (protaffl~=8 & protaffl~=9)
		replace religion = othaffl  if othaffl>0  & othaffl<.  & control~=3 & (othaffl~=8  & othaffl~=9)
		replace religion = 30       if affil==4 
		replace religion = 80       if affil==5 
		replace religion = 99       if religion==0 & (affil==6 | affil==7)
	}
	else if `X'==1998 {
		gen     religion = 0
		replace religion = relaffil if relaffil>0 & relaffil<.
		replace religion = 99       if religion==0 & (affil==6 | affil==7)
	}
	else if `X'>=1999 & `X'<=2001 {
		gen     religion = 0
		replace religion = relaffil if relaffil>0 & relaffil<.
		replace religion = 99       if religion==0 & affil==4
	}
	else {
		gen     religion = 0
		replace religion = relaffil if relaffil>0 & relaffil<.
		replace religion = 99       if religion==0 & cntlaffi==4
	}
	
	*-----------------------------
	* Institutional control
	*-----------------------------
	if `X'==1984 | `X'==1985 {
		gen     inst_control = 0
		replace inst_control = 1 if affil>=11 & affil<=15
		replace inst_control = 2 if affil==25
		replace inst_control = 3 if affil==21 & religion==0
		replace inst_control = 4 if religion>0
	}
	else if `X'>=1986 & `X'<=2001 {
		gen     inst_control = 0
		replace inst_control = 1 if control==1  | ( affil==1    & (control==0 | control>=.) )
		replace inst_control = 2 if control==3  | ( affil==2    & (control==0 | control>=.) )
		replace inst_control = 3 if (control==2 | ( affil==3    & (control==0 | control>=.) )) & religion==0
		replace inst_control = 4 if religion>0	
	}
	else {
		gen     inst_control = 0
		replace inst_control = 1 if control==1  | ( cntlaffi==1 & (control==0 | control>=.) )
		replace inst_control = 2 if control==3  | ( cntlaffi==2 & (control==0 | control>=.) )
		replace inst_control = 3 if (control==2 | ( cntlaffi==3 & (control==0 | control>=.) )) & religion==0
		replace inst_control = 4 if religion>0	
	}
	
	*-----------------------------
	* Nonprofit - unknown if religious or not (need more for early yrs)
	*-----------------------------
	if `X'>=2002 {
		gen     nonprofit_unk = 0
		replace nonprofit_unk = 1 if cntlaffi==. & control==2
	}

	*-----------------------------
	* Admin/sector_unk
	*-----------------------------
	if `X'==1984 | `X'==1985 {
		gen     admin = (type==0) | (status=="0") | (status=="2") | (status=="4") | (status=="A") | (status=="B") | (status=="C")
	}
	else  gen admin = (sector==0)
	
	if `X'>=2000 & `X'<=2015  gen sector_unk = (sector==99)
	
	*-----------------------------
	* Highest level offered - hloffer
	*-----------------------------
	if `X'==1984 | `X'==1985 {
		recode hloffer (10=0) (9=0) (8=9) (7=8) (6=7) (5=6) (4=5) (3=2.5) (2=1)
	}
	*------------------------------------------------------
	* Tuition - 1-3 should be undergrad, 5-7 should be grad
	*------------------------------------------------------
	if `X'==1986 {
		drop tuition7 tuition8 tuition9
		rename tuition6 tuition8
		rename tuition5 tuition7
		rename tuition4 tuition6
		rename tuition3 tuition4
		rename tuition2 tuition3
		rename tuition1 tuition2
	}
	if `X'==1987 | `X'==1988 {
		rename tuition7 tuition8
		rename tuition6 tuition7
		rename tuition5 tuition6		
	}
	if `X'>=1999 & `X'<=2015 {
		replace tuition1 = tuition1 + fee1
		replace tuition2 = tuition2 + fee2
		replace tuition3 = tuition3 + fee3
		replace tuition5 = tuition5 + fee5
		replace tuition6 = tuition6 + fee6
		replace tuition7 = tuition7 + fee7
	}

	*-----------------------------
	* Other vars and tweaks (??? - opeflag, act, newid, deathyr, locale)
	*-----------------------------
    gen year = `X'
	replace instnm = upper(instnm)
    replace city   = upper(city)

	* Keep relevant variables
	if `X'>=1984 & `X'<=1986  keep unitid year instnm city stabbr zip countynm hloffer inst_control religion admin
	if `X'>=1987 & `X'<=1994  keep unitid year instnm city stabbr zip countynm hloffer inst_control religion admin                                        tuition*
	if `X'==1995              keep unitid year instnm city stabbr zip countynm hloffer inst_control religion admin                                 locale tuition*
	if `X'>=1996 & `X'<=1997  keep unitid year instnm city stabbr zip countynm hloffer inst_control religion admin       opeind                    locale tuition*
	if `X'>=1998 & `X'<=1999  keep unitid year instnm city stabbr zip countynm hloffer inst_control religion admin       opeflag act newid deathyr locale tuition*
	if `X'>=2000 & `X'<=2008  keep unitid year instnm city stabbr zip          hloffer inst_control religion admin *_unk opeflag act newid deathyr locale tuition*
	if `X'>=2009 & `X'<=2015  keep unitid year instnm city stabbr zip countynm hloffer inst_control religion admin *_unk opeflag act newid deathyr locale tuition*
	
	compress
	tempfile holder`X'
	save `holder`X'', replace
}

clear
foreach X of numlist 1984/2015 {
	disp `X'
	append using `holder`X''
}

order unitid year instnm city stabbr zip countynm inst_control religion hloffer ope* act newid deathyr locale tuition1 tuition2 tuition3 tuition4 tuition5 tuition6 tuition7 tuition8
sort unitid year

*============================================================================
* Clean
*============================================================================
*------------------------------------------------------------------
* act - clean lead/trailing blanks
*------------------------------------------------------------------
replace act = trim(act)

*------------------------------------------------------------------
* instnm - spelling errors
*        - missing instnm <==> missing all data; drop
*------------------------------------------------------------------
replace instnm = regexr(instnm, "CHAROLOTTE", "CHARLOTTE")
replace instnm = trim(instnm)
replace instnm = itrim(instnm)
drop if mi(instnm)

*------------------------------------------------------------------
* city - spelling errors/cleaning blanks
*      - various instances where part of st bleeds into city
*         eg, city=SAN DIEGO, CA; remove all text from comma to end
*------------------------------------------------------------------
replace city = regexr(city, ",.*$" ,"")
replace city = trim(city)
replace city = itrim(city)

replace city = "ALBUQUERQUE"    if city=="ALBUEQUERQUE"
replace city = "ANAHEM"         if city=="ANAHEIM"
replace city = "CORPUS CHRISTI" if city=="CORPUS CHRIST"
replace city = "SALEM"          if city=="1288M"
 
replace stabbr = "MN" if unitid==174991 & city=="ST PAUL"
 
*------------------------------------------------------------------
* countynm - spelling errors/cleaning blanks
*------------------------------------------------------------------
replace countynm = regexr(countynm, ",.*$" ,"")
replace countynm = trim(countynm)
replace countynm = itrim(countynm)

*------------------------------------------------------------------
* 1986 cleaning
* In 1986 there are a LOT of duplicates. Most of these seem to actually
*  have the wrong zip code and/or unitid.
*  Resolve: replace 1986 zip and unitid with 1987 values if there is a
*   match on instnm, city, and stabbr. Else, drop in 1986
*------------------------------------------------------------------
* First, unitid 247719 has 780 different instnm's: drop all in 1986
drop if year==1986 & unitid==247719

* Create index, a running total in each year within a unique
*  college name, state, city combo
gsort instnm stabbr city year -hloffer religion zip
by    instnm stabbr city year: gen index   = _n

* Match the indexes in 1986 with the indexes in 1987
gen index1986A   = index if year==1986
gen index1987A   = index if year==1987
bys instnm stabbr city index: egen index1986   = max(index1986A)
bys instnm stabbr city index: egen index1987   = max(index1987A)

* Create vars to store the 1987 data to replace into 1986
bys instnm stabbr city year index: gen  zip1987A    = zip     if year==1987
bys instnm stabbr city year index: gen  unitid1987A = unitid  if year==1987
bys instnm stabbr city index     : egen zip1987     = max(zip1987A)   
bys instnm stabbr city index     : egen unitid1987  = max(unitid1987A)

* Replace the 1986 data with 1987 if indexes match. If indexes don't
*  match, then drop the 1986 obs
replace zip   =zip1987    if year==1986 & index1986==index1987
replace unitid=unitid1987 if year==1986 & index1986==index1987

* Drop all obs that don't have an index-match AND do not have matching
*  info to 85 or 87
bys unitid (year): gen check1 = (year==1986 & year[_n-1]==1985 & year[_n+1]==1987)
drop if year==1986 & index1986!=index1987 & !check1
drop index index1986A index1987A index1986 index1987 zip1987A unitid1987A zip1987 unitid1987 check1

*-----------------
* Random tweaks
*-----------------
replace admin = 1     if year==1984 & (unitid==3318 | unitid==4075 | unitid==7999 | unitid==8236 | unitid==10268 | unitid==10299 | unitid==125426)
replace admin = 1     if year==1985 & (unitid==1807 | unitid==9135 | unitid==9562 |                                unitid==10299 | unitid==125426)

replace religion = 54 if year==1986 & unitid==232557
replace religion = 54 if year==1987 & unitid==232557
replace religion = 54 if year==1988 & unitid==232557

replace inst_control = 2 if year==1986 & unitid==8192
replace inst_control = 3 if year==1986 & unitid==2662
* replace inst_control = 3 if year==1986 & unitid==29345
replace inst_control = 4 if unitid==217749 & inst_control ==2 // Bob Jones University: sometimes classified as for-profit, should always be non-profit, religous

drop if year==1994 & unitid==414948 // duplicate 

*------------------------------------------------------------------
* city - missing city, fillin from prev/next year, else drop
*         most have a deathyr value, so this doesn't really matter
*------------------------------------------------------------------
count if mi(city)
display r(N)
* assert r(N)==78
sort unitid year
by unitid: replace city = city[_n-1] if mi(city[_n]) & ~mi(city[_n-1]) & ~mi(zip[_n-1])
by unitid: replace zip  = zip[ _n-1] if mi(zip[ _n]) & ~mi(city[_n-1]) & ~mi(zip[_n-1])

by unitid: replace city = city[_n+1] if mi(city[_n]) & ~mi(city[_n+1]) & ~mi(zip[_n+1])
by unitid: replace zip  = zip[ _n+1] if mi(zip[ _n]) & ~mi(city[_n+1]) & ~mi(zip[_n+1])

drop if mi(city)

*======================
* Label 
*======================
label drop _all

label data "Relevant Institutional Charateristics 1984-2015"

label var year "year"
label var instnm "Name of Institution"
label var religion "Religious Affiliation, if any"
label var inst_control "Institutional Control"
label var nonprofit_unk "Unknown if Religious or not"

label var tuition1 "Tuition and fees full-time undergraduate, in-district"
label var tuition2 "Tuition and fees full-time undergraduate, in-state"
label var tuition3 "Tuition and fees full-time undergraduate, out-of-state"
label var tuition4 "No full-time undergraduate students"
label var tuition5 "Tuition and fees full-time graduate, in-district"
label var tuition6 "Tuition and fees full-time graduate, in-state"
label var tuition7 "Tuition and fees full-time graduate, out-of-state"
label var tuition8 "No full-time graduate students"

label define vlinst_control 0 "Control Unknown"
label define vlinst_control 1 "Public", add
label define vlinst_control 2 "For-profit", add 
label define vlinst_control 3 "Non-profit NR", add 
label define vlinst_control 4 "Non-profit R", add 
label values inst_control vlinst_control

label define vlreligion 0 "None"
label define vlreligion 22 "American Evangelical Lutheran Church", add
* label define vlreligion 23 "American Missionary Association", add
label define vlreligion 24 "African/American Methodist Episcopal Zion Church", add
* label define vlreligion 25 "Amish Church", add
label define vlreligion 26 "Advent Christian Church", add
label define vlreligion 27 "Assemblies of God Church", add
label define vlreligion 28 "Brethren Church", add
label define vlreligion 29 "Brethren in Christ Church", add
label define vlreligion 30 "Roman Catholic", add
label define vlreligion 31 "Church of God in Christ", add
label define vlreligion 32 "Church of New Jerusalem", add
label define vlreligion 33 "Wisconsin Evangelical Lutheran Synod", add
label define vlreligion 34 "Christ(ian) and Missionary Alliance Church", add
label define vlreligion 35 "Christian Reformed Church", add
label define vlreligion 36 "Evangelical Congregational Church", add
label define vlreligion 37 "Evangelical Covenant Church of America", add
label define vlreligion 38 "Evangelical Free Church of America", add
label define vlreligion 39 "Evangelical Lutheran Church", add
label define vlreligion 40 "International United Pentecostal Church", add
label define vlreligion 41 "Free Will Baptist Church", add
label define vlreligion 42 "Interdenominational", add
label define vlreligion 43 "Mennonite Brethren Church", add
label define vlreligion 44 "Moravian Church", add
label define vlreligion 45 "North American Baptist", add
label define vlreligion 46 "American Lutheran and Lutheran Church in America", add
label define vlreligion 47 "Pentecostal Holiness Church", add
label define vlreligion 48 "Christian Churches and Churches of Christ", add
label define vlreligion 49 "Reformed Church in America", add
label define vlreligion 50 "Reformed Episcopal Church", add
label define vlreligion 51 "African Methodist Episcopal", add
label define vlreligion 52 "American Baptist", add
label define vlreligion 53 "American Lutheran", add
label define vlreligion 54 "Baptist", add
label define vlreligion 55 "Christian Methodist Episcopal", add
label define vlreligion 56 "Church of Christ (Scientist)", add
label define vlreligion 57 "Church of God", add
label define vlreligion 58 "Church of the Brethren", add
label define vlreligion 59 "Church of the Nazarene", add
label define vlreligion 60 "Cumberland Presbyterian", add
label define vlreligion 61 "Christian Church (Disciples of Christ)", add
* label define vlreligion 63 "Friends United Meeting", add
label define vlreligion 64 "Free Methodist", add
label define vlreligion 65 "Friends", add
label define vlreligion 66 "Presbyterian Church (USA)", add
label define vlreligion 67 "Lutheran Church in America", add
label define vlreligion 68 "Lutheran Church - Missouri Synod", add
label define vlreligion 69 "Mennonite Church", add
label define vlreligion 70 "General Conference Mennonite Church", add
label define vlreligion 71 "United Methodist", add
label define vlreligion 73 "Protestant Episcopal", add
label define vlreligion 74 "Churches of Christ", add
label define vlreligion 75 "Southern Baptist", add
label define vlreligion 76 "United Church of Christ", add
label define vlreligion 77 "Protestant, Not Specified", add
label define vlreligion 78 "Multiple Protestant Denominations", add
label define vlreligion 79 "Other Protestant", add
label define vlreligion 80 "Jewish", add
label define vlreligion 81 "Reformed Presbyterian Church", add
label define vlreligion 82 "Reorganized Latter-Day Saints Church", add
label define vlreligion 83 "Seventh Day Baptist Church", add
label define vlreligion 84 "United Brethren Church", add
* label define vlreligion 85 "Jehovah's Witnesses", add
label define vlreligion 86 "Independent Fundamental Churches of America", add
label define vlreligion 87 "Missionary Church Inc (Formerly United Miss Church)", add
label define vlreligion 88 "Undenominational", add
label define vlreligion 89 "Wesleyan Church", add
label define vlreligion 90 "Young Men's Christian Association", add
label define vlreligion 91 "Greek Orthodox", add
label define vlreligion 92 "Russian Orthodox", add
label define vlreligion 93 "Unitarian Universalist", add
label define vlreligion 94 "Latter-Day Saints (Mormon Church)", add
label define vlreligion 95 "Seventh-Day Adventists", add
label define vlreligion 96 "Church of God of Prophecy", add
label define vlreligion 97 "The Presbyterian Church in America", add
label define vlreligion 98 "Salvation Army", add
label define vlreligion 99 "Other", add
label define vlreligion 100 "Original Free Will Baptist", add
label values religion vlreligion

label define vlhloffer 0   "Other"
label define vlhloffer 1   "Award of less than 1 academic year", add
label define vlhloffer 2   "Award of at least 1, but less than 2 academic years", add
* label define vlhloffer 2.5 "Award or degree of at least 1, but less than 4 academic yrs", add
label define vlhloffer 3   "Associate's degree", add
label define vlhloffer 4   "Award of at least 2, but less than 4 academic yrs", add
label define vlhloffer 5   "Bachelor's degree", add
label define vlhloffer 6   "Postbaccalaureate certificate", add
label define vlhloffer 7   "Master's degree", add
label define vlhloffer 8   "Post-master's certificate", add
label define vlhloffer 9   "Doctor's degree", add
label define vlhloffer -1  "No response/missing", add
label define vlhloffer -2  "{Item not applicable, 1st-prof only}", add
label define vlhloffer -3  "{Item not available}", add
label values hloffer vlhloffer

*======================
* Read in zip code data
*======================
merge m:1 stabbr using ../ZipCodes/state_zip_range.dta
assert _merge!=2
drop _merge

gen zip_valid = (zip>=min_zip1 & zip<=max_zip1) | (zip>=min_zip2 & zip<=max_zip2) | (zip>=min_zip3 & zip<=max_zip3) | (zip>=min_zip4 & zip<=max_zip4)
gen non_state=0

foreach X in AQ AS CM FM GU M MH MP PR PW TQ TT VI {
	replace non_state=1 if stabbr=="`X'"
}

drop if mi(stabbr)
drop state min_zip* max_zip*

*============================================================================
* Advance 'year' one period ahead to be consistent with the completions data
*============================================================================
replace year = year+1


sort unitid year
compress
save inst_all.dta, replace

log close
