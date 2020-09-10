version 11.1
clear all
set more off
capture log close
capture cd "/afs/econ.duke.edu/data/vjh3/WageReturns/Data/y79"
* capture cd        "C:\Dropbox\School\Hotz\SchooltoWork\REStat_Update\Data"

set mem 3g
set maxvar 20000

log using "y79_create_trim.log", replace

**************************************************
* Keep and rename vars and obs
**************************************************
!unzip -u y79_master.dta.zip
use y79_master.dta, clear
!rm y79_master.dta

* Rename certain variables
rename dob_yr          birthYear
rename dob_mo          birthMonth
rename family_size1979 HHsize1979
rename grade_current   gradeCurrent

* Keep relevant variables and observations
* local keep_demo    id year age birthMonth birthYear female white black hispanic race region weight oversampleRace annualHrsWrk missInt afqt m_afqt hgcMoth m_hgcMoth hgcFath m_hgcFath foreignBorn famInc1978 m_famInc1978 liveWithMom14 femaleHeadHH14 HHsize1979 born1961 born1962 born1963 born1964 ageAtMissInt yearMissInt everMissInt missIntCum missIntLength everMiss3plusInt missIntLastSpell everReturnAfter3plusMissInt fedMinWage cpi
* local keep_school  hgc gradeCurrent enrSchool monthsSchool enrK12 monthsK12 enrCollege monthsCollege gradDiploma gradHS grad2yr grad4yr gradGraduate enrK12Jan-enrK12Dec enrCollegeJan-enrCollegeDec
* local keep_work    annualWeeksWorked weeksWorked??? hoursWorked??? avgHrs??? weeksMilitary??? workFT??? workPT??? work??? workSch??? workK12??? workCollege??? military??? other??? activity??? weeksLabForce weeksMilitary wageMean??? wageMedian??? annualWageMean annualWageMed annualWageMin annualWageMax annualWageMain annualOccMin annualOccMax annualOccMain annualIndMin annualIndMax annualIndMain 
* keep `keep_demo' `keep_school' `keep_work'

sort id year

label var id               "Person ID"
label var year             "Year of Survey"
label var age              "Age as of Jan 1 of current year"
label var birthMonth       "Birth month"
label var birthYear        "Birth year"
label var female           "Female"
label var white            "White indicator"
label var black            "Black indicator"
label var hispanic         "Hispanic indicator"
label var race             "Race from Screener (Mixed dropped in 97)"
label var region           "Census Region at Interview Date"
label var weight           "Weight - Cross-Sectional weight from first year of Survey"
label var oversampleRace   "Dummy: 1=oversample; 0=cross-sectional"
label var annualHrsWrk     "Hours worked in calendar year t across all jobs"
label var missInt          "Missed Interview In Current Year"
label var afqt               "Standardized AFQT (Altonji et al.)"
label var asvabAR            "Standardized ASVAB Arithmetic Reasoning    (AR) Subtest (Altonji et al.)"
label var asvabCS            "Standardized ASVAB Coding Speed            (CS) Subtest (Altonji et al.)"
label var asvabMK            "Standardized ASVAB Mathematics Knowledge   (MK) Subtest (Altonji et al.)"
label var asvabNO            "Standardized ASVAB Numerical Operations    (NO) Subtest (Altonji et al.)"
label var asvabPC            "Standardized ASVAB Paragraph Comprehension (PC) Subtest (Altonji et al.)"
label var asvabWK            "Standardized ASVAB Word Knowledge          (WK) Subtest (Altonji et al.)"
label var m_afqt	           "Missing AFQT"                              
label var m_asvabAR          "Missing ASVAB Arithmetic Reasoning    (AR)"
label var m_asvabCS          "Missing ASVAB Coding Speed            (CS)"
label var m_asvabMK          "Missing ASVAB Mathematics Knowledge   (MK)"
label var m_asvabNO          "Missing ASVAB Numerical Operations    (NO)"
label var m_asvabPC          "Missing ASVAB Paragraph Comprehension (PC)"
label var m_asvabWK          "Missing ASVAB Word Knowledge          (WK)"
label var hgcMoth          "Mother's HGC"
label var m_hgcMoth        "Missing Mother's HGC"
label var hgcFath          "Father's HGC"
label var m_hgcFath        "Missing Father's HGC"
label var foreignBorn      "Born outside of the US"
label var famInc1978       "(Real) Family Income in 1978"
label var m_famInc1978     "Missing Family Income in 1978"
label var liveWithMom14    "Live with mother at age 14"
label var femaleHeadHH14   "Female headed household at age 14"
label var HHsize1979       "Household Size in 1979"
label var born1957         "Born in year 1957 dummy"
label var born1958         "Born in year 1958 dummy"
label var born1959         "Born in year 1959 dummy"
label var born1960         "Born in year 1960 dummy"
label var born1961         "Born in year 1961 dummy"
label var born1962         "Born in year 1962 dummy"
label var born1963         "Born in year 1963 dummy"
label var born1964         "Born in year 1964 dummy"
label var ageAtMissInt     "Age * Miss Int dummy"
label var yearMissInt      "Year * Miss Int dummy"
label var everMissInt      "Ever miss an interview"
label var missIntCum       "Running Tally Of Current Missed Interview Spell"
label var missIntLength    "Length Of Current Missed Interview Spell"
label var everMiss3plusInt "Ever miss 3+ consecutive interviews"
label var everReturnAfter3plusMissInt "Ever return after missing 3+ consecutive interviews"
label var fedMinWage       "Federal Minimum Wage, $1982-84"
label var cpi              "Consumer Price Index (CPI) $1982-84"

