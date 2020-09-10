* Create age, foreignBorn, race, sex, female, family income, parental co-residence status, missed interview, etc.

**get sex dummies
capture noisily drop male female
gen male =   (sex==1)
gen female = (sex==2)

**Recode parental education variables
recode  Bio_father_highest_educ (95 = .)
recode  Bio_mother_highest_educ (95 = .)
rename  Bio_mother_highest_educ Meduc
generat m_Meduc = mi(Meduc)
replace Meduc = 0 if mi(Meduc)
rename  Bio_father_highest_educ Feduc
generat m_Feduc = mi(Feduc)
replace Feduc = 0 if mi(Feduc)

**Fix Born_abroad variable, etc.
bys ID: egen born_here = mean(Born_in_US)
replace born_here=1 if born_here>0 & born_here<1
generat foreignBorn = 1-born_here
drop    born_here

** Fix AFQT
generat m_afqt   = mi(afqt_std   )
generat m_afqtAR = mi(asvabAR_std)
generat m_afqtCS = mi(asvabCS_std)
generat m_afqtMK = mi(asvabMK_std)
generat m_afqtNO = mi(asvabNO_std)
generat m_afqtPC = mi(asvabPC_std)
generat m_afqtWK = mi(asvabWK_std)
replace afqt_std    = 0 if mi(afqt_std   )
replace asvabAR_std = 0 if mi(asvabAR_std)
replace asvabCS_std = 0 if mi(asvabCS_std)
replace asvabMK_std = 0 if mi(asvabMK_std)
replace asvabNO_std = 0 if mi(asvabNO_std)
replace asvabPC_std = 0 if mi(asvabPC_std)
replace asvabWK_std = 0 if mi(asvabWK_std)

*Fix Family Income
generate        Finc96     = Family_income if year==1996
bys ID: egen    famInc1996 = mean(Finc96)
bys ID: replace famInc1996 = .r if Finc96[17]==.r
bys ID: replace famInc1996 = .d if Finc96[17]==.d
bys ID: replace famInc1996 = .i if Finc96[17]==.i
bys ID: replace famInc1996 = .v if Finc96[17]==.v
bys ID: replace famInc1996 = .n if Finc96[17]==.n
bys ID: replace famInc1996 = .  if Finc96[17]==.
drop Finc96
generat m_famInc1996 = mi(famInc1996)
replace famInc1996   = famInc1996/1.569 // 1.569 is the 1982-84 CPI-Urban in 1996
replace famInc1996   = famInc1996/1000
replace famInc1996   = 0 if mi(famInc1996)

* Fix relationship to Head of Household
generat      true_rel_HH_headA = Relationship_HH_head if year==1997
replace      true_rel_HH_headA = min(Relationship_to_Par_age12_, Relationship_HH_head) if (mi(Relationship_HH_head) | mi(Relationship_to_Par_age12_)) & year==1997 & Relationship_HH_head~=Relationship_to_Par_age12_
bys ID: egen true_rel_HH_head  = mean(true_rel_HH_headA)
drop         true_rel_HH_headA
label   val  true_rel_HH_head vl_relPar

* Get whether or not person lives with mom in 1997
gen liveWithMom14 = inlist(true_rel_HH_head,1,2,4)

* Get whether or not person lives in female-headed household in 1997
gen femaleHeadHH1997 = true_rel_HH_head==4

* Get Household size in 1997
rename  HH_size HHsize1997

* Fix Weights Variable
replace weight_panel = . if year~=1997
bys ID: egen weight  = mean(weight_panel)
drop weight_panel

* Generate cohort dummies
capture noisily drop age_now
generat born_1980 = (birth_year==1980)
generat born_1981 = (birth_year==1981)
generat born_1982 = (birth_year==1982)
generat born_1983 = (birth_year==1983)
generat born_1984 = (birth_year==1984)

* Generate age
genera now_1997 = (1997-1960)*12
genera DOB = (birth_year-1960)*12+birth_month-1
format now_1997 %tm
format DOB %tm
genera age      = (now_1997-DOB)/12
genera age_now  = year-birth_year-1

* Generate race dummies
renam race_ethnicity race
gener white    = (race==4)
gener black    = (race==1)
gener hispanic = (race==2)
gener mixed    = (race==3)
label val race vl_race

* missed interviews
* variables that flag if the year is missing, how long the missing has 
*  gone on, how long the missing lasts, if it's the last missing spell
*  and if it's the first long missing spell (long = 3+ missed interviews)
generat Interview_date                      = Int_month+239 // add 239 to convert from NLSY base month (Dec 1979) to Stata base month (Jan 1960)
format  Interview_date %tm
replace Interview_date                      = .n if Int_month==.n

