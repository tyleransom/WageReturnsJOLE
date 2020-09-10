* Import, rename, reshape, recode and label the demographic variables
!unzip y79_demographicsV2.dct.zip
infile using y79_demographicsV2.dct, clear
!rm y79_demographicsV2.dct

****************
* Rename
****************

rename A0002600 versionR26
rename R0000100 id
rename R0000300 dob_mo1979
rename R0000500 dob_yr1979
rename R0000700 country_born
rename R0001800 urbanity_14
rename R0001900 live_with_14
rename R0006500 hgcMoth
rename R0007900 hgcFath
rename R0153000 rotter_1a1979
rename R0153100 rotter_1b1979
rename R0153200 rotter_2a1979
rename R0153300 rotter_2b1979
rename R0153400 rotter_3a1979
rename R0153500 rotter_3b1979
rename R0153600 rotter_4a1979
rename R0153700 rotter_4b1979
rename R0153710 rotter_score1979
rename R0173600 sample_id1979
rename R0214700 race_screen
rename R0214800 sex
rename R0216100 weight1979
rename R0216400 region1979
rename R0217502 family_size1979
rename R0217900 famInc1978
rename R0405200 weight1980
rename R0405700 region1980
rename R0406310 reason_noninterview1980
rename R0602810 region1981
rename R0614600 weight1981
rename R0618200 afqt1980
rename R0618300 afqt1989
rename R0618301 afqt2006
rename R0618810 reason_noninterview1981
rename R0896700 weight1982
rename R0897910 region1982
rename R0898510 reason_noninterview1982
rename R0901000	yearEnteredUS
rename R1144400 weight1983
rename R1144710 reason_noninterview1983
rename R1144800 region1983
rename R1519600 weight1984
rename R1519910 reason_noninterview1984
rename R1520000 region1984
rename R1890200 weight1985
rename R1890300 reason_noninterview1985
rename R1890700 region1985
rename R2257300 weight1986
rename R2257400 reason_noninterview1986
rename R2257800 region1986
rename R2444500 weight1987
rename R2444600 reason_noninterview1987
rename R2445200 region1987
rename R2870000 weight1988
rename R2870100 reason_noninterview1988
rename R2870800 region1988
rename R3073800 weight1989
rename R3073900 reason_noninterview1989
rename R3074500 region1989
rename R3400200 weight1990
rename R3400500 reason_noninterview1990
rename R3401200 region1990
rename R3655800 weight1991
rename R3655900 reason_noninterview1991
rename R3656600 region1991
rename R4006300 weight1992
rename R4006400 reason_noninterview1992
rename R4007100 region1992
rename R4417400 weight1993
rename R4417500 reason_noninterview1993
rename R4418200 region1993
rename R5080400 weight1994
rename R5080500 reason_noninterview1994
rename R5081200 region1994
rename R5165700 weight1996               
rename R5165800 reason_noninterview1996  
rename R5166500 region1996               
rename R6466300 weight1998             
rename R6478500 reason_noninterview1998
rename R6479100 region1998             
rename R7006200 weight2000             
rename R7006300 reason_noninterview2000
rename R7006800 region2000             
rename R7703400 weight2002             
rename R7703500 reason_noninterview2002
rename R7704100 region2002             
rename R8495700 weight2004             
rename R8495900 reason_noninterview2004
rename R8496500 region2004             
rename T0987300 weight2006             
rename T0987500 reason_noninterview2006
rename T0988300 region2006             
rename T2209600 weight2008             
rename T2209800 reason_noninterview2008
rename T2210300 region2008             
rename T3107400 weight2010             
rename T3107600 reason_noninterview2010
rename T3108200 region2010             
rename T4111900 weight2012             
rename T4112100 reason_noninterview2012
rename T4112700 region2012             
rename T5022100 weight2014             
rename T5022300 reason_noninterview2014
rename T5023100 region2014             

***************************************************
* Reshape and recode certain variables.
***************************************************

