***************************************************
* Generate various demographic variables
***************************************************

* age
gen age = year-dob_yr1979 - 1
label var age "AGE AS OF JAN 1"

* missing parent's education
generat m_hgcMoth = (hgcMoth>=.)
replace hgcMoth = 0 if m_hgcMoth==1
generat m_hgcFath = (hgcFath>=.)
replace hgcFath = 0 if m_hgcFath==1
label var m_hgcMoth "MISSING MOTHER'S HGC"
label var m_hgcFath "MISSING FATHER'S HGC"

* afqt (import from file)
rename    id ID
merge     m:1 ID using ../y97/RawData/AFQT_MATCHING/afqt_adjusted_final79,    keepusing(ID afqt_std) assert(match master) nogen
merge     m:1 ID using ../y97/RawData/AFQT_MATCHING_AR/afqt_adjusted_final79, keepusing(ID asvabAR_std) assert(match master) nogen
merge     m:1 ID using ../y97/RawData/AFQT_MATCHING_CS/afqt_adjusted_final79, keepusing(ID asvabCS_std) assert(match master) nogen
merge     m:1 ID using ../y97/RawData/AFQT_MATCHING_MK/afqt_adjusted_final79, keepusing(ID asvabMK_std) assert(match master) nogen
merge     m:1 ID using ../y97/RawData/AFQT_MATCHING_NO/afqt_adjusted_final79, keepusing(ID asvabNO_std) assert(match master) nogen
merge     m:1 ID using ../y97/RawData/AFQT_MATCHING_PC/afqt_adjusted_final79, keepusing(ID asvabPC_std) assert(match master) nogen
merge     m:1 ID using ../y97/RawData/AFQT_MATCHING_WK/afqt_adjusted_final79, keepusing(ID asvabWK_std) assert(match master) nogen

label var afqt_std    "AFQT STANDARDIZED BY ALTONJI"
label var asvabAR_std "ASVAB ARITHMETIC REASONING    (AR) SUBTEST STANDARDIZED BY ALTONJI"
label var asvabCS_std "ASVAB NUMERICAL OPERATIONS    (CS) SUBTEST STANDARDIZED BY ALTONJI"
label var asvabMK_std "ASVAB CODING SPEED            (MK) SUBTEST STANDARDIZED BY ALTONJI"
label var asvabNO_std "ASVAB MATHEMATICS KNOWLEDGE   (NO) SUBTEST STANDARDIZED BY ALTONJI"
label var asvabPC_std "ASVAB WORD KNOWLEDGE          (PC) SUBTEST STANDARDIZED BY ALTONJI"
label var asvabWK_std "ASVAB PARAGRAPH COMPREHENSION (WK) SUBTEST STANDARDIZED BY ALTONJI"
rename    afqt_std    afqt
rename    asvabAR_std asvabAR
rename    asvabCS_std asvabCS
rename    asvabMK_std asvabMK
rename    asvabNO_std asvabNO
rename    asvabPC_std asvabPC
rename    asvabWK_std asvabWK
generat   m_afqt   =mi(afqt  )
generat   m_asvabAR=mi(asvabAR)
generat   m_asvabCS=mi(asvabCS)
generat   m_asvabMK=mi(asvabMK)
generat   m_asvabNO=mi(asvabNO)
generat   m_asvabPC=mi(asvabPC)
generat   m_asvabWK=mi(asvabWK)
replace   afqt     = 0 if m_afqt  ==1
replace   asvabAR  = 0 if m_asvabAR==1
replace   asvabCS  = 0 if m_asvabCS==1
replace   asvabMK  = 0 if m_asvabMK==1
replace   asvabNO  = 0 if m_asvabNO==1
replace   asvabPC  = 0 if m_asvabPC==1
replace   asvabWK  = 0 if m_asvabWK==1
rename    ID id

