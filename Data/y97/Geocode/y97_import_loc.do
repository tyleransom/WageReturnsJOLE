* Import, rename, reshape, recode and label the location variables

infile using "../../NLSY97_Geocode_1997-2015/Geocode/Location/Location_R17.dct", clear

****************
* Rename
****************
ren R0000100 ID
ren R1242900 fips_co1997
ren R1243000 fips_st1997
ren R1243100 fips_msa1997
ren R1243200 fips_pmsa1997
ren R1243300 fips_msa_type1997
ren R1243400 fips_quality1997
ren R1308200 PSU
ren R2602200 fips_co1998
ren R2602300 fips_st1998
ren R2602400 fips_msa1998
ren R2602500 fips_pmsa1998
ren R2602600 fips_msa_type1998
ren R2707600 fips_quality1998
ren R3925400 fips_quality1999
ren R3927400 fips_co1999
ren R3927500 fips_st1999
ren R3927600 fips_msa1999
ren R3927700 fips_pmsa1999
ren R3927800 fips_msa_type1999
ren R5521300 fips_co2000
ren R5521400 fips_st2000
ren R5521500 fips_msa2000
ren R5521600 fips_pmsa2000
ren R5521700 fips_msa_type2000
ren R5521800 fips_quality2000
ren R7283100 fips_co2001
ren R7283200 fips_st2001
ren R7283300 fips_msa2001
ren R7283400 fips_pmsa2001
ren R7283500 fips_msa_type2001
ren R7283600 fips_quality2001
ren S1609400 fips_co2002
ren S1609500 fips_st2002
ren S1609600 fips_msa2002
ren S1609700 fips_quality2002
ren S2072500 fips_co2003
ren S2072600 fips_st2003
ren S2072700 fips_msa2003
ren S2072800 fips_quality2003
ren S5251600 fips_co2004
ren S5251700 fips_st2004
ren S5251800 fips_cbsa2004
ren S5251900 fips_quality2004
ren S5451900 fips_co2005
ren S5452000 fips_st2005
ren S5452100 fips_cbsa2005
ren S5452200 fips_quality2005
ren S7553400 fips_co2006
ren S7553500 fips_st2006
ren S7553600 fips_cbsa2006
ren S7553700 fips_quality2006
ren T0000300 fips_co2007
ren T0000400 fips_st2007
ren T0000500 fips_cbsa2007
ren T0000600 fips_quality2007
ren T2000200 fips_co2008
ren T2000300 fips_st2008
ren T2000400 fips_cbsa2008
ren T2000500 fips_quality2008
ren T3621700 fips_co2009
ren T3621800 fips_st2009
ren T3621900 fips_cbsa2009
ren T3622000 fips_quality2009
ren T5221700 fips_co2010
ren T5221800 fips_st2010
ren T5221900 fips_cbsa2010
ren T5222000 fips_quality2010
ren T6673800 fips_co2011
ren T6673900 fips_st2011
ren T6674000 fips_cbsa2011
ren T6674100 fips_quality2011
ren T8144300 fips_co2013
ren T8144400 fips_st2013
ren T8144500 fips_cbsa2013
ren T8144600 fips_quality2013
ren U0025800 fips_co2015
ren U0025900 fips_st2015
ren U0026000 fips_cbsa2015
ren U0026100 fips_quality2015
ren R1249900 unemp1997
ren R2609000 unemp1998
ren R3925500 unemp1999
ren R5514400 unemp2000
ren R7277900 unemp2001
ren S1598500 unemp2002
ren S2072900 unemp2003
ren S3870000 unemp2004
ren S5453100 unemp2005
ren S7554800 unemp2006
ren T0001600 unemp2007
ren T2002200 unemp2008
ren T3622700 unemp2009
ren T5223100 unemp2010
ren T6675000 unemp2011
ren T8145500 unemp2013
ren U0027000 unemp2015

capture drop ????????

***********
* Reshape 
***********
forvalues yr = 1997/2016 {
    qui gen temp`yr'=0
}
reshape long temp fips_co fips_st fips_msa fips_pmsa fips_msa_type fips_quality fips_cbsa unemp, i(ID) j(year)
recode _all (-1 = .r) (-2 = .d) (-3 = .i) (-4 = .v) (-5 = .a)

drop temp

***************************************************
* Label variables and values
***************************************************
label var ID            "ID"
label var year          "YEAR"
label var fips_co       "COUNTY OF RESIDENCE (EDT)"
label var fips_st       "STATE OF RESIDENCE (EDT)"
label var fips_cbsa     "CBSA OF RES"
label var fips_msa      "MSA/CMSA/NECMA OF RES"
label var fips_pmsa     "PMSA OF RES PART E"
label var fips_msa_type "MSA/CMSA/NECMA REC TYPE"
label var fips_quality  "QUALITY OF MATCH"
label var PSU           "PRIMARY SAMPLING UNIT 1997"
label var unemp         "UNEMPLOYMENT RATE FOR LABOR MARKET OF CURRENT RESIDENCE"

label define vlfips_msa_type   0 "United States"  1 "State"  2 "CMSA/PMSA County"  3 "MSA County"  4 "NECMA County"  5 "Not MA County"
label values fips_msa_type vlfips_msa_type
label define vlfips_quality   1 "Actual Match Based on Address"  2 "Manual Edit; Match Based on Short Street"  3 "Manual Edit; Match Based on Long Street"  4 "Match Based on Zip Centroid"
label values fips_quality vlfips_quality

*********************************************************************
* Convert unemployment to pct points (instead of 10s of basis points)
*********************************************************************
replace unemp = unemp/10
