version 14.1
clear all
set more off
set maxvar 32000
capture log close
log using BEA_create.log, replace

local states    AK AL AR AZ CA CO CT DC DE FL GA HI IA ID IL IN KS KY LA MA MD ME MI MN MO MS MT NC ND NE NH NJ NM NV NY OH OK OR PA RI SC SD TN TX UT VA VT WA WI WV WY
local statesNot    AL AR AZ CA CO CT DC DE FL GA HI IA ID IL IN KS KY LA MA MD ME MI MN MO MS MT NC ND NE NH NJ NM NV NY OH OK OR PA RI SC SD TN TX UT VA VT WA WI WV WY

foreach state in `states' {
    tempfile IncEmp`state'
    tempfile SectorEmpOld`state'
    tempfile SectorEmpNew`state'
    tempfile SectorIncOld`state'
    tempfile SectorIncNew`state'
}   
tempfile BLSunemp2016 BEAemptot2015

foreach state in `states' {
    * Get per-captia income and total employment by county
    insheet using CA4_1969_2016_`state'.csv, comma case clear
    ren v8  yr1969
    ren v9  yr1970
    ren v10 yr1971
    ren v11 yr1972
    ren v12 yr1973
    ren v13 yr1974
    ren v14 yr1975
    ren v15 yr1976
    ren v16 yr1977
    ren v17 yr1978
    ren v18 yr1979
    ren v19 yr1980
    ren v20 yr1981
    ren v21 yr1982
    ren v22 yr1983
    ren v23 yr1984
    ren v24 yr1985
    ren v25 yr1986
    ren v26 yr1987
    ren v27 yr1988
    ren v28 yr1989
    ren v29 yr1990
    ren v30 yr1991
    ren v31 yr1992
    ren v32 yr1993
    ren v33 yr1994
    ren v34 yr1995
    ren v35 yr1996
    ren v36 yr1997
    ren v37 yr1998
    ren v38 yr1999
    ren v39 yr2000
    ren v40 yr2001
    ren v41 yr2002
    ren v42 yr2003
    ren v43 yr2004
    ren v44 yr2005
    ren v45 yr2006
    ren v46 yr2007
    ren v47 yr2008
    ren v48 yr2009
    ren v49 yr2010
    ren v50 yr2011
    ren v51 yr2012
    ren v52 yr2013
    ren v53 yr2014
    ren v54 yr2015
    ren v55 yr2016
    keep if inlist(LineCode,20,30,7010) // LineCode 20 is population; 30 is per-capita income for each county; 7010 is total employment for each county
    keep GeoFIPS LineCode GeoName yr* // this keeps the GeoFIPS code, the LineCode and the year
    tostring yr*, replace
    reshape long yr, i(GeoFIPS LineCode) j(year)
    ren yr value
    reshape wide value, i(GeoFIPS year) j(LineCode)
    replace value20   = "" if value20=="(D)"   | value20=="(N)"   | value20=="(L)"
    replace value30   = "" if value30=="(D)"   | value30=="(N)"   | value30=="(L)"
    replace value7010 = "" if value7010=="(D)" | value7010=="(N)" | value7010=="(L)"
    destring value20,   gen (popAllBEA) force
    destring value30,   gen (incPerCapita) force
    destring value7010, gen (empTot) force
    destring GeoFIPS, replace force
    drop value*
    save `IncEmp`state''
    disp _newline(5) "About to list name of temp file"
    disp "`IncEmp`state''" _newline(5) 
    
    * Get sector-specific employment by county (NAICS classificaiton -- 2001-09)
    insheet using CA25N_2001_2016_`state'.csv, comma case clear
    ren v8  yr2001
    ren v9  yr2002
    ren v10 yr2003
    ren v11 yr2004
    ren v12 yr2005
    ren v13 yr2006
    ren v14 yr2007
    ren v15 yr2008
    ren v16 yr2009
    ren v17 yr2010
    ren v18 yr2011
    ren v19 yr2012
    ren v20 yr2013
    ren v21 yr2014
    ren v22 yr2015
    ren v23 yr2016
    keep if inlist(LineCode,70,100,200,300,400,500,600,700,800,900,1000,1100,1200,1300,1400,1500,1600,1700,1800,1900,2000) // 400 is Manufacturing sector; 800 is service sector
    keep GeoFIPS LineCode yr*
    tostring yr*, replace
    reshape long yr, i(GeoFIPS LineCode) j(year)
    ren yr value
    reshape wide value, i(GeoFIPS year) j(LineCode)
    foreach x of numlist 70 100(100)2000 {
        replace value`x' = "" if inlist(value`x',"(D)","(N)","(L)")
    }
    ** BEA categories
    * Forestry, fishing, and related activities
    * Mining
    * Utilities
    * Construction
    * Manufacturing
    * Wholesale trade
    * Retail trade
    * Transportation and warehousing
    * Information
    * Finance and insurance
    * Real estate and rental and leasing
    * Professional, scientific, and technical services
    * Management of companies and enterprises
    * Administrative and waste services
    * Educational services
    * Health care and social assistance
    * Arts, entertainment, and recreation
    * Accommodation and food services
    * Other services, except public administration
    * Government and government enterprises

    ** My categories
    * 1. AGRICULTURE, FORESTRY, FISHING, MINING, UTILITIES, CONSTRUCTION
    * 2. MANUFACTURING 
    * 3. WHOLESALE & RETAIL TRADE
    * 4. TRANSPORTATION, WAREHOUSING, INFORMATION AND COMMUNICATION
    * 5. FIRE
    * 6. PROFESSIONAL AND RELATED SERVICES
    * 7. EDUCATIONAL, HEALTH, AND SOCIAL SERVICES
    * 8. ENTERTAINMENT, ACCOMODATIONS, AND FOOD & OTHER SERVICES
    * 9. PUBLIC ADMINISTRATION, MILITARY & SPECIAL CODES
  

    destring value70  , gen (empFarm) force
    destring value100 , gen (agriEmp) force
    destring value200 , gen (miningEmp) force
    destring value300 , gen (utilEmp) force
    destring value400 , gen (constrEmp) force
    destring value500 , gen (manufEmp) force
    destring value600 , gen (wtEmp) force
    destring value700 , gen (rtEmp) force
    destring value800 , gen (transEmp) force
    destring value900 , gen (infoEmp) force
    destring value1000, gen (fiEmp) force
    destring value1100, gen (reEmp) force
    destring value1200, gen (proSvcEmp) force
    destring value1300, gen (mgmtEmp) force
    destring value1400, gen (adminEmp) force
    destring value1500, gen (educEmp) force
    destring value1600, gen (healthEmp) force
    destring value1700, gen (artrecEmp) force
    destring value1800, gen (hospfoodEmp) force
    destring value1900, gen (othsvcEmp) force
    destring value2000, gen (pubEmp) force
    recode   agriEmp     (. = 0)
    recode   miningEmp   (. = 0)
    recode   utilEmp     (. = 0)
    recode   constrEmp   (. = 0)
    recode   manufEmp    (. = 0)
    recode   wtEmp       (. = 0)
    recode   rtEmp       (. = 0)
    recode   transEmp    (. = 0)
    recode   infoEmp     (. = 0)
    recode   fiEmp       (. = 0)
    recode   reEmp       (. = 0)
    recode   proSvcEmp   (. = 0)
    recode   mgmtEmp     (. = 0)
    recode   adminEmp    (. = 0)
    recode   educEmp     (. = 0)
    recode   healthEmp   (. = 0)
    recode   artrecEmp   (. = 0)
    recode   hospfoodEmp (. = 0)
    recode   othsvcEmp   (. = 0)
    recode   pubEmp      (. = 0)
    
    generate ind1Emp = agriEmp+miningEmp+utilEmp+constrEmp
    generate ind2Emp = manufEmp
    generate ind3Emp = wtEmp+rtEmp
    generate ind4Emp = transEmp+infoEmp
    generate ind5Emp = fiEmp+reEmp
    generate ind6Emp = proSvcEmp+mgmtEmp+adminEmp
    generate ind7Emp = artrecEmp+educEmp+healthEmp
    generate ind8Emp = hospfoodEmp+othsvcEmp
    generate ind9Emp = pubEmp
    
    destring GeoFIPS, replace force
    drop value*
    save `SectorEmpNew`state''
    
    * Get sector-specific employment by county (SIC classification --- 1969 - 2000)
    insheet using CA25_1969_2000_`state'.csv, comma case clear
    ren v8  yr1969
    ren v9  yr1970
    ren v10 yr1971
    ren v11 yr1972
    ren v12 yr1973
    ren v13 yr1974
    ren v14 yr1975
    ren v15 yr1976
    ren v16 yr1977
    ren v17 yr1978
    ren v18 yr1979
    ren v19 yr1980
    ren v20 yr1981
    ren v21 yr1982
    ren v22 yr1983
    ren v23 yr1984
    ren v24 yr1985
    ren v25 yr1986
    ren v26 yr1987
    ren v27 yr1988
    ren v28 yr1989
    ren v29 yr1990
    ren v30 yr1991
    ren v31 yr1992
    ren v32 yr1993
    ren v33 yr1994
    ren v34 yr1995
    ren v35 yr1996
    ren v36 yr1997
    ren v37 yr1998
    ren v38 yr1999
    ren v39 yr2000
    keep if inlist(LineCode,70,100,200,300,400,500,610,620,700,800,900) // 400 is Manufacturing sector; 800 is service sector
    keep GeoFIPS LineCode yr*
    tostring yr*, replace
    reshape long yr, i(GeoFIPS LineCode) j(year)
    ren yr value
    reshape wide value, i(GeoFIPS year) j(LineCode)
    foreach x of numlist 70 100 200 300 400 500 610 620 700 800 900 {
        replace value`x' = "" if inlist(value`x',"(D)","(N)","(L)")
    }
    destring value70 , gen (empFarm) force
    destring value100, gen (agriEmp) force
    destring value200, gen (miningEmp) force
    destring value300, gen (constrEmp) force
    destring value400, gen (manufEmp) force
    destring value500, gen (transEmp) force
    destring value610, gen (wtEmp) force
    destring value620, gen (rtEmp) force
    destring value700, gen (fireEmp) force
    destring value800, gen (serviceEmp) force
    destring value900, gen (pubEmp) force
    
    destring GeoFIPS, replace force
    drop value*
    save `SectorEmpOld`state''
    
    * Get sector-specific income per worker by county
    insheet using CA5_1969_2000_`state'.csv, comma case clear
    ren v8  yr1969
    ren v9  yr1970
    ren v10 yr1971
    ren v11 yr1972
    ren v12 yr1973
    ren v13 yr1974
    ren v14 yr1975
    ren v15 yr1976
    ren v16 yr1977
    ren v17 yr1978
    ren v18 yr1979
    ren v19 yr1980
    ren v20 yr1981
    ren v21 yr1982
    ren v22 yr1983
    ren v23 yr1984
    ren v24 yr1985
    ren v25 yr1986
    ren v26 yr1987
    ren v27 yr1988
    ren v28 yr1989
    ren v29 yr1990
    ren v30 yr1991
    ren v31 yr1992
    ren v32 yr1993
    ren v33 yr1994
    ren v34 yr1995
    ren v35 yr1996
    ren v36 yr1997
    ren v37 yr1998
    ren v38 yr1999
    ren v39 yr2000
    keep if LineCode==400 | LineCode==800 // 400 is Manufacturing sector; 800 is service sector
    keep GeoFIPS LineCode yr*
    tostring yr*, replace
    reshape long yr, i(GeoFIPS LineCode) j(year)
    ren yr value
    reshape wide value, i(GeoFIPS year) j(LineCode)
    replace value400 = "" if value400=="(D)" | value400=="(N)" | value400=="(L)"
    replace value800 = "" if value800=="(D)" | value800=="(N)" | value800=="(L)"
    destring value800, gen (serviceInc) force
    destring value400, gen (manufInc) force
    destring GeoFIPS, replace force
    drop value*
    save `SectorIncOld`state''

    * Get sector-specific income per worker by county
    insheet using CA5N_2001_2016_`state'.csv, comma case clear
    ren v8  yr2001
    ren v9  yr2002
    ren v10 yr2003
    ren v11 yr2004
    ren v12 yr2005
    ren v13 yr2006
    ren v14 yr2007
    ren v15 yr2008
    ren v16 yr2009
    ren v17 yr2010
    ren v18 yr2011
    ren v19 yr2012
    ren v20 yr2013
    ren v21 yr2014
    ren v22 yr2015
    ren v23 yr2016
    keep if inlist(LineCode,100,200,300,400,500,600,700,800,900,1000,1100,1200,1300,1400,1500,1600,1700,1800,1900,2000) // 400 is Manufacturing sector; 800 is service sector
    keep GeoFIPS LineCode yr*
    tostring yr*, replace
    reshape long yr, i(GeoFIPS LineCode) j(year)
    ren yr value
    reshape wide value, i(GeoFIPS year) j(LineCode)
    foreach x of numlist 100(100)2000 {
        replace value`x' = "" if inlist(value`x',"(D)","(N)","(L)")
    }
    destring value100 , gen (agriInc) force
    destring value200 , gen (miningInc) force
    destring value300 , gen (utilInc) force
    destring value400 , gen (constrInc) force
    destring value500 , gen (manufInc) force
    destring value600 , gen (wtInc) force
    destring value700 , gen (rtInc) force
    destring value800 , gen (transInc) force
    destring value900 , gen (infoInc) force
    destring value1000, gen (fiInc) force
    destring value1100, gen (reInc) force
    destring value1200, gen (proSvcInc) force
    destring value1300, gen (mgmtInc) force
    destring value1400, gen (adminInc) force
    destring value1500, gen (educInc) force
    destring value1600, gen (healthInc) force
    destring value1700, gen (artrecInc) force
    destring value1800, gen (hospfoodInc) force
    destring value1900, gen (othsvcInc) force
    destring value2000, gen (pubInc) force
    recode   agriInc     (. = 0)
    recode   miningInc   (. = 0)
    recode   utilInc     (. = 0)
    recode   constrInc   (. = 0)
    recode   manufInc    (. = 0)
    recode   wtInc       (. = 0)
    recode   rtInc       (. = 0)
    recode   transInc    (. = 0)
    recode   infoInc     (. = 0)
    recode   fiInc       (. = 0)
    recode   reInc       (. = 0)
    recode   proSvcInc   (. = 0)
    recode   mgmtInc     (. = 0)
    recode   adminInc    (. = 0)
    recode   educInc     (. = 0)
    recode   healthInc   (. = 0)
    recode   artrecInc   (. = 0)
    recode   hospfoodInc (. = 0)
    recode   othsvcInc   (. = 0)
    recode   pubInc      (. = 0)
    
    generate ind1Inc = agriInc+miningInc+utilInc+constrInc
    generate ind2Inc = manufInc
    generate ind3Inc = wtInc+rtInc
    generate ind4Inc = transInc+infoInc
    generate ind5Inc = fiInc+reInc
    generate ind6Inc = proSvcInc+mgmtInc+adminInc
    generate ind7Inc = artrecInc+educInc+healthInc
    generate ind8Inc = hospfoodInc+othsvcInc
    generate ind9Inc = pubInc
    destring GeoFIPS, replace force
    drop value*
    save `SectorIncNew`state''
}