label var hgc              "HGC as of survey date"
label var gradeCurrent     "Current Grade Attending"
label var enrSchool        "Ever enrolled in any school in calendar year t"
label var monthsSchool     "Months enrolled in any school in calendar year t"
label var enrK12           "Ever enrolled in K12 in calendar year t"
label var monthsK12        "Months enrolled in K12 in calendar year t"
label var enrCollege       "Ever enrolled in College in calendar year t"
label var monthsCollege    "Months enrolled in College in calendar year t"
label var gradHS           "Absorbing dummy for having graduated HS by year t"
label var grad2yr          "Absorbing dummy for having competed 2 yr degree by year t"
label var grad4yr          "Absorbing dummy for having competed 4 yr degree by year t"
label var gradGraduate     "Absorbing dummy for having competed graduate degree by year t"
label var enrK12Jan        "Enrolled in K12 in Jan of Survey Year"
label var enrK12Feb        "Enrolled in K12 in Feb of Survey Year"
label var enrK12Mar        "Enrolled in K12 in Mar of Survey Year"
label var enrK12Apr        "Enrolled in K12 in Apr of Survey Year"
label var enrK12May        "Enrolled in K12 in May of Survey Year"
label var enrK12Jun        "Enrolled in K12 in Jun of Survey Year"
label var enrK12Jul        "Enrolled in K12 in Jul of Survey Year"
label var enrK12Aug        "Enrolled in K12 in Aug of Survey Year"
label var enrK12Sep        "Enrolled in K12 in Sep of Survey Year"
label var enrK12Oct        "Enrolled in K12 in Oct of Survey Year"
label var enrK12Nov        "Enrolled in K12 in Nov of Survey Year"
label var enrK12Dec        "Enrolled in K12 in Dec of Survey Year"
label var enrCollegeJan    "Enrolled in College in Jan of Survey Year"
label var enrCollegeFeb    "Enrolled in College in Feb of Survey Year"
label var enrCollegeMar    "Enrolled in College in Mar of Survey Year"
label var enrCollegeApr    "Enrolled in College in Apr of Survey Year"
label var enrCollegeMay    "Enrolled in College in May of Survey Year"
label var enrCollegeJun    "Enrolled in College in Jun of Survey Year"
label var enrCollegeJul    "Enrolled in College in Jul of Survey Year"
label var enrCollegeAug    "Enrolled in College in Aug of Survey Year"
label var enrCollegeSep    "Enrolled in College in Sep of Survey Year"
label var enrCollegeOct    "Enrolled in College in Oct of Survey Year"
label var enrCollegeNov    "Enrolled in College in Nov of Survey Year"
label var enrCollegeDec    "Enrolled in College in Dec of Survey Year"
label var enrGradSchJan    "Enrolled in GradSch in Jan of Survey Year"
label var enrGradSchFeb    "Enrolled in GradSch in Feb of Survey Year"
label var enrGradSchMar    "Enrolled in GradSch in Mar of Survey Year"
label var enrGradSchApr    "Enrolled in GradSch in Apr of Survey Year"
label var enrGradSchMay    "Enrolled in GradSch in May of Survey Year"
label var enrGradSchJun    "Enrolled in GradSch in Jun of Survey Year"
label var enrGradSchJul    "Enrolled in GradSch in Jul of Survey Year"
label var enrGradSchAug    "Enrolled in GradSch in Aug of Survey Year"
label var enrGradSchSep    "Enrolled in GradSch in Sep of Survey Year"
label var enrGradSchOct    "Enrolled in GradSch in Oct of Survey Year"
label var enrGradSchNov    "Enrolled in GradSch in Nov of Survey Year"
label var enrGradSchDec    "Enrolled in GradSch in Dec of Survey Year"

label var annualWeeksWorked "Number of weeks of calendar year t spent working for an employer"
label var weeksLabForce    "Number of weeks of calendar year t spent in the labor force"
label var annualWageMean   "Average wage (either pay or compensation) weighted by weeks worked in calendar year"
label var annualWageMed    "Median wage (either pay or compensation) across all jobs in calendar year t"
label var annualWageMin    "Lowest wage (either pay or compensation) across all jobs in calendar year t"
label var annualWageMax    "Highest wage (either pay or compensation) across all jobs in calendar year t"
label var annualWageMain   "Wage at main job in calendar year t"
label var annualOccMin     "Occupation of the lowest-wage job in calendar year t"
label var annualOccMax     "Occupation of the highest-wage job in calendar year t"
label var annualOccMain    "Occupation of the main job in calendar year t"
label var annualIndMin     "Industry of the lowest-wage job in calendar year t"
label var annualIndMax     "Industry of the highest-wage job in calendar year t"
label var annualIndMain    "Industry of the main job in calendar year t"
label var weeksWorkedJan   "Weeks Worked in Jan of calendar year t"
label var weeksWorkedFeb   "Weeks Worked in Feb of calendar year t"
label var weeksWorkedMar   "Weeks Worked in Mar of calendar year t"
label var weeksWorkedApr   "Weeks Worked in Apr of calendar year t"
label var weeksWorkedMay   "Weeks Worked in May of calendar year t"
label var weeksWorkedJun   "Weeks Worked in Jun of calendar year t"
label var weeksWorkedJul   "Weeks Worked in Jul of calendar year t"
label var weeksWorkedAug   "Weeks Worked in Aug of calendar year t"
label var weeksWorkedSep   "Weeks Worked in Sep of calendar year t"
label var weeksWorkedOct   "Weeks Worked in Oct of calendar year t"
label var weeksWorkedNov   "Weeks Worked in Nov of calendar year t"
label var weeksWorkedDec   "Weeks Worked in Dec of calendar year t"
label var weeksSelfEmployedJan   "Weeks Self-Employed in Jan of calendar year t"
label var weeksSelfEmployedFeb   "Weeks Self-Employed in Feb of calendar year t"
label var weeksSelfEmployedMar   "Weeks Self-Employed in Mar of calendar year t"
label var weeksSelfEmployedApr   "Weeks Self-Employed in Apr of calendar year t"
label var weeksSelfEmployedMay   "Weeks Self-Employed in May of calendar year t"
label var weeksSelfEmployedJun   "Weeks Self-Employed in Jun of calendar year t"
label var weeksSelfEmployedJul   "Weeks Self-Employed in Jul of calendar year t"
label var weeksSelfEmployedAug   "Weeks Self-Employed in Aug of calendar year t"
label var weeksSelfEmployedSep   "Weeks Self-Employed in Sep of calendar year t"
label var weeksSelfEmployedOct   "Weeks Self-Employed in Oct of calendar year t"
label var weeksSelfEmployedNov   "Weeks Self-Employed in Nov of calendar year t"
label var weeksSelfEmployedDec   "Weeks Self-Employed in Dec of calendar year t"
* label var avgHrsWrk        "Annual Hours Worked / Weeks Employed, where N/0 = 0"
label var weeksMilitary    "Number of weeks of calendar year t spent in the military"