foreach x of numlist 1/17 {
    local temp=`x'+19
    bys ID: gen R`x'interviewDate  = Interview_date[`temp']
    bys ID: gen R`x'interviewDay   = mdy(InterviewM[`temp'],InterviewD[`temp'],InterviewY[`temp'])
    bys ID: gen R`x'interviewWeek  = wofd(mdy(InterviewM[`temp'],InterviewD[`temp'],InterviewY[`temp']))
    format R`x'interviewDate %tm
    format R`x'interviewDay  %td
    format R`x'interviewWeek %tw
}
gen flag1 = yofd(dofm(R1interviewDate)) ==1998 // create flag for imputing schooling before first interview
gen flag2 = yofd(dofm(R17interviewDate))==2016 // create flag for dropping observations after last interview

gen Interview_day                           = mdy(InterviewM,InterviewD,InterviewY)
gen Interview_month                         = month(dofm(Interview_date))
replace Interview_month                     = .n if Interview_date==.n
replace Interview_month                     = .  if Interview_date==.

gen miss_interview                          = (Interview_date==.n)
bys ID: egen miss_interview_dumB            = mean(miss_interview)
gen ever_miss_interview                     = (miss_interview_dumB > 0)
drop miss_interview_dumB

gen age_at_miss_int                         = age_now*miss_interview
gen year_miss_int                           = year*miss_interview

gen miss_interview_cum                      = 0
by ID: replace miss_interview_cum           = miss_interview_cum[_n-1] + 1 if miss_interview[_n]==1

gsort +ID -year
gen miss_interview_length                   = miss_interview_cum
by ID: replace miss_interview_length        = miss_interview_length[_n-1] if miss_interview_cum[_n]!=0 & miss_interview_cum[_n-1]!=0 & year~=2016

sort ID year
* create flag for long missed interview spell
generate year_first_long_spellA             = year*(miss_interview_length>2)
replace  year_first_long_spellA             = . if year_first_long_spellA==0
bys ID (year): egen year_first_long_spell   = min(year_first_long_spellA)
drop year_first_long_spellA
gen long_miss_flag                          = year>=year_first_long_spell

* create flag for any missed interview spell
generate year_first_short_spellA             = year*(miss_interview_length>0)
replace  year_first_short_spellA             = . if year_first_short_spellA==0
bys ID (year): egen year_first_short_spell   = min(year_first_short_spellA)
drop year_first_short_spellA
gen short_miss_flag                          = year>=year_first_short_spell

gsort +ID -year
gen miss_interview_last_spell               = 0
by ID: replace miss_interview_last_spell    = 1 if miss_interview_cum[_n]!=0 & ( (year==2015 & ~flag2) | miss_interview_last_spell[_n-1]==1)
sort ID year
label var miss_interview            "Missed Interview In Current Year"
label var miss_interview_cum        "Running Tally Of Current Missed Interview Spell"
label var miss_interview_length     "Length Of Current Missed Interview Spell"
label var miss_interview_last_spell "Element Of Last Missed Interview Spell"

* identify right-censored interview spells
generat not_missing_interview               = 1-miss_interview if year<2016
replace not_missing_interview               = 1 if year==2016 & flag2
generat nonmissing_int_year                 = year*not_missing_interview
bys ID (year): egen max_nonmissing_int_year = max(nonmissing_int_year)
generat missIntLastSpell                    = (year>max_nonmissing_int_year)

* interview month of last survey year (either the last year before a 3+ missed spell, the last year before a right-censored spell, or 2015)
generat last_survey_yearA                   = year_first_long_spell-1 if year==year_first_long_spell
replace last_survey_yearA                   = max_nonmissing_int_year if year==2015

generat last_survey_year_hastyA             = year_first_short_spell-1 if year==year_first_short_spell
replace last_survey_year_hastyA             = max_nonmissing_int_year if year==2015

bys ID (year): egen last_survey_year        = min(last_survey_yearA)
bys ID (year): egen last_survey_year_hasty  = min(last_survey_year_hastyA)

gen last_int_dayA                           = Interview_day if year==last_survey_year
bys ID (year): egen last_int_day            = mean(last_int_dayA)
format last_int_day %td


*--------------------------------------------------------------------------------
* Some summary stats on people's missing interview behavior throughout the survey
*--------------------------------------------------------------------------------
* get proportion of people who ever missed any number of consecutive interviews
foreach x of numlist 1/13 {
    by ID: gen miss_`x'_intA  = (miss_interview_length==`x')
}
foreach x of numlist 1/13 {
    by ID: egen miss_`x'_intB  = mean(miss_`x'_intA )
}
foreach x of numlist 1/13 {
    by ID: gen ever_miss_`x'_int  = (miss_`x'_intB >0)
}
drop miss_*intA miss_*intB