tempfile IncEmpGeoFIPS
tempfile SectorEmpGeoFIPS
tempfile SectorIncGeoFIPS

clear
use `IncEmpAK'
foreach state in `statesNot' {
    append using `IncEmp`state''
}
sort GeoFIPS year
xtset GeoFIPS year
save `IncEmpGeoFIPS'

clear
use `SectorEmpOldAK'
append using `SectorEmpNewAK'
foreach state in `statesNot' {
    append using `SectorEmpOld`state''
    append using `SectorEmpNew`state''
}
sort GeoFIPS year
xtset GeoFIPS year
save `SectorEmpGeoFIPS'

clear
use `SectorIncOldAK'
append using `SectorIncNewAK'
foreach state in `statesNot' {
    append using `SectorIncOld`state''
    append using `SectorIncNew`state''
}
sort GeoFIPS year
xtset GeoFIPS year
save `SectorIncGeoFIPS'

clear
use `IncEmpGeoFIPS'
merge 1:1 GeoFIPS year using `SectorEmpGeoFIPS', nogen
merge 1:1 GeoFIPS year using `SectorIncGeoFIPS', nogen

* aggregate service and manufacturing for years 2001 -
replace manufEmp   = ind2Emp                 if year>2000
replace serviceEmp = ind6Emp+ind7Emp+ind8Emp if year>2000
replace manufInc   = ind2Inc                 if year>2000
replace serviceInc = ind6Inc+ind7Inc+ind8Inc if year>2000

