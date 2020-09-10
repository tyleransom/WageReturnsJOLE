* Import, rename, reshape, recode and label location variables (county, state, smsa)

infile using "../../NLSY79_Geocode_1979_2014/location.dct", clear

****************
* Rename
****************

* rename A0002400 versionR24
rename R0000100 id
rename R0219001 fips_co1979
rename R0219002 fips_st1979
rename R0219003 fips_smsa1979
rename R0219004 fips_editcode1979
rename R0408001 fips_co1980
rename R0408002 fips_st1980
rename R0408003 fips_smsa1980
rename R0408004 fips_editcode1980
rename R0648001 fips_co1981
rename R0648002 fips_st1981
rename R0648003 fips_smsa1981
rename R0648004 fips_editcode1981
rename R0899001 fips_co1982
rename R0899002 fips_st1982
rename R0899003 fips_smsa1982
rename R0899004 fips_editcode1982
rename R1150000 fips_co1983
rename R1150001 fips_st1983
rename R1150002 fips_smsa1983
* rename R1150003 fips_smsa1983
rename R1150006 fips_editcode1983
rename R1523000 fips_co1984
rename R1523001 fips_st1984
rename R1523002 fips_smsa1984
* rename R1523005 fips_smsa1984
rename R1523006 fips_editcode1984
rename R1893000 fips_co1985
rename R1893001 fips_st1985
rename R1893002 fips_smsa1985
* rename R1893005 fips_smsa1985
rename R1893006 fips_editcode1985
rename R2260000 fips_co1986
rename R2260001 fips_st1986
rename R2260002 fips_smsa1986
* rename R2260005 fips_smsa1986
rename R2260006 fips_editcode1986
rename R2450000 fips_co1987
rename R2450001 fips_st1987
rename R2450002 fips_smsa1987
* rename R2450005 fips_smsa1987
rename R2450006 fips_editcode1987
rename R2882500 fips_co1988
rename R2882600 fips_st1988
rename R2882700 fips_smsa1988
* rename R2883000 fips_smsa1988
rename R2883400 fips_editcode1988
rename R3076900 fips_co1989
rename R3077000 fips_st1989
rename R3077100 fips_smsa1989
* rename R3077400 fips_smsa1989
rename R3077800 fips_quality1989
rename R3411300 fips_co1990
rename R3411400 fips_st1990
rename R3411500 fips_smsa1990
* rename R3411800 fips_smsa1990
rename R3412200 fips_quality1990
rename R3659500 fips_co1991
rename R3659600 fips_st1991
rename R3659700 fips_smsa1991
* rename R3660000 fips_smsa1991
rename R3660400 fips_quality1991
rename R4009500 fips_co1992
rename R4009600 fips_st1992
rename R4009700 fips_smsa1992
* rename R4010000 fips_smsa1992
rename R4010400 fips_quality1992
rename R4420600 fips_co1993
rename R4420700 fips_st1993
rename R4421100 fips_smsa1993
rename R4421500 fips_quality1993
rename R5090500 fips_co1994
rename R5090600 fips_st1994
rename R5091000 fips_smsa1994
rename R5091400 fips_quality1994
rename R5176300 fips_co1996
rename R5176400 fips_st1996
rename R5176800 fips_smsa1996
rename R6489500 fips_co1998
rename R6489600 fips_st1998
rename R6490000 fips_smsa1998
rename R6490700 fips_quality1998
rename R7017300 fips_co2000
rename R7017400 fips_st2000
rename R7017800 fips_smsa2000
rename R7038200 fips_quality2000
rename R7714800 fips_co2002
rename R7714900 fips_st2002
rename R7715400 fips_smsa2002
rename R7716100 fips_quality2002
rename R8507600 fips_co2004
rename R8507700 fips_st2004
rename R8508100 fips_quality2004
rename T0999300 fips_co2006
rename T0999400 fips_st2006
rename T0999800 fips_quality2006
rename T2221100 fips_co2008
rename T2221200 fips_st2008
rename T2221600 fips_quality2008
rename T3119100 fips_co2010
rename T3119200 fips_st2010
rename T3119900 fips_quality2010
rename T4125000 fips_co2012 
rename T4125100 fips_st2012 
rename T4125900 fips_quality2012 
rename T5035700 fips_co2014
rename T5035800 fips_st2014
rename T5036600 fips_quality2014

* keep id versionR24 fips*
keep id fips*