label var wageJobCPS          "Wage of CPS job (job_current) in calendar year t"
label var wageJobMain         "Wage of 'Main' job (Boehm) in calendar year t"
label var occJobCPS           "Occupation of CPS job (job_current) in calendar year t"
label var occJobMain          "Occupation of 'Main' job (Boehm) in calendar year t"
label var indJobCPS           "Industry of CPS job (job_current) in calendar year t"
label var indJobMain          "Industry of 'Main' job (Boehm) in calendar year t"
label var hoursJobCPS         "Weekly hours of CPS job (job_current) in calendar year t"
label var hoursJobMain        "Weekly hours of 'Main' job (Boehm) in calendar year t"
label var selfEmployedJobCPS  "Self-employed status of CPS job (job_current) in calendar year t"
label var selfEmployedJobMain "Self-employed status of 'Main' job (Boehm) in calendar year t"

local months "Jan Feb Mar Apr May Jun Jul Aug Sep Oct Nov Dec"
foreach month in `months' {
	ren work`month'       atWork`month'
	
	ren workFTRecall`month'      RECALLworkFTRecall`month'      
	ren workPTRecall`month'      RECALLworkPTRecall`month'      
	ren militaryRecall`month'    RECALLmilitaryRecall`month'    
	ren workRecall`month'        RECALLworkRecall`month'        
	ren workSchRecall`month'     RECALLworkSchRecall`month'     
	ren workK12Recall`month'     RECALLworkK12Recall`month'     
	ren workCollegeRecall`month' RECALLworkCollegeRecall`month' 
	ren otherRecall`month'       RECALLotherRecall`month'       
	ren activityRecall`month'    RECALLactivityRecall`month'    
	ren workGradSchRecall`month' RECALLworkGradSchRecall`month'
}