* get sector-specific employment shares and per-worker income
gen farmShare           = (100)*empFarm/empTot
gen manufShare          = (100)*manufEmp/empTot
gen serviceShare        = (100)*serviceEmp/empTot
gen manufIncPerCapita   = manufInc/manufEmp
gen serviceIncPerCapita = serviceInc/serviceEmp
foreach x of numlist 1/9 {
    gen ind`x'Share        = (100)*ind`x'Emp/empTot
    gen ind`x'IncPerCapita = (100)*ind`x'Inc/ind`x'Emp
}
* divide income variables by 1000
replace incPerCapita        = incPerCapita/1000
* replace manufIncPerCapita   = manufIncPerCapita/1000    // these are already in 1000s of dollars
* replace serviceIncPerCapita = serviceIncPerCapita/1000  // these are already in 1000s of dollars

* get growth rates in sector-specific employment
bys GeoFIPS (year): gen growthEmp     = (100)*(empTot[_n]-empTot[_n-1])/empTot[_n-1]
bys GeoFIPS (year): gen growthManuf   = manufShare[_n-1]*((manufEmp[_n]-manufEmp[_n-1])/manufEmp[_n-1])
bys GeoFIPS (year): gen growthService = serviceShare[_n-1]*((serviceEmp[_n]-serviceEmp[_n-1])/serviceEmp[_n-1])
foreach x of numlist 1/9 {
    bys GeoFIPS (year): gen growthInd`x' = ind`x'Share[_n-1]*((ind`x'Emp[_n]-ind`x'Emp[_n-1])/ind`x'Emp[_n-1])
}

