* Import, rename, reshape, recode and label the schooling variables

!unzip RawData/y97_school.dct.zip
infile using y97_school.dct, clear
!rm y97_school.dct

****************
* Rename
****************

ren R0000100 ID
ren E5280200 School_Yr_to_Grade1982
ren E5280300 School_Yr_to_Grade1983
ren E5280400 School_Yr_to_Grade1984
ren E5280500 School_Yr_to_Grade1985
ren E5280600 School_Yr_to_Grade1986
ren E5280700 School_Yr_to_Grade1987
ren E5280800 School_Yr_to_Grade1988
ren E5280900 School_Yr_to_Grade1989
ren E5281000 School_Yr_to_Grade1990
ren E5281100 School_Yr_to_Grade1991
ren E5281200 School_Yr_to_Grade1992
ren E5281300 School_Yr_to_Grade1993
ren E5281400 School_Yr_to_Grade1994
ren E5281500 School_Yr_to_Grade1995
ren E5281600 School_Yr_to_Grade1996
ren E5281700 School_Yr_to_Grade1997
ren E5281800 School_Yr_to_Grade1998
ren E5281900 School_Yr_to_Grade1999
ren E5282000 School_Yr_to_Grade2000
ren E5282100 School_Yr_to_Grade2001
ren E5282200 School_Yr_to_Grade2002
ren E5282300 School_Yr_to_Grade2003
ren E5282400 School_Yr_to_Grade2004
ren E5282500 School_Yr_to_Grade2005
ren E5282600 School_Yr_to_Grade2006
ren E5282700 School_Yr_to_Grade2007

ren R2563101 Highest_Grade_Completed1998
ren R3884701 Highest_Grade_Completed1999
ren R5463901 Highest_Grade_Completed2000
ren R7227601 Highest_Grade_Completed2001
ren S1541501 Highest_Grade_Completed2002
ren S2011301 Highest_Grade_Completed2003
ren S3812201 Highest_Grade_Completed2004
ren S5412600 Highest_Grade_Completed2005
ren S7513500 Highest_Grade_Completed2006
ren T0013900 Highest_Grade_Completed2007
ren T2016000 Highest_Grade_Completed2008
ren T3606300 Highest_Grade_Completed2009
ren T5206700 Highest_Grade_Completed2010
ren T6656500 Highest_Grade_Completed2011
ren T8128900 Highest_Grade_Completed2013
ren U0008800 Highest_Grade_Completed2015
ren Z9083800 Highest_Grade_Ever_Completed

ren R2564001 Highest_degree_ever1998
ren R3885601 Highest_degree_ever1999
ren R5464801 Highest_degree_ever2000
ren R7228501 Highest_degree_ever2001
ren S1542401 Highest_degree_ever2002
ren S2012201 Highest_degree_ever2003
ren S3813701 Highest_degree_ever2004
ren S5413300 Highest_degree_ever2005
ren S7514200 Highest_degree_ever2006
ren T0014600 Highest_degree_ever2007
ren T2016700 Highest_degree_ever2008
ren T3607000 Highest_degree_ever2009
ren T5207400 Highest_degree_ever2010
ren T6657200 Highest_degree_ever2011
ren T8129600 Highest_degree_ever2013
ren U0009400 Highest_degree_ever2015
ren R3885701 Highest_degree1999
ren R5464901 Highest_degree2000
ren R7228601 Highest_degree2001
ren S1542501 Highest_degree2002
ren S2012301 Highest_degree2003
ren S3813801 Highest_degree2004
ren S5413400 Highest_degree2005
ren S7514300 Highest_degree2006
ren T0014700 Highest_degree2007
ren T2016800 Highest_degree2008
ren T3607100 Highest_degree2009
ren T5207500 Highest_degree2010
ren T6657300 Highest_degree2011
ren T8129700 Highest_degree2013
ren Z9083900 Highest_degree_ever_cum

ren Z9084200 Months_to_HS_diploma
ren Z9084100 Months_to_GED
ren Z9084300 Months_to_AA_degree
ren Z9084400 Months_to_BA_degree
ren Z9084700 Months_to_MA_degree
ren Z9084500 Months_to_Prof_degree
ren Z9084600 Months_to_PhD_degree