keep  id year age birthMonth birthYear white black hispanic liveWithMom14 race HHsize1979 region weight oversamplePoor oversampleMilitary oversampleRace annualHrsWrk gradeCurrent missInt afqt asvabAR asvabCS asvabMK asvabNO asvabPC asvabWK m_afqt m_asvabAR m_asvabCS m_asvabMK m_asvabNO m_asvabPC m_asvabWK female hgc hgcMoth m_hgcMoth hgcFath m_hgcFath foreignBorn famInc1978 m_famInc1978 femaleHeadHH14 born1957 born1958 born1959 born1960 born1961 born1962 born1963 born1964 ageAtMissInt yearMissInt everMissInt missIntCum missIntLength everMiss3plusInt everReturnAfter3plusMissInt missIntLastSpell fedMinWage cpi enrK12Jan enrK12Feb enrK12Mar enrK12Apr enrK12May enrK12Jun enrK12Jul enrK12Aug enrK12Sep enrK12Oct enrK12Nov enrK12Dec enrCollegeJan enrCollegeFeb enrCollegeMar enrCollegeApr enrCollegeMay enrCollegeJun enrCollegeJul enrCollegeAug enrCollegeSep enrCollegeOct enrCollegeNov enrCollegeDec enrGradSchJan enrGradSchFeb enrGradSchMar enrGradSchApr enrGradSchMay enrGradSchJun enrGradSchJul enrGradSchAug enrGradSchSep enrGradSchOct enrGradSchNov enrGradSchDec monthsGradSch monthsCollege monthsK12 annualWeeksWorked weeksLabForce annualWageMean annualWageMed annualWageMin annualWageMax annualWageMain wageMeanJan wageMeanFeb wageMeanMar wageMeanApr wageMeanMay wageMeanJun wageMeanJul wageMeanAug wageMeanSep wageMeanOct wageMeanNov wageMeanDec wageAltMeanJan wageAltMeanFeb wageAltMeanMar wageAltMeanApr wageAltMeanMay wageAltMeanJun wageAltMeanJul wageAltMeanAug wageAltMeanSep wageAltMeanOct wageAltMeanNov wageAltMeanDec wageMedianJan wageMedianFeb wageMedianMar wageMedianApr wageMedianMay wageMedianJun wageMedianJul wageMedianAug wageMedianSep wageMedianOct wageMedianNov wageMedianDec wageAltMedianJan wageAltMedianFeb wageAltMedianMar wageAltMedianApr wageAltMedianMay wageAltMedianJun wageAltMedianJul wageAltMedianAug wageAltMedianSep wageAltMedianOct wageAltMedianNov wageAltMedianDec annualOccMin annualOccMax annualOccMain annualIndMin annualIndMax annualIndMain weeksWorkedJan weeksWorkedFeb weeksWorkedMar weeksWorkedApr weeksWorkedMay weeksWorkedJun weeksWorkedJul weeksWorkedAug weeksWorkedSep weeksWorkedOct weeksWorkedNov weeksWorkedDec weeksSelfEmployedJan weeksSelfEmployedFeb weeksSelfEmployedMar weeksSelfEmployedApr weeksSelfEmployedMay weeksSelfEmployedJun weeksSelfEmployedJul weeksSelfEmployedAug weeksSelfEmployedSep weeksSelfEmployedOct weeksSelfEmployedNov weeksSelfEmployedDec avgHrsJan avgHrsFeb avgHrsMar avgHrsApr avgHrsMay avgHrsJun avgHrsJul avgHrsAug avgHrsSep avgHrsOct avgHrsNov avgHrsDec hoursWorkedJan hoursWorkedFeb hoursWorkedMar hoursWorkedApr hoursWorkedMay hoursWorkedJun hoursWorkedJul hoursWorkedAug hoursWorkedSep hoursWorkedOct hoursWorkedNov hoursWorkedDec weeksMilitaryJan weeksMilitaryFeb weeksMilitaryMar weeksMilitaryApr weeksMilitaryMay weeksMilitaryJun weeksMilitaryJul weeksMilitaryAug weeksMilitarySep weeksMilitaryOct weeksMilitaryNov weeksMilitaryDec workFTJan workFTFeb workFTMar workFTApr workFTMay workFTJun workFTJul workFTAug workFTSep workFTOct workFTNov workFTDec workPTJan workPTFeb workPTMar workPTApr workPTMay workPTJun workPTJul workPTAug workPTSep workPTOct workPTNov workPTDec militaryJan militaryFeb militaryMar militaryApr militaryMay militaryJun militaryJul militaryAug militarySep militaryOct militaryNov militaryDec atWorkJan atWorkFeb atWorkMar atWorkApr atWorkMay atWorkJun atWorkJul atWorkAug atWorkSep atWorkOct atWorkNov atWorkDec workSchJan workSchFeb workSchMar workSchApr workSchMay workSchJun workSchJul workSchAug workSchSep workSchOct workSchNov workSchDec workK12Jan workK12Feb workK12Mar workK12Apr workK12May workK12Jun workK12Jul workK12Aug workK12Sep workK12Oct workK12Nov workK12Dec workCollegeJan workCollegeFeb workCollegeMar workCollegeApr workCollegeMay workCollegeJun workCollegeJul workCollegeAug workCollegeSep workCollegeOct workCollegeNov workCollegeDec workGradSchJan workGradSchFeb workGradSchMar workGradSchApr workGradSchMay workGradSchJun workGradSchJul workGradSchAug workGradSchSep workGradSchOct workGradSchNov workGradSchDec otherJan otherFeb otherMar otherApr otherMay otherJun otherJul otherAug otherSep otherOct otherNov otherDec activityJan activityFeb activityMar activityApr activityMay activityJun activityJul activityAug activitySep activityOct activityNov activityDec RECALLworkFTRecallJan RECALLworkFTRecallFeb RECALLworkFTRecallMar RECALLworkFTRecallApr RECALLworkFTRecallMay RECALLworkFTRecallJun RECALLworkFTRecallJul RECALLworkFTRecallAug RECALLworkFTRecallSep RECALLworkFTRecallOct RECALLworkFTRecallNov RECALLworkFTRecallDec RECALLworkPTRecallJan RECALLworkPTRecallFeb RECALLworkPTRecallMar RECALLworkPTRecallApr RECALLworkPTRecallMay RECALLworkPTRecallJun RECALLworkPTRecallJul RECALLworkPTRecallAug RECALLworkPTRecallSep RECALLworkPTRecallOct RECALLworkPTRecallNov RECALLworkPTRecallDec RECALLmilitaryRecallJan RECALLmilitaryRecallFeb RECALLmilitaryRecallMar RECALLmilitaryRecallApr RECALLmilitaryRecallMay RECALLmilitaryRecallJun RECALLmilitaryRecallJul RECALLmilitaryRecallAug RECALLmilitaryRecallSep RECALLmilitaryRecallOct RECALLmilitaryRecallNov RECALLmilitaryRecallDec RECALLworkRecallJan RECALLworkRecallFeb RECALLworkRecallMar RECALLworkRecallApr RECALLworkRecallMay RECALLworkRecallJun RECALLworkRecallJul RECALLworkRecallAug RECALLworkRecallSep RECALLworkRecallOct RECALLworkRecallNov RECALLworkRecallDec RECALLworkSchRecallJan RECALLworkSchRecallFeb RECALLworkSchRecallMar RECALLworkSchRecallApr RECALLworkSchRecallMay RECALLworkSchRecallJun RECALLworkSchRecallJul RECALLworkSchRecallAug RECALLworkSchRecallSep RECALLworkSchRecallOct RECALLworkSchRecallNov RECALLworkSchRecallDec RECALLworkK12RecallJan RECALLworkK12RecallFeb RECALLworkK12RecallMar RECALLworkK12RecallApr RECALLworkK12RecallMay RECALLworkK12RecallJun RECALLworkK12RecallJul RECALLworkK12RecallAug RECALLworkK12RecallSep RECALLworkK12RecallOct RECALLworkK12RecallNov RECALLworkK12RecallDec RECALLworkCollegeRecallJan RECALLworkCollegeRecallFeb RECALLworkCollegeRecallMar RECALLworkCollegeRecallApr RECALLworkCollegeRecallMay RECALLworkCollegeRecallJun RECALLworkCollegeRecallJul RECALLworkCollegeRecallAug RECALLworkCollegeRecallSep RECALLworkCollegeRecallOct RECALLworkCollegeRecallNov RECALLworkCollegeRecallDec RECALLworkGradSchRecallJan RECALLworkGradSchRecallFeb RECALLworkGradSchRecallMar RECALLworkGradSchRecallApr RECALLworkGradSchRecallMay RECALLworkGradSchRecallJun RECALLworkGradSchRecallJul RECALLworkGradSchRecallAug RECALLworkGradSchRecallSep RECALLworkGradSchRecallOct RECALLworkGradSchRecallNov RECALLworkGradSchRecallDec RECALLotherRecallJan RECALLotherRecallFeb RECALLotherRecallMar RECALLotherRecallApr RECALLotherRecallMay RECALLotherRecallJun RECALLotherRecallJul RECALLotherRecallAug RECALLotherRecallSep RECALLotherRecallOct RECALLotherRecallNov RECALLotherRecallDec RECALLactivityRecallJan RECALLactivityRecallFeb RECALLactivityRecallMar RECALLactivityRecallApr RECALLactivityRecallMay RECALLactivityRecallJun RECALLactivityRecallJul RECALLactivityRecallAug RECALLactivityRecallSep RECALLactivityRecallOct RECALLactivityRecallNov RECALLactivityRecallDec gradGraduate yrGradGraduate grad4yr yrGrad4yr grad2yr yrGrad2yr gradHS yrGradHS gradDiploma yrGradDiploma gradGED yrGradGED annualHrsWrkCalc Grad_month BA_month AA_month Diploma_month GED_month HS_month Grad_year BA_year AA_year Diploma_year GED_year HS_year interview_date lastValidIntDate lastValidSchoolDate R*interviewDate wageJobCPS wageJobMain occJobCPS occJobMain indJobCPS indJobMain hoursJobCPS hoursJobMain selfEmployedJobCPS selfEmployedJobMain high_grade_comp_May yearEnteredUS
order id year age birthMonth birthYear white black hispanic liveWithMom14 race HHsize1979 region weight oversamplePoor oversampleMilitary oversampleRace annualHrsWrk gradeCurrent missInt afqt asvabAR asvabCS asvabMK asvabNO asvabPC asvabWK m_afqt m_asvabAR m_asvabCS m_asvabMK m_asvabNO m_asvabPC m_asvabWK female hgc hgcMoth m_hgcMoth hgcFath m_hgcFath foreignBorn famInc1978 m_famInc1978 femaleHeadHH14 born1957 born1958 born1959 born1960 born1961 born1962 born1963 born1964 ageAtMissInt yearMissInt everMissInt missIntCum missIntLength everMiss3plusInt everReturnAfter3plusMissInt missIntLastSpell fedMinWage cpi enrK12Jan enrK12Feb enrK12Mar enrK12Apr enrK12May enrK12Jun enrK12Jul enrK12Aug enrK12Sep enrK12Oct enrK12Nov enrK12Dec enrCollegeJan enrCollegeFeb enrCollegeMar enrCollegeApr enrCollegeMay enrCollegeJun enrCollegeJul enrCollegeAug enrCollegeSep enrCollegeOct enrCollegeNov enrCollegeDec enrGradSchJan enrGradSchFeb enrGradSchMar enrGradSchApr enrGradSchMay enrGradSchJun enrGradSchJul enrGradSchAug enrGradSchSep enrGradSchOct enrGradSchNov enrGradSchDec monthsGradSch monthsCollege monthsK12 annualWeeksWorked weeksLabForce annualWageMean annualWageMed annualWageMin annualWageMax annualWageMain wageMeanJan wageMeanFeb wageMeanMar wageMeanApr wageMeanMay wageMeanJun wageMeanJul wageMeanAug wageMeanSep wageMeanOct wageMeanNov wageMeanDec wageAltMeanJan wageAltMeanFeb wageAltMeanMar wageAltMeanApr wageAltMeanMay wageAltMeanJun wageAltMeanJul wageAltMeanAug wageAltMeanSep wageAltMeanOct wageAltMeanNov wageAltMeanDec wageMedianJan wageMedianFeb wageMedianMar wageMedianApr wageMedianMay wageMedianJun wageMedianJul wageMedianAug wageMedianSep wageMedianOct wageMedianNov wageMedianDec wageAltMedianJan wageAltMedianFeb wageAltMedianMar wageAltMedianApr wageAltMedianMay wageAltMedianJun wageAltMedianJul wageAltMedianAug wageAltMedianSep wageAltMedianOct wageAltMedianNov wageAltMedianDec annualOccMin annualOccMax annualOccMain annualIndMin annualIndMax annualIndMain weeksWorkedJan weeksWorkedFeb weeksWorkedMar weeksWorkedApr weeksWorkedMay weeksWorkedJun weeksWorkedJul weeksWorkedAug weeksWorkedSep weeksWorkedOct weeksWorkedNov weeksWorkedDec weeksSelfEmployedJan weeksSelfEmployedFeb weeksSelfEmployedMar weeksSelfEmployedApr weeksSelfEmployedMay weeksSelfEmployedJun weeksSelfEmployedJul weeksSelfEmployedAug weeksSelfEmployedSep weeksSelfEmployedOct weeksSelfEmployedNov weeksSelfEmployedDec avgHrsJan avgHrsFeb avgHrsMar avgHrsApr avgHrsMay avgHrsJun avgHrsJul avgHrsAug avgHrsSep avgHrsOct avgHrsNov avgHrsDec hoursWorkedJan hoursWorkedFeb hoursWorkedMar hoursWorkedApr hoursWorkedMay hoursWorkedJun hoursWorkedJul hoursWorkedAug hoursWorkedSep hoursWorkedOct hoursWorkedNov hoursWorkedDec weeksMilitaryJan weeksMilitaryFeb weeksMilitaryMar weeksMilitaryApr weeksMilitaryMay weeksMilitaryJun weeksMilitaryJul weeksMilitaryAug weeksMilitarySep weeksMilitaryOct weeksMilitaryNov weeksMilitaryDec workFTJan workFTFeb workFTMar workFTApr workFTMay workFTJun workFTJul workFTAug workFTSep workFTOct workFTNov workFTDec workPTJan workPTFeb workPTMar workPTApr workPTMay workPTJun workPTJul workPTAug workPTSep workPTOct workPTNov workPTDec militaryJan militaryFeb militaryMar militaryApr militaryMay militaryJun militaryJul militaryAug militarySep militaryOct militaryNov militaryDec atWorkJan atWorkFeb atWorkMar atWorkApr atWorkMay atWorkJun atWorkJul atWorkAug atWorkSep atWorkOct atWorkNov atWorkDec workSchJan workSchFeb workSchMar workSchApr workSchMay workSchJun workSchJul workSchAug workSchSep workSchOct workSchNov workSchDec workK12Jan workK12Feb workK12Mar workK12Apr workK12May workK12Jun workK12Jul workK12Aug workK12Sep workK12Oct workK12Nov workK12Dec workCollegeJan workCollegeFeb workCollegeMar workCollegeApr workCollegeMay workCollegeJun workCollegeJul workCollegeAug workCollegeSep workCollegeOct workCollegeNov workCollegeDec workGradSchJan workGradSchFeb workGradSchMar workGradSchApr workGradSchMay workGradSchJun workGradSchJul workGradSchAug workGradSchSep workGradSchOct workGradSchNov workGradSchDec otherJan otherFeb otherMar otherApr otherMay otherJun otherJul otherAug otherSep otherOct otherNov otherDec activityJan activityFeb activityMar activityApr activityMay activityJun activityJul activityAug activitySep activityOct activityNov activityDec RECALLworkFTRecallJan RECALLworkFTRecallFeb RECALLworkFTRecallMar RECALLworkFTRecallApr RECALLworkFTRecallMay RECALLworkFTRecallJun RECALLworkFTRecallJul RECALLworkFTRecallAug RECALLworkFTRecallSep RECALLworkFTRecallOct RECALLworkFTRecallNov RECALLworkFTRecallDec RECALLworkPTRecallJan RECALLworkPTRecallFeb RECALLworkPTRecallMar RECALLworkPTRecallApr RECALLworkPTRecallMay RECALLworkPTRecallJun RECALLworkPTRecallJul RECALLworkPTRecallAug RECALLworkPTRecallSep RECALLworkPTRecallOct RECALLworkPTRecallNov RECALLworkPTRecallDec RECALLmilitaryRecallJan RECALLmilitaryRecallFeb RECALLmilitaryRecallMar RECALLmilitaryRecallApr RECALLmilitaryRecallMay RECALLmilitaryRecallJun RECALLmilitaryRecallJul RECALLmilitaryRecallAug RECALLmilitaryRecallSep RECALLmilitaryRecallOct RECALLmilitaryRecallNov RECALLmilitaryRecallDec RECALLworkRecallJan RECALLworkRecallFeb RECALLworkRecallMar RECALLworkRecallApr RECALLworkRecallMay RECALLworkRecallJun RECALLworkRecallJul RECALLworkRecallAug RECALLworkRecallSep RECALLworkRecallOct RECALLworkRecallNov RECALLworkRecallDec RECALLworkSchRecallJan RECALLworkSchRecallFeb RECALLworkSchRecallMar RECALLworkSchRecallApr RECALLworkSchRecallMay RECALLworkSchRecallJun RECALLworkSchRecallJul RECALLworkSchRecallAug RECALLworkSchRecallSep RECALLworkSchRecallOct RECALLworkSchRecallNov RECALLworkSchRecallDec RECALLworkK12RecallJan RECALLworkK12RecallFeb RECALLworkK12RecallMar RECALLworkK12RecallApr RECALLworkK12RecallMay RECALLworkK12RecallJun RECALLworkK12RecallJul RECALLworkK12RecallAug RECALLworkK12RecallSep RECALLworkK12RecallOct RECALLworkK12RecallNov RECALLworkK12RecallDec RECALLworkCollegeRecallJan RECALLworkCollegeRecallFeb RECALLworkCollegeRecallMar RECALLworkCollegeRecallApr RECALLworkCollegeRecallMay RECALLworkCollegeRecallJun RECALLworkCollegeRecallJul RECALLworkCollegeRecallAug RECALLworkCollegeRecallSep RECALLworkCollegeRecallOct RECALLworkCollegeRecallNov RECALLworkCollegeRecallDec RECALLworkGradSchRecallJan RECALLworkGradSchRecallFeb RECALLworkGradSchRecallMar RECALLworkGradSchRecallApr RECALLworkGradSchRecallMay RECALLworkGradSchRecallJun RECALLworkGradSchRecallJul RECALLworkGradSchRecallAug RECALLworkGradSchRecallSep RECALLworkGradSchRecallOct RECALLworkGradSchRecallNov RECALLworkGradSchRecallDec RECALLotherRecallJan RECALLotherRecallFeb RECALLotherRecallMar RECALLotherRecallApr RECALLotherRecallMay RECALLotherRecallJun RECALLotherRecallJul RECALLotherRecallAug RECALLotherRecallSep RECALLotherRecallOct RECALLotherRecallNov RECALLotherRecallDec RECALLactivityRecallJan RECALLactivityRecallFeb RECALLactivityRecallMar RECALLactivityRecallApr RECALLactivityRecallMay RECALLactivityRecallJun RECALLactivityRecallJul RECALLactivityRecallAug RECALLactivityRecallSep RECALLactivityRecallOct RECALLactivityRecallNov RECALLactivityRecallDec gradGraduate yrGradGraduate grad4yr yrGrad4yr grad2yr yrGrad2yr gradHS yrGradHS gradDiploma yrGradDiploma gradGED yrGradGED annualHrsWrkCalc Grad_month BA_month AA_month Diploma_month GED_month HS_month Grad_year BA_year AA_year Diploma_year GED_year HS_year interview_date lastValidIntDate lastValidSchoolDate R*interviewDate wageJobCPS wageJobMain occJobCPS occJobMain indJobCPS indJobMain hoursJobCPS hoursJobMain selfEmployedJobCPS selfEmployedJobMain high_grade_comp_May yearEnteredUS

