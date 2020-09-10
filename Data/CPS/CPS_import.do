version 13.0
clear all
set more off
capture log close
log using CPS_import.log, replace

/* Need to create the wage gap variables as well as the
supply variables, by age, sex, education, and state. Also,
drop wage outliers.
Age groups:     young(1)  =26-35
                old(2)    =36-64
                others(0) =else
Education(<92): HS(1)     =12
                college(2)=16 or 17
                others(0) =else
Education(>92): HS(1)     =39 ('high-school graduate') or
                38 ('twelth grade, no diploma')
                college(2)=43 ('bachelor's degree')
                others(0) =else
State:          duh
Wage:           low/hi(1)= <2 or >150 in 1989 dollars
                fine(2)  = >=2 and <=150 in 1989 dollars
Sex:            sex male=1, female=2
Race:           race    white=1, non-white>1
Marital Status: marital married<=3, single >=4
P/T Employment: uhourse hours<35
*/

local years 79 80 81 82 83 84 85 86 87 88 89 90 91 92 93 94 95 96 97 98 99 00 01 02 03 04 05 06 07 08 09 10 11 12 13 14 15 16
foreach X in `years' {
	local EY = int(10000*uniform()) // NO seed; needs to be random
    ! gunzip -fc ./sourcedata/morg`X'.dta.gz > tmp`EY'.dta
    if inrange(`X',79,83) use year intmonth state        age sex race ethnic marital class   ftpt79 gradeat gradecp               uhours uhourse earnhr earnhre paidhr paidhre earnwk earnwke I25? weight earnwt        using tmp`EY'.dta, clear
    if inrange(`X',84,88) use year intmonth state        age sex race ethnic marital class   ftpt79 gradeat gradecp schenr schlvl uhours uhourse earnhr earnhre paidhr paidhre earnwk earnwke I25? weight earnwt        using tmp`EY'.dta, clear
    if inrange(`X',89,91) use year intmonth state stfips age sex race ethnic marital class   ftpt89 gradeat gradecp schenr schlvl uhours uhourse earnhr earnhre paidhr paidhre earnwk earnwke I25? weight earnwt        using tmp`EY'.dta, clear
    if inrange(`X',92,93) use year intmonth state stfips age sex race ethnic marital class   ftpt89 grade92         schenr schlvl uhours uhourse earnhr earnhre paidhr paidhre earnwk earnwke I25? weight earnwt        using tmp`EY'.dta, clear
    if inrange(`X',94,97) use year intmonth state stfips age sex race ethnic marital class94 ftpt94 grade92         schenr schlvl uhours uhourse earnhr earnhre paidhr paidhre earnwk earnwke I25? weight earnwt        using tmp`EY'.dta, clear
    if inrange(`X',98,99) use year intmonth state stfips age sex race ethnic marital class94 ftpt94 grade92         schenr schlvl uhours uhourse earnhr earnhre paidhr paidhre earnwk earnwke I25? weight earnwt cmpwgt using tmp`EY'.dta, clear
    if inrange(`X',00,14) use year intmonth state stfips age sex race ethnic marital class94 ftpt94 grade92         schenr schlvl uhours uhourse earnhr earnhre paidhr paidhre earnwk earnwke I25? weight earnwt cmpwgt using tmp`EY'.dta, clear
    if inrange(`X',15,16) use year intmonth       stfips age sex race ethnic marital class94 ftpt94 grade92         schenr schlvl uhours uhourse earnhr earnhre paidhr paidhre earnwk earnwke I25? weight earnwt cmpwgt using tmp`EY'.dta, clear
    ! rm tmp`EY'.dta
    
    disp "`X'"
    /***Generate hourly wage: if reported weekly earnings, it is
    weekly earnings divided by usual hours.  If not, it is just
    usual hourly wage.***/
    
    generat hrwage1 = earnwke/uhourse
    generat hrwage2 = earnhre/100
    generat hrwage3 = hrwage2
    replace hrwage3 = hrwage1 if mi(hrwage2)
    
    rename hrwage3 hrwage
    
    * drop if hrwage==.
    
    /***Create age and education flags(see top for details)***/
    
    * gen young= (age>=26 & age<=35)
    * gen older= (age>=36 & age<=64)
    * keep if young==1
    
    * Generate education attainment/variables
    if inrange(`X',79,91) {
        gen byte hsonly    = (gradeat==12)
        gen byte college   = (gradeat==16 | gradeat==17)
        gen byte college2  = (gradeat>=16 & ~mi(gradeat)) // alt def of college
        gen byte gradHS    = (gradeat>=12 & ~mi(gradeat))
        gen byte grad4yr   = (gradeat>=16 & ~mi(gradeat))
        gen byte HSdropout = (gradeat<=11 & ~mi(gradeat))
		
		* gradeat is attempted grade, gradecp is whether it was completed or not
		*   for those with gradeat=0, gradecp=2, so use "max" to keep it at 0
		gen hgc       = gradeat*(gradecp==1) + max(gradeat-1,0)*(gradecp==2)
    }
    else {
        gen byte hsonly    = (grade92==38 | grade92==39)
        gen byte college   = (grade92==43)
        gen byte college2  = (grade92>=43) & ~mi(grade92) // alt def of college
        gen byte gradHS    = (inrange(grade92,39,46))
        gen byte grad4yr   = (inrange(grade92,43,46))
        gen byte HSdropout = (grade92<=38)
		
		* grade92 doesn't fully break it out by years completed; for now, "recode":
		*                     Less Than 1st Grade (31=0 )
		*                1st,2nd,3rd Or 4th Grade (32=3 ) 
		*                        5th Or 6th Grade (33=6 )
		*                        7th Or 8th Grade (34=8 )
		*                               9th Grade (35=9 )
		*                              10th Grade (36=10)
		*                              11th Grade (37=11)
		*                   12th Grade No Diploma (38=11) hgc 11 if no diploma
		* High School Grad-Diploma Or Equiv (GED) (39=12)
		*              Some College But No Degree (40=13)
		* Associate Degree-Occupational/Vocationa (41=14)
		*         Associate Deg.-Academic Program (42=14)
		*          Bachelor's Degree(ex:ba,ab,bs) (43=16)
		*         Master's(ex:MA,MS,MEng,MEd,MSW) (44=18)
		*  Professional School Deg(ex:MD,DDS,DVM) (45=20) 
		*            Doctorate Degree(ex:PhD,EdD) (46=21)
		* Note: recode is VERY slow since replace is built-in (type -which replace-)
		*       but recode is an ado file (type -which recode-) tradeoff of coding lines
		*       for speed (replace has speed advantage of 90% )
		genera hgc = grade92
		recode hgc (31=0 ) (32=3 ) (33=6 ) (34=8 ) (35=9 ) (36=10) (37=11) (38=11) (39=12) (40=13) (41=14) (42=14) (43=16) (44=18) (45=20) (46=21)
    }
    
    * Generate self-employment indicator
    if inrange(`X',79,93) {
        gen byte selfEmployed = inrange(class,5,6)
    }
    else {
        gen byte selfEmployed = inrange(class94,6,7)
    }

    * Generate employment status
    if inrange(`X',79,88) {
        gen byte empFT     = inlist(ftpt79,1)
        gen byte empPT     = inlist(ftpt79,2,4)
        gen byte unemp     = inlist(ftpt79,3,5)
        gen byte nilf      = inlist(ftpt79,0)
    }
    else if inrange(`X',89,93) {
        gen byte empFT     = inlist(ftpt89,2)
        gen byte empPT     = inlist(ftpt89,3,4,5)
        gen byte unemp     = inlist(ftpt89,6,7)
        gen byte nilf      = inlist(ftpt89,1)
    }
    else if inrange(`X',94,99) | inrange(`X',00,16) {
        gen byte empFT     = inlist(ftpt94,2,8,9)
        gen byte empPT     = inlist(ftpt94,3,4,6,7)
        gen byte unemp     = inlist(ftpt94,5,10,11,12)
        gen byte nilf      = inlist(ftpt94,1)
    }
    
    * Generate imputation indicators
    if inrange(`X',79,93) {
        gen byte allocated_uhrs     = I25a>0 
        gen byte allocated_hrly_job = I25b>0 
        gen byte allocated_earnhr   = I25c>0
        gen byte allocated_earnwk   = I25d>0 
    }
    else if inrange(`X',95,99) | inrange(`X',00,16) {
        gen byte allocated_uhrs     = I25a>3 
        gen byte allocated_hrly_job = I25b>3 
        gen byte allocated_earnhr   = I25c>0
        gen byte allocated_earnwk   = I25d>0 
    }
    if inrange(`X',79,93) {
        gen byte allocated_incl_mi_uhrs     = I25a>0 & ~mi(I25a)
        gen byte allocated_incl_mi_hrly_job = I25b>0 & ~mi(I25b)
        gen byte allocated_incl_mi_earnhr   = I25c>0 & ~mi(I25c)
        gen byte allocated_incl_mi_earnwk   = I25d>0 & ~mi(I25d)
    }
    else if inrange(`X',95,99) | inrange(`X',00,16) {
        gen byte allocated_incl_mi_uhrs     = I25a>3 & ~mi(I25a)
        gen byte allocated_incl_mi_hrly_job = I25b>3 & ~mi(I25b)
        gen byte allocated_incl_mi_earnhr   = I25c>0 & ~mi(I25c)
        gen byte allocated_incl_mi_earnwk   = I25d>0 & ~mi(I25d)
    }
    
    /***Create sex, race, marital, and p/t flags***/
    gen byte female   = (sex==2)
    gen byte nonwhite = (race~=1)
    gen byte hispanic = (ethnic<8 & year<=2002) | (~mi(ethnic) & year>=2003)
    gen byte white    = race==1 & ~hispanic
    gen byte black    = race==2 & ~hispanic
    gen byte other    = race>2 & ~hispanic
    gen byte married  = (marital<=3)
    gen byte parttime = (uhourse<35)
    
    * keep state year hrwage age college college2 female nonwhite parttime marital
    tempfile holder`X'
    save `holder`X'', replace

}

clear
foreach X in `years' {
    append using `holder`X''
}

gen     empstat = .
replace empstat = 1 if empFT==1
replace empstat = 2 if empPT==1
replace empstat = 3 if unemp==1
replace empstat = 4 if nilf ==1
lab def vlempstat 1 "Employed full-time" 2 "Employed part-time" 3 "Unemployed" 4 "Not in labor force"
lab val empstat vlempstat

tab empstat
tab year empstat, row nofreq

sum uhourse if empFT, d
sum uhourse if empPT, d
sum uhourse if unemp, d
sum uhourse if nilf , d

cpigen
gen  cpi1983A = cpiu if year==1983
egen cpi1983B = max(cpi1983A)
gen  cpi1983  = cpiu/cpi1983B
drop cpi cpiu cpi1983A cpi1983B
* http://www.usinflationcalculator.com/inflation/consumer-price-index-and-annual-percent-changes-from-1913-to-2008/
replace cpi1983 = 2.36736 if year==2014
replace cpi1983 = 2.37017 if year==2015
replace cpi1983 = 2.40007 if year==2016
replace cpi1983 = 2.44786 if year==2017

ren intmonth month

compress

* If need all the vars in here, use this. But note that it will create git 
*   issues, so you'll need to rm the file
* save     CPS_data1, replace
* !gzip -f CPS_data1.dta
* !mv      CPS_data1.dta.gz /home/jared/TempData/

* Create smaller file, easier to git
drop if year-age < 1940
gen float realwage = hrwage/cpi1983
gen float realearn = earnwke/cpi1983 
gen byte  shortyr = year - 1978

* Keep subset of variables to control file size
keep shortyr month age realwage realearn gradHS grad4yr hgc female white black hispanic other empFT empPT unemp allocated* weight earnwt gradeat gradecp grade92

compress

* save     CPS_data, replace
* !gzip -f CPS_data.dta
* !mv      CPS_data.dta.gz /home/jared/TempData/

* Create smaller versions that can be gitted; randomize for testing
set seed 101
gen byte sortey = runiform()
sort     sortey
drop     sortey

local NUMPIECES 3
forvalues X = 1/`NUMPIECES' {
    preserve
        keep if inrange(_n,1+(_N/`NUMPIECES')*(`X'-1),(_N/`NUMPIECES')*(`X'))
        save     CPS_data_pt`X', replace
        !gzip -f CPS_data_pt`X'.dta
    restore
}

log close
