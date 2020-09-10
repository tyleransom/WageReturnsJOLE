*****************************************************************************
* Cleans instnm and city for match
* UPDATE 9/15/2016: subinword works much better/easier than regexr when wanting 
*                   to replace entire words, regardess of location within in
*                   text, and will replace all instances
* UPDATE 1/19/2017: city technically not needed, but will keep
*****************************************************************************
* charlist instnm
* di "`r(ascii)'"

foreach X in instnm city {
	* Get rid of all punctuation 
	foreach Y in # - , & / ( ) : ; . {
		replace `X' = subinstr( `X',"`Y'"," ",.)
	}
	
	foreach Y in ' ` `=char(146)' `=char(150)'   {
		replace `X' = subinstr( `X',"`Y'","",.)
	}
	
	* Ñ,ì,ò
	replace `X' = subinstr( `X', "`=char(209)'","N",.)
	replace `X' = subinstr( `X', "`=char(237)'","I",.)
	replace `X' = subinstr( `X', "`=char(243)'","O",.)
	
	* Get rid of  extra/trailing/leading spaces
	qui replace `X' =  trim(itrim(`X'))
	
	* replace "U" and "UN" and "UNIV" and "UNIVER" with "UNIVERSITY"
	qui replace `X' = subinword( `X', "U"     , "UNIVERSITY",.)
	qui replace `X' = subinword( `X', "UN"    , "UNIVERSITY",.)
	qui replace `X' = subinword( `X', "UNI"   , "UNIVERSITY",.)
	qui replace `X' = subinword( `X', "UNIV"  , "UNIVERSITY",.)
	qui replace `X' = subinword( `X', "UNIVE" , "UNIVERSITY",.)
	qui replace `X' = subinword( `X', "UNIVER", "UNIVERSITY",.)
	qui replace `X' = subinword( `X', "UNIVERISTY", "UNIVERSITY",.)
	qui replace `X' = subinword( `X', "UNIVERTISY", "UNIVERSITY",.)
	qui replace `X' = subinword( `X', "UNIVERSITYS", "UNIVERSITY",.)
	qui replace `X' = subinword( `X', "UNIVERSITIES", "UNIVERSITY",.)
	qui replace `X' = subinword( `X', "UNIVERSITIE", "UNIVERSITY",.)
	
	qui replace `X' = subinstr( `X', "UNIVERSITY", "UNIVERSITY ",.)
	qui replace `X' =  trim(itrim(`X'))
	
	* If ends with "UNIVERSITY OF", put it at beginning
	qui replace instnm = "UNIVERSITY OF "+instnm if regexm( instnm, " UNIVERSITY OF$")
	qui replace instnm = regexr( instnm, " UNIVERSITY OF$", "")

	* Now return all instances of "UNIVERSITY" back to "U"
	*  This makes the fuzzy match to work on important words
	qui replace `X' = subinword( `X', "UNIVERSITY", "U",.)
	
	* replace "STATE" with "ST"
	qui replace `X' = subinword( `X', "STATE", "ST",.)

	* replace "CMTY" with "COMMUNITY"
	qui replace `X' = subinword( `X', "CMTY", "COMMUNITY",.)

	* replace "CC" and "C C" with "COMMUNITY COLLEGE"
	qui replace `X' = subinword( `X', "CC", "COMMUNITY COLLEGE",.)
	
	qui replace `X' = subinword( `X', "C C", "COMMUNITY COLLEGE",.)

	* If ends with "COMMUNITY COLLEGE OF", put it at beginning
	qui replace instnm = "COMMUNITY COLLEGE OF "+instnm if regexm( instnm, " COMMUNITY COLLEGE OF$")
	qui replace instnm = regexr( instnm, " COMMUNITY COLLEGE OF$", "")
			
	* replace "C" and "COL" and "COLL" and "COLLEGES" with "COLLEGE" ( note "C C" above is done)
	qui replace `X' = subinword( `X', "C"       , "COLLEGE",.)
	qui replace `X' = subinword( `X', "COL"     , "COLLEGE",.)
	qui replace `X' = subinword( `X', "COLL"    , "COLLEGE",.)
	qui replace `X' = subinword( `X', "COLLEGES", "COLLEGE",.)
	
	* If ends with "COLLEGE OF", put it at beginning
	qui replace instnm = "COLLEGE OF "+instnm if regexm( instnm, " COLLEGE OF$")
	qui replace instnm = regexr( instnm, " COLLEGE OF$", "")

	* Drop the words "THE " "OF " "AND " "AT " "FOR "
	qui replace `X' = subinword( `X',"THE","",.)
	qui replace `X' = subinword( `X',"OF" ,"",.)
	qui replace `X' = subinword( `X',"AND","",.)
	qui replace `X' = subinword( `X',"AT" ,"",.)
	qui replace `X' = subinword( `X',"FOR","",.)
	
	* Drop the words "INC" "CAMPUSES" "CAMPUS" "CAM" "CAMP$" CAMPU"
	qui replace `X' = subinword( `X', "INC"     ,"",.)
	qui replace `X' = subinword( `X', "CAMPUSES","",.)
	qui replace `X' = subinword( `X', "CAMPUS"  ,"",.)
	qui replace `X' = subinword( `X', "CAMPU"   ,"",.)
	qui replace `X' = subinword( `X', "CAMP"    ,"",.)
	qui replace `X' = subinword( `X', "CAM"     ,"",.)
	qui replace `X' = subinword( `X', "CMP"     ,"",.)
	
	* Get rid of  extra/trailing/leading spaces
	qui replace `X' =  trim(itrim(`X'))
	
	* replace and "SCH" with "SCHOOL"
	qui replace `X' = subinword( `X', "SCH", "SCHOOL",.)

	* replace and "INST" with "INSTITUTE"
	qui replace `X' = subinword( `X', "INST", "INSTITUTE",.)

	* replace and "TECHNOLOGY and "TECHNICAL" with "TECH"
	qui replace `X' = subinword( `X', "TECHNOLOGY", "TECH",.)
	qui replace `X' = subinword( `X', "TECHNICAL" , "TECH",.)

	* replace "INT TECH" with "INSTITUTE TECH"
	qui replace `X' = subinword( `X', "INT TECH" , "INSTITUTE TECH",.)

	* replace "POLYTECHNIC" with "POLY"
	qui replace `X' = subinword( `X', "POLYTECHNIC"  , "POLY",.)
	qui replace `X' = subinword( `X', "POLYTECH"     , "POLY",.)
	qui replace `X' = subinword( `X', "POLYTECHNICAL", "POLY",.)
	qui replace `X' = subinword( `X', "POLYTECHNICE" , "POLY",.)

	* replace "AGRL" with "AGRICULTURAL"
	qui replace `X' = subinword( `X', "AGRL"  , "AGRICULTURAL",.)

	* replace "AGRICULTURAL MECH" and "AGRICULTURAL MECHANICAL" with "A M"
	qui replace `X' = subinword( `X', "AGRICULTURAL MECH"      , "A M",.)
	qui replace `X' = subinword( `X', "AGRICULTURAL MECHANICAL", "A M",.)
	
	* replace "JR" with "JUNIOR"
	qui replace `X' = subinword( `X', "JR"  , "JUNIOR",.)
	
	* replace "GRAD" with "GRADUATE"
	qui replace `X' = subinword( `X', "GRAD"  , "GRADUATE",.)

	* replace "INTL" with "INTERNATIONAL"
	qui replace `X' = subinword( `X', "INTL"  , "INTERNATIONAL",.)
	
	* replace "CTY" and "CNTY" with "COUNTY"
	qui replace `X' = subinword( `X', "CTY" , "COUNTY",.)
	qui replace `X' = subinword( `X', "CNTY", "COUNTY",.)
	
	* replace "NORTH" with "N"
	* qui replace `X' = subinword( `X', "NORTH"  , "N",.)

	* replace "EAST" with "E"
	* qui replace `X' = subinword( `X', "EAST"  , "E",.)
	
	* replace "SOUTH" with "S"
	* qui replace `X' = subinword( `X', "SOUTH"  , "S",.)

	* replace "WEST" with "W"
	* qui replace `X' = subinword( `X', "WEST"  , "W",.)

	* replace "STHN" with "SOUTHERN"
	qui replace `X' = subinword( `X', "STHN"  , "SOUTHERN",.)
	
	* replace "STHESTN" with "SOUTHEASTERN"
	qui replace `X' = subinword( `X', "STHESTN"  , "SOUTHEASTERN",.)

	* replace "STHWSTRN" with "SOUTHWESTERN"
	qui replace `X' = subinword( `X', "STHWSTRN"  , "SOUTHWESTERN",.)

	* replace "ESTN" with "EASTERN"
	qui replace `X' = subinword( `X', "ESTN"  , "EASTERN",.)
	
	* replace "WSTN" with "WESTERN"
	qui replace `X' = subinword( `X', "WSTN"  , "WESTERN",.)

	* replace "SAINT" and "SNT" with "ST"
	qui replace `X' = subinword( `X', "SAINT", "ST",.)
	qui replace `X' = subinword( `X', "SNT"  , "ST",.)

	* replace "SEM" with "SEMINARY"
	qui replace `X' = subinword( `X', "SEM"  , "SEMINARY",.)

	* replace "THEO" and "THEOL" and "THEOLOGICAL" with "THEOLOGY"
	qui replace `X' = subinword( `X', "THEO"        , "THEOLOGY",.)
	qui replace `X' = subinword( `X', "THEOL"       , "THEOLOGY",.)
	qui replace `X' = subinword( `X', "THEOLOGICAL" , "THEOLOGY",.)
	
	* replace "INTELL" with "INTELLIGENCE"
	qui replace `X' = subinword( `X', "INTELL"  , "INTELLIGENCE",.)
	
	* replace "MGMT" with "MANAGEMENT"
	qui replace `X' = subinword( `X', "MGMT"  , "MANAGEMENT",.)
	
	* replace "MOUNT" with "MT"
	qui replace `X' = subinword( `X', "MOUNT"  , "MT",.)

	* replace "FORT" with "FT"
	qui replace `X' = subinword( `X', "FORT"  , "FT",.)

	* replace "CTR" with "CENTER"
	qui replace `X' = subinword( `X', "CTR"  , "CENTER",.)
	
	* replace "MEDICINE" AND "MEDICAL" with "MED"
	qui replace `X' = subinword( `X',"MEDICINE","MED",.)
	qui replace `X' = subinword( `X',"MEDICAL" ,"MED",.)

	* replace "SCI", "SCIEN" and "SCIENCES" with "SCIENCE"
	qui replace `X' = subinword( `X', "SCI"     , "SCIENCE",.)
	qui replace `X' = subinword( `X', "SCIEN"   , "SCIENCE",.)
	qui replace `X' = subinword( `X', "SCIENCES", "SCIENCE",.)

	* replace "HLTH" with "HEALTH"
	qui replace `X' = subinword( `X', "HLTH"  , "HEALTH",.)

	* replace "ENVRNMTL" with "ENVIRONMENTAL"
	qui replace `X' = subinword( `X', "ENVRNMTL"  , "ENVIRONMENTAL",.)

		* replace "PROF" with "PROFESSIONAL"
	qui replace `X' = subinword( `X', "PROF"  , "PROFESSIONAL",.)

	* replace "AVN" with "AVIATION"
	qui replace `X' = subinword( `X', "AVN"  , "AVIATION",.)
	
	* States
	qui replace `X' = subinword( `X', "AL"   , "ALABAMA",.)       if stabbr=="AL"
	qui replace `X' = subinword( `X', "ALA"  , "ALABAMA",.)       if stabbr=="AL"
	qui replace `X' = subinword( `X', "AK"   , "ALASKA",.)        if stabbr=="AK"
	qui replace `X' = subinword( `X', "ALAS" , "ALASKA",.)        if stabbr=="AK"
	qui replace `X' = subinword( `X', "CA"   , "CALIFORNIA",.)    if stabbr=="CA"
	qui replace `X' = subinword( `X', "CAL"  , "CALIFORNIA",.)    if stabbr=="CA"
	qui replace `X' = subinword( `X', "FL"   , "FLORIDA",.)       if stabbr=="FL"
	qui replace `X' = subinword( `X', "FLA"  , "FLORIDA",.)       if stabbr=="FL"
	qui replace `X' = subinword( `X', "IND"  , "INDIANA",.)       if stabbr=="IN"
	qui replace `X' = subinword( `X', "IL"   , "ILLINOIS",.)      if stabbr=="IL"
	qui replace `X' = subinword( `X', "ILL"  , "ILLINOIS",.)      if stabbr=="IL"
	qui replace `X' = subinword( `X', "LA"   , "LOUISIANA",.)     if stabbr=="LA"
	qui replace `X' = subinword( `X', "MD"   , "MARYLAND",.)      if stabbr=="MD"
	qui replace `X' = subinword( `X', "NJ"   , "NEW JERSEY",.)    if stabbr=="NJ"
	qui replace `X' = subinword( `X', "NM"   , "NEW MEXICO",.)    if stabbr=="NM"
	qui replace `X' = subinword( `X', "NC"   , "N CAROLINA",.)    if stabbr=="NC"
	qui replace `X' = subinword( `X', "ND"   , "N DAKOTA",.)      if stabbr=="ND"
	qui replace `X' = subinword( `X', "OK"   , "OKLAHOMA",.)      if stabbr=="OK"
	qui replace `X' = subinword( `X', "OKLA" , "OKLAHOMA",.)      if stabbr=="OK"
	qui replace `X' = subinword( `X', "PA"   , "PENNSYLVANIA",.)  if stabbr=="PA"
	qui replace `X' = subinword( `X', "PENN" , "PENNSYLVANIA",.)  if stabbr=="PA"
	qui replace `X' = subinword( `X', "SC"   , "S CAROLINA",.)    if stabbr=="SC"
	qui replace `X' = subinword( `X', "SD"   , "S DAKOTA",.)      if stabbr=="SD"
	qui replace `X' = subinword( `X', "TN"   , "TENNESSEE",.)     if stabbr=="TN"
	qui replace `X' = subinword( `X', "TENN" , "TENNESSEE",.)     if stabbr=="TN"
	qui replace `X' = subinword( `X', "VA"   , "VIRGINIA",.)      if stabbr=="VA"
	qui replace `X' = subinword( `X', "VA"   , "VIRGINIA",.)      if stabbr=="WV"
	
	* Get rid of  extra/trailing/leading spaces, again
	qui replace `X' =  trim(itrim(`X'))
	
	*** More locational specific changes
	* replace "SN" with "SAN" at beginning
	qui replace `X' = subinword( `X', "SN","SAN",1)
	
	* replace "CY" and "CIT" with "city" at end
	qui replace `X' = regexr( `X', "( CY$)"  , " CITY")		
	qui replace `X' = regexr( `X', "( CIT$)"  , " CITY")		
	
	* replace "MTN" with "MOUNTAIN" at end
	qui replace `X' = regexr( `X', "( MTN$)"  , " MOUNTAIN")		
	
	* replace "PK" with "PARK" at end
	qui replace `X' = regexr( `X', "( PK$)"  , " PARK")
	
	* replace "STA" with "STATION" at end
	qui replace `X' = regexr( `X', "( STA$)"  , " STATION")
	
	* replace "VL" with "VILLE" at end, with or without space
	qui replace `X' = regexr( `X', "VL$"  , "VILLE")
	
	* replace "WDS" with "WOODS" at end
	qui replace `X' = regexr( `X', "( WDS$)"  , " WOODS")
	
	qui replace `X' = subinword( `X', "PITTSBG"  , "PITTSBURGH",.) if stabbr=="PA"
	qui replace `X' = subinword( `X', "PITTSBURG", "PITTSBURGH",.) if stabbr=="PA"
	
	* Get rid of  extra/trailing/leading spaces, again
	qui replace `X' =  trim(itrim(`X'))
	
	* 3 different types of modified campuses: MAIN, ALL, CENTRAL/ADMIN. Standardize
	* replace "OFC" and "OFCS" with "OFFICE"
	qui replace `X' = subinword( `X', "OFC"  ,  "OFFICE",.)
	qui replace `X' = subinword( `X', "OFCS"  ,  "OFFICE",.)
	
	* replace "SYS" and "SYSW" with "SYSTEM"
	qui replace `X' = subinword( `X', "SYS"  ,  "SYSTEM",.)
	qui replace `X' = subinword( `X', "SYSW"  ,  "SYSTEM",.)
	
	* replace "ADM" with "ADMIN"
	qui replace `X' = subinword( `X', "ADM","ADMIN",.)
	
	* Standarize Main Campuses
	qui replace `X' = regexr(`X', " MAIN CAMPUS", " MAIN")
	qui replace `X' = regexr(`X', " MAIN CAM"   , " MAIN")
	qui replace `X' = regexr(`X', " MAIN CAP"   , " MAIN")
	qui replace `X' = regexr(`X', " MAIN$"      , " MAIN")	
	
	* Get rid of Main Campuses? I think so...
	qui replace `X' = regexr( `X', " MAIN$"  , "")

	* Standardize Central, Central Office, CEN OFFICE. 
	*  Potentially get rid of CENTRAL in NCERDC data. If someone goes to U VIRGINIA CENTRAL, they probably went to U VIRGINIA or U VIRGINIA MAIN, and we'll have 
	*   more info about them if so
	qui replace `X' = subinword(`X', "CENTRAL OFFICE"      , "CENTRAL",.)
	qui replace `X' = subinword(`X', "CENTRAL OFF"         , "CENTRAL",.)
	qui replace `X' = subinword(`X', "CEN OFFICE"          , "CENTRAL",.)
	qui replace `X' = subinword(`X', "CEN OFF"             , "CENTRAL",.)
	qui replace `X' = subinword(`X', "ADMIN CENTRAL OFFICE", "CENTRAL",.)
	qui replace `X' = subinword(`X', "ADMIN CENTRAL"       , "CENTRAL",.)
	qui replace `X' = subinword(`X', "ADMIN CEN"           , "CENTRAL",.)
	* qui replace `X' = regexr( `X', " CENTRAL$"  , "") if NCERDC (in NCERDC file)
	
	* Related to SYSTEM and ALL should end in ALL
	qui replace `X' = subinword(`X',"SYSTEM ADMIN ALL$","ALL",.)
	qui replace `X' = subinword(`X',"SYSTEM ADMIN$","ALL",.)
	qui replace `X' = subinword(`X',"GEN ADMIN ALL$","ALL",.)
	qui replace `X' = subinword(`X',"GEN ADMIN$","ALL",.)
	qui replace `X' = subinword(`X',"ADMIN OFFFICE$","ALL",.)
	qui replace `X' = subinword(`X',"ALL INSTITUTE$","ALL",.)
	qui replace `X' = regexr(`X', "SYSTEM$", "ALL")
	
	* Get rid of  extra/trailing/leading spaces, again
	qui replace `X' =  trim(itrim(`X'))
	
	*** Individual institution fixes, roughly ordered by magnitude

	* ST U NEW YORK - (Arose because of NEW PALTZ, should resolve itself now)
	qui replace `X' = regexr( `X',"ST U NEW YORK","SUNY")
   	qui replace `X' = regexr(`X', "SUNY SUNY", "SUNY")

	qui replace instnm = "SUNY "+instnm if regexm( instnm, " SUNY")
	qui replace instnm = regexr( instnm, " SUNY", "")
	
	* CITY U NEW YORK
	qui replace `X' = regexr( `X',"CITY U NEW YORK","CUNY")
   	qui replace `X' = regexr(`X', "CUNY CUNY", "CUNY")

	qui replace instnm = "CUNY "+instnm if regexm( instnm, " CUNY")
	qui replace instnm = regexr( instnm, " CUNY", "")

	
	* MIAMI U, all OXFORD should say OXFORD
	qui replace `X' = regexr( `X', "^MIAMI U$","MIAMI U OXFORD") if city=="OXFORD"
	
	* RUTGERS - TOTAL MESS
	qui replace `X' = regexr( `X', "RUTGERS ST U NEW JERSEY", "RUTGERS U")
	qui replace `X' = regexr( `X', "RUTGERS ST U"           , "RUTGERS U")
	
	qui replace `X' = regexr( `X', "$RUTGERS U^"            , "RUTGERS U NEW BRUNSWICK") if city=="NEW BRUNSWICK"
	qui replace `X' = regexr( `X', "$RUTGERS U ALL^"        , "RUTGERS U NEW BRUNSWICK") // this is asserting that those at "ALL" should just be put at "MAIN"
	
	* LONG ISLAND
	qui replace `X' = regexr( `X', "^LONG ISLAND U W POST$","LONG ISLAND U COLLEGE W POST")
	
	* U MASSACHUSETTS
	qui replace `X' = "U MASSACHUSETTS" if `X'=="U MASSACHUSETTS AMHERST" & city=="AMHERST"

	* ST JOHNS
	qui replace `X' = regexr( `X', "ST JOHNS U NEW YORK", "ST JOHNS U")

	* SE COLLEGE ASSEMBLIES OF GOD
	qui replace `X' = regexr( `X', "^SE COLLEGE", "SOUTHEASTERN COLLEGE")

	* TULANE U
	qui replace `X' = "TULANE U" if `X'=="TULANE U LOUISIANA"
	
	* SOUTHERN ILLINOIS U
	qui replace `X' = "SOUTHERN ILLINOIS U CARBONDALE" if `X'=="SOUTHERN ILLINOIS U" & city=="CARBONDALE" 

	* WILLIAM MARY ALL COLLEGE
	qui replace `X' = "COLLEGE WILLIAM MARY" if `X'=="WILLIAM MARY ALL COLLEGE"
	qui replace `X' = "COLLEGE WILLIAM MARY" if `X'=="COLLEGE WM MARY"
	
	* INDIANA PURDUE U
	qui replace `X' = subinword(`X',"INDIANA PURDUE U","INDIANA U PURDUE U",.)

	* PENNSYLVANIA ST U PENN ST
	qui replace `X' = subinword(`X',"PENNSYLVANIA ST U PENN ST","PENNSYLVANIA ST U",.)
	qui replace `X' = subinword(`X',"PENNSYLVANIA ST U PENNSYLVANIA ST","PENNSYLVANIA ST U",.)
	qui replace `X' = subinword(`X',"ABINGTON COLLEGE$","ABINGTON",.)
	qui replace `X' = subinword(`X',"ALTOONA COLLEGE$","ALTOONA",.)
	
	* CLINCH VALLEY COLLEGE UVA
	qui replace `X' = subinword(`X',"CLINCH VALLEY COLLEGE UVA","U VIRGINIA CLINCH VALLEY COLLEGE",.)
	
	* OHIO/AUBURN U ALL - potentially need to come up with a better way to handle these.
	qui replace `X' = subinword(`X',"OHIO U ALL","OHIO U",.)
	qui replace `X' = subinword(`X',"AUBURN U ALL","AUBURN U",.)
	
	* COLUMBIA
	qui replace `X' = regexr( `X', "^COLUMBIA U$", "COLUMBIA U IN CITY NEW YORK")
	
	* BOWLING GRN to BOWLING GREEN
	qui replace `X' = subinword( `X', "GRN"  , "GREEN",.)
	
	* INTER CONTINENTAL shouldn't have a space
	qui replace `X' = regexr( `X', "INTER CONTINENTAL" , "INTERCONTINENTAL")
	
	* U PITTSBURGH, the main campus sometimes has PITTSBURGH twice
	qui replace `X' = regexr( `X', "PITTSBURGH PITTSBURGH", "PITTSBURGH")
	
	* NORTHWESTERN ST U - really?
	qui replace `X' = regexr( `X', "^NORTHWESTERN ST U$", "NORTHWESTERN ST U LOUISIANA") if city=="NATCHITOCHES"
	qui replace `X' = regexr( `X', "^NORTHWESTERN ST U$", "NORTHWESTERN OKLAHOMA ST U")  if city=="ALVA"

	* U S CAROLINA
	qui replace `X' = "U S CAROLINA COLUMBIA" if `X'=="U S CAROLINA" & city==""
	
	* Get rid of  extra/trailing/leading spaces, again
	qui replace `X' =  trim(itrim(`X'))
}
