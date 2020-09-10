version 14.1
clear all
set more off
capture log close
set maxvar 32000

log using "y97_create_trim.log", replace

!unzip y97_master.dta.zip
use y97_master.dta
!rm y97_master.dta

local months Jan Feb Mar Apr May Jun Jul Aug Sep Oct Nov Dec

foreach x of local months {
    replace  activity`x' = 1  if schOnly`x'                               // School Only
    replace  activity`x' = 2  if workSch`x'                               // School and Work using defn A
    replace  activity`x' = 3  if !military`x' & !In_school`x' & workPT`x' // Part-Time Work Only using defn A
    replace  activity`x' = 4  if !military`x' & !In_school`x' & workFT`x' // Full-Time Work Only
    replace  activity`x' = 5  if military`x'                              // Military
    replace  activity`x' = 6  if other`x'                                 // Other
}

foreach x of local months {
    * Create mutually exclusive activity indicators
    gen byte one`x'   = schOnly`x'             
    gen byte two`x'   = workSch`x'               
    gen byte three`x' = !military`x' & !In_school`x' & workPT`x'
    gen byte four`x'  = !military`x' & !In_school`x' & workFT`x'
    gen byte five`x'  = military`x'              
    gen byte six`x'   = other`x'    
}

tab2 oneJan twoJan threeJan fourJan fiveJan sixJan, mi

foreach x of local months {
    assert workSch`x'==workK12`x'+workCollege`x'
    assert schOnly`x'+workSch`x'==In_school`x'
}