* Exclued from reshape: id (i), afqt1980 afqt1989 afqt2006 country_born yearEnteredUS dob_mo1979 dob_yr1979 famInc1978 family_size1979 hgcFath hgcMoth live_with_14 race_screen rotter_1a1979 rotter_1b1979 rotter_2a1979 rotter_2b1979 rotter_3a1979 rotter_3b1979 rotter_4a1979 rotter_4b1979 rotter_score1979 sample_id1979 sex urbanity_14
forvalues yr=1970/2014 {
	gen temp`yr'=0
}
reshape long temp reason_noninterview region weight, i(id) j(year)
drop temp

recode _all (-1 = .r) (-2 = .d) (-3 = .i) (-4 = .v) (-5 = .n)
recode *_yr* (50 = 1950) (51 = 1951) (52 = 1952) (53 = 1953) (54 = 1954) (55 = 1955) (55 = 1955) (57 = 1957) (58 = 1958) (59 = 1959) ///
             (60 = 1960) (61 = 1961) (62 = 1962) (63 = 1963) (64 = 1964) (65 = 1965) (66 = 1966) (67 = 1967) (68 = 1968) (69 = 1969) ///
             (70 = 1970) (71 = 1971) (72 = 1972) (73 = 1973) (74 = 1974) (75 = 1975) (76 = 1976) (77 = 1977) (78 = 1978) (79 = 1979) ///
             (80 = 1980) (81 = 1981) (82 = 1982) (83 = 1983) (84 = 1984) (85 = 1985) (86 = 1986) (87 = 1987) (88 = 1988) (89 = 1989) ///
             (90 = 1990) (91 = 1991) (92 = 1992) (93 = 1993) (94 = 1994) (95 = 1995) (96 = 1996) (97 = 1997) (99 = 1999) (99 = 1999)

***************************************************
* Label variables and values
***************************************************

label var id                  "ID"
label var year                "YEAR"
label var dob_mo1979          "DATE OF BIRTH - MONTH 79"
label var dob_yr1979          "DATE OF BIRTH - YR 79"
label var race_screen         "RACL/ETHNIC COHORT /SCRNR"
label var sex                 "SEX"
label var afqt1980            "PROFILES AFQT PRCTILE SCORE-1980"
label var afqt1989            "PROFILES AFQT PRCTILE SCORE-1989 (REV)"
label var afqt2006            "PROFILES AFQT PRCTILE SCORE-2006 (REV)"
label var country_born        "CNTRY OF BIRTH 79"
label var yearEnteredUS       "YEAR FIRST ENTERED UNITED STATES"
label var famInc1978          "TOT NET FAMILY INC 1978"
label var family_size1979     "FAMILY SIZE 79"
label var hgcFath             "HGC BY RS FATHER 79"
label var hgcMoth             "HGC BY RS MOTHER 79"
label var live_with_14        "WITH WHOM DID R LIVE @ AGE 14 79"
label var reason_noninterview "REASON FOR NONINTERVIEW"
label var region              "CENSUS REGION OF CURRENT RESIDENCE"
label var rotter_1a1979       "ROTTER SCALE - PAIR ONE, STMT A 79"
label var rotter_1b1979       "ROTTER SCALE - PAIR ONE, STMT B 79"
label var rotter_2a1979       "ROTTER SCALE - PAIR TWO, STMT A 79"
label var rotter_2b1979       "ROTTER SCALE - PAIR TWO, STMT B 79"
label var rotter_3a1979       "ROTTER SCALE - PAIR THREE, STMT A 79"
label var rotter_3b1979       "ROTTER SCALE - PAIR THREE, STMT B 79"
label var rotter_4a1979       "ROTTER SCALE - PAIR FOUR, STMT A 79"
label var rotter_4b1979       "ROTTER SCALE - PAIR FOUR, STMT B 79"
label var rotter_score1979    "ROTTER SCALE SCORE 79"
label var sample_id1979       "SAMPLE ID  79 INT"
label var urbanity_14         "AREA RESIDENCE @ AGE 14 URBAN/RURAL 79"
label var weight              "SAMPLING WEIGHT"

label define vl_race   1 "HISPANIC"  2 "BLACK"  3 "NON-BLACK, NON-HISPANIC"
label values race_screen vl_race

label define vl_sex   1 "MALE"  2 "FEMALE"
label values sex vl_sex

label define vl_born   1 "IN THE US"  2 "IN OTHER COUNTRY"
label values country_born vl_born

label define vl_grade   0 "NONE"  1 "1ST GRADE"  2 "2ND GRADE"  3 "3RD GRADE"  4 "4TH GRADE"  5 "5TH GRADE"  6 "6TH GRADE"  7 "7TH GRADE"  8 "8TH GRADE"  9 "9TH GRADE"  10 "10TH GRADE"  11 "11TH GRADE"  12 "12TH GRADE"  13 "1ST YR COL"  14 "2ND YR COL"  15 "3RD YR COL"  16 "4TH YR COL"  17 "5TH YR COL"  18 "6TH YR COL"  19 "7TH YR COL"  20 "8TH YR COL OR MORE"  95 "UNGRADED"
label values hgcFath vl_grade
label values hgcMoth vl_grade

label define vl_live_with   11 "FATHER-MOTHER"  12 "FATHER-STEPMOTHER"  13 "FATHER-OTHER WOMAN RELATIVE"  14 "FATHER-OTHER WOMAN"  15 "FATHER-NO WOMAN"  19 "FATHER-MISSING WOMAN"  21 "STEPFATHER-MOTHER"  22 "STEPFATHER-STEPMOTHER"  23 "STEPFATHER-WOMAN RELATIVE"  24 "STEPFATHER-OTHER WOMAN"  25 "STEPFATHER-NO WOMAN"  31 "MAN RELATIVE-MOTHER"  32 "MAN RELATIVE-STEPMOTHER"  33 "MAN RELATIVE-WOMAN RELATIVE"  34 "MAN RELATIVE-OTHER WOMAN"  35 "MAN RELATIVE-NO WOMAN"  41 "OTHER MAN-MOTHER"  42 "OTHER MAN-STEPMOTHER"  43 "OTHER MAN-WOMAN RELATIVE"  44 "OTHER MAN-OTHER WOMAN"  45 "OTHER MAN-NO WOMAN"  51 "NO MAN-MOTHER"  52 "NO MAN-STEPMOTHER"  53 "NO MAN-WOMAN RELATIVE"  54 "NO MAN-OTHER WOMAN"  55 "NO MAN-NO WOMAN"  80 "OTHER ARRANGEMENT"  90 "ON MY OWN"  91 "MISSING MAN-MOTHER"  93 "MISSING MAN-WOMAN RELATIVE"
label values live_with_14 vl_live_with

label define vl_sample_id   1 "CROSS MALE WHITE"  2 "CROSS MALE WH. POOR"  3 "CROSS MALE BLACK"  4 "CROSS MALE HISPANIC"  5 "CROSS FEMALE WHITE"  6 "CROSS FEMALE WH POOR"  7 "CROSS FEMALE BLACK"  8 "CROSS FEMALE HISPANIC"  9 "SUP MALE WH POOR"  10 "SUP MALE BLACK"  11 "SUP MALE HISPANIC"  12 "SUP FEM WH POOR"  13 "SUP FEMALE BLACK"  14 "SUP FEMALE HISPANIC"  15 "MIL MALE WHITE"  16 "MIL MALE BLACK"  17 "MIL MALE HISPANIC"  18 "MIL FEMALE WHITE"  19 "MIL FEMALE BLACK"  20 "MIL FEMALE HISPANIC"
label values sample_id1979 vl_sample_id

label define vl_rotter_control   1 "IN CONTROL"      2 "NOT IN CONTROL"
label define vl_rotter_closeness 1 "MUCH CLOSER"     2 "SLIGHTLY CLOSER"
label define vl_rotter_plans     1 "R'S PLANS WORK"  2 "MATTER OF LUCK"
label define vl_rotter_luck1     1 "LUCK NOT FACTOR" 2 "FLIP A COIN"
label define vl_rotter_luck2     1 "LUCK BIG ROLE"   2 "LUCK NO ROLE"
label values rotter_1a1979 vl_rotter_control
label values rotter_1b1979 vl_rotter_closeness
label values rotter_2a1979 vl_rotter_plans
label values rotter_2b1979 vl_rotter_closeness
label values rotter_3a1979 vl_rotter_luck1
label values rotter_3b1979 vl_rotter_closeness
label values rotter_4a1979 vl_rotter_luck2
label values rotter_4b1979 vl_rotter_closeness

label define vl_noninterview   60 "PARENT REFUSAL/BREAKOFF"  61 "YOUTH REFUSAL/BREAKOFF"  62 "PARENT AND YOUTH REFUSAL/BREAKOFF"  63 "UNABLE TO LOCATE FAMILY UNIT AND YOUTH"  64 "UNABLE TO LOCATE YOUTH"  65 "DECEASED"  66 "OTHER" 67 "DO NOT REFIELD (VERY DIFFICULT CASES)"  68 "MILITARY SAMPLE DROPPED"  69 "SUPPLEMENTAL MALE POOR WHITE SAMPLE DROPPED"  70 "SUPPLEMENTAL FEMALE POOR WHITE SAMPLE DROPPED"
label values reason_noninterview vl_noninterview

label define vl_region   1 "NORTHEAST"  2 "NORTH CENTRAL"  3 "SOUTH"  4 "WEST"
label values region vl_region

label define vl_urbanity   1 "IN TOWN OR CITY"  2 "IN COUNTRY-NOT FARM"  3 "ON FARM OR RANCH"
label values urbanity_14 vl_urbanity

order id year dob* race_screen sex