* Import, rename, reshape, recode and label the demographic variables

infile using y79_college_majorsV2.dct, clear

****************
* Rename
****************

rename R0000100 id
rename R0021600 college1major1979
rename R0230900 college1major1980
rename R0419100 college1major1981
rename R0666200 college1major1982
rename R0907500 college1major1983
rename R1207800 college1major1984
rename R1208700 college2major1984
rename R1209600 college3major1984
rename R1607000 college1major1985
rename R1607900 college2major1985
rename R1608800 college3major1985
rename R1907400 college1major1986
rename R1908300 college2major1986
rename R1909200 college3major1986
rename R2511300 college1major1988
rename R2512800 college2major1988
rename R2514200 college3major1988
rename R2910200 college1major1989
rename R2911700 college2major1989
rename R2913100 college3major1989
rename R3112200 college1major1990
rename R3113700 college2major1990
rename R3115100 college3major1990
rename R3712700 college1major1992
rename R3714200 college2major1992
rename R3715600 college3major1992
rename R4140300 college1major1993
rename R4141900 college2major1993
rename R4143400 college3major1993
rename R4528700 college1major1994
rename R4530000 college2major1994
rename R4531100 college3major1994
rename R5224000 college1major1996
rename R5225300 college2major1996
rename R5226500 college3major1996
rename R6467800 college1major1998
rename R6467900 college2major1998
rename R6468000 college3major1998
rename R6543300 college1major2000
rename R6543400 college2major2000
rename R6543500 college3major2000
rename R7106500 college1major2002
rename R7106600 college2major2002
rename R7106700 college3major2002
rename R7813302 college1major2004
rename R7813303 college2major2004
rename R7813304 college3major2004
rename T0017300 college1major2006
rename T0017400 college2major2006
rename T0017500 college3major2006
rename T1217700 college1major2008
rename T1217800 college2major2008
rename T2275700 college1major2010
rename T2275800 college2major2010
rename T3216300 college1major2012
rename T3216400 college2major2012
rename T4205900 college1major2014
rename T4206000 college2major2014
rename T4206100 college3major2014


***************************************************
* Reshape and recode certain variables.
***************************************************

reshape long  college1major college2major college3major , i(id) j(year)
recode _all (-1 = .r) (-2 = .d) (-3 = .i) (-4 = .v) (-5 = .n)

***************************************************
* Label variables and values
***************************************************

label var id                  "ID"
label var year                "YEAR"
label var college1major       "MAJOR FIELD OF STUDY AT MOST RECENT COLLEGE ATTENDED"
label var college2major       "MAJOR FIELD OF STUDY AT 2ND MOST RECENT COLLEGE ATTENDED"
label var college3major       "MAJOR FIELD OF STUDY AT 3RD MOST RECENT COLLEGE ATTENDED"

compress
order id year college1major college2major college3major
save y79_college_majors, replace
