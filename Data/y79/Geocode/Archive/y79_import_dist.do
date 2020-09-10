* Import, rename, reshape, recode and label unemployment and college variables

infile using "../CDs/NLSY79 data/distances.dct", clear

****************
* Rename
****************
rename A0002400 versionR24
rename R0000100 id
* rename R0219120 fips_co1move1979
* rename R0219121 fips_st1move1979
* rename R0219122 fips_cntry1move1979
* rename R0219123 fips_co2move1979
* rename R0219124 fips_st2move1979
* rename R0219125 fips_cntry2move1979
* rename R0219126 fips_co3move1979
* rename R0219127 fips_st3move1979
* rename R0219128 fips_cntry3move1979
* rename R0219129 fips_co4move1979
* rename R0219130 fips_st4move1979
* rename R0219131 fips_cntry4move1979
* rename R0219132 fips_co5move1979
* rename R0219133 fips_st5move1979
* rename R0408114 fips_co5move1980
* rename R0408115 fips_st5move1980
* rename R0408116 fips_cntry5move1980
* rename R0408117 fips_co4move1980
* rename R0408118 fips_st4move1980
* rename R0408119 fips_cntry4move1980
* rename R0408120 fips_co3move1980
* rename R0408121 fips_st3move1980
* rename R0408122 fips_cntry3move1980
* rename R0408123 fips_co2move1980
* rename R0408124 fips_st2move1980
* rename R0408125 fips_cntry2move1980
* rename R0408126 fips_co1move1980
* rename R0408127 fips_st1move1980
rename R0408133 unempLocal1980
rename R0648120 unempLocal1981
* rename R0899114 fips_co9move1982
* rename R0899115 fips_st9move1982
* rename R0899116 fips_cntry9move1982
* rename R0899117 fips_co8move1982
* rename R0899118 fips_st8move1982
* rename R0899119 fips_cntry8move1982
* rename R0899120 fips_co7move1982
* rename R0899121 fips_st7move1982
* rename R0899122 fips_cntry7move1982
* rename R0899123 fips_co6move1982
* rename R0899124 fips_st6move1982
* rename R0899125 fips_cntry6move1982
* rename R0899126 fips_co5move1982
* rename R0899127 fips_st5move1982
* rename R0899128 fips_cntry5move1982
* rename R0899129 fips_co4move1982
* rename R0899130 fips_st4move1982
* rename R0899131 fips_cntry4move1982
* rename R0899132 fips_co3move1982
* rename R0899133 fips_st3move1982
* rename R0899134 fips_co2move1982
* rename R0899135 fips_st2move1982
* rename R0899136 fips_cntry2move1982
* rename R0899137 fips_co1move1982
* rename R0899138 fips_st1move1982
rename R0899149 unempLocal1982
rename R1150062 unempLocal1983
rename R1523062 unempLocal1984
* rename R1523063 ficeOrig1col1984
rename R1523064 state1col1984
* rename R1523065 ficeOrig2col1984
rename R1523066 state2col1984
* rename R1523067 ficeOrig3col1984
rename R1523068 state3col1984
rename R1523071 fice1col1984
rename R1523072 ficeType1col1984
rename R1523073 fice2col1984
rename R1523074 ficeType2col1984
rename R1523075 fice3col1984
rename R1523076 ficeType3col1984
rename R1893062 unempLocal1985
* rename R1893063 ficeOrig1col1985
rename R1893064 state1col1985
* rename R1893065 ficeOrig2col1985
rename R1893066 state2col1985
* rename R1893067 ficeOrig3col1985
rename R1893068 state3col1985
rename R1893071 fice1col1985
rename R1893072 ficeType1col1985
rename R1893073 fice2col1985
rename R1893074 ficeType2col1985
rename R1893075 fice3col1985
rename R1893076 ficeType3col1985
rename R2260062 unempLocal1986
* rename R2260063 ficeOrig1col1986
rename R2260064 state1col1986
* rename R2260065 ficeOrig2col1986
rename R2260066 state2col1986
* rename R2260067 ficeOrig3col1986
rename R2260068 state3col1986
rename R2260069 fice1col1986
rename R2260070 ficeType1col1986
rename R2260071 fice2col1986
rename R2260072 ficeType2col1986
rename R2260073 fice3col1986
rename R2260074 ficeType3col1986
rename R2450062 unempLocal1987
rename R2891900 unempLocal1988
* rename R2892000 ficeOrig1col1988
rename R2892100 state1col1988
rename R2892101 fice1col1988
rename R2892102 ficeType1col1988
* rename R2892200 ficeOrig2col1988
rename R2892201 fice2col1988
rename R2892202 ficeType2col1988
rename R2892300 state2col1988
* rename R2892400 ficeOrig3col1988
rename R2892401 fice3col1988
rename R2892402 ficeType3col1988
rename R2892500 state3col1988
rename R3086300 unempLocal1989
* rename R3086400 ficeOrig1col1989
rename R3086401 fice1col1989
rename R3086402 ficeType1col1989
rename R3086500 state1col1989
* rename R3086600 ficeOrig2col1989
rename R3086601 fice2col1989
rename R3086602 ficeType2col1989
rename R3086700 state2col1989
* rename R3086800 ficeOrig3col1989
rename R3086801 fice3col1989
rename R3086802 ficeType3col1989
rename R3086900 state3col1989
rename R3420700 unempLocal1990
* rename R3420800 ficeOrig1col1990
rename R3420801 fice1col1990
rename R3420802 ficeType1col1990
rename R3420900 state1col1990
* rename R3421000 ficeOrig2col1990
rename R3421001 fice2col1990
rename R3421002 ficeType2col1990
rename R3421100 state2col1990
* rename R3421200 ficeOrig3col1990
rename R3421201 fice3col1990
rename R3421202 ficeType3col1990
rename R3421300 state3col1990
rename R3668900 unempLocal1991
rename R4018900 unempLocal1992
* rename R4019000 ficeOrig1col1992
rename R4019001 fice1col1992
rename R4019002 ficeType1col1992
rename R4019100 state1col1992
* rename R4019200 ficeOrig2col1992
rename R4019201 fice2col1992
rename R4019202 ficeType2col1992
rename R4019300 state2col1992
* rename R4019400 ficeOrig3col1992
rename R4019401 fice3col1992
rename R4019402 ficeType3col1992
rename R4019500 state3col1992
rename R4430000 unempLocal1993
* rename R4430100 ficeOrig1col1993
rename R4430101 fice1col1993
rename R4430102 ficeType1col1993
rename R4430200 state1col1993
* rename R4430300 ficeOrig2col1993
rename R4430301 fice2col1993
rename R4430302 ficeType2col1993
rename R4430400 state2col1993
* rename R4430500 ficeOrig3col1993
rename R4430501 fice3col1993
rename R4430502 ficeType3col1993
rename R4430600 state3col1993
rename R5099900 unempLocal1994
* rename R5100000 ficeOrig1col1994
rename R5100100 state1col1994
* rename R5100200 ficeOrig2col1994
rename R5100300 state2col1994
* rename R5100400 ficeOrig3col1994
rename R5100500 state3col1994
rename R5108900 fice1col1994
rename R5109000 ficeType1col1994
rename R5109100 fice2col1994
rename R5109200 ficeType2col1994
rename R5109300 fice3col1994
rename R5109400 ficeType3col1994
rename R5185700 unempLocal1996
* rename R5185800 ficeOrig1col1996
rename R5185900 state1col1996
* rename R5186000 ficeOrig2col1996
rename R5186100 state2col1996
* rename R5186200 ficeOrig3col1996
rename R5186300 state3col1996
rename R5756500 fice1col1996
rename R5756600 ficeType1col1996
rename R5756700 fice2col1996
rename R5756800 ficeType2col1996
rename R5756900 fice3col1996
rename R5757000 ficeType3col1996