label values HHsize1979 .

* reshape to monthly data
reshape long enrCollege enrK12 weeksWorked weeksSelfEmployed avgHrs hoursWorked wageMean wageAltMean wageMedian wageAltMedian weeksMilitary workFT workPT atWork workSch workK12 workCollege workGradSch military other activity RECALLworkFTRecall RECALLworkPTRecall RECALLworkRecall RECALLworkSchRecall RECALLworkK12Recall RECALLworkCollegeRecall RECALLworkGradSchRecall RECALLmilitaryRecall RECALLotherRecall RECALLactivityRecall , string i(id year) j(month)
* ren hgcIn  hgc
ren wageMean     wage

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
ren RECALLworkGradSchRecall workGradSchRecall

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

* label months with value label
lab def vlMonth 1 "Jan" 2 "Feb" 3 "Mar" 4 "Apr" 5 "May" 6 "Jun" 7 "Jul" 8 "Aug" 9 "Sep" 10 "Oct" 11 "Nov" 12 "Dec"
lab val month vlMonth

* convert our annualized age variable to a monthly basis
*  need to assure that it stays sorted in the current order
sort id year month
gen sorter = _n
gen ageYr = year-birthYear
gen ageMo = month-birthMonth
replace ageYr = ageYr-1 if ageMo<0
drop ageMo
bys id ageYr (sorter): gen ageMo = [_n-1]
drop age sorter
ren ageYr age

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
bys id: gen gradHS       = (month>=HS_month      & year==HS_year     ) | (year>HS_year     )