ren E5011701 School_Enrollment_Status_Jan1997
ren E5011702 School_Enrollment_Status_Feb1997
ren E5011703 School_Enrollment_Status_Mar1997
ren E5011704 School_Enrollment_Status_Apr1997
ren E5011705 School_Enrollment_Status_May1997
ren E5011706 School_Enrollment_Status_Jun1997
ren E5011707 School_Enrollment_Status_Jul1997
ren E5011708 School_Enrollment_Status_Aug1997
ren E5011709 School_Enrollment_Status_Sep1997
ren E5011710 School_Enrollment_Status_Oct1997
ren E5011711 School_Enrollment_Status_Nov1997
ren E5011712 School_Enrollment_Status_Dec1997
ren E5011801 School_Enrollment_Status_Jan1998
ren E5011802 School_Enrollment_Status_Feb1998
ren E5011803 School_Enrollment_Status_Mar1998
ren E5011804 School_Enrollment_Status_Apr1998
ren E5011805 School_Enrollment_Status_May1998
ren E5011806 School_Enrollment_Status_Jun1998
ren E5011807 School_Enrollment_Status_Jul1998
ren E5011808 School_Enrollment_Status_Aug1998
ren E5011809 School_Enrollment_Status_Sep1998
ren E5011810 School_Enrollment_Status_Oct1998
ren E5011811 School_Enrollment_Status_Nov1998
ren E5011812 School_Enrollment_Status_Dec1998
ren E5011901 School_Enrollment_Status_Jan1999
ren E5011902 School_Enrollment_Status_Feb1999
ren E5011903 School_Enrollment_Status_Mar1999
ren E5011904 School_Enrollment_Status_Apr1999
ren E5011905 School_Enrollment_Status_May1999
ren E5011906 School_Enrollment_Status_Jun1999
ren E5011907 School_Enrollment_Status_Jul1999
ren E5011908 School_Enrollment_Status_Aug1999
ren E5011909 School_Enrollment_Status_Sep1999
ren E5011910 School_Enrollment_Status_Oct1999
ren E5011911 School_Enrollment_Status_Nov1999
ren E5011912 School_Enrollment_Status_Dec1999
ren E5012001 School_Enrollment_Status_Jan2000
ren E5012002 School_Enrollment_Status_Feb2000
ren E5012003 School_Enrollment_Status_Mar2000
ren E5012004 School_Enrollment_Status_Apr2000
ren E5012005 School_Enrollment_Status_May2000
ren E5012006 School_Enrollment_Status_Jun2000
ren E5012007 School_Enrollment_Status_Jul2000
ren E5012008 School_Enrollment_Status_Aug2000
ren E5012009 School_Enrollment_Status_Sep2000
ren E5012010 School_Enrollment_Status_Oct2000
ren E5012011 School_Enrollment_Status_Nov2000
ren E5012012 School_Enrollment_Status_Dec2000
ren E5012101 School_Enrollment_Status_Jan2001
ren E5012102 School_Enrollment_Status_Feb2001
ren E5012103 School_Enrollment_Status_Mar2001
ren E5012104 School_Enrollment_Status_Apr2001
ren E5012105 School_Enrollment_Status_May2001
ren E5012106 School_Enrollment_Status_Jun2001
ren E5012107 School_Enrollment_Status_Jul2001
ren E5012108 School_Enrollment_Status_Aug2001
ren E5012109 School_Enrollment_Status_Sep2001
ren E5012110 School_Enrollment_Status_Oct2001
ren E5012111 School_Enrollment_Status_Nov2001
ren E5012112 School_Enrollment_Status_Dec2001
ren E5012201 School_Enrollment_Status_Jan2002
ren E5012202 School_Enrollment_Status_Feb2002
ren E5012203 School_Enrollment_Status_Mar2002
ren E5012204 School_Enrollment_Status_Apr2002
ren E5012205 School_Enrollment_Status_May2002
ren E5012206 School_Enrollment_Status_Jun2002
ren E5012207 School_Enrollment_Status_Jul2002
ren E5012208 School_Enrollment_Status_Aug2002
ren E5012209 School_Enrollment_Status_Sep2002
ren E5012210 School_Enrollment_Status_Oct2002
ren E5012211 School_Enrollment_Status_Nov2002
ren E5012212 School_Enrollment_Status_Dec2002
ren E5012301 School_Enrollment_Status_Jan2003
ren E5012302 School_Enrollment_Status_Feb2003
ren E5012303 School_Enrollment_Status_Mar2003
ren E5012304 School_Enrollment_Status_Apr2003
ren E5012305 School_Enrollment_Status_May2003
ren E5012306 School_Enrollment_Status_Jun2003
ren E5012307 School_Enrollment_Status_Jul2003
ren E5012308 School_Enrollment_Status_Aug2003
ren E5012309 School_Enrollment_Status_Sep2003
ren E5012310 School_Enrollment_Status_Oct2003
ren E5012311 School_Enrollment_Status_Nov2003
ren E5012312 School_Enrollment_Status_Dec2003
ren E5012401 School_Enrollment_Status_Jan2004
ren E5012402 School_Enrollment_Status_Feb2004
ren E5012403 School_Enrollment_Status_Mar2004
ren E5012404 School_Enrollment_Status_Apr2004
ren E5012405 School_Enrollment_Status_May2004
ren E5012406 School_Enrollment_Status_Jun2004
ren E5012407 School_Enrollment_Status_Jul2004
ren E5012408 School_Enrollment_Status_Aug2004
ren E5012409 School_Enrollment_Status_Sep2004
ren E5012410 School_Enrollment_Status_Oct2004
ren E5012411 School_Enrollment_Status_Nov2004
ren E5012412 School_Enrollment_Status_Dec2004
ren E5012501 School_Enrollment_Status_Jan2005
ren E5012502 School_Enrollment_Status_Feb2005
ren E5012503 School_Enrollment_Status_Mar2005
ren E5012504 School_Enrollment_Status_Apr2005
ren E5012505 School_Enrollment_Status_May2005
ren E5012506 School_Enrollment_Status_Jun2005
ren E5012507 School_Enrollment_Status_Jul2005
ren E5012508 School_Enrollment_Status_Aug2005
ren E5012509 School_Enrollment_Status_Sep2005
ren E5012510 School_Enrollment_Status_Oct2005
ren E5012511 School_Enrollment_Status_Nov2005
ren E5012512 School_Enrollment_Status_Dec2005
ren E5012601 School_Enrollment_Status_Jan2006
ren E5012602 School_Enrollment_Status_Feb2006
ren E5012603 School_Enrollment_Status_Mar2006
ren E5012604 School_Enrollment_Status_Apr2006
ren E5012605 School_Enrollment_Status_May2006
ren E5012606 School_Enrollment_Status_Jun2006
ren E5012607 School_Enrollment_Status_Jul2006
ren E5012608 School_Enrollment_Status_Aug2006
ren E5012609 School_Enrollment_Status_Sep2006
ren E5012610 School_Enrollment_Status_Oct2006
ren E5012611 School_Enrollment_Status_Nov2006
ren E5012612 School_Enrollment_Status_Dec2006
ren E5012701 School_Enrollment_Status_Jan2007
ren E5012702 School_Enrollment_Status_Feb2007
ren E5012703 School_Enrollment_Status_Mar2007
ren E5012704 School_Enrollment_Status_Apr2007
ren E5012705 School_Enrollment_Status_May2007
ren E5012706 School_Enrollment_Status_Jun2007
ren E5012707 School_Enrollment_Status_Jul2007
ren E5012708 School_Enrollment_Status_Aug2007
ren E5012709 School_Enrollment_Status_Sep2007
ren E5012710 School_Enrollment_Status_Oct2007
ren E5012711 School_Enrollment_Status_Nov2007
ren E5012712 School_Enrollment_Status_Dec2007
ren E5012801 School_Enrollment_Status_Jan2008
ren E5012802 School_Enrollment_Status_Feb2008
ren E5012803 School_Enrollment_Status_Mar2008
ren E5012804 School_Enrollment_Status_Apr2008
ren E5012805 School_Enrollment_Status_May2008
ren E5012806 School_Enrollment_Status_Jun2008
ren E5012807 School_Enrollment_Status_Jul2008
ren E5012808 School_Enrollment_Status_Aug2008
ren E5012809 School_Enrollment_Status_Sep2008
ren E5012810 School_Enrollment_Status_Oct2008
ren E5012811 School_Enrollment_Status_Nov2008
ren E5012812 School_Enrollment_Status_Dec2008
ren E5012901 School_Enrollment_Status_Jan2009
ren E5012902 School_Enrollment_Status_Feb2009
ren E5012903 School_Enrollment_Status_Mar2009
ren E5012904 School_Enrollment_Status_Apr2009
ren E5012905 School_Enrollment_Status_May2009