gen ever_miss_3plus_int = ((ever_miss_3_int)|(ever_miss_4_int)|(ever_miss_5_int)|(ever_miss_6_int)|(ever_miss_7_int)|(ever_miss_8_int)|(ever_miss_9_int)|(ever_miss_10_int)|(ever_miss_11_int)|(ever_miss_12_int))

* get proportion of people who return after missing any number of consecutive interviews
foreach x of numlist 1/13 {
    by ID: gen return_after_`x'_miss_intA  = (miss_interview_length[_n-1]==`x'  & miss_interview_length[_n]==0)
}
foreach x of numlist 1/13 {
    by ID: egen return_after_`x'_miss_intB  = mean(return_after_`x'_miss_intA )
}
foreach x of numlist 1/13 {
    by ID: gen ever_return_after_`x'_miss_int  = (return_after_`x'_miss_intB >0)
}
drop return_after*A return_after*B

gen ever_return_after_3plus_miss_int = ((ever_return_after_3_miss_int)|(ever_return_after_4_miss_int)|(ever_return_after_5_miss_int)|(ever_return_after_6_miss_int)|(ever_return_after_7_miss_int)|(ever_return_after_8_miss_int)|(ever_return_after_9_miss_int)|(ever_return_after_10_miss_int)|(ever_return_after_11_miss_int)|(ever_return_after_12_miss_int)|(ever_return_after_13_miss_int))

* Count number of people who have multiple missing interview spells lasting different lengths
foreach x of numlist 1/13 {
    count if ever_return_after_1_miss_int ==1 & ever_return_after_`x'_miss_int==1 & year==1997
}
foreach x of numlist 2/13 {
    count if ever_return_after_2_miss_int ==1 & ever_return_after_`x'_miss_int==1 & year==1997
}
foreach x of numlist 3/13 {
    count if ever_return_after_3_miss_int ==1 & ever_return_after_`x'_miss_int==1 & year==1997
}
foreach x of numlist 4/13 {
    count if ever_return_after_4_miss_int ==1 & ever_return_after_`x'_miss_int==1 & year==1997
}
foreach x of numlist 5/13 {
    count if ever_return_after_5_miss_int ==1 & ever_return_after_`x'_miss_int==1 & year==1997
}
foreach x of numlist 6/13 {
    count if ever_return_after_6_miss_int ==1 & ever_return_after_`x'_miss_int==1 & year==1997
}
foreach x of numlist 7/13 {
    count if ever_return_after_7_miss_int ==1 & ever_return_after_`x'_miss_int==1 & year==1997
}
foreach x of numlist 8/13 {
    count if ever_return_after_8_miss_int ==1 & ever_return_after_`x'_miss_int==1 & year==1997
}
foreach x of numlist 9/13 {
    count if ever_return_after_9_miss_int ==1 & ever_return_after_`x'_miss_int==1 & year==1997
}
foreach x of numlist 10/13 {
    count if ever_return_after_10_miss_int ==1 & ever_return_after_`x'_miss_int==1 & year==1997
}
foreach x of numlist 11/13 {
    count if ever_return_after_11_miss_int ==1 & ever_return_after_`x'_miss_int==1 & year==1997
}
foreach x of numlist 12/13 {
    count if ever_return_after_12_miss_int ==1 & ever_return_after_`x'_miss_int==1 & year==1997
}
foreach x of numlist 13/13 {
    count if ever_return_after_13_miss_int ==1 & ever_return_after_`x'_miss_int==1 & year==1997
}

foreach x of numlist 1/13 {
    sum ever_return_after_`x'_miss_int if ever_miss_`x'_int==1 & year==1997
}

sum ever_return_after_3plus_miss_int if ever_miss_3plus_int==1 & year==1997

tab age_at_miss_int            if age_at_miss_int>0, mi
tab age_at_miss_int birth_year if age_at_miss_int>0, mi col nofreq
tab year_miss_int              if year_miss_int>0, mi // show momentary interview missers
tab last_survey_year           if  year==2015 // show cumulative attrition in our sample (either because of permanent attrition from NLSY or having missed 3+ interviews)
tab last_survey_year_hasty     if  year==2015 // show cumulative attrition in our sample if we never made use of backfilled observations
tab max_nonmissing_int_year    if year==2015 // show cumulative attrition in our sample if we always used backfilled obs (i.e. if we kept super-long missed spells)
/* See ../NLSY97AttritionSummary.xlsx for spreadsheet of last four lines */