* impute highest grade completed on a monthly basis
* do hgc_monthly_impute.do

sort id year month

* drop observations outside of age ranges we want; rectangularize data
* drop if !inrange(age,13,28)
drop if !inrange(age,13,36)

gen uniqueTime = age*100+ageMo+1
xtset id uniqueTime

compress
save y79_all_balanced.dta, replace
!zip -m y79_all_balanced.dta.zip y79_all_balanced.dta

*=================================================
* Frequency stats and droppings
*=================================================
*** "Drop" females and over-samples
* Youngins
qui count if uniqueTime==1301 & birthYear>=1961
scalar r0 = r(N)
qui count if uniqueTime==1301 & birthYear>=1961  &  female
scalar r1 = r(N)              
qui count if uniqueTime==1301 & birthYear>=1961  & !female & (oversamplePoor | oversampleMilitary)
scalar r2 = r(N)                                
qui count if uniqueTime==1301 & birthYear>=1961  & !female & !oversamplePoor & !oversampleMilitary
scalar r3 = r(N)                                

disp "Starting persons  (youngins) "  r0
disp "Drop females      (youngins) "  r1
disp "Drop oversample   (youngins) "  r2
disp "Resulting persons (youngins) "  r3

* Oldfolks
qui count if uniqueTime==1301 & birthYear<=1960
scalar r10 = r(N)
qui count if uniqueTime==1301 & birthYear<=1960  &  female
scalar r11 = r(N)              
qui count if uniqueTime==1301 & birthYear<=1960  & !female &  birthYear< 1959
scalar r11a = r(N)              
qui count if uniqueTime==1301 & birthYear<=1960  & !female &  birthYear>=1959 & (oversamplePoor | oversampleMilitary)
scalar r12 = r(N)                                
qui count if uniqueTime==1301 & birthYear<=1960  & !female &  birthYear>=1959 & !oversamplePoor & !oversampleMilitary
scalar r13 = r(N)                                