ren E5111701 College_enrollment_Jan1997
ren E5111702 College_enrollment_Feb1997
ren E5111703 College_enrollment_Mar1997
ren E5111704 College_enrollment_Apr1997
ren E5111705 College_enrollment_May1997
ren E5111706 College_enrollment_Jun1997
ren E5111707 College_enrollment_Jul1997
ren E5111708 College_enrollment_Aug1997
ren E5111709 College_enrollment_Sep1997
ren E5111710 College_enrollment_Oct1997
ren E5111711 College_enrollment_Nov1997
ren E5111712 College_enrollment_Dec1997
ren E5111801 College_enrollment_Jan1998
ren E5111802 College_enrollment_Feb1998
ren E5111803 College_enrollment_Mar1998
ren E5111804 College_enrollment_Apr1998
ren E5111805 College_enrollment_May1998
ren E5111806 College_enrollment_Jun1998
ren E5111807 College_enrollment_Jul1998
ren E5111808 College_enrollment_Aug1998
ren E5111809 College_enrollment_Sep1998
ren E5111810 College_enrollment_Oct1998
ren E5111811 College_enrollment_Nov1998
ren E5111812 College_enrollment_Dec1998
ren E5111901 College_enrollment_Jan1999
ren E5111902 College_enrollment_Feb1999
ren E5111903 College_enrollment_Mar1999
ren E5111904 College_enrollment_Apr1999
ren E5111905 College_enrollment_May1999
ren E5111906 College_enrollment_Jun1999
ren E5111907 College_enrollment_Jul1999
ren E5111908 College_enrollment_Aug1999
ren E5111909 College_enrollment_Sep1999
ren E5111910 College_enrollment_Oct1999
ren E5111911 College_enrollment_Nov1999
ren E5111912 College_enrollment_Dec1999
ren E5112001 College_enrollment_Jan2000
ren E5112002 College_enrollment_Feb2000
ren E5112003 College_enrollment_Mar2000
ren E5112004 College_enrollment_Apr2000
ren E5112005 College_enrollment_May2000
ren E5112006 College_enrollment_Jun2000
ren E5112007 College_enrollment_Jul2000
ren E5112008 College_enrollment_Aug2000
ren E5112009 College_enrollment_Sep2000
ren E5112010 College_enrollment_Oct2000
ren E5112011 College_enrollment_Nov2000
ren E5112012 College_enrollment_Dec2000
ren E5112101 College_enrollment_Jan2001
ren E5112102 College_enrollment_Feb2001
ren E5112103 College_enrollment_Mar2001
ren E5112104 College_enrollment_Apr2001
ren E5112105 College_enrollment_May2001
ren E5112106 College_enrollment_Jun2001
ren E5112107 College_enrollment_Jul2001
ren E5112108 College_enrollment_Aug2001
ren E5112109 College_enrollment_Sep2001
ren E5112110 College_enrollment_Oct2001
ren E5112111 College_enrollment_Nov2001
ren E5112112 College_enrollment_Dec2001
ren E5112201 College_enrollment_Jan2002
ren E5112202 College_enrollment_Feb2002
ren E5112203 College_enrollment_Mar2002
ren E5112204 College_enrollment_Apr2002
ren E5112205 College_enrollment_May2002
ren E5112206 College_enrollment_Jun2002
ren E5112207 College_enrollment_Jul2002
ren E5112208 College_enrollment_Aug2002
ren E5112209 College_enrollment_Sep2002
ren E5112210 College_enrollment_Oct2002
ren E5112211 College_enrollment_Nov2002
ren E5112212 College_enrollment_Dec2002
ren E5112301 College_enrollment_Jan2003
ren E5112302 College_enrollment_Feb2003
ren E5112303 College_enrollment_Mar2003
ren E5112304 College_enrollment_Apr2003
ren E5112305 College_enrollment_May2003
ren E5112306 College_enrollment_Jun2003
ren E5112307 College_enrollment_Jul2003
ren E5112308 College_enrollment_Aug2003
ren E5112309 College_enrollment_Sep2003
ren E5112310 College_enrollment_Oct2003
ren E5112311 College_enrollment_Nov2003
ren E5112312 College_enrollment_Dec2003
ren E5112401 College_enrollment_Jan2004
ren E5112402 College_enrollment_Feb2004
ren E5112403 College_enrollment_Mar2004
ren E5112404 College_enrollment_Apr2004
ren E5112405 College_enrollment_May2004
ren E5112406 College_enrollment_Jun2004
ren E5112407 College_enrollment_Jul2004
ren E5112408 College_enrollment_Aug2004
ren E5112409 College_enrollment_Sep2004
ren E5112410 College_enrollment_Oct2004
ren E5112411 College_enrollment_Nov2004
ren E5112412 College_enrollment_Dec2004
ren E5112501 College_enrollment_Jan2005
ren E5112502 College_enrollment_Feb2005
ren E5112503 College_enrollment_Mar2005
ren E5112504 College_enrollment_Apr2005
ren E5112505 College_enrollment_May2005
ren E5112506 College_enrollment_Jun2005
ren E5112507 College_enrollment_Jul2005
ren E5112508 College_enrollment_Aug2005
ren E5112509 College_enrollment_Sep2005
ren E5112510 College_enrollment_Oct2005
ren E5112511 College_enrollment_Nov2005
ren E5112512 College_enrollment_Dec2005
ren E5112601 College_enrollment_Jan2006
ren E5112602 College_enrollment_Feb2006
ren E5112603 College_enrollment_Mar2006
ren E5112604 College_enrollment_Apr2006
ren E5112605 College_enrollment_May2006
ren E5112606 College_enrollment_Jun2006
ren E5112607 College_enrollment_Jul2006
ren E5112608 College_enrollment_Aug2006
ren E5112609 College_enrollment_Sep2006
ren E5112610 College_enrollment_Oct2006
ren E5112611 College_enrollment_Nov2006
ren E5112612 College_enrollment_Dec2006
ren E5112701 College_enrollment_Jan2007
ren E5112702 College_enrollment_Feb2007
ren E5112703 College_enrollment_Mar2007
ren E5112704 College_enrollment_Apr2007
ren E5112705 College_enrollment_May2007
ren E5112706 College_enrollment_Jun2007
ren E5112707 College_enrollment_Jul2007
ren E5112708 College_enrollment_Aug2007
ren E5112709 College_enrollment_Sep2007
ren E5112710 College_enrollment_Oct2007
ren E5112711 College_enrollment_Nov2007
ren E5112712 College_enrollment_Dec2007
ren E5112801 College_enrollment_Jan2008
ren E5112802 College_enrollment_Feb2008
ren E5112803 College_enrollment_Mar2008
ren E5112804 College_enrollment_Apr2008
ren E5112805 College_enrollment_May2008
ren E5112806 College_enrollment_Jun2008
ren E5112807 College_enrollment_Jul2008
ren E5112808 College_enrollment_Aug2008
ren E5112809 College_enrollment_Sep2008
ren E5112810 College_enrollment_Oct2008
ren E5112811 College_enrollment_Nov2008
ren E5112812 College_enrollment_Dec2008
ren E5112901 College_enrollment_Jan2009
ren E5112902 College_enrollment_Feb2009
ren E5112903 College_enrollment_Mar2009
ren E5112904 College_enrollment_Apr2009
ren E5112905 College_enrollment_May2009
ren E5112906 College_enrollment_Jun2009
ren E5112907 College_enrollment_Jul2009
ren E5112908 College_enrollment_Aug2009
ren E5112909 College_enrollment_Sep2009
ren E5112910 College_enrollment_Oct2009
ren E5112911 College_enrollment_Nov2009
ren E5112912 College_enrollment_Dec2009
ren E5113001 College_enrollment_Jan2010
ren E5113002 College_enrollment_Feb2010
ren E5113003 College_enrollment_Mar2010
ren E5113004 College_enrollment_Apr2010
ren E5113005 College_enrollment_May2010
ren E5113006 College_enrollment_Jun2010
ren E5113007 College_enrollment_Jul2010
ren E5113008 College_enrollment_Aug2010
ren E5113009 College_enrollment_Sep2010
ren E5113010 College_enrollment_Oct2010
ren E5113011 College_enrollment_Nov2010
ren E5113012 College_enrollment_Dec2010
ren E5113101 College_enrollment_Jan2011
ren E5113102 College_enrollment_Feb2011
ren E5113103 College_enrollment_Mar2011
ren E5113104 College_enrollment_Apr2011
ren E5113105 College_enrollment_May2011
ren E5113106 College_enrollment_Jun2011
ren E5113107 College_enrollment_Jul2011
ren E5113108 College_enrollment_Aug2011
ren E5113109 College_enrollment_Sep2011
ren E5113110 College_enrollment_Oct2011
ren E5113111 College_enrollment_Nov2011
ren E5113112 College_enrollment_Dec2011
ren E5113201 College_enrollment_Jan2012
ren E5113202 College_enrollment_Feb2012
ren E5113203 College_enrollment_Mar2012
ren E5113204 College_enrollment_Apr2012
ren E5113205 College_enrollment_May2012
ren E5113206 College_enrollment_Jun2012
ren E5113207 College_enrollment_Jul2012
ren E5113208 College_enrollment_Aug2012
ren E5113209 College_enrollment_Sep2012
ren E5113210 College_enrollment_Oct2012
ren E5113211 College_enrollment_Nov2012
ren E5113212 College_enrollment_Dec2012
ren E5113301 College_enrollment_Jan2013
ren E5113302 College_enrollment_Feb2013
ren E5113303 College_enrollment_Mar2013
ren E5113304 College_enrollment_Apr2013
ren E5113305 College_enrollment_May2013
ren E5113306 College_enrollment_Jun2013
ren E5113307 College_enrollment_Jul2013
ren E5113308 College_enrollment_Aug2013
ren E5113309 College_enrollment_Sep2013
ren E5113310 College_enrollment_Oct2013
ren E5113311 College_enrollment_Nov2013
ren E5113312 College_enrollment_Dec2013
ren E5113401 College_enrollment_Jan2014
ren E5113402 College_enrollment_Feb2014
ren E5113403 College_enrollment_Mar2014
ren E5113404 College_enrollment_Apr2014
ren E5113405 College_enrollment_May2014
ren E5113406 College_enrollment_Jun2014
ren E5113407 College_enrollment_Jul2014
ren E5113408 College_enrollment_Aug2014
ren E5113409 College_enrollment_Sep2014
ren E5113410 College_enrollment_Oct2014
ren E5113411 College_enrollment_Nov2014
ren E5113412 College_enrollment_Dec2014
ren E5113501 College_enrollment_Jan2015
ren E5113502 College_enrollment_Feb2015
ren E5113503 College_enrollment_Mar2015
ren E5113504 College_enrollment_Apr2015
ren E5113505 College_enrollment_May2015
ren E5113506 College_enrollment_Jun2015
ren E5113507 College_enrollment_Jul2015
ren E5113508 College_enrollment_Aug2015
ren E5113509 College_enrollment_Sep2015
ren E5113510 College_enrollment_Oct2015
ren E5113511 College_enrollment_Nov2015
ren E5113512 College_enrollment_Dec2015
ren E5113601 College_enrollment_Jan2016
ren E5113602 College_enrollment_Feb2016
ren E5113603 College_enrollment_Mar2016
ren E5113604 College_enrollment_Apr2016
ren E5113605 College_enrollment_May2016
ren E5113606 College_enrollment_Jun2016
ren E5113607 College_enrollment_Jul2016
ren E5113608 College_enrollment_Aug2016