* Check all missings accounted for
foreach V in hgcMoth hgcFath afqt {
	assert !missing( `V')
	count if m_`V'
	assert r(N)~=0
}

* forgeignBorn
gen foreignBorn = country_born==2
label var foreignBorn "FOREIGN BORN DUMMY"

* year entered us if foreign born
replace yearEnteredUS = yearEnteredUS+1900 if yearEnteredUS<.

* race
gen white    = race_screen==3
gen black    = race_screen==2
gen hispanic = race_screen==1
gen race     = 1 if white
replace race = 2 if black
replace race = 3 if hispanic
assert race != 0
lab var white "WHITE"
lab var black "BLACK"
lab var hispanic "HISPANIC"
lab var race "RACE"

* female
gen female = sex==2
label var female "FEMALE DUMMY"

* birth cohorts
gen     born1957 = dob_yr==1957
gen     born1958 = dob_yr==1958
gen     born1959 = dob_yr==1959
gen     born1960 = dob_yr==1960
gen     born1961 = dob_yr==1961
gen     born1962 = dob_yr==1962
gen     born1963 = dob_yr==1963
gen     born1964 = dob_yr==1964
lab var born1957 "BIRTH COHORT DUMMY 1957"
lab var born1958 "BIRTH COHORT DUMMY 1958"
lab var born1959 "BIRTH COHORT DUMMY 1959"
lab var born1960 "BIRTH COHORT DUMMY 1960"
lab var born1961 "BIRTH COHORT DUMMY 1961"
lab var born1962 "BIRTH COHORT DUMMY 1962"
lab var born1963 "BIRTH COHORT DUMMY 1963"
lab var born1964 "BIRTH COHORT DUMMY 1964"

* live with mom at 14
gen       liveWithMom14  = (live_with_14==11) | (live_with_14==21) | (live_with_14==31) | (live_with_14==41) | (live_with_14==51) | (live_with_14==91)
label var liveWithMom14  "LIVE WITH MOTHER AT AGE 14"
gen       femaleHeadHH14 = (live_with_14==51) | (live_with_14==52) | (live_with_14==53) | (live_with_14==54) | (live_with_14==91) | (live_with_14==93)
label var femaleHeadHH14 "FEMALE HEADED HOUSEHOLD AT AGE 14"

* oversample dummies
gen     oversampleRace     = (sample_id1979==10 | sample_id1979==11 | sample_id1979==13 | sample_id1979==14)
gen     oversamplePoor     = (sample_id1979==9  | sample_id1979==12)
gen     oversampleMilitary = (sample_id1979>=15 & sample_id1979<= 20)
lab var oversampleRace     "OVERSAMPLE - BLACKS AND HISPANICS"
lab var oversamplePoor     "OVERSAMPLE - POOR WHITES"
lab var oversampleMilitary "OVERSAMPLE - MILITARY"

* deflate family income
sort id year
by id: replace famInc1978 = famInc1978/cpi[9]
replace famInc1978 = famInc1978/1000

generat m_famInc1978=(famInc1978>=.)
replace famInc1978 = 0 if m_famInc1978==1
lab var famInc1978   "FAMILY INCOME IN 1978, 1000's of 1982-4 $"
lab var m_famInc1978 "MISSING FAMILY INCOME IN 1978"

* weights
rename      weight weight_cross
gen         weight_temp = weight_cross if year==1979
by id: egen weight = max(weight_temp)
drop        weight_temp
lab var     weight "WEIGHT FROM FIRST YEAR OF SURVEY"

*============================================================================
* missed interviews
* variables that flag if the year is missing, how long the missing has 
*  gone on, how long the missing lasts, and if it's the last missing spell
*  Also, variables that list whether the element is the first after a spell
*  and the last year of data before the spell.
*============================================================================
sort id year
gen         missInt = reason_noninterview<.
by id: egen everMissInt = max(missInt)
gen         ageAtMissInt = age*missInt
gen         yearMissInt = year*missInt

gen            missIntCum = 0
by id: replace missIntCum = missIntCum[_n-1] + 1 if missInt[_n]==1

gsort +id -year
gen            missIntLength = missIntCum
by id: replace missIntLength = missIntLength[_n-1] if missIntCum[_n]!=0 & missIntCum[_n-1]!=0 & year<1994

gen            missIntLastSpell = 0
by id: replace missIntLastSpell = 1 if missIntCum[_n]!=0 & (year==1994 | missIntLastSpell[_n-1]==1)
sort id year

by id: gen     missIntEnd = (missInt[_n-1]==1) & (missInt[_n]==0) & (year<=1994)

by id: gen     missIntEndLength = missIntEnd[_n]*missIntLength[_n-1]
replace        missIntEndLength = 0 if year==1970

gen            missIntFirstYear = 0
by id: replace missIntFirstYear = year[_n]               if missIntCum[_n]==1
by id: replace missIntFirstYear = missIntFirstYear[_n-1] if missIntCum[_n]>1

gen            missIntLongestSpellYet = missIntLength
by id: replace missIntLongestSpellYet = missIntLongestSpellYet[_n-1] if missIntLongestSpellYet<missIntLongestSpellYet[_n-1] & _n>1

by id: gen     missIntInvalidPeriod   = missIntLongestSpellYet[_n]>=3 | missIntLastSpell[_n]==1

by id: gen     lastValidInt           = missIntInvalidPeriod[_n]==0 & missIntInvalidPeriod[_n+1]==1

gen            temp_date              = mdy(interview_mo,1,year) if lastValidInt
by id: egen    lastValidIntDate       = max(temp_date)
format         lastValidIntDate %td
drop           temp_date

gen            temp_date              = mdy(interview_mo,1,year) if missIntLastSpell==0 & missIntLastSpell[_n+1]==1
by id: egen    beforeLastSpellIntDate = max(temp_date)
format         beforeLastSpellIntDate %td
drop           temp_date

label var missInt                "MISSED INTERVIEW IN CURRENT YEAR"
label var missIntCum             "RUNNING TALLY OF CURRENT MISSED INTERVIEW SPELL"
label var missIntLength          "LENGTH OF CURRENT MISSED INTERVIEW SPELL"
label var missIntLastSpell       "ELEMENT OF LAST MISSED INTERVIEW SPELL"
label var missIntEnd             "FIRST OBS AFTER MISSED INTERVIEW SPELL"
label var missIntEndLength       "LENGTH OF MISSED INTERVIEW SPELL THAT ENDED THE PREVIOUS YEAR"
label var missIntFirstYear       "YEAR OF FIRST OBS OF MISSED INTERVIEW SPELL" 
label var missIntLongestSpellYet "LENGTH OF LONGEST SPELL INDIV HAS EXPERIENCE BY T"
label var missIntInvalidPeriod   "ELEMENT OF INVALID INTERVIEW PERIOD"
label var lastValidInt           "LAST VALID INTERVIEW"
label var lastValidIntDate       "DATE OF LAST VALID INTERVIEW"

foreach x of numlist 1/18 {
	local temp=`x'+9
	bys id: gen R`x'interviewDate  = ym(year[`temp'],interview_mo[`temp'])
	format R`x'interviewDate %tm
}

* get proportion of people who ever missed any number of consecutive interviews
foreach x of numlist 1/11 {
	by id: gen miss_`x'_intA  = (missIntLength==`x')
}
foreach x of numlist 1/11 {
	by id: egen miss_`x'_intB  = mean(miss_`x'_intA )
}
foreach x of numlist 1/11 {
	by id: gen ever_miss_`x'_int  = (miss_`x'_intB >0)
}
drop miss_*intA miss_*intB

gen everMiss3plusInt = ((ever_miss_3_int)|(ever_miss_4_int)|(ever_miss_5_int)|(ever_miss_6_int)|(ever_miss_7_int)|(ever_miss_8_int)|(ever_miss_9_int)|(ever_miss_10_int)|(ever_miss_11_int))

* get proportion of people who return after missing any number of consecutive interviews
foreach x of numlist 1/11 {
	by id: gen return_after_`x'_miss_intA  = (missIntLength[_n-1]==`x'  & missIntLength[_n]==0 & year<=1994)
}
foreach x of numlist 1/11 {
	by id: egen return_after_`x'_miss_intB  = mean(return_after_`x'_miss_intA  & year<=1994)
}
foreach x of numlist 1/11 {
	by id: gen ever_return_after_`x'_miss_int  = (return_after_`x'_miss_intB >0  & year<=1994)
}
drop return_after*A return_after*B

gen everReturnAfter3plusMissInt = ((ever_return_after_3_miss_int)|(ever_return_after_4_miss_int)|(ever_return_after_5_miss_int)|(ever_return_after_6_miss_int)|(ever_return_after_7_miss_int)|(ever_return_after_8_miss_int)|(ever_return_after_9_miss_int)|(ever_return_after_10_miss_int)|(ever_return_after_11_miss_int))

* Count number of people who have multiple missing interview spells lasting different lengths
foreach x of numlist 1/11 {
	count if ever_return_after_1_miss_int ==1 & ever_return_after_`x'_miss_int==1 & year==1979
}
foreach x of numlist 2/11 {
	count if ever_return_after_2_miss_int ==1 & ever_return_after_`x'_miss_int==1 & year==1979
}
foreach x of numlist 3/11 {
	count if ever_return_after_3_miss_int ==1 & ever_return_after_`x'_miss_int==1 & year==1979
}
foreach x of numlist 4/11 {
	count if ever_return_after_4_miss_int ==1 & ever_return_after_`x'_miss_int==1 & year==1979
}
foreach x of numlist 5/11 {
	count if ever_return_after_5_miss_int ==1 & ever_return_after_`x'_miss_int==1 & year==1979
}
foreach x of numlist 6/11 {
	count if ever_return_after_6_miss_int ==1 & ever_return_after_`x'_miss_int==1 & year==1979
}
foreach x of numlist 7/11 {
	count if ever_return_after_7_miss_int ==1 & ever_return_after_`x'_miss_int==1 & year==1979
}
foreach x of numlist 8/11 {
	count if ever_return_after_8_miss_int ==1 & ever_return_after_`x'_miss_int==1 & year==1979
}
foreach x of numlist 9/11 {
	count if ever_return_after_9_miss_int ==1 & ever_return_after_`x'_miss_int==1 & year==1979
}
foreach x of numlist 10/11 {
	count if ever_return_after_10_miss_int ==1 & ever_return_after_`x'_miss_int==1 & year==1979
}
foreach x of numlist 11/11 {
	count if ever_return_after_11_miss_int ==1 & ever_return_after_`x'_miss_int==1 & year==1979
}

foreach x of numlist 1/11 {
	sum ever_return_after_`x'_miss_int if ever_miss_`x'_int==1 & year==1979
}

sum everReturnAfter3plusMissInt if everMiss3plusInt==1 & year==1979

tab ageAtMissInt if ageAtMissInt>0, mi
tab ageAtMissInt dob_yr if ageAtMissInt>0, mi col nofreq
tab yearMissInt if yearMissInt>0, mi