disp "Starting persons  (oldfolks) "  r10
disp "Drop females      (oldfolks) "  r11
disp "Drop older cohorts(oldfolks) "  r11a
disp "Drop oversample   (oldfolks) "  r12
disp "Resulting persons (oldfolks) "  r13


qui count if uniqueTime==1301 & !female & birthYear==1957 & !oversamplePoor & !oversampleMilitary
scalar r57 = r(N)
qui count if uniqueTime==1301 & !female & birthYear==1958 & !oversamplePoor & !oversampleMilitary
scalar r58 = r(N)
qui count if uniqueTime==1301 & !female & birthYear==1959 & !oversamplePoor & !oversampleMilitary
scalar r59 = r(N)
qui count if uniqueTime==1301 & !female & birthYear==1960 & !oversamplePoor & !oversampleMilitary
scalar r60 = r(N)
qui count if uniqueTime==1301 & !female & birthYear==1961 & !oversamplePoor & !oversampleMilitary
scalar r61 = r(N)
qui count if uniqueTime==1301 & !female & birthYear==1962 & !oversamplePoor & !oversampleMilitary
scalar r62 = r(N)
qui count if uniqueTime==1301 & !female & birthYear==1963 & !oversamplePoor & !oversampleMilitary
scalar r63 = r(N)
qui count if uniqueTime==1301 & !female & birthYear==1964 & !oversamplePoor & !oversampleMilitary
scalar r64 = r(N)

* For 79:
*  dob   age_int  svy_rounds  new svy_rounds   final_rounds (with imputed data)
*  1964  14-28    15          13               16
*  1963  15-28    14          13               16
*  1962  16-28    13          13               16
*  1961  17-28    12          12               16
*  1960  18-28    11          11               16
*  1959  19-28    10          10               16
*  1958  20-28     9           9               16
*  1957  21-28     8           8               16

disp "Survey rounds                      " 13
disp "Survey Person-years     (youngins) " r64*13 + r63*13 + r62*13 + r61*12
disp "Add Retro data          (youngins) " r64*0  + r63*0  + r62*0  + r61*1
disp "Potential person-years  (youngins) " r3*13
disp "Potential person-months (youngins) " r3*13*12

disp "Survey rounds                      " 15
disp "Survey Person-years     (oldfolks) " r60*11 + r59*10
disp "Add Retro data          (oldfolks) " r60*2  + r59*3 
disp "Potential person-years  (oldfolks) " r13*13
disp "Potential person-months (oldfolks) " r13*13*12

drop if oversamplePoor | oversampleMilitary