***************************************************
* Reshape and recode certain variables.
***************************************************

* exclued from reshape: ID (i) Highest_Grade_Ever_Completed Highest_degree_ever_cum Months_to_HS_diploma Months_to_GED Months_to_AA_degree Months_to_BA_degree Months_to_MA_degree Months_to_Prof_degree Months_to_PhD_degree
forvalues yr=1980/2016 {
    gen temp`yr'=0
}

reshape long temp School_Yr_to_Grade Highest_Grade_Completed Highest_degree_ever Highest_degree School_Enrollment_Status_Jan School_Enrollment_Status_Feb School_Enrollment_Status_Mar School_Enrollment_Status_Apr School_Enrollment_Status_May School_Enrollment_Status_Jun School_Enrollment_Status_Jul School_Enrollment_Status_Aug School_Enrollment_Status_Sep School_Enrollment_Status_Oct School_Enrollment_Status_Nov School_Enrollment_Status_Dec College_enrollment_Jan College_enrollment_Feb College_enrollment_Mar College_enrollment_Apr College_enrollment_May College_enrollment_Jun College_enrollment_Jul College_enrollment_Aug College_enrollment_Sep College_enrollment_Oct College_enrollment_Nov College_enrollment_Dec, i(ID) j(year)
drop temp
drop if mi(ID)

recode _all (-1 = .r) (-2 = .d) (-3 = .i) (-4 = .v) (-5 = .n)

***************************************************
* Label variables and values
***************************************************

label var ID                            "ID"
label var Highest_Grade_Ever_Completed  "HIGHEST GRADE EVER COMPLETED (XRND)"
label var Highest_degree_ever_cum       "HIGHEST DEGREE EVER COMPLETED (XRND)"
label var Months_to_HS_diploma          "MONTH RECEIVED HS DIPLOMA (IN MONTHS SINCE DEC 1979)"
label var Months_to_GED                 "MONTH RECEIVED GED (IN MONTHS SINCE DEC 1979)"
label var Months_to_AA_degree           "MONTH RECEIVED ASSOCIATE'S DEGREE (IN MONTHS SINCE DEC 1979)"
label var Months_to_BA_degree           "MONTH RECEIVED BACHELOR'S DEGREE (IN MONTHS SINCE DEC 1979)"
label var Months_to_MA_degree           "MONTH RECEIVED MASTER'S DEGREE (IN MONTHS SINCE DEC 1979)"
label var Months_to_Prof_degree         "MONTH RECEIVED PROFESSIONAL DEGREE (IN MONTHS SINCE DEC 1979)"
label var Months_to_PhD_degree          "MONTH RECEIVED PHD (IN MONTHS SINCE DEC 1979)"
label var School_Yr_to_Grade            "GRADE ATTENDED THIS YEAR"
label var Highest_Grade_Completed       "HIGHEST GRADE COMPLETED"
label var Highest_degree_ever           "HIGHEST DEGREE EVER COMPLETED"
label var Highest_degree                "HIGHEST DEGREE COMPLETED"
foreach month in Jan Feb Mar Apr May Jun Jul Aug Sep Oct Nov Dec {
    label var School_Enrollment_Status_`month' "K-12 ENROLLMENT STATUS IN `=upper("`month'")'"
    label var College_enrollment_`month'       "COLLEGE ENROLLMENT STATUS IN `=upper("`month'")'"
}