foreach x of local months {
    * assert (schOnly`x')+(workSch`x')+(!military`x' & !In_school`x' & workPT`x')+(!military`x' & !In_school`x' & workFT`x')+(military`x')+(other`x')==1
    tab year if (schOnly`x')+(workSch`x')+(!military`x' & !In_school`x' & workPT`x')+(!military`x' & !In_school`x' & workFT`x')+(military`x')+(other`x')~=1
}

* Assume people who are missing foreignBorn are actually foreign born
recode foreignBorn (. = 1)

foreach x in AR CS MK NO PC WK {
    ren m_afqt`x' m_asvab`x'
}

* keep variables
local demographics ID year age_now miss_interview miss_interview_cum miss_interview_length year_miss_int ever_return_after_*int ever_miss_interview ever_miss*int age_at*int missIntLastSpell last_int_day Meduc m_Meduc Feduc m_Feduc foreignBorn afqt_std asvabAR_std asvabCS_std asvabMK_std asvabNO_std asvabPC_std asvabWK_std m_afqt m_asvabAR m_asvabCS m_asvabMK m_asvabNO m_asvabPC m_asvabWK famInc1996 m_famInc1996 liveWithMom14 femaleHeadHH1997 HHsize1997 female race white black hispanic mixed birth_month birth_year born_1980 born_1981 born_1982 born_1983 born_1984 Sample_type weight fedMinWage cpi Interview_date
local school Highest_Grade_Completed School_Yr_to_Grade In_school??? Months_in_K12 Months_in_college Months_in_grad_school In_K12 In_grad_school School_Yr_to_Grade Enrolled_K12_??? Enrolled_college_??? Enrolled_2yr_??? Enrolled_4yr_??? Enrolled_grad_school_??? gradGraduate yrGradGraduate grad4yr yrGrad4yr grad2yr yrGrad2yr gradHS yrGradHS gradGED yrGradGED gradDiploma yrGradDiploma Grad_month BA_month AA_month Diploma_month GED_month HS_month Grad_year BA_year AA_year Diploma_year GED_year HS_year 
local work weeks_employed weeks_worked_??? weeksSelfEmployed??? hours_worked_??? avgHrs??? weeksMilitary??? workFT??? workPT??? work??? workSch??? workK12??? workCollege??? military??? other??? activity???  workFTRecall??? workPTRecall??? workRecall??? workSchRecall??? workK12Recall??? workCollegeRecall??? militaryRecall??? otherRecall??? activityRecall???  weeks_in_labor_force Avg_hrs_worked Hrs_worked_tot Created_Hours_Worked Total_Hours_Worked Total_Hours_Worked_Old annualHrsWrkCalcCalc annual_most_wage annual_main_wage annual_median_wage annual_least_wage annual_mean_wage annual_most_comp annual_main_comp annual_median_comp annual_least_comp annual_mean_comp annual_ind_max annual_occ_max annual_occ_main annual_ind_main annual_ind_min annual_occ_min internship_max internship_min internship_main internship Hrs_worked_tot Created_Hours_Worked num_jobs_week* wage_week* comp_week* wagerWeek* comprWeek* wage??? comp??? wageAlt??? compAlt??? wageMedian??? compMedian??? wageAltMedian??? compAltMedian??? total_employers num_primary_job_switches
keep `demographics' `school' `work' lastValidSchoolDate long_miss_flag max_nonmissing_int_year R*interview* wage_job_current wage_job_main comp_job_current comp_job_main Highest_degree_ever self_employed_job_current self_employed_job_main occ_job_current occ_job_main ind_job_current ind_job_main

#delimit ;
capture ren ID id; lab var id "Person ID";
capture ren age_now age; lab var age "Age as of Jan 1 of current year";
capture ren Meduc hgcMoth; lab var hgcMoth "Mother's HGC";
capture ren m_Meduc m_hgcMoth; lab var m_hgcMoth "Missing Mother's HGC";
capture ren Feduc hgcFath; lab var hgcFath "Father's HGC";
capture ren m_Feduc m_hgcFath; lab var m_hgcFath "Missing Father's HGC"; 
capture ren foreignBorn foreignBorn; lab var foreignBorn "Born outside of the US";
capture ren afqt_std    afqt   ; lab var afqt      "Standardized AFQT (Altonji et al.)";
capture ren asvabAR_std asvabAR; lab var asvabAR   "Standardized ASVAB Arithmetic Reasoning    (AR) Subtest (Altonji et al.)";
capture ren asvabCS_std asvabCS; lab var asvabCS   "Standardized ASVAB Coding Speed            (CS) Subtest (Altonji et al.)";
capture ren asvabMK_std asvabMK; lab var asvabMK   "Standardized ASVAB Mathematics Knowledge   (MK) Subtest (Altonji et al.)";
capture ren asvabNO_std asvabNO; lab var asvabNO   "Standardized ASVAB Numerical Operations    (NO) Subtest (Altonji et al.)";
capture ren asvabPC_std asvabPC; lab var asvabPC   "Standardized ASVAB Paragraph Comprehension (PC) Subtest (Altonji et al.)";
capture ren asvabWK_std asvabWK; lab var asvabWK   "Standardized ASVAB Word Knowledge          (WK) Subtest (Altonji et al.)";
capture ren m_afqt    m_afqt   ; lab var m_afqt    "Missing AFQT"                              ;
capture ren m_asvabAR m_asvabAR; lab var m_asvabAR "Missing ASVAB Arithmetic Reasoning    (AR)";
capture ren m_asvabCS m_asvabCS; lab var m_asvabCS "Missing ASVAB Coding Speed            (CS)";
capture ren m_asvabMK m_asvabMK; lab var m_asvabMK "Missing ASVAB Mathematics Knowledge   (MK)";
capture ren m_asvabNO m_asvabNO; lab var m_asvabNO "Missing ASVAB Numerical Operations    (NO)";
capture ren m_asvabPC m_asvabPC; lab var m_asvabPC "Missing ASVAB Paragraph Comprehension (PC)";
capture ren m_asvabWK m_asvabWK; lab var m_asvabWK "Missing ASVAB Word Knowledge          (WK)";
capture ren famInc1996 famInc1996; lab var famInc1996 "(Real) Family Income in 1996";
capture ren m_famInc1996 m_famInc1996; lab var m_famInc1996 "Missing Family Income in 1996";
* capture ren Census_region region; * lab var region "Census Region at Interview Date";
capture ren birth_month birthMonth;
capture ren birth_year  birthYear;
capture ren born_1980 born1980; lab var born1980 "Born in year 1980 dummy";
capture ren born_1981 born1981; lab var born1981 "Born in year 1981 dummy";
capture ren born_1982 born1982; lab var born1982 "Born in year 1982 dummy";
capture ren born_1983 born1983; lab var born1983 "Born in year 1983 dummy";
capture ren born_1984 born1984; lab var born1984 "Born in year 1984 dummy"; // remember to use b1984 as the omitted dummy
gen oversample = 1-Sample_type; lab var oversample "Dummy: 1=oversample; 0=cross-sectional";
drop Sample_type;
lab var fedMinWage "Federal Minimum Wage, $1982-84";
lab var cpi "Consumer Price Index (CPI) $1982-84";
*lab var weight_cc "Cumulative Cases survey weight (BLS created)";
*lab var weight_panel "Panel survey weight (BLS created)";
*lab var weight_altonji "Altonji et al. survey weight";
*lab var custom_weight "Custom (BLS created) survey weight";
ren Highest_Grade_Completed hgcIn; lab var hgcIn "HGC as of survey date";
ren School_Yr_to_Grade grade_current; lab var grade_current "Current Grade Attending";
ren Months_in_K12 monthsK12; lab var monthsK12 "Months enrolled in K12 in calendar year t";
ren Months_in_college monthsCollege; lab var monthsCollege "Months enrolled in College in calendar year t";
ren Months_in_grad_school monthsGradSch; lab var monthsGradSch "Months enrolled in Graduate School in calendar year t";
* ren In_K12 enrK12; * lab var enrK12 "Ever enrolled in K12 in calendar year t";
* ren In_college enrCollege; * lab var enrCollege "Ever enrolled in College in calendar year t";
* ren In_grad_school enrGradSch; * lab var enrGradSch "Ever enrolled in Graduate school in calendar year t";
foreach mon in Jan Feb Mar Apr May Jun Jul Aug Sep Oct Nov Dec {;
    ren Enrolled_K12_`mon' enrK12`mon'; lab var enrK12`mon' "Enrolled in K12 in `mon' of calendar year t";
    ren Enrolled_college_`mon' enrCollege`mon'; lab var enrCollege`mon' "Enrolled in College in `mon' of calendar year t";
    ren Enrolled_2yr_`mon' enr2yr`mon'; lab var enr2yr`mon' "Enrolled in 2yr in `mon' of calendar year t";
    ren Enrolled_4yr_`mon' enr4yr`mon'; lab var enr4yr`mon' "Enrolled in 4yr in `mon' of calendar year t";
    ren Enrolled_grad_school_`mon' enrGradSch`mon'; lab var enrGradSch`mon' "Enrolled in Graduate School in `mon' of calendar year t";
};
* ren Weeks_in_Military weeksMilitary; * lab var weeksMilitary "Number of weeks of calendar year t spent in the military";
ren weeks_employed weeksEmployed; lab var weeksEmployed "Number of weeks of calendar year t spent working for an employer";
ren weeks_in_labor_force weeksLabForce; lab var weeksLabForce "Number of weeks of calendar year t spent in the labor force";
ren Avg_hrs_worked annualAvgHrsWrk; lab var annualAvgHrsWrk "Annual Hours Worked / Weeks Employed, where N/0 = 0";
ren Total_Hours_Worked annualHrsWrk; lab var annualHrsWrk "Hours worked in calendar year t across all jobs";
ren annual_most_wage annualWageMax; lab var annualWageMax "Highest wage across all jobs in calendar year t";
ren annual_median_wage annualWageMed; lab var annualWageMed "Median wage across all jobs in calendar year t";
ren annual_least_wage annualWageMin; lab var annualWageMin "Lowest wage across all jobs in calendar year t";
ren annual_mean_wage annualWageMean; lab var annualWageMean "Average wage weighted by job length in calendar year t";
ren annual_main_wage annualWageMain; lab var annualWageMain "Wage at main job in calendar year t";
ren annual_most_comp annualCompMax; lab var annualCompMax "Highest comp across all jobs in calendar year t";
ren annual_median_comp annualCompMed; lab var annualCompMed "Median comp across all jobs in calendar year t";
ren annual_least_comp annualCompMin; lab var annualCompMin "Lowest comp across all jobs in calendar year t";
ren annual_mean_comp annualCompMean; lab var annualCompMean "Average comp weighted by job length in calendar year t";
ren annual_main_comp annualCompMain; lab var annualCompMain "Comp at main job in calendar year t";
ren annual_ind_max annualIndMax; lab var annualIndMax "Industry of the highest-wage job in calendar year t";
ren annual_occ_max annualOccMax; lab var annualOccMax "Industry of the highest-wage job in calendar year t";
ren annual_ind_main annualIndMain; lab var annualIndMain "Industry of the main job in calendar year t";
ren annual_occ_main annualOccMain; lab var annualOccMax "Occupation of the main job in calendar year t";
ren annual_ind_min annualIndMin; lab var annualIndMin "Industry of the highest-wage job in calendar year t";
ren annual_occ_min annualOccMin; lab var annualOccMin "Industry of the highest-wage job in calendar year t";
ren internship_max internshipMax; lab var internshipMax "Industry of the highest-wage job in calendar year t";
ren internship_min internshipMin; lab var internshipMin "Industry of the highest-wage job in calendar year t";
lab var internship "Any job reported in calendar year t was an internship";
foreach mon of local months {;
    ren weeks_worked_`mon' weeksWrk`mon'; lab var weeksWrk`mon' "Weeks Worked in `mon' of calendar year t";
    ren hours_worked_`mon' monthlyHrsWrk`mon'; lab var monthlyHrsWrk`mon' "Total Hours Worked in `mon' of calendar year t";
    ren avgHrs`mon' avgHrsWrk`mon'; lab var avgHrsWrk`mon' "Average weekly hours worked in `mon' of calendar year t";
    lab var weeksMilitary`mon' "Weeks in military in `mon' of calendar year t";
    ren work`mon' atWork`mon'; lab var atWork`mon' "Activity >=2 & Activity<=4 in `mon' of calendar year t";
    
    ren workFTRecall`mon'      RECALLworkFTRecall`mon'      ;
    ren workPTRecall`mon'      RECALLworkPTRecall`mon'      ;
    ren militaryRecall`mon'    RECALLmilitaryRecall`mon'    ;
    ren workRecall`mon'        RECALLworkRecall`mon'        ;
    ren workSchRecall`mon'     RECALLworkSchRecall`mon'     ;
    ren workK12Recall`mon'     RECALLworkK12Recall`mon'     ;
    ren workCollegeRecall`mon' RECALLworkCollegeRecall`mon' ;
    ren otherRecall`mon'       RECALLotherRecall`mon'       ;
    ren activityRecall`mon'    RECALLactivityRecall`mon'    ;
};
#delimit cr

capture ren In_school enrSchool
capture ren id id
capture ren year year
capture ren age age
capture ren birth_year birthYear
capture ren white white
capture ren black black
capture ren hispanic hispanic
capture ren race race
capture ren HH_size_78 HHsize1978
capture ren HHsize1997 HHsize1997
capture ren region region
capture ren hgcIn hgcIn
capture ren weight_panel weight
capture ren oversample oversampleRace
capture ren annualHrsWrk annualHrsWrk
capture ren grade_current gradeCurrent
capture ren miss_interview missInt
capture ren afqt afqt
capture ren female female
capture ren hgcMoth hgcMoth
capture ren m_hgcMoth m_hgcMoth
capture ren hgcFath hgcFath
capture ren m_hgcFath m_hgcFath
capture ren foreignBorn foreignBorn
capture ren m_afqt m_afqt
capture ren famInc1978 famInc1978
capture ren famInc1996 famInc1996
capture ren m_famInc1978 m_famInc1978
capture ren m_famInc1996 m_famInc1996
capture ren femaleHeadHH1997 femaleHeadHH1997
capture ren livwmom14 liveWithMom14
capture ren born1961 born1961
capture ren born1962 born1962
capture ren born1963 born1963
capture ren born1964 born1964
capture ren born1980 born1980
capture ren born1981 born1981
capture ren born1982 born1982
capture ren born1983 born1983
capture ren born1984 born1984
capture ren age_at_miss_int ageAtMissInt
capture ren year_miss_int yearMissInt
capture ren ever_miss_interview everMissInt
capture ren miss_interview_cum missIntCum
capture ren miss_interview_length missIntLength
capture ren ever_miss_3plus_int everMiss3plusInt
capture ren ever_return_after_3plus_miss_int everReturnAfter3plusMissInt
capture ren fedMinWage    fedMinWage
capture ren cpi           cpi
capture ren enrCollegeJan enrCollegeJan
capture ren enrCollegeFeb enrCollegeFeb
capture ren enrCollegeMar enrCollegeMar
capture ren enrCollegeApr enrCollegeApr
capture ren enrCollegeMay enrCollegeMay
capture ren enrCollegeJun enrCollegeJun
capture ren enrCollegeJul enrCollegeJul
capture ren enrCollegeAug enrCollegeAug
capture ren enrCollegeSep enrCollegeSep
capture ren enrCollegeOct enrCollegeOct
capture ren enrCollegeNov enrCollegeNov
capture ren enrCollegeDec enrCollegeDec
capture ren enr2yrJan enr2yrJan
capture ren enr2yrFeb enr2yrFeb
capture ren enr2yrMar enr2yrMar
capture ren enr2yrApr enr2yrApr
capture ren enr2yrMay enr2yrMay
capture ren enr2yrJun enr2yrJun
capture ren enr2yrJul enr2yrJul
capture ren enr2yrAug enr2yrAug
capture ren enr2yrSep enr2yrSep
capture ren enr2yrOct enr2yrOct
capture ren enr2yrNov enr2yrNov
capture ren enr2yrDec enr2yrDec
capture ren enr4yrJan enr4yrJan
capture ren enr4yrFeb enr4yrFeb
capture ren enr4yrMar enr4yrMar
capture ren enr4yrApr enr4yrApr
capture ren enr4yrMay enr4yrMay
capture ren enr4yrJun enr4yrJun
capture ren enr4yrJul enr4yrJul
capture ren enr4yrAug enr4yrAug
capture ren enr4yrSep enr4yrSep
capture ren enr4yrOct enr4yrOct
capture ren enr4yrNov enr4yrNov
capture ren enr4yrDec enr4yrDec
capture ren enrGradSchJan enrGradSchJan
capture ren enrGradSchFeb enrGradSchFeb
capture ren enrGradSchMar enrGradSchMar
capture ren enrGradSchApr enrGradSchApr
capture ren enrGradSchMay enrGradSchMay
capture ren enrGradSchJun enrGradSchJun
capture ren enrGradSchJul enrGradSchJul
capture ren enrGradSchAug enrGradSchAug
capture ren enrGradSchSep enrGradSchSep
capture ren enrGradSchOct enrGradSchOct
capture ren enrGradSchNov enrGradSchNov
capture ren enrGradSchDec enrGradSchDec
capture ren enrK12Jan enrK12Jan
capture ren enrK12Feb enrK12Feb
capture ren enrK12Mar enrK12Mar
capture ren enrK12Apr enrK12Apr
capture ren enrK12May enrK12May
capture ren enrK12Jun enrK12Jun
capture ren enrK12Jul enrK12Jul
capture ren enrK12Aug enrK12Aug
capture ren enrK12Sep enrK12Sep
capture ren enrK12Oct enrK12Oct
capture ren enrK12Nov enrK12Nov
capture ren enrK12Dec enrK12Dec
capture ren monthsCollege monthsCollege
capture ren monthsGradSch monthsGradSch
capture ren monthsK12 monthsK12
capture ren enrK12 enrK12
capture ren enrCollege enrCollege
capture ren enrGradSch enrGradSch
capture ren weeksEmployed weeksEmployed
capture ren weeksLabForce weeksLabForce
capture ren annualWageMean annualWageMean
capture ren annualWageMed annualWageMed
capture ren annualWageMin annualWageMin
capture ren annualWageMax annualWageMax
capture ren annualWageMain annualWageMain
capture ren annualCompMean annualCompMean
capture ren annualCompMed annualCompMed
capture ren annualCompMin annualCompMin
capture ren annualCompMax annualCompMax
capture ren annualCompMain annualCompMain
capture ren annualOccMin annualOccMin
capture ren annualOccMax annualOccMax
capture ren annualOccMain annualOccMain
capture ren annualIndMin annualIndMin
capture ren annualIndMax annualIndMax
capture ren annualIndMain annualIndMain
capture ren weeksWrkJan weeksWrkJan
capture ren weeksWrkFeb weeksWrkFeb
capture ren weeksWrkMar weeksWrkMar
capture ren weeksWrkApr weeksWrkApr
capture ren weeksWrkMay weeksWrkMay
capture ren weeksWrkJun weeksWrkJun
capture ren weeksWrkJul weeksWrkJul
capture ren weeksWrkAug weeksWrkAug
capture ren weeksWrkSep weeksWrkSep
capture ren weeksWrkOct weeksWrkOct
capture ren weeksWrkNov weeksWrkNov
capture ren weeksWrkDec weeksWrkDec
capture ren annualAvgHrsWrk annualAvgHrsWrk
capture ren weeksMilitary weeksMilitary
* capture ren   workFT workFT
* capture ren   workPT_A workPT_A
* capture ren   workPT_B workPT_B
* capture ren   militaryA militaryA
* capture ren   militaryB militaryB
* capture ren   militaryC militaryC
* capture ren   workA workA
* capture ren   workB workB
* capture ren   workSchA workSchA
* capture ren   workK12A workK12A
* capture ren   workCollegeA workCollegeA
* capture ren   workSchB workSchB
* capture ren   workK12B workK12B
* capture ren   workCollegeB workCollegeB
* capture ren   otherA otherA
* capture ren   otherB otherB
* capture ren   otherC otherC
* capture ren   activityA activityA
* capture ren   activityB activityB
* capture ren   activityC activityC

capture lab var id "Person ID"
capture lab var year "Year of Survey"
capture lab var age "Age as of Jan 1 of current year"
capture lab var birthYear "Birth year"
capture lab var white "White indicator"
capture lab var black "Black indicator"
capture lab var hispanic "Hispanic indicator"
capture lab var race "Race from Screener (Mixed dropped in 97)"
capture lab var HHsize1978 "Household Size in 1979"
capture lab var HHsize1997 "Household Size in 1997"
capture lab var region "Census Region at Interview Date"
capture lab var hgcIn "HGC as of survey date"
capture lab var weight "Panel survey weight (BLS created)"
capture lab var oversampleRace "Dummy: 1=oversample; 0=cross-sectional"
capture lab var annualHrsWrk "Hours worked in calendar year t across all jobs"
capture lab var gradeCurrent "Current Grade Attending"
capture lab var missInt "Missed Interview In Current Year"
capture lab var afqt "Standardized AFQT (Altonji et al.)"
capture lab var female "Female"
capture lab var hgcMoth "Mother's HGC"
capture lab var m_hgcMoth "Missing Mother's HGC"
capture lab var hgcFath "Father's HGC"
capture lab var m_hgcFath "Missing Father's HGC"
capture lab var foreignBorn "Born outside of the US"
capture lab var m_afqt "Missing AFQT"
capture lab var famInc1978 "(Real) Family Income in 1978"
capture lab var famInc1996 "(Real) Family Income in 1996"
capture lab var m_famInc1978 "Missing Family Income in 1978"
capture lab var m_famInc1996 "Missing Family Income in 1996"
capture lab var femaleHeadHH1997 "Female headed household in 1997"
capture lab var liveWithMom14 "Live with mother at age 14"
capture lab var born1961 "Born in year 1961 dummy"
capture lab var born1962 "Born in year 1962 dummy"
capture lab var born1963 "Born in year 1963 dummy"
capture lab var born1964 "Born in year 1964 dummy"
capture lab var born1980 "Born in year 1980 dummy"
capture lab var born1981 "Born in year 1981 dummy"
capture lab var born1982 "Born in year 1982 dummy"
capture lab var born1983 "Born in year 1983 dummy"
capture lab var born1984 "Born in year 1984 dummy"
capture lab var ageAtMissInt "Age * Miss Int dummy"
capture lab var yearMissInt "Year * Miss Int dummy"
capture lab var everMissInt "Ever miss an interview"
capture lab var missIntCum "Running Tally Of Current Missed Interview Spell"
capture lab var missIntLength "Length Of Current Missed Interview Spell"
capture lab var everMiss3plusInt "Ever miss 3+ consecutive interviews"
capture lab var everReturnAfter3plusMissInt "Ever return after missing 3+ consecutive interviews"
capture lab var fedMinWage "Federal Minimum Wage, $1982-84"
capture lab var cpi "Consumer Price Index (CPI) $1982-84"
capture lab var enrCollegeJan "Enrolled in College in Jan of Survey Year"
capture lab var enrCollegeFeb "Enrolled in College in Feb of Survey Year"
capture lab var enrCollegeMar "Enrolled in College in Mar of Survey Year"
capture lab var enrCollegeApr "Enrolled in College in Apr of Survey Year"
capture lab var enrCollegeMay "Enrolled in College in May of Survey Year"
capture lab var enrCollegeJun "Enrolled in College in Jun of Survey Year"
capture lab var enrCollegeJul "Enrolled in College in Jul of Survey Year"
capture lab var enrCollegeAug "Enrolled in College in Aug of Survey Year"
capture lab var enrCollegeSep "Enrolled in College in Sep of Survey Year"
capture lab var enrCollegeOct "Enrolled in College in Oct of Survey Year"
capture lab var enrCollegeNov "Enrolled in College in Nov of Survey Year"
capture lab var enrCollegeDec "Enrolled in College in Dec of Survey Year"
capture lab var enr2yrJan "Enrolled in 2yr in Jan of Survey Year"
capture lab var enr2yrFeb "Enrolled in 2yr in Feb of Survey Year"
capture lab var enr2yrMar "Enrolled in 2yr in Mar of Survey Year"
capture lab var enr2yrApr "Enrolled in 2yr in Apr of Survey Year"
capture lab var enr2yrMay "Enrolled in 2yr in May of Survey Year"
capture lab var enr2yrJun "Enrolled in 2yr in Jun of Survey Year"
capture lab var enr2yrJul "Enrolled in 2yr in Jul of Survey Year"
capture lab var enr2yrAug "Enrolled in 2yr in Aug of Survey Year"
capture lab var enr2yrSep "Enrolled in 2yr in Sep of Survey Year"
capture lab var enr2yrOct "Enrolled in 2yr in Oct of Survey Year"
capture lab var enr2yrNov "Enrolled in 2yr in Nov of Survey Year"
capture lab var enr2yrDec "Enrolled in 2yr in Dec of Survey Year"
capture lab var enr4yrJan "Enrolled in 4yr in Jan of Survey Year"
capture lab var enr4yrFeb "Enrolled in 4yr in Feb of Survey Year"
capture lab var enr4yrMar "Enrolled in 4yr in Mar of Survey Year"
capture lab var enr4yrApr "Enrolled in 4yr in Apr of Survey Year"
capture lab var enr4yrMay "Enrolled in 4yr in May of Survey Year"
capture lab var enr4yrJun "Enrolled in 4yr in Jun of Survey Year"
capture lab var enr4yrJul "Enrolled in 4yr in Jul of Survey Year"
capture lab var enr4yrAug "Enrolled in 4yr in Aug of Survey Year"
capture lab var enr4yrSep "Enrolled in 4yr in Sep of Survey Year"
capture lab var enr4yrOct "Enrolled in 4yr in Oct of Survey Year"
capture lab var enr4yrNov "Enrolled in 4yr in Nov of Survey Year"
capture lab var enr4yrDec "Enrolled in 4yr in Dec of Survey Year"
capture lab var enrGradSchJan "Enrolled in Grad School in Jan of Survey Year"
capture lab var enrGradSchFeb "Enrolled in Grad School in Feb of Survey Year"
capture lab var enrGradSchMar "Enrolled in Grad School in Mar of Survey Year"
capture lab var enrGradSchApr "Enrolled in Grad School in Apr of Survey Year"
capture lab var enrGradSchMay "Enrolled in Grad School in May of Survey Year"
capture lab var enrGradSchJun "Enrolled in Grad School in Jun of Survey Year"
capture lab var enrGradSchJul "Enrolled in Grad School in Jul of Survey Year"
capture lab var enrGradSchAug "Enrolled in Grad School in Aug of Survey Year"
capture lab var enrGradSchSep "Enrolled in Grad School in Sep of Survey Year"
capture lab var enrGradSchOct "Enrolled in Grad School in Oct of Survey Year"
capture lab var enrGradSchNov "Enrolled in Grad School in Nov of Survey Year"
capture lab var enrGradSchDec "Enrolled in Grad School in Dec of Survey Year"
capture lab var enrK12Jan "Enrolled in K12 in Jan of Survey Year"
capture lab var enrK12Feb "Enrolled in K12 in Feb of Survey Year"
capture lab var enrK12Mar "Enrolled in K12 in Mar of Survey Year"
capture lab var enrK12Apr "Enrolled in K12 in Apr of Survey Year"
capture lab var enrK12May "Enrolled in K12 in May of Survey Year"
capture lab var enrK12Jun "Enrolled in K12 in Jun of Survey Year"
capture lab var enrK12Jul "Enrolled in K12 in Jul of Survey Year"
capture lab var enrK12Aug "Enrolled in K12 in Aug of Survey Year"
capture lab var enrK12Sep "Enrolled in K12 in Sep of Survey Year"
capture lab var enrK12Oct "Enrolled in K12 in Oct of Survey Year"
capture lab var enrK12Nov "Enrolled in K12 in Nov of Survey Year"
capture lab var enrK12Dec "Enrolled in K12 in Dec of Survey Year"
capture lab var monthsCollege "Months enrolled in College in calendar year t"
capture lab var monthsGradSch "Months enrolled in Graduate School in calendar year t"
capture lab var monthsK12 "Months enrolled in K12 in calendar year t"
capture lab var enrK12 "Ever enrolled in K12 in calendar year t"
capture lab var enrCollege "Ever enrolled in College in calendar year t"
capture lab var enrGradSch "Ever enrolled in Graduate school in calendar year t"
capture lab var weeksEmployed "Number of weeks of calendar year t spent working for an employer"
capture lab var weeksLabForce "Number of weeks of calendar year t spent in the labor force"
capture lab var annualWageMean "Average wage weighted by weeks worked in calendar year"
capture lab var annualWageMed "Median wage across all jobs in calendar year t"
capture lab var annualWageMin "Lowest wage across all jobs in calendar year t"
capture lab var annualWageMax "Highest wage across all jobs in calendar year t"
capture lab var annualWageMain "Wage at main job in calendar year t"
capture lab var annualCompMean "Average Comp weighted by weeks worked in calendar year"
capture lab var annualCompMed "Median Comp across all jobs in calendar year t"
capture lab var annualCompMin "Lowest Comp across all jobs in calendar year t"
capture lab var annualCompMax "Highest Comp across all jobs in calendar year t"
capture lab var annualCompMain "Comp at main job in calendar year t"
capture lab var annualOccMin "Occupation of the lowest-wage job in calendar year t"
capture lab var annualOccMax "Occupation of the highest-wage job in calendar year t"
capture lab var annualOccMain "Occupation of the main job in calendar year t"
capture lab var annualIndMin "Industry of the lowest-wage job in calendar year t"
capture lab var annualIndMax "Industry of the highest-wage job in calendar year t"
capture lab var annualIndMain "Industry of the main job in calendar year t"
capture lab var weeksWrkJan "Weeks Worked in Jan of calendar year t"
capture lab var weeksWrkFeb "Weeks Worked in Feb of calendar year t"
capture lab var weeksWrkMar "Weeks Worked in Mar of calendar year t"
capture lab var weeksWrkApr "Weeks Worked in Apr of calendar year t"
capture lab var weeksWrkMay "Weeks Worked in May of calendar year t"
capture lab var weeksWrkJun "Weeks Worked in Jun of calendar year t"
capture lab var weeksWrkJul "Weeks Worked in Jul of calendar year t"
capture lab var weeksWrkAug "Weeks Worked in Aug of calendar year t"
capture lab var weeksWrkSep "Weeks Worked in Sep of calendar year t"
capture lab var weeksWrkOct "Weeks Worked in Oct of calendar year t"
capture lab var weeksWrkNov "Weeks Worked in Nov of calendar year t"
capture lab var weeksWrkDec "Weeks Worked in Dec of calendar year t"
capture lab var weeksSelfEmployedJan   "Weeks Self-Employed in Jan of calendar year t"
capture lab var weeksSelfEmployedFeb   "Weeks Self-Employed in Feb of calendar year t"
capture lab var weeksSelfEmployedMar   "Weeks Self-Employed in Mar of calendar year t"
capture lab var weeksSelfEmployedApr   "Weeks Self-Employed in Apr of calendar year t"
capture lab var weeksSelfEmployedMay   "Weeks Self-Employed in May of calendar year t"
capture lab var weeksSelfEmployedJun   "Weeks Self-Employed in Jun of calendar year t"
capture lab var weeksSelfEmployedJul   "Weeks Self-Employed in Jul of calendar year t"
capture lab var weeksSelfEmployedAug   "Weeks Self-Employed in Aug of calendar year t"
capture lab var weeksSelfEmployedSep   "Weeks Self-Employed in Sep of calendar year t"
capture lab var weeksSelfEmployedOct   "Weeks Self-Employed in Oct of calendar year t"
capture lab var weeksSelfEmployedNov   "Weeks Self-Employed in Nov of calendar year t"
capture lab var weeksSelfEmployedDec   "Weeks Self-Employed in Dec of calendar year t"
capture lab var annualAvgHrsWrk "Annual Hours Worked / Weeks Employed, where N/0 = 0"
capture lab var weeksMilitary "Number of weeks of calendar year t spent in the military"
* capture lab var workFT "Working Full-Time indicator"
* capture lab var workPT_A "Working Part-Time indicator (Def A)"
* capture lab var workPT_B "Working Part-Time indicator (Def B)"
* capture lab var militaryA "Military indicator (Def A)"
* capture lab var militaryB "Military indicator (Def B)"
* capture lab var militaryC "Military indicator (Def C)"
* capture lab var workA "Working indicator (Def A)"
* capture lab var workB "Working indicator (Def B)"
* capture lab var workSchA "Working and School indicator (Def A)"
* capture lab var workK12A "Working and K12 indicator (Def A)"
* capture lab var workCollegeA "Working and College indicator (Def A)"
* capture lab var workSchB "Working and School indicator (Def B)"
* capture lab var workK12B "Working and K12 indicator (Def B)"
* capture lab var workCollegeB "Working and College indicator (Def B)"
* capture lab var otherA "Other indicator (Def A)"
* capture lab var otherB "Other indicator (Def B)"
* capture lab var otherC "Other indicator (Def C)"
* capture lab var activityA "Primary Activity (Def A)"
* capture lab var activityB "Primary Activity (Def B)"
* capture lab var activityC "Primary Activity (Def C)"
capture ren Hrs_worked_tot annualHrsWrkCalc
capture lab var annualHrsWrkCalc "Annual Hours calculated as sum of 'Hours per week across jobs' variable"
capture ren Created_Hours_Worked annualHrsWrkRaw
capture lab var annualHrsWrkRaw "Annual Hours from raw survey data"
capture ren Total_Hours_Worked_Old annualHrsWrkOld
capture lab var annualHrsWrkOld "Previous Annual Hours variable (before summing over different types)"
capture lab var annualHrsWrkCalcCalc "Annual Hours calculated as sum of 'Hours per week at job X' multiplied by weeks worked at job X in the year"

ren wage_job_current          WageJobCurrent
ren wage_job_main             WageJobMain
ren comp_job_current          CompJobCurrent
ren comp_job_main             CompJobMain
ren self_employed_job_current selfEmployedJobCurrent
ren self_employed_job_main    selfEmployedJobMain
ren occ_job_current           occJobCurrent
ren occ_job_main              occJobMain
ren ind_job_current           indJobCurrent
ren ind_job_main              indJobMain

order id year age birthMonth birthYear white black hispanic mixed liveWithMom14 race HHsize1997 weight oversampleRace annualHrsWrk gradeCurrent missInt afqt asvabAR asvabCS asvabMK asvabNO asvabPC asvabWK m_afqt m_asvabAR m_asvabCS m_asvabMK m_asvabNO m_asvabPC m_asvabWK female hgcIn hgcMoth m_hgcMoth hgcFath m_hgcFath foreignBorn famInc1996 m_famInc1996 femaleHeadHH1997 born1980 born1981 born1982 born1983 born1984 ageAtMissInt yearMissInt everMissInt missIntCum missIntLength everMiss3plusInt everReturnAfter3plusMissInt missIntLastSpell fedMinWage cpi enrCollegeJan enrCollegeFeb enrCollegeMar enrCollegeApr enrCollegeMay enrCollegeJun enrCollegeJul enrCollegeAug enrCollegeSep enrCollegeOct enrCollegeNov enrCollegeDec enr2yrJan enr2yrFeb enr2yrMar enr2yrApr enr2yrMay enr2yrJun enr2yrJul enr2yrAug enr2yrSep enr2yrOct enr2yrNov enr2yrDec enr4yrJan enr4yrFeb enr4yrMar enr4yrApr enr4yrMay enr4yrJun enr4yrJul enr4yrAug enr4yrSep enr4yrOct enr4yrNov enr4yrDec enrGradSchJan enrGradSchFeb enrGradSchMar enrGradSchApr enrGradSchMay enrGradSchJun enrGradSchJul enrGradSchAug enrGradSchSep enrGradSchOct enrGradSchNov enrGradSchDec enrK12Jan enrK12Feb enrK12Mar enrK12Apr enrK12May enrK12Jun enrK12Jul enrK12Aug enrK12Sep enrK12Oct enrK12Nov enrK12Dec monthsCollege monthsGradSch monthsK12 weeksEmployed weeksLabForce annualWageMean annualWageMed annualWageMin annualWageMax annualWageMain wageJan wageFeb wageMar wageApr wageMay wageJun wageJul wageAug wageSep wageOct wageNov wageDec wageMedianJan wageMedianFeb wageMedianMar wageMedianApr wageMedianMay wageMedianJun wageMedianJul wageMedianAug wageMedianSep wageMedianOct wageMedianNov wageMedianDec wageAltJan wageAltFeb wageAltMar wageAltApr wageAltMay wageAltJun wageAltJul wageAltAug wageAltSep wageAltOct wageAltNov wageAltDec wageAltMedianJan wageAltMedianFeb wageAltMedianMar wageAltMedianApr wageAltMedianMay wageAltMedianJun wageAltMedianJul wageAltMedianAug wageAltMedianSep wageAltMedianOct wageAltMedianNov wageAltMedianDec annualCompMean annualCompMed annualCompMin annualCompMax annualCompMain compJan compFeb compMar compApr compMay compJun compJul compAug compSep compOct compNov compDec compMedianJan compMedianFeb compMedianMar compMedianApr compMedianMay compMedianJun compMedianJul compMedianAug compMedianSep compMedianOct compMedianNov compMedianDec compAltJan compAltFeb compAltMar compAltApr compAltMay compAltJun compAltJul compAltAug compAltSep compAltOct compAltNov compAltDec compAltMedianJan compAltMedianFeb compAltMedianMar compAltMedianApr compAltMedianMay compAltMedianJun compAltMedianJul compAltMedianAug compAltMedianSep compAltMedianOct compAltMedianNov compAltMedianDec annualOccMin annualOccMax annualOccMain annualIndMin annualIndMax annualIndMain weeksWrkJan weeksWrkFeb weeksWrkMar weeksWrkApr weeksWrkMay weeksWrkJun weeksWrkJul weeksWrkAug weeksWrkSep weeksWrkOct weeksWrkNov weeksWrkDec weeksSelfEmployedJan weeksSelfEmployedFeb weeksSelfEmployedMar weeksSelfEmployedApr weeksSelfEmployedMay weeksSelfEmployedJun weeksSelfEmployedJul weeksSelfEmployedAug weeksSelfEmployedSep weeksSelfEmployedOct weeksSelfEmployedNov weeksSelfEmployedDec avgHrsWrkJan avgHrsWrkFeb avgHrsWrkMar avgHrsWrkApr avgHrsWrkMay avgHrsWrkJun avgHrsWrkJul avgHrsWrkAug avgHrsWrkSep avgHrsWrkOct avgHrsWrkNov avgHrsWrkDec annualAvgHrsWrk monthlyHrsWrkJan monthlyHrsWrkFeb monthlyHrsWrkMar monthlyHrsWrkApr monthlyHrsWrkMay monthlyHrsWrkJun monthlyHrsWrkJul monthlyHrsWrkAug monthlyHrsWrkSep monthlyHrsWrkOct monthlyHrsWrkNov monthlyHrsWrkDec weeksMilitaryJan weeksMilitaryFeb weeksMilitaryMar weeksMilitaryApr weeksMilitaryMay weeksMilitaryJun weeksMilitaryJul weeksMilitaryAug weeksMilitarySep weeksMilitaryOct weeksMilitaryNov weeksMilitaryDec workFTJan workFTFeb workFTMar workFTApr workFTMay workFTJun workFTJul workFTAug workFTSep workFTOct workFTNov workFTDec workPTJan workPTFeb workPTMar workPTApr workPTMay workPTJun workPTJul workPTAug workPTSep workPTOct workPTNov workPTDec militaryJan militaryFeb militaryMar militaryApr militaryMay militaryJun militaryJul militaryAug militarySep militaryOct militaryNov militaryDec atWorkJan atWorkFeb atWorkMar atWorkApr atWorkMay atWorkJun atWorkJul atWorkAug atWorkSep atWorkOct atWorkNov atWorkDec workSchJan workSchFeb workSchMar workSchApr workSchMay workSchJun workSchJul workSchAug workSchSep workSchOct workSchNov workSchDec workK12Jan workK12Feb workK12Mar workK12Apr workK12May workK12Jun workK12Jul workK12Aug workK12Sep workK12Oct workK12Nov workK12Dec workCollegeJan workCollegeFeb workCollegeMar workCollegeApr workCollegeMay workCollegeJun workCollegeJul workCollegeAug workCollegeSep workCollegeOct workCollegeNov workCollegeDec otherJan otherFeb otherMar otherApr otherMay otherJun otherJul otherAug otherSep otherOct otherNov otherDec activityJan activityFeb activityMar activityApr activityMay activityJun activityJul activityAug activitySep activityOct activityNov activityDec RECALLworkFTRecallJan RECALLworkFTRecallFeb RECALLworkFTRecallMar RECALLworkFTRecallApr RECALLworkFTRecallMay RECALLworkFTRecallJun RECALLworkFTRecallJul RECALLworkFTRecallAug RECALLworkFTRecallSep RECALLworkFTRecallOct RECALLworkFTRecallNov RECALLworkFTRecallDec RECALLworkPTRecallJan RECALLworkPTRecallFeb RECALLworkPTRecallMar RECALLworkPTRecallApr RECALLworkPTRecallMay RECALLworkPTRecallJun RECALLworkPTRecallJul RECALLworkPTRecallAug RECALLworkPTRecallSep RECALLworkPTRecallOct RECALLworkPTRecallNov RECALLworkPTRecallDec RECALLmilitaryRecallJan RECALLmilitaryRecallFeb RECALLmilitaryRecallMar RECALLmilitaryRecallApr RECALLmilitaryRecallMay RECALLmilitaryRecallJun RECALLmilitaryRecallJul RECALLmilitaryRecallAug RECALLmilitaryRecallSep RECALLmilitaryRecallOct RECALLmilitaryRecallNov RECALLmilitaryRecallDec RECALLworkRecallJan RECALLworkRecallFeb RECALLworkRecallMar RECALLworkRecallApr RECALLworkRecallMay RECALLworkRecallJun RECALLworkRecallJul RECALLworkRecallAug RECALLworkRecallSep RECALLworkRecallOct RECALLworkRecallNov RECALLworkRecallDec RECALLworkSchRecallJan RECALLworkSchRecallFeb RECALLworkSchRecallMar RECALLworkSchRecallApr RECALLworkSchRecallMay RECALLworkSchRecallJun RECALLworkSchRecallJul RECALLworkSchRecallAug RECALLworkSchRecallSep RECALLworkSchRecallOct RECALLworkSchRecallNov RECALLworkSchRecallDec RECALLworkK12RecallJan RECALLworkK12RecallFeb RECALLworkK12RecallMar RECALLworkK12RecallApr RECALLworkK12RecallMay RECALLworkK12RecallJun RECALLworkK12RecallJul RECALLworkK12RecallAug RECALLworkK12RecallSep RECALLworkK12RecallOct RECALLworkK12RecallNov RECALLworkK12RecallDec RECALLworkCollegeRecallJan RECALLworkCollegeRecallFeb RECALLworkCollegeRecallMar RECALLworkCollegeRecallApr RECALLworkCollegeRecallMay RECALLworkCollegeRecallJun RECALLworkCollegeRecallJul RECALLworkCollegeRecallAug RECALLworkCollegeRecallSep RECALLworkCollegeRecallOct RECALLworkCollegeRecallNov RECALLworkCollegeRecallDec RECALLotherRecallJan RECALLotherRecallFeb RECALLotherRecallMar RECALLotherRecallApr RECALLotherRecallMay RECALLotherRecallJun RECALLotherRecallJul RECALLotherRecallAug RECALLotherRecallSep RECALLotherRecallOct RECALLotherRecallNov RECALLotherRecallDec RECALLactivityRecallJan RECALLactivityRecallFeb RECALLactivityRecallMar RECALLactivityRecallApr RECALLactivityRecallMay RECALLactivityRecallJun RECALLactivityRecallJul RECALLactivityRecallAug RECALLactivityRecallSep RECALLactivityRecallOct RECALLactivityRecallNov RECALLactivityRecallDec gradGraduate yrGradGraduate grad4yr yrGrad4yr grad2yr yrGrad2yr gradHS yrGradHS gradDiploma yrGradDiploma gradGED yrGradGED annualHrsWrkCalc annualHrsWrkCalcCalc annualHrsWrkRaw annualHrsWrkOld Grad_month BA_month AA_month Diploma_month GED_month HS_month Grad_year BA_year AA_year Diploma_year GED_year HS_year WageJobCurrent WageJobMain CompJobCurrent CompJobMain Interview_date last_int_day R*interview* Highest_degree_ever selfEmployedJobCurrent selfEmployedJobMain indJobMain indJobCurrent occJobMain occJobCurrent long_miss_flag max_nonmissing_int_year lastValidSchoolDate
keep  id year age birthMonth birthYear white black hispanic mixed liveWithMom14 race HHsize1997 weight oversampleRace annualHrsWrk gradeCurrent missInt afqt asvabAR asvabCS asvabMK asvabNO asvabPC asvabWK m_afqt m_asvabAR m_asvabCS m_asvabMK m_asvabNO m_asvabPC m_asvabWK female hgcIn hgcMoth m_hgcMoth hgcFath m_hgcFath foreignBorn famInc1996 m_famInc1996 femaleHeadHH1997 born1980 born1981 born1982 born1983 born1984 ageAtMissInt yearMissInt everMissInt missIntCum missIntLength everMiss3plusInt everReturnAfter3plusMissInt missIntLastSpell fedMinWage cpi enrCollegeJan enrCollegeFeb enrCollegeMar enrCollegeApr enrCollegeMay enrCollegeJun enrCollegeJul enrCollegeAug enrCollegeSep enrCollegeOct enrCollegeNov enrCollegeDec enr2yrJan enr2yrFeb enr2yrMar enr2yrApr enr2yrMay enr2yrJun enr2yrJul enr2yrAug enr2yrSep enr2yrOct enr2yrNov enr2yrDec enr4yrJan enr4yrFeb enr4yrMar enr4yrApr enr4yrMay enr4yrJun enr4yrJul enr4yrAug enr4yrSep enr4yrOct enr4yrNov enr4yrDec enrGradSchJan enrGradSchFeb enrGradSchMar enrGradSchApr enrGradSchMay enrGradSchJun enrGradSchJul enrGradSchAug enrGradSchSep enrGradSchOct enrGradSchNov enrGradSchDec enrK12Jan enrK12Feb enrK12Mar enrK12Apr enrK12May enrK12Jun enrK12Jul enrK12Aug enrK12Sep enrK12Oct enrK12Nov enrK12Dec monthsCollege monthsGradSch monthsK12 weeksEmployed weeksLabForce annualWageMean annualWageMed annualWageMin annualWageMax annualWageMain wageJan wageFeb wageMar wageApr wageMay wageJun wageJul wageAug wageSep wageOct wageNov wageDec wageMedianJan wageMedianFeb wageMedianMar wageMedianApr wageMedianMay wageMedianJun wageMedianJul wageMedianAug wageMedianSep wageMedianOct wageMedianNov wageMedianDec wageAltJan wageAltFeb wageAltMar wageAltApr wageAltMay wageAltJun wageAltJul wageAltAug wageAltSep wageAltOct wageAltNov wageAltDec wageAltMedianJan wageAltMedianFeb wageAltMedianMar wageAltMedianApr wageAltMedianMay wageAltMedianJun wageAltMedianJul wageAltMedianAug wageAltMedianSep wageAltMedianOct wageAltMedianNov wageAltMedianDec annualCompMean annualCompMed annualCompMin annualCompMax annualCompMain compJan compFeb compMar compApr compMay compJun compJul compAug compSep compOct compNov compDec compMedianJan compMedianFeb compMedianMar compMedianApr compMedianMay compMedianJun compMedianJul compMedianAug compMedianSep compMedianOct compMedianNov compMedianDec compAltJan compAltFeb compAltMar compAltApr compAltMay compAltJun compAltJul compAltAug compAltSep compAltOct compAltNov compAltDec compAltMedianJan compAltMedianFeb compAltMedianMar compAltMedianApr compAltMedianMay compAltMedianJun compAltMedianJul compAltMedianAug compAltMedianSep compAltMedianOct compAltMedianNov compAltMedianDec annualOccMin annualOccMax annualOccMain annualIndMin annualIndMax annualIndMain weeksWrkJan weeksWrkFeb weeksWrkMar weeksWrkApr weeksWrkMay weeksWrkJun weeksWrkJul weeksWrkAug weeksWrkSep weeksWrkOct weeksWrkNov weeksWrkDec weeksSelfEmployedJan weeksSelfEmployedFeb weeksSelfEmployedMar weeksSelfEmployedApr weeksSelfEmployedMay weeksSelfEmployedJun weeksSelfEmployedJul weeksSelfEmployedAug weeksSelfEmployedSep weeksSelfEmployedOct weeksSelfEmployedNov weeksSelfEmployedDec avgHrsWrkJan avgHrsWrkFeb avgHrsWrkMar avgHrsWrkApr avgHrsWrkMay avgHrsWrkJun avgHrsWrkJul avgHrsWrkAug avgHrsWrkSep avgHrsWrkOct avgHrsWrkNov avgHrsWrkDec annualAvgHrsWrk monthlyHrsWrkJan monthlyHrsWrkFeb monthlyHrsWrkMar monthlyHrsWrkApr monthlyHrsWrkMay monthlyHrsWrkJun monthlyHrsWrkJul monthlyHrsWrkAug monthlyHrsWrkSep monthlyHrsWrkOct monthlyHrsWrkNov monthlyHrsWrkDec weeksMilitaryJan weeksMilitaryFeb weeksMilitaryMar weeksMilitaryApr weeksMilitaryMay weeksMilitaryJun weeksMilitaryJul weeksMilitaryAug weeksMilitarySep weeksMilitaryOct weeksMilitaryNov weeksMilitaryDec workFTJan workFTFeb workFTMar workFTApr workFTMay workFTJun workFTJul workFTAug workFTSep workFTOct workFTNov workFTDec workPTJan workPTFeb workPTMar workPTApr workPTMay workPTJun workPTJul workPTAug workPTSep workPTOct workPTNov workPTDec militaryJan militaryFeb militaryMar militaryApr militaryMay militaryJun militaryJul militaryAug militarySep militaryOct militaryNov militaryDec atWorkJan atWorkFeb atWorkMar atWorkApr atWorkMay atWorkJun atWorkJul atWorkAug atWorkSep atWorkOct atWorkNov atWorkDec workSchJan workSchFeb workSchMar workSchApr workSchMay workSchJun workSchJul workSchAug workSchSep workSchOct workSchNov workSchDec workK12Jan workK12Feb workK12Mar workK12Apr workK12May workK12Jun workK12Jul workK12Aug workK12Sep workK12Oct workK12Nov workK12Dec workCollegeJan workCollegeFeb workCollegeMar workCollegeApr workCollegeMay workCollegeJun workCollegeJul workCollegeAug workCollegeSep workCollegeOct workCollegeNov workCollegeDec otherJan otherFeb otherMar otherApr otherMay otherJun otherJul otherAug otherSep otherOct otherNov otherDec activityJan activityFeb activityMar activityApr activityMay activityJun activityJul activityAug activitySep activityOct activityNov activityDec RECALLworkFTRecallJan RECALLworkFTRecallFeb RECALLworkFTRecallMar RECALLworkFTRecallApr RECALLworkFTRecallMay RECALLworkFTRecallJun RECALLworkFTRecallJul RECALLworkFTRecallAug RECALLworkFTRecallSep RECALLworkFTRecallOct RECALLworkFTRecallNov RECALLworkFTRecallDec RECALLworkPTRecallJan RECALLworkPTRecallFeb RECALLworkPTRecallMar RECALLworkPTRecallApr RECALLworkPTRecallMay RECALLworkPTRecallJun RECALLworkPTRecallJul RECALLworkPTRecallAug RECALLworkPTRecallSep RECALLworkPTRecallOct RECALLworkPTRecallNov RECALLworkPTRecallDec RECALLmilitaryRecallJan RECALLmilitaryRecallFeb RECALLmilitaryRecallMar RECALLmilitaryRecallApr RECALLmilitaryRecallMay RECALLmilitaryRecallJun RECALLmilitaryRecallJul RECALLmilitaryRecallAug RECALLmilitaryRecallSep RECALLmilitaryRecallOct RECALLmilitaryRecallNov RECALLmilitaryRecallDec RECALLworkRecallJan RECALLworkRecallFeb RECALLworkRecallMar RECALLworkRecallApr RECALLworkRecallMay RECALLworkRecallJun RECALLworkRecallJul RECALLworkRecallAug RECALLworkRecallSep RECALLworkRecallOct RECALLworkRecallNov RECALLworkRecallDec RECALLworkSchRecallJan RECALLworkSchRecallFeb RECALLworkSchRecallMar RECALLworkSchRecallApr RECALLworkSchRecallMay RECALLworkSchRecallJun RECALLworkSchRecallJul RECALLworkSchRecallAug RECALLworkSchRecallSep RECALLworkSchRecallOct RECALLworkSchRecallNov RECALLworkSchRecallDec RECALLworkK12RecallJan RECALLworkK12RecallFeb RECALLworkK12RecallMar RECALLworkK12RecallApr RECALLworkK12RecallMay RECALLworkK12RecallJun RECALLworkK12RecallJul RECALLworkK12RecallAug RECALLworkK12RecallSep RECALLworkK12RecallOct RECALLworkK12RecallNov RECALLworkK12RecallDec RECALLworkCollegeRecallJan RECALLworkCollegeRecallFeb RECALLworkCollegeRecallMar RECALLworkCollegeRecallApr RECALLworkCollegeRecallMay RECALLworkCollegeRecallJun RECALLworkCollegeRecallJul RECALLworkCollegeRecallAug RECALLworkCollegeRecallSep RECALLworkCollegeRecallOct RECALLworkCollegeRecallNov RECALLworkCollegeRecallDec RECALLotherRecallJan RECALLotherRecallFeb RECALLotherRecallMar RECALLotherRecallApr RECALLotherRecallMay RECALLotherRecallJun RECALLotherRecallJul RECALLotherRecallAug RECALLotherRecallSep RECALLotherRecallOct RECALLotherRecallNov RECALLotherRecallDec RECALLactivityRecallJan RECALLactivityRecallFeb RECALLactivityRecallMar RECALLactivityRecallApr RECALLactivityRecallMay RECALLactivityRecallJun RECALLactivityRecallJul RECALLactivityRecallAug RECALLactivityRecallSep RECALLactivityRecallOct RECALLactivityRecallNov RECALLactivityRecallDec gradGraduate yrGradGraduate grad4yr yrGrad4yr grad2yr yrGrad2yr gradHS yrGradHS gradDiploma yrGradDiploma gradGED yrGradGED annualHrsWrkCalc annualHrsWrkCalcCalc annualHrsWrkRaw annualHrsWrkOld Grad_month BA_month AA_month Diploma_month GED_month HS_month Grad_year BA_year AA_year Diploma_year GED_year HS_year WageJobCurrent WageJobMain CompJobCurrent CompJobMain Interview_date last_int_day R*interview* Highest_degree_ever selfEmployedJobMain selfEmployedJobCurrent indJobMain indJobCurrent occJobMain occJobCurrent long_miss_flag max_nonmissing_int_year lastValidSchoolDate

label values HHsize1997 .

foreach x of local months {
    assert other`x'==0             if activity`x'==1
    assert RECALLotherRecall`x'==0 if RECALLactivityRecall`x'==1
}

* reshape to monthly data
reshape long enrCollege enr2yr enr4yr enrGradSch enrK12 weeksWrk weeksSelfEmployed avgHrsWrk monthlyHrsWrk wage wageAlt wageMedian wageAltMedian comp compAlt compMedian compAltMedian weeksMilitary workFT workPT atWork workSch workK12 workCollege military other activity RECALLworkFTRecall RECALLworkPTRecall RECALLworkRecall RECALLworkSchRecall RECALLworkK12Recall RECALLworkCollegeRecall RECALLmilitaryRecall RECALLotherRecall RECALLactivityRecall , string i(id year) j(month)
ren hgcIn          hgc
ren atWork       work

ren RECALLworkFTRecall      workFTRecall      
ren RECALLworkPTRecall      workPTRecall      
ren RECALLmilitaryRecall    militaryRecall    
ren RECALLworkRecall        workRecall        
ren RECALLworkSchRecall     workSchRecall     
ren RECALLworkK12Recall     workK12Recall     
ren RECALLworkCollegeRecall workCollegeRecall 
ren RECALLotherRecall       otherRecall      
ren RECALLactivityRecall    activityRecall

ren weeksWrk       weeksWorked 
ren avgHrsWrk      avgHrs 
ren monthlyHrsWrk  hoursWorked 
ren WageJobCurrent wageJobCurrent
ren WageJobMain    wageJobMain
ren CompJobCurrent compJobCurrent
ren CompJobMain    compJobMain

foreach x of local months {
    assert other==0       if activity==1
    assert otherRecall==0 if activityRecall==1
}

* convert string month variable to numeric
generat month_num = .
replace month_num = 1  if month=="Jan"
replace month_num = 2  if month=="Feb"
replace month_num = 3  if month=="Mar"
replace month_num = 4  if month=="Apr"
replace month_num = 5  if month=="May"
replace month_num = 6  if month=="Jun"
replace month_num = 7  if month=="Jul"
replace month_num = 8  if month=="Aug"
replace month_num = 9  if month=="Sep"
replace month_num = 10 if month=="Oct"
replace month_num = 11 if month=="Nov"
replace month_num = 12 if month=="Dec"
drop month
ren month_num month
sort id year month

* label months with value label
lab def vlMonth 1 "Jan" 2 "Feb" 3 "Mar" 4 "Apr" 5 "May" 6 "Jun" 7 "Jul" 8 "Aug" 9 "Sep" 10 "Oct" 11 "Nov" 12 "Dec"
lab val month vlMonth

* rename to be CPS variables
ren wageJobCurrent         wageJobCPS
ren compJobCurrent         compJobCPS
ren occJobCurrent          occJobCPS
ren indJobCurrent          indJobCPS
ren selfEmployedJobCurrent selfEmployedJobCPS

* convert our annualized age variable to a monthly basis
*  need to assure that it stays sorted in the current order
sort id year month
generat sorter = _n
generat ageYr = year-birthYear
generat ageMo = month-birthMonth
replace ageYr = ageYr-1 if ageMo<0
drop ageMo
bys id ageYr (sorter): gen ageMo = [_n-1]
drop age sorter
ren ageYr age

* drop people outside of age ranges we want
keep if inrange(age,13,.)

* set the panel
gen uniqueTime = age*100+ageMo+1
xtset id uniqueTime

* replace absorbing graduation dummies by new monthly basis:
ren gradGraduate gradGraduateAnnual
ren grad4yr      grad4yrAnnual
ren grad2yr      grad2yrAnnual
ren gradDiploma  gradDiplomaAnnual
ren gradGED      gradGEDAnnual
ren gradHS       gradHSAnnual

bys id: gen gradGraduate = (month>=Grad_month    & year==Grad_year   ) | (year>Grad_year   )
bys id: gen grad4yr      = (month>=BA_month      & year==BA_year     ) | (year>BA_year     )
bys id: gen grad2yr      = (month>=AA_month      & year==AA_year     ) | (year>AA_year     )
bys id: gen gradDiploma  = (month>=Diploma_month & year==Diploma_year) | (year>Diploma_year)
bys id: gen gradGED      = (month>=GED_month     & year==GED_year    ) | (year>GED_year    )
        gen gradHS       =  max(gradGED,gradDiploma)

* impute highest grade completed on a monthly basis
* do hgc_monthly_impute.do // this file was not updated with Round 15 update because we don't end up using hgc in any of the final estimations

* impute people as being in HS if they were 13 and not initially classified as HS, but eventually graduated HS
bys id: egen everHS = max(gradHS)
replace other    = 0 if other==1 & activity==6 & age==13 & everHS==1 & month~=6 & month~=7 & month~=8
replace activity = 1 if            activity==6 & age==13 & everHS==1 & month~=6 & month~=7 & month~=8
replace other    = 0 if other==1 & activity==6 & age==14 & everHS==1 & month~=6 & month~=7 & month~=8
replace activity = 1 if            activity==6 & age==14 & everHS==1 & month~=6 & month~=7 & month~=8

* impute SOME people as being in HS if they were 13 and not initially classified as HS, but never gradHS
replace other    = 0 if activity==6 & other==1 & age==13 & month~=6 & month~=7 & month~=8 & (id==46 | id==343 | id==344 | id==345 | id==2142 | id==3033 | id==4225 | id==5282 | id==5447 | id==6219 | id==6345 | id==6659 | id==7000)
replace activity = 1 if activity==6            & age==13 & month~=6 & month~=7 & month~=8 & (id==46 | id==343 | id==344 | id==345 | id==2142 | id==3033 | id==4225 | id==5282 | id==5447 | id==6219 | id==6345 | id==6659 | id==7000)

* replace enrK12 if activity==1 | activity==2 but enrK12==0
replace enrK12     = 1 if enrK12==0 & enrCollege==0 & (activity==1 | activity==2) & age<18
replace enrK12     = 1 if enrK12==0 & enrCollege==0 & (activity==1 | activity==2) & age>17 & gradHS==0
replace enrCollege = 1 if enrK12==0 & enrCollege==0 & (activity==1 | activity==2) & age>17 & gradHS==1
* replace workK12    = 1 if activity==2 & gradHS==0
* replace enrK12     = 1 if workK12 & ~enrK12
* replace enrCollege = 1 if workCollege & ~enrCollege

count if activity==1 & other

compress
save y97_all_balanced.dta, replace
!zip -m y97_all_balanced.dta.zip y97_all_balanced.dta

*=================================================
* Frequency stats and droppings
*=================================================
xtset id uniqueTime
xtsum id if inrange(year,1997,2016)
xtsum id if inrange(age,16,36) & female==0 
xtsum id if inrange(age,16,36) & female==0 & mixed==0

* -------------------------------------------------------------------------
* get number of people in each birth cohort for potential survey definition
* -------------------------------------------------------------------------

* If t0=13:
* yob    ages_interviewed  #ints (years) by 36  # ints (years) when incorporating retrospective info
* -------------------------------------------------------------------------------------------
* 84        12~31                19                 19
* 83        13~32                20                 20
* 82        14~33                20                 21
* 81        15~34                20                 22
* 80        16~35                20                 23

* If t0=16:
* yob    ages_interviewed  #ints (years) by 36  # ints (years) when incorporating retrospective info
* -------------------------------------------------------------------------------------------
* 84        12~31                16                 16
* 83        13~32                17                 17
* 82        14~33                18                 18
* 81        15~34                19                 29
* 80        16~35                20                 21

bys id (uniqueTime): gen firstPer = _n==1
tab birthYear if female==0 & mixed==0 & firstPer

* * If t0=13
* generat numPotentialSurveys = 0
* replace numPotentialSurveys = 14 if birthYear==1984 & firstPer & female==0 & mixed==0
* replace numPotentialSurveys = 15 if birthYear==1983 & firstPer & female==0 & mixed==0
* replace numPotentialSurveys = 15 if birthYear==1982 & firstPer & female==0 & mixed==0
* replace numPotentialSurveys = 14 if birthYear==1981 & firstPer & female==0 & mixed==0
* replace numPotentialSurveys = 13 if birthYear==1980 & firstPer & female==0 & mixed==0

* If t0=16
generat numPotentialSurveys = 0
replace numPotentialSurveys = 16 if birthYear==1984 & firstPer & female==0 & mixed==0
replace numPotentialSurveys = 17 if birthYear==1983 & firstPer & female==0 & mixed==0
replace numPotentialSurveys = 18 if birthYear==1982 & firstPer & female==0 & mixed==0
replace numPotentialSurveys = 19 if birthYear==1981 & firstPer & female==0 & mixed==0
replace numPotentialSurveys = 20 if birthYear==1980 & firstPer & female==0 & mixed==0

sum numPotentialSurveys if firstPer & female==0 & mixed==0

generat totPotentialSurveysObs = sum(numPotentialSurveys)
l totPotentialSurveysObs if _n==_N

* * If t0=13
* generat numPotentialSurveysPlusRetro = 0
* replace numPotentialSurveysPlusRetro = 14 if birthYear==1984 & firstPer & female==0 & mixed==0
* replace numPotentialSurveysPlusRetro = 15 if birthYear==1983 & firstPer & female==0 & mixed==0
* replace numPotentialSurveysPlusRetro = 16 if birthYear==1982 & firstPer & female==0 & mixed==0
* replace numPotentialSurveysPlusRetro = 16 if birthYear==1981 & firstPer & female==0 & mixed==0
* replace numPotentialSurveysPlusRetro = 16 if birthYear==1980 & firstPer & female==0 & mixed==0

* If t0=16
generat numPotentialSurveysPlusRetro = 0
replace numPotentialSurveysPlusRetro = 16 if birthYear==1984 & firstPer & female==0 & mixed==0
replace numPotentialSurveysPlusRetro = 17 if birthYear==1983 & firstPer & female==0 & mixed==0
replace numPotentialSurveysPlusRetro = 18 if birthYear==1982 & firstPer & female==0 & mixed==0
replace numPotentialSurveysPlusRetro = 19 if birthYear==1981 & firstPer & female==0 & mixed==0
replace numPotentialSurveysPlusRetro = 21 if birthYear==1980 & firstPer & female==0 & mixed==0

sum numPotentialSurveysPlusRetro if firstPer & female==0 & mixed==0

generat totPotentialSurveysPlusRetroObs = sum(numPotentialSurveysPlusRetro)
l totPotentialSurveysPlusRetroObs if _n==_N

* drop mixed race and recode race to be consistent with 79
drop race
gen race = .
replace race = 1 if white==1
replace race = 2 if black==1
replace race = 3 if hispanic==1
replace race = 4 if mixed==1
label define vlrace_true 1 "White" 2 "Black" 3 "Hispanic" 4 "Mixed"
lab val race vlrace_true
drop if mixed==1
xtsum id if female==0

* drop months for people after R17 interview date
drop if R17interviewDate<=ym(year,month) & ~mi(R17interviewDate)
* xtsum id if female==0 // if t0=13
xtsum id if inrange(age,16,36) & female==0 // if t0=16

* drop months for people after last valid interview date
gen yrmo = year*100+month
gen yrmo_last = year(last_int_day)*100+month(last_int_day)
drop if yrmo>=yrmo_last
* xtsum id if female==0 // if t0=13
xtsum id if inrange(age,16,36) & female==0 // if t0=16

* xtsum id if female==0 & ageMo==0 // if t0=13
xtsum id if female==0 & ageMo==0 & inrange(age,16,36)

* drop everything after the beginning of long missed interview spells
drop if long_miss_flag
* xtsum id if female==0 // if t0=13
xtsum id if inrange(age,16,36) & female==0 // if t0=16

* drop right-censored interview spells
tab max_nonmissing_int_year year if year>=2011
keep if year<=max_nonmissing_int_year
xtsum id if inrange(age,16,36) & female==0
xtsum id if inrange(age,16,36) & female==0 & mixed~=1 & ~long_miss_flag & year<=max_nonmissing_int_year

* drop observations after someone "illegally" went to college (without a Diploma)
drop if mdy(month,1,year)>=lastValidSchoolDate
xtsum id if inrange(age,16,36) & female==0
xtsum id if inrange(age,16,36) & female==0 & mixed~=1 & ~long_miss_flag & year<=max_nonmissing_int_year

preserve
    collapse (count) n=ageMo if inrange(age,16,36) & female==0 & mixed~=1 & ~long_miss_flag & year<=max_nonmissing_int_year, by(id)
    sum n, d
restore

* cohort graph to put in appendix
table age year birthYear if ageMo==0

*--------------------------------------------------
* Graph the choice shares by age and caldendar time
*--------------------------------------------------
generate caldate = ym(year,month)
preserve
    format caldate  %tm
    gen tempy = 1
    collapse (count) tempy, by(activity caldate)
    xtset activity caldate
    fillin activity caldate
    drop _fillin
    recode tempy (. = 0)
    sort caldate activity
    
    * collapse sum(tempy), by(activity caldate) ????
    
    *----------------------------------------------------------------
    * Create pct variables for total degrees and education degrees
    *  as well as cumulative pct and total/1000
    *----------------------------------------------------------------
    foreach X in tempy {
        bys caldate: egen `X'_denom = total(`X')
        gen `X'_pct = `X'/`X'_denom
    }
    
    * Adjust pct variables so that they can be in an area plot
    foreach X in tempy {
        * Order in area graph (top2bottom): public, non-profit, for-profit
        gen `X'_pct2 = .
        bys caldate (activity): replace `X'_pct2 = `X'_pct[1] + `X'_pct[2] + `X'_pct[3] + `X'_pct[4] + `X'_pct[5] + `X'_pct[6] if activity==6
        bys caldate (activity): replace `X'_pct2 = `X'_pct[1] + `X'_pct[2] + `X'_pct[3] + `X'_pct[4] + `X'_pct[5]              if activity==5
        bys caldate (activity): replace `X'_pct2 = `X'_pct[1] + `X'_pct[2] + `X'_pct[3] + `X'_pct[4]                           if activity==4
        bys caldate (activity): replace `X'_pct2 = `X'_pct[1] + `X'_pct[2] + `X'_pct[3]                                        if activity==3
        bys caldate (activity): replace `X'_pct2 = `X'_pct[1] + `X'_pct[2]                                                     if activity==2
        bys caldate (activity): replace `X'_pct2 = `X'_pct[1]                                                                  if activity==1
    }
    
    twoway  (area tempy_pct2 caldate if activity==6, lcolor(midblue) fcolor(eltblue) lwidth(vthin) ) (area tempy_pct2 caldate if activity==5, lcolor(midgreen) fcolor(eltgreen) lwidth(vthin) ) (area tempy_pct2 caldate if activity==4, lcolor(cranberry) fcolor(erose) lwidth(vthin)) (area tempy_pct2 caldate if activity==3, lcolor(dknavy) fcolor(edkblue) lwidth(vthin) ) (area tempy_pct2 caldate if activity==2, lcolor(sand) fcolor(sandb) lwidth(vthin) ) (area tempy_pct2 caldate if activity==1, lcolor(brown) fcolor(stone) lwidth(vthin) )   ,legend(order(6 "{stSerif:School Only}" 5 "{stSerif:Work in School}" 4 "{stSerif:Work PT}" 3 "{stSerif:Work FT}" 2 "{stSerif:Military}" 1 "{stSerif:Other}") rows(2) ) title( "") ytitle( "{stSerif:Probability}") xtitle( "{stSerif:Date}")  xlabel(,format(%tm)) graphregion(fcolor(white) lcolor(white)) note( "{stSerif:Source: NLSY97}")
    graph export choiceSharesMonthly.eps, replace
restore

preserve
    gen monthAlt = ( month-(birthMonth-1) )*( year-age==birthYear ) + ( month+(12-birthMonth+1) )*( year-age==birthYear+1  )
    gen yearmo = year*100+month
    gen agemo  =  age*100+monthAlt
    gen tempy = 1
    collapse (count) tempy, by(activity agemo)
    xtset activity agemo
    fillin activity agemo
    drop _fillin
    recode tempy (. = 0)
    sort agemo activity
    *----------------------------------------------------------------
    * Create pct variables for total degrees and education degrees
    *  as well as cumulative pct and total/1000
    *----------------------------------------------------------------
    foreach X in tempy {
        bys agemo: egen `X'_denom = total(`X')
        gen `X'_pct = `X'/`X'_denom
    }
    
    * Adjust pct variables so that they can be in an area plot
    foreach X in tempy {
        * Order in area graph (top2bottom): public, non-profit, for-profit
        gen `X'_pct2 = .
        bys agemo (activity): replace `X'_pct2 = `X'_pct[1] + `X'_pct[2] + `X'_pct[3] + `X'_pct[4] + `X'_pct[5] + `X'_pct[6] if activity==6
        bys agemo (activity): replace `X'_pct2 = `X'_pct[1] + `X'_pct[2] + `X'_pct[3] + `X'_pct[4] + `X'_pct[5]              if activity==5
        bys agemo (activity): replace `X'_pct2 = `X'_pct[1] + `X'_pct[2] + `X'_pct[3] + `X'_pct[4]                           if activity==4
        bys agemo (activity): replace `X'_pct2 = `X'_pct[1] + `X'_pct[2] + `X'_pct[3]                                        if activity==3
        bys agemo (activity): replace `X'_pct2 = `X'_pct[1] + `X'_pct[2]                                                     if activity==2
        bys agemo (activity): replace `X'_pct2 = `X'_pct[1]                                                                  if activity==1
    }
    
    /* * Add var to add vline
    gen liner1 = .
    gen liner2 = .
    gen liner3 = .
    replace liner1 = 1600 if year==2003
    replace liner2 = 400 if year==2003
    replace liner3 = 100 if year==2003

    gen nclb = "NCLB" */
    
    replace agemo = agemo/100
    
    twoway  (area tempy_pct2 agemo if activity==6, lcolor(midblue) fcolor(eltblue) lwidth(vthin) ) (area tempy_pct2 agemo if activity==5, lcolor(midgreen) fcolor(eltgreen) lwidth(vthin) ) (area tempy_pct2 agemo if activity==4, lcolor(cranberry) fcolor(erose) lwidth(vthin)) (area tempy_pct2 agemo if activity==3, lcolor(dknavy) fcolor(edkblue) lwidth(vthin) ) (area tempy_pct2 agemo if activity==2, lcolor(sand) fcolor(sandb) lwidth(vthin) ) (area tempy_pct2 agemo if activity==1, lcolor(brown) fcolor(stone) lwidth(vthin) )   ,legend(order(6 "{stSerif:School Only}" 5 "{stSerif:Work in School}" 4 "{stSerif:Work PT}" 3 "{stSerif:Work FT}" 2 "{stSerif:Military}" 1 "{stSerif:Other}") rows(2) ) title( "") ytitle( "{stSerif:Probability}") xtitle( "{stSerif:Age}") xlabel(13(2)36) graphregion(fcolor(white) lcolor(white)) note( "{stSerif:Source: NLSY97}")
    graph export choiceSharesMonthlyAge.eps, replace
restore

compress
save y97_all.dta, replace
!zip -m y97_all.dta.zip y97_all.dta

log close