forvalues yr=1970/1996 {
	gen temp`yr'=0
}

reshape long temp fips_st fips_co fips_smsa fips_editcode fips_quality, i(id) j(year)
drop temp

recode _all (-1 = .r) (-2 = .d) (-3 = .i) (-4 = .v) (-5 = .n)

gen fips_editcode1 = fips_editcode if inlist(year,1979,1982)
gen fips_editcode2 = fips_editcode if inlist(year,1983,1988)
* drop fips_editcode

***************************************************
* Label variables and values
***************************************************

label var id              "ID# (1-12686) 79"
* label var versionR24      "VERSION_R24 2010"
label var fips_st         "STATE FIPS CODE"
label var fips_co         "COUNTY FIPS CODE"
label var fips_smsa       "SMSA FIPS CODE"
label var fips_editcode1  "CODE FOR HAND EDITS (1979-1982)"
label var fips_editcode2  "CODE FOR HAND EDITS (1983-1989)"
label var fips_quality    "CODE FOR QUALITY (1990-2014)"

label define vleditcode1 0 "NO EDIT NECESSARY"  1 "ZIP CODE CHANGED-KEYPUNCH ERROR"  2 "COUNTY CODE CHANGED-KEYPUNCH ERROR" 3 "STATE CODE CHANGED-KEYPUNCH ERROR"  4 "ZIP CODE CHANGED-ASSIGNMENT"  5 "COUNTY CODE CHANGED-ASSIGNMENT"  6 "STATE CODE CHANGED-ASSIGNMENT"  7 "MULTIPLE CHANGES-AT LEAST ONE KEYPUNCH ERROR"  8 "MULTIPLE CHANGES-ASSIGNMENTS"
label define vleditcode2 0 "NO HAND EDIT"       1 "ZIP CODE ADDED-STREET ADDRESS, CITY, COUNTY & STATE AVAILABLE"  2 "ZIP CODE ADDED-STREET ADDRESS, COUNTY, & STATE AVAILABLE"  3 "ZIP CODE ADDED-CITY, COUNTY, & STATE AVAILABLE"  4 "ZIP CODE ADDED-COUNTY & STATE AVAILABLE, MAIN PO ZIP USED"  5 "COUNTY & STATE ADDED-ZIP CODE AVAILABLE"  6 "ZIP, COUNTY & STATE CODES FROM PRIOR INT-NO RESIDENCE CHANGE"  7 "MATCH ON COUNTY & STATE CODES ON CCDB 83-NO MATCH ON 83 CRF"  8 "COUNTY CODE ADDED-ZIP CODE & STATE CODE AVAILABLE"  9 "MISCELLANEOUS HAND EDITS-ZIP, COUNTY, &/OR STATE CODES ADDED"  10 "COUNTY ADDED FROM CRF-STATE & ZIP CODE MATCH W/CRF"  11 "COUNTY & STATE ADDED FROM CRF-ZIP CODE MATCH W/CRF"

label values fips_editcode1 vleditcode1
label values fips_editcode2 vleditcode2

* Quality definition changed over time:
* 1988 (init): 0 "R IN MILITARY OR RESIDING ABROAD"  1 "RESIDENCE INFORMATION INDETERMINANT"  3 "ZIP NOT FOUND, MATCH ON STATE AND COUNTY"  4 "ZIPCODE STATE AND AREA-CODE-ONLY STATE MATCH"  6 "ADDRESS STATE AND PHONE STATE MATCH"  7 "ZIPCODE STATE AND PHONE STATE MATCH"  8 "ADDRESS STATE AND ZIPCODE STATE MATCH"  9 "ADDRESS STATE, ZIPCODE STATE AND PHONE STATE MATCH"  10 "COUNTY AND/OR STATE WERE HAND EDITED"
* 1998--2004: 1 Actual Match Based on Address 0 Match Based on Zip Centroid
* 2006--2014: 1: Actual Match Based on Address 2: Manual Edit: Match Based on Short Street 3: Manual Edit: Match Based on Long Street 4: Match Based on Zip Centroid
recode fips_quality (1 = 11) (0 = 14) if inlist(year,1998,2000,2002,2004)
recode fips_quality (1 = 11) (2 = 12) (3 = 13) (4 = 14) if inlist(year,2006,2008,2010,2012,2014)

label define vlquality    0 "R IN MILITARY OR RESIDING ABROAD"  1 "RESIDENCE INFORMATION INDETERMINANT"  3 "ZIP NOT FOUND, MATCH ON STATE AND COUNTY"  4 "ZIPCODE STATE AND AREA-CODE-ONLY STATE MATCH"  6 "ADDRESS STATE AND PHONE STATE MATCH"  7 "ZIPCODE STATE AND PHONE STATE MATCH"  8 "ADDRESS STATE AND ZIPCODE STATE MATCH"  9 "ADDRESS STATE, ZIPCODE STATE AND PHONE STATE MATCH"  10 "COUNTY AND/OR STATE WERE HAND EDITED" 11 "ACTUAL MATCH ABSED ON ADDRESS" 12 "MANUAL EDIT: MATCH BASED ON SHORT STREET" 13 "MANUAL EDIT: MATCH BASED ON LONG STREET" 14 "MATCHED BASED ON ZIP CENTROID"
label values fips_quality vlquality

* order id year version* fips_st fips_co fips_smsa fips_editcode1 fips_editcode2 fips_quality
order id year fips_st fips_co fips_smsa fips_editcode1 fips_editcode2 fips_quality