label define vl_SYtG  1 "1st grade"  2 "2nd grade"  3 "3rd grade"  4 "4th grade"  5 "5th grade"  6 "6th grade"  7 "7th grade"  8 "8th grade"  9 "9th grade"  10 "10th grade"  11 "11th grade"  12 "12th grade"  13 "1st year of college"  14 "2nd year of college"  15 "3rd year of college"  16 "4th year of college"  17 "5th year of college"  18 "6th year of college"  19 "7th year of college"  20 "8th year of college"  21 "9th year of college"  91 "Kindergarten - 1st year"  92 "Kindergarten - 2nd year"  93 "Head Start"  95 "Ungraded"
label values School_Yr_to_Grade vl_SYtG

label define vl_HGC  0 "None"  1 "1st grade"  2 "2nd grade"  3 "3rd grade"  4 "4th grade"  5 "5th grade"  6 "6th grade"  7 "7th grade"  8 "8th grade"  9 "9th grade"  10 "10th grade"  11 "11th grade"  12 "12th grade"  13 "1st year college"  14 "2nd year college"  15 "3rd year college"  16 "4th year college"  17 "5th year college"  18 "6th year college"  19 "7th year college"  20 "8th year college or more"  95 "Ungraded"
label values Highest_Grade_Completed vl_HGC
label values Highest_Grade_Ever_Completed vl_HGC

label define vl_HDC 0 "None"  1 "GED"  2 "High school diploma (Regular 12 year program)"  3 "Associate/Junior college (AA)"  4 "Bachelor's degree (BA, BS)"  5 "Master's degree (MA, MS)"  6 "PhD"  7 "Professional degree (DDS, JD, MD)"
label values Highest_degree_ever_cum vl_HDC
label values Highest_degree_ever     vl_HDC
label values Highest_degree          vl_HDC

label define vl_K12    1 "Not enrolled"  2 "Attending grade K-12"  4 "On vacation"  5 "Expelled from school"  6 "Other"
label define vl_ColEnr 1 "Not enrolled in college"  2 "Enrolled in 2-year college"  3 "Enrolled in 4-year college"  4 "Enrolled in graduate school"
foreach month in Jan Feb Mar Apr May Jun Jul Aug Sep Oct Nov Dec {
    label values School_Enrollment_Status_`month' vl_K12
    label values College_enrollment_`month'       vl_ColEnr
}