***************************************************
* Keep, reshape and recode certain variables.
***************************************************

keep id versionR24 unemp* fice*col* state*col*
* keep id versionR24 unemp* fips*  fice*col* state*col*

forvalues yr=1970/1996 {
	gen temp`yr'=0
}

reshape long temp unempLocal fice1col ficeType1col state1col fice2col ficeType2col state2col fice3col ficeType3col state3col , i(id) j(year)
* reshape long temp unempLocal ficeOrig1col fice1col ficeType1col state1col ficeOrig2col fice2col ficeType2col state2col ficeOrig3col fice3col ficeType3col state3col fips_co1move fips_st1move fips_co2move fips_st2move fips_cntry2move fips_co3move fips_st3move fips_cntry3move fips_co4move fips_st4move fips_cntry4move fips_co5move fips_st5move fips_cntry5move fips_co6move fips_st6move fips_cntry6move fips_co7move fips_st7move fips_cntry7move fips_co8move fips_st8move fips_cntry8move fips_co9move fips_st9move fips_cntry9move , i(id) j(year)
drop temp

recode _all (-1 = .r) (-2 = .d) (-3 = .i) (-4 = .v) (-5 = .n)


***************************************************
* Label variables and values
***************************************************

label var id              "ID# (1-12686) 79"
label var versionR24      "VERSION_R24 2010"
* label var ficeOrig1col    "FICE CODE MOST RECENT COLLEGE"
* label var ficeOrig2col    "FICE CODE 2ND MOST RECENT COLLEGE"
* label var ficeOrig3col    "FICE CODE 3RD MOST RECENT COLLEGE"
label var fice1col        "FICE CODE MOST RECENT COLLEGE (REVISED)"
label var fice2col        "FICE CODE 2ND MOST RECENT COLLEGE (REVISED)"
label var fice3col        "FICE CODE 3RD MOST RECENT COLLEGE (REVISED)"
label var ficeType1col    "FICE TYPE MOST RECENT COLLEGE (REVISED)"
label var ficeType2col    "FICE TYPE 2ND MOST RECENT COLLEGE (REVISED)"
label var ficeType3col    "FICE TYPE 3RD MOST RECENT COLLEGE (REVISED)"
label var state1col       "STATE MOST RECENT COLLEGE"
label var state2col       "STATE 2ND MOST RECENT COLLEGE"
label var state3col       "STATE 3RD MOST RECENT COLLEGE"
label var unempLocal      "UNEMP RATE OF LABOR MARKET OF CURRENT RESIDENCE"

label define vl_ficeType   0 "VALID FICE CODE"  1 "UNITID"  2 "SCHOOL ID CODE FOR INTERNATIONAL INSTITUTIONS"  3 "TAKING COURSES FROM REMOTE LOCATION"  4 "SCHOOL ID CODE - INSTITUTION CANNOT BE VERIFIED"
label values ficeType1col vl_ficeType
label values ficeType2col vl_ficeType
label values ficeType3col vl_ficeType

order id year versionR24
