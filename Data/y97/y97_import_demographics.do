* Import, rename, reshape, recode and label the demographic variables

!unzip RawData/y97_demographics.dct.zip
infile using y97_demographics.dct, clear
!rm y97_demographics.dct

****************
* Rename
****************

ren R0000100 ID
ren R1235800 Sample_type
ren R1482600 race_ethnicity
ren R0536300 sex
ren R0536401 birth_month
ren R0536402 birth_year

ren R1236101 weight_cc1997
ren R2600301 weight_cc1998
ren R3923701 weight_cc1999
ren R5510600 weight_cc2000
ren R7274200 weight_cc2001
ren S1598100 weight_cc2002
ren S2067000 weight_cc2003
ren S3861600 weight_cc2004
ren S5444200 weight_cc2005
ren S7545500 weight_cc2006
ren T0042100 weight_cc2007
ren T2022500 weight_cc2008
ren T3613300 weight_cc2009
ren T5213200 weight_cc2010
ren T6665000 weight_cc2011
ren T8135900 weight_cc2013
ren U0017100 weight_cc2015
ren R1236201 weight_panel1997
ren R2600401 weight_panel1998
ren R3958501 weight_panel1999
ren R5510700 weight_panel2000
ren R7274300 weight_panel2001
ren S1598200 weight_panel2002
ren S2067100 weight_panel2003
ren S3861700 weight_panel2004
ren S5444300 weight_panel2005
ren S7545600 weight_panel2006
ren T0042200 weight_panel2007
ren T2022600 weight_panel2008
ren T3613400 weight_panel2009
ren T5213300 weight_panel2010
ren T6665100 weight_panel2011
ren T8136000 weight_panel2013
ren U0017200 weight_panel2015

ren R1209300 Int_month1997
ren R2568200 Int_month1998
ren R3890100 Int_month1999
ren R5472200 Int_month2000
ren R7236000 Int_month2001
ren S1550800 Int_month2002
ren S2020700 Int_month2003
ren S3821900 Int_month2004
ren S5421900 Int_month2005
ren S7524000 Int_month2006
ren T0024400 Int_month2007
ren T2019300 Int_month2008
ren T3609900 Int_month2009
ren T5210300 Int_month2010
ren T6661300 Int_month2011
ren T8132800 Int_month2013
ren U0013100 Int_month2015
ren R1209400 InterviewD1997
ren R1209401 InterviewM1997
ren R1209402 InterviewY1997
ren R2568300 InterviewD1998
ren R2568301 InterviewM1998
ren R2568302 InterviewY1998
ren R3890300 InterviewD1999
ren R3890301 InterviewM1999
ren R3890302 InterviewY1999
ren R5472300 InterviewD2000
ren R5472301 InterviewM2000
ren R5472302 InterviewY2000
ren R7236100 InterviewD2001
ren R7236101 InterviewM2001
ren R7236102 InterviewY2001
ren S1550900 InterviewD2002
ren S1550901 InterviewM2002
ren S1550902 InterviewY2002
ren S2020800 InterviewD2003
ren S2020801 InterviewM2003
ren S2020802 InterviewY2003
ren S3822000 InterviewD2004
ren S3822001 InterviewM2004
ren S3822002 InterviewY2004
ren S5422000 InterviewD2005
ren S5422001 InterviewM2005
ren S5422002 InterviewY2005
ren S7524100 InterviewD2006
ren S7524101 InterviewM2006
ren S7524102 InterviewY2006
ren T0024500 InterviewD2007
ren T0024501 InterviewM2007
ren T0024502 InterviewY2007
ren T2019400 InterviewD2008
ren T2019401 InterviewM2008
ren T2019402 InterviewY2008
ren T3610000 InterviewD2009
ren T3610001 InterviewM2009
ren T3610002 InterviewY2009
ren T5210400 InterviewD2010
ren T5210401 InterviewM2010
ren T5210402 InterviewY2010
ren T6661400 InterviewD2011
ren T6661401 InterviewM2011
ren T6661402 InterviewY2011
ren T8132900 InterviewD2013
ren T8132901 InterviewM2013
ren T8132902 InterviewY2013
ren U0013200 InterviewD2015
ren U0013201 InterviewM2015
ren U0013202 InterviewY2015