generat m_empTot              = (empTot             >=.)
generat m_incPerCapita        = (incPerCapita       >=.)
generat m_manufEmp            = (manufEmp           >=.)
generat m_serviceEmp          = (serviceEmp         >=.)
generat m_manufInc            = (manufInc           >=.)
generat m_serviceInc          = (serviceInc         >=.)
generat m_manufShare          = (manufShare         >=.)
generat m_serviceShare        = (serviceShare       >=.)
generat m_manufIncPerCapita   = (manufIncPerCapita  >=.)
generat m_serviceIncPerCapita = (serviceIncPerCapita>=.)
generat m_growthEmp           = (growthEmp          >=.)
generat m_growthManuf         = (growthManuf        >=.)
generat m_growthService       = (growthService      >=.)

foreach x of numlist 1/9 {
    generat m_ind`x'Emp           = (ind`x'Emp         >=.)
    generat m_ind`x'Inc           = (ind`x'Inc         >=.)
    generat m_ind`x'IncPerCapita  = (ind`x'IncPerCapita>=.)
    generat m_ind`x'Share         = (ind`x'Share       >=.)
    generat m_growthInd`x'        = (growthInd`x'      >=.)
}

replace empTot              = 0 if m_empTot              == 1
replace incPerCapita        = 0 if m_incPerCapita        == 1
replace manufEmp            = 0 if m_manufEmp            == 1
replace serviceEmp          = 0 if m_serviceEmp          == 1
replace manufInc            = 0 if m_manufInc            == 1
replace serviceInc          = 0 if m_serviceInc          == 1
replace manufShare          = 0 if m_manufShare          == 1
replace serviceShare        = 0 if m_serviceShare        == 1
replace manufIncPerCapita   = 0 if m_manufIncPerCapita   == 1
replace serviceIncPerCapita = 0 if m_serviceIncPerCapita == 1
replace growthEmp           = 0 if m_growthEmp           == 1
replace growthManuf         = 0 if m_growthManuf         == 1
replace growthService       = 0 if m_growthService       == 1