*** Drop observations after last (valid) interview and more counts
* Youngins
count    if birthYear>=1961 & !female & ( mdy(month,1,year)> lastValidIntDate | mdy(month,1,year)> lastValidSchoolDate ) & uniqueTime>=1601
scalar s0 = r(N)
xtsum id if birthYear>=1961 & !female &   mdy(month,1,year)<=lastValidIntDate & mdy(month,1,year)<=lastValidSchoolDate  & uniqueTime>=1601
scalar s1 = r(N)
scalar s2 = r(Tbar)
xtsum id if birthYear>=1961 & !female &   mdy(month,1,year)<=lastValidIntDate & mdy(month,1,year)<=lastValidSchoolDate & ageMo==0 & uniqueTime>=1601
scalar s3 = r(N)
scalar s4 = r(n)

disp "Drop missing int months " s0
disp "Final months "            s1
disp "Final Tbar "              s2

disp "Final years "             s3
disp "Final persons "           s4
disp "Drop missing int years "  s4*13-s3

* Oldfolks
count    if inrange(birthYear,1959,1960) & !female & ( mdy(month,1,year)>lastValidIntDate  | mdy(month,1,year)>lastValidSchoolDate ) & uniqueTime>=1601
scalar s10 = r(N)
xtsum id if inrange(birthYear,1959,1960) & !female &   mdy(month,1,year)<=lastValidIntDate & mdy(month,1,year)<=lastValidSchoolDate & uniqueTime>=1601
scalar s11 = r(N)
scalar s12 = r(Tbar)
xtsum id if inrange(birthYear,1959,1960) & !female &   mdy(month,1,year)<=lastValidIntDate & mdy(month,1,year)<=lastValidSchoolDate & ageMo==0 & uniqueTime>=1601
scalar s13 = r(N)
scalar s14 = r(n)

disp "Drop missing int months " s10
disp "Final months "            s11
disp "Final Tbar "              s12

disp "Final years "             s13
disp "Final persons "           s14
disp "Drop missing int years "  s14*13-s13

drop     if mdy(month,1,year)>lastValidIntDate
drop     if mdy(month,1,year)>lastValidSchoolDate

compress
save y79_all, replace
!zip -m y79_all.dta.zip y79_all.dta

*============================================================================
* Vfill graph of activity over time
*============================================================================
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
	
	twoway  (area tempy_pct2 caldate if activity==6, lcolor(midblue) fcolor(eltblue) lwidth(vthin) ) (area tempy_pct2 caldate if activity==5, lcolor(midgreen) fcolor(eltgreen) lwidth(vthin) ) (area tempy_pct2 caldate if activity==4, lcolor(cranberry) fcolor(erose) lwidth(vthin)) (area tempy_pct2 caldate if activity==3, lcolor(dknavy) fcolor(edkblue) lwidth(vthin) ) (area tempy_pct2 caldate if activity==2, lcolor(sand) fcolor(sandb) lwidth(vthin) ) (area tempy_pct2 caldate if activity==1, lcolor(brown) fcolor(stone) lwidth(vthin) )   ,legend(order(6 "{stSerif:School Only}" 5 "{stSerif:Work in School}" 4 "{stSerif:Work PT}" 3 "{stSerif:Work FT}" 2 "{stSerif:Military}" 1 "{stSerif:Other}") rows(2) ) title( "") ytitle( "{stSerif:Probability}") xtitle( "{stSerif:Date}")  xlabel(,format(%tm)) graphregion(fcolor(white) lcolor(white)) note( "{stSerif:Source: NLSY79}")
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
		* Order in area graph (top2bottom): other, military, workFT, workPT, workSch, SchoolOnly
		gen `X'_pct2 = .
		bys agemo (activity): replace `X'_pct2 = `X'_pct[1] + `X'_pct[2] + `X'_pct[3] + `X'_pct[4] + `X'_pct[5] + `X'_pct[6] if activity==6
		bys agemo (activity): replace `X'_pct2 = `X'_pct[1] + `X'_pct[2] + `X'_pct[3] + `X'_pct[4] + `X'_pct[5]              if activity==5
		bys agemo (activity): replace `X'_pct2 = `X'_pct[1] + `X'_pct[2] + `X'_pct[3] + `X'_pct[4]                           if activity==4
		bys agemo (activity): replace `X'_pct2 = `X'_pct[1] + `X'_pct[2] + `X'_pct[3]                                        if activity==3
		bys agemo (activity): replace `X'_pct2 = `X'_pct[1] + `X'_pct[2]                                                     if activity==2
		bys agemo (activity): replace `X'_pct2 = `X'_pct[1]                                                                  if activity==1
	}
	
	replace agemo = agemo/100
	
	twoway  (area tempy_pct2 agemo if activity==6, lcolor(midblue) fcolor(eltblue) lwidth(vthin) ) (area tempy_pct2 agemo if activity==5, lcolor(midgreen) fcolor(eltgreen) lwidth(vthin) ) (area tempy_pct2 agemo if activity==4, lcolor(cranberry) fcolor(erose) lwidth(vthin)) (area tempy_pct2 agemo if activity==3, lcolor(dknavy) fcolor(edkblue) lwidth(vthin) ) (area tempy_pct2 agemo if activity==2, lcolor(sand) fcolor(sandb) lwidth(vthin) ) (area tempy_pct2 agemo if activity==1, lcolor(brown) fcolor(stone) lwidth(vthin) )   ,legend(order(6 "{stSerif:School Only}" 5 "{stSerif:Work in School}" 4 "{stSerif:Work PT}" 3 "{stSerif:Work FT}" 2 "{stSerif:Military}" 1 "{stSerif:Other}") rows(2) ) title( "") ytitle( "{stSerif:Probability}") xtitle( "{stSerif:Age}") xlabel(13(2)28) graphregion(fcolor(white) lcolor(white)) note( "{stSerif:Source: NLSY79}")
	graph export choiceSharesMonthlyAge.eps, replace
restore

log close