ren R1205000 Relationship_to_Par_age12_
ren R1205100 Relationship_to_Par_age2_
ren R1205200 Relationship_to_Par_age6_
ren R1205300 Relationship_HH_head1997
ren R2563600 Relationship_HH_head1998
ren R3885200 Relationship_HH_head1999
ren R5464400 Relationship_HH_head2000
ren R7228100 Relationship_HH_head2001
ren S1542000 Relationship_HH_head2002
ren S2011800 Relationship_HH_head2003

ren R1205400 HH_size

ren R5821400 Born_in_US2001
ren S0191300 Born_in_US2002
ren S2175900 Born_in_US2003
ren S3952000 Born_in_US2004
ren S7642200 Born_in_US2006
ren T0135800 Born_in_US2007
ren T2110700 Born_in_US2008
ren T3721700 Born_in_US2009
ren T5313500 Born_in_US2010
ren T6758500 Born_in_US2011
ren T8232600 Born_in_US2013
ren U0128300 Born_in_US2015

ren R9829600 ASVAB
ren R1210800 PIAT_math1997
ren R2569700 PIAT_math1998
ren R3891700 PIAT_math1999
ren R5473700 PIAT_math2000
ren R7237400 PIAT_math2001
ren S1552700 PIAT_math2002

ren R1204500 Family_income1996
ren R2563300 Family_income1997
ren R3884900 Family_income1998
ren R5464100 Family_income1999
ren R7227800 Family_income2000
ren S1541700 Family_income2001
ren S2011500 Family_income2002
ren S3812400 Family_income2003
ren S5412800 Family_income2004
ren S7513700 Family_income2005
ren T0014100 Family_income2006
ren T2016200 Family_income2007
ren T3606500 Family_income2008
ren T5206900 Family_income2009
ren T6656700 Family_income2010
ren T8129100 Family_income2012
ren U0008900 Family_income2014

ren R1302400 Bio_father_highest_educ
ren R1302500 Bio_mother_highest_educ

ren R2510200 reason_noninterview1998
ren R3827700 reason_noninterview1999
ren R5341500 reason_noninterview2000
ren R7085400 reason_noninterview2001
ren S1524700 reason_noninterview2002
ren S3590300 reason_noninterview2003
ren S4966600 reason_noninterview2004
ren S6706700 reason_noninterview2005
ren S8679600 reason_noninterview2006
ren T1099500 reason_noninterview2007
ren T3176800 reason_noninterview2008
ren T4587900 reason_noninterview2009
ren T6221000 reason_noninterview2010
ren T7718200 reason_noninterview2011
ren T9118900 reason_noninterview2013
ren U1110400 reason_noninterview2015

***************************************************
* Reshape and recode certain variables.
***************************************************