foreach x of numlist 1/9 {
    replace ind`x'Emp           = 0 if m_ind`x'Emp         ==1
    replace ind`x'Inc           = 0 if m_ind`x'Inc         ==1
    replace ind`x'IncPerCapita  = 0 if m_ind`x'IncPerCapita==1
    replace ind`x'Share         = 0 if m_ind`x'Share       ==1
    replace growthInd`x'        = 0 if m_growthInd`x'      ==1
}

order GeoFIPS year GeoName popAllBEA growthEmp growthManuf growthService growthInd? ind?IncPerCapita ind?Emp ind?Inc empTot ind?Share farmShare incPerCapita manufIncPerCapita serviceIncPerCapita m_growthEmp m_growthManuf m_growthService m_incPerCapita m_manufIncPerCapita m_serviceIncPerCapita m_growthInd? m_ind?IncPerCapita m_ind?Share m_ind?Emp m_empTot
keep  GeoFIPS year GeoName popAllBEA growthEmp growthManuf growthService growthInd? ind?IncPerCapita ind?Emp ind?Inc empTot ind?Share farmShare incPerCapita manufIncPerCapita serviceIncPerCapita m_growthEmp m_growthManuf m_growthService m_incPerCapita m_manufIncPerCapita m_serviceIncPerCapita m_growthInd? m_ind?IncPerCapita m_ind?Share m_ind?Emp m_empTot
sort  GeoFIPS year

preserve 
    ren GeoName AreaName
    gen fips_st = floor(GeoFIPS/1000)
    gen fips_co = GeoFIPS-fips_st*1000
    drop if fips_co==0
    compress
    save BEAcountyFIPS.dta, replace
restore

reshape wide popAllBEA growthEmp growthManuf growthService growthInd? ind?IncPerCapita ind?Emp ind?Inc empTot farmShare ind?Share incPerCapita manufIncPerCapita serviceIncPerCapita m_growthEmp m_growthManuf m_growthService m_incPerCapita m_manufIncPerCapita m_serviceIncPerCapita m_growthInd? m_ind?IncPerCapita m_ind?Share m_ind?Emp m_empTot, i(GeoFIPS GeoName) j(year)

keep GeoName GeoFIPS *2001 *2002 *2003 *2004 *2005 *2006 *2007 *2008 *2009 *2010 *2011 *2012 *2013 *2014 *2015 *2016
ren GeoName AreaName
gen fips_st = floor(GeoFIPS/1000)
gen fips_co = GeoFIPS-fips_st*1000
drop if fips_co==0
compress
save BEAcountyFIPS_wide.dta, replace

log close