* exclued from reshape: ID (i) Sample_type race_ethnicity sex birth_month birth_year Bio_father_highest_educ Bio_mother_highest_educ Relationship_to_Par_age12_ Relationship_to_Par_age2_ Relationship_to_Par_age6_ HH_size ASVAB
forvalues yr=1980/2016 {
    gen temp`yr'=0
}
reshape long temp weight_cc weight_panel Int_month InterviewD InterviewM InterviewY Relationship_HH_head Born_in_US PIAT_math Family_income reason_noninterview, i(ID) j(year)

drop temp
drop if mi(ID)

recode _all (-1 = .r) (-2 = .d) (-3 = .i) (-4 = .v) (-5 = .n)

***************************************************
* Label variables and values
***************************************************

label var ID                          "ID"
label var year                        "YEAR"
label var sex                         "SEX"
label var birth_month                 "BIRTH MONTH"
label var birth_year                  "BIRTH YEAR"
label var Relationship_to_Par_age12_  "RELATIONSHIP TO PARENTS AT AGE 12"
label var Relationship_to_Par_age2_   "RELATIONSHIP TO PARENTS AT AGE 2"
label var Relationship_to_Par_age6_   "RELATIONSHIP TO PARENTS AT AGE 6"
label var HH_size                     "HOUSEHOLD SIZE"
label var Sample_type                 "SAMPLE TYPE (CROSS-SECTIONAL OR OVERSAMPLE)"
label var Bio_father_highest_educ     "FATHER'S EDUCATION"
label var Bio_mother_highest_educ     "MOTHER'S EDUCATION"
label var race_ethnicity              "RACE/ETHNICITY"
label var ASVAB                       "ASVAB MATH/VERBAL SCORE PERCENTILE"
label var weight_cc                   "CUMULATIVE-CASES WEIGHTS"
label var weight_panel                "PANEL WEIGHTS"
label var Int_month                   "INTERVIEW MONTH (CONTINUOUS MONTH FORMAT)"
label var InterviewD                  "INTERVIEW DAY (CALENDAR FORMAT)"
label var InterviewM                  "INTERVIEW MONTH (CALENDAR FORMAT)"
label var InterviewY                  "INTERVIEW YEAR (CALENDAR FORMAT)"
label var Relationship_HH_head        "RELATIONSHIP TO HOUSEHOLD HEAD"
label var Born_in_US                  "BORN IN THE US"
label var PIAT_math                   "PIAT MATH SCORE"
label var Family_income               "FAMILY INCOME"
label var reason_noninterview         "REASON FOR NON-INTERVIEW"

label define vl_race   1 "Black"  2 "Hispanic"  3 "Mixed Race (Non-Hispanic)"  4 "Non-Black / Non-Hispanic"
label values race_ethnicity vl_race

label define vl_sex   1 "Male"  2 "Female"  0 "No Information"
label values sex vl_sex

label define vl_relPar 1 "Both biological parents"  2 "Biological mother, other parent present"  3 "Biological father, other parent present"  4 "Biological mother, marital status unknown"  5 "Biological dad, marital status unknown"  6 "Adoptive parent(s)"  7 "Foster parent(s)"  8 "Other adults, biologial parent status unknown, not group quarters"  9 "Group quarters"  10 "Anything else"
label define vl_relHH  1 "Both biological parents"  2 "Two parents, biological mother"  3 "Two parents, biological father"  4 "Biological mother only"  5 "Biological father only"  6 "Adoptive parent(s)"  7 "Foster parent(s)"  8 "No parents, grandparents"  9 "No parents, other relatives"  10 "Anything else"
label values Relationship_to_Par_age12_ vl_relPar
label values Relationship_to_Par_age2_  vl_relPar
label values Relationship_to_Par_age6_  vl_relPar
label values Relationship_HH_head       vl_relHH

label define vl_sample  1 "Cross-sectional"  0 "Oversample"
label values Sample_type vl_sample

label define vl_int  60 "Completed in person"  61 "Completed by phone"  62 "Comp in person/conv"  63 "Comp by phone/conv"  64 "Compy by proxy parent/R disabled"  65 "Comp by proxy nonparent/R disabled"  66 "Comp in person/incarcerated"  67 "Comp by phone/incarcerated"  80 "Prior deceased blocked"  89 "NIR blocked"  90 "Final unlocatable"  91 "Very hostile refusal"  92 "Gatekeeper Refusal"  93 "R - inaccessible"  94 "Respondent too ill/handicapped"  95 "Respondent unavailable entire field period"  96 "Refusal"  97 "Hostile refusal"  98 "Deceased"  99 "Other"
label values reason_noninterview vl_int

label define vl_origin 1 "YES"  0 "NO"
label values Born_in_US vl_origin

order ID year birth* race_ethnicity sex
