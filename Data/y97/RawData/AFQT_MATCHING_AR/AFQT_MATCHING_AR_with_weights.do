clear all
set mem 400m
pause on 
set more off
capture log close
log using "/afs/econ.duke.edu/data/vjh3/WageReturns/Data/y97/RawData/AFQT_MATCHING_AR/AFQT_MATCHING_AR_with_weights.log", replace

/***************************************************
MATCHING AFQT SCORES ACROSS NLSY 1979 and NLSY 1997

This do file creates a data file with comparable AFQT scores across both NLSY79 and NLSY97.
There are two main steps in creating the comparable AFQT scores:

1. The 1979 ASVAB is a Paper and Pencil (P&P) test, while the 1997 ASVAB was computer adminstered. 
To make the scores comparable across cohorts, we rely on a percentile mapping provided by Dan Segall (Segall (1997))

2. The age at which respondents took the test differs between 1979 and 1997. The 1997 sample is much younger.
For both samples, we observe a large sample of individuals taking the test at age 16. We use this overlap in the 
test-taking age by mapping all test scores within cohorts into the age 16-distribution based on the within age 
ranking of test scores. 

For details, see Segall (1997) and Altonji, Bharadwaj & Lange (2009).

Altonji, J., Bharadwaj, P. & Lange, F. "Changes in the Characteristics of American Youth - 
Implications for Adult Outcomes" NBER Working Papers No. 13883, revised 2009.
Segall, D. O. (1997). "Equating the CAT-ASVAB". In W. A. Sands, B. K. Waters, & J. R. McBride (Eds.), 
        Computerized adaptive testing: From inquiry to operation (pp. 181-198). Washington, DC: American Psychological Association. 
Date: August 19, 2009.
******************************************************/

// Set path to directory containing afqt1997a.csv //
capture cd "/afs/econ.duke.edu/data/vjh3/WageReturns/Data/y97/RawData/AFQT_MATCHING_AR"
* cd "/Users/JKukkur/Documents/Research/ABL/AFQT MATCHING"

tempfile afqt97 afqt_append nlsy_agestd agestd_afqt missings finished_product

/****************************************************************
First Step of score conversion: 
Transfrom CAT Test Scores from NLSY97 into Paper and Pencil Test Scores using mapping provided by Dan Segall.
Combine this data with raw data from NLSY79.
*****************************************************************/


// afqt1997a.csv contains individual id's and sex from NLSY1997 and the ASVAB component scores provided by Dan Segall. 
// The are P&P equivalent scores based on the mapping procedure described in Segall (1996). 
// Dan Segall suuplied us with these P&P equivalent scores using ASVAB component scores contained in (DICTIONARY FILE).
insheet using afqt1997a.csv, comma
ren v1 pid
ren v2 male
gen asvabAR=ar if ar!=0 // pc=paragraph comprehension, no=numerical comprehension 
keep pid male asvabAR
sort pid
save `afqt97', replace

// Merge age in for the NLSY97 sample //
infile using age97.dct, clear
ren R0000100	pid
ren R1194100	age  // age as of 1997 (test-taking year for NLSY97) //
keep pid age
sort pid
merge pid using `afqt97' 
drop _merge 
sort pid
save `afqt97', replace

// Merge in weights for 1997 data //
// We use the custom weight provided by the NLSY for the year 1997, the year when the ASVAB was administered. //
insheet using weights97.csv, clear
sort pid
merge pid using `afqt97'
drop _merge 
gen sample=1				// Sample Identifier: 1= 1997 NLSY sample, 0=1979 NLSY sample //
sort sample pid
save `afqt97', replace

// NLSY 1979 Sample: Age Information and AFQT-scores //
// NLSY 1979 Sample: Age Information and AFQT-scores //
infile using y79_asvab.dct, clear
ren R0000100 pid		
ren R0000500 birthyear 
ren R0173600 sampid
ren R0406510 age 									// Age as of 1980 (test taking year for NLSY79) //

ren R0618010 gs
ren R0618011 ar
ren R0618012 wk
ren R0618013 pc
ren R0618014 no
ren R0618015 cs
ren R0618016 as
ren R0618017 mk
ren R0618018 mc
ren R0618019 ei

ren R0618100 asvabVerb
ren R0618200 AFQT_1
ren R0618300 AFQT_2
ren R0618301 AFQT_3

foreach var in gs ar wk pc no cs as mk mc ei {
	qui replace `var'=. if `var'<0
}
gen asvabAR = ar if ar!=0
drop if asvabAR==.
label var asvabAR "Arithmetic Reasoning subset of ASVAB score"
replace age=80-birthyear if age<0 & birthyear!=. 	// Fill missing age using birth-year // 
drop birthyear
gen sample=0							// Sample Identifier: 1= 1997 NLSY sample, 0=1979 NLSY sample //
append using `afqt97' 				// Append the data-set for NLSY97 //
sort sample pid
save `afqt_append', replace

* Merge in 1979 weights
// We use the custom weight provided by the NLSY for the year 1979, the year when the ASVAB was administered. //

insheet using weights79.csv, clear
gen sample=0
sort sample pid
merge sample pid using `afqt_append'
drop _merge

* The weights have implied 2 decimal places.
replace weight=weight/100
sort sample pid
save `afqt_append', replace

/***************************************************************************
Second Step: Percentile mapping of P&P test scores into age=16 distribution
****************************************************************************/

*****		GENERATING PERCENTILES OF SCORES BY AGE AND NLSY-SAMPLE	*********
use `afqt_append', clear
drop gs ar wk pc no cs as mk mc ei asvabVerb AFQT_1 AFQT_2 AFQT_3

// Drop those with missing AFQT AR scores
drop if asvabAR==.

// For Table I in Introduction.doc
bysort sample: tab age


// For Figure 1 in NSLY79
kdensity asvabAR if sample==0&age==16, addplot(kdensity asvabAR if sample==1&age==16, lpattern(_)) title(Figure 1: AFQT Scores at Age 16) ///
note("The NLSY79-scores are the P&P scores reported by the NLSY79." "The NLSY-97 scores are based on the CAT scores from NLSY97 and the equation by Segal (1997)." "Both populations are weighted to be population representative.") ///
legend(label(1 "NLSY 1979") label(2 "NLSY 1997") cols(2)) saving(HistScores, replace)


// Combine sparsely populated age-groups in both samples with adjacent age-groups //
replace age=22 if age==23 & sample==0
replace age=17 if age==18 & sample==1

*******************************************************************
*EXPANDING THE DATA AND CREATING PERCENTILES BY HAND
// The following procedure improves the quality of the percentile mapping. 
// The problem is that some observations 'belong' in several percentiles because they 
// have large weights. Stata commands such as xtile will simply assign a unique percentile to these
// observations. Instead, we need to account for the fact that these observations belong to several pctiles. 
// This is achieved by expanding the data-set proportionally to the weights and then generating percentiles. 

*expanding each observation by its weight - an observation with a weight of 1100 is expanded into 11 observations. 
gen percentile_rank=.
replace weight=round(weight/100)
foreach num of numlist 0/160 {
	qui expand `num' if weight==`num'
}

*generating a unique rank within each sample and age
bysort sample age: egen r=rank(asvabAR), u
gen pasvabAR=.

* Divide the rank by number of individuals corresponding to the population of a given age and sample
* to get the percentile of an individual.

gen holdey = 1/100
bysort sample age: egen sumWgts=total(holdey)

*SAMPLE==0
qui replace pasvabAR=round(r/sumWgts) if age==15 & sample==0
qui replace pasvabAR=round(r/sumWgts) if age==16 & sample==0
qui replace pasvabAR=round(r/sumWgts) if age==17 & sample==0
qui replace pasvabAR=round(r/sumWgts) if age==18 & sample==0
qui replace pasvabAR=round(r/sumWgts) if age==19 & sample==0
qui replace pasvabAR=round(r/sumWgts) if age==20 & sample==0
qui replace pasvabAR=round(r/sumWgts) if age==21 & sample==0
qui replace pasvabAR=round(r/sumWgts) if age==22 & sample==0

*SAMPLE 1
qui replace pasvabAR=round(r/sumWgts) if age==12 & sample==1
qui replace pasvabAR=round(r/sumWgts) if age==13 & sample==1
qui replace pasvabAR=round(r/sumWgts) if age==14 & sample==1
qui replace pasvabAR=round(r/sumWgts) if age==15 & sample==1
qui replace pasvabAR=round(r/sumWgts) if age==16 & sample==1
qui replace pasvabAR=round(r/sumWgts) if age==17 & sample==1

*dropping the duplicates now
egen tag=tag(sample pid)
keep if tag==1
drop tag

sort sample pasvabAR
save `nlsy_agestd', replace

*****************************************************************************

// Within sample, we map AFQT scores by age in the age=16
// distribution. We therefore require mean AFQT-scores of age=16 by percentile in each sample. 
// We need to generate these averages using the weights.
bys sample pasvabAR: egen pop=sum(weight) if age==16
bys sample pasvabAR: egen tot_score=sum(asvabAR*weight) if age==16 	// Mean age=16 raw score for each percentile //
bys sample pasvabAR: gen mean=tot_score/pop if age==16
drop tot_score pop
egen tag=tag(sample pasvabAR mean) if age==16 			// We need only 1 obs per sample and percentile //
keep if tag==1
ren mean asvabAR_std
keep sample asvabAR_std pasvabAR asvabAR
sort sample pasvabAR
save `agestd_afqt', replace

use `nlsy_agestd', clear
merge sample pasvabAR using `agestd_afqt' // Merge into each percentile the age=16 corresponding score //
drop _merge
keep sample pid male pasvabAR asvabAR_std asvabAR weight age
sort sample pid
// The final data contains "asvabAR_std": which is the comparable score across the 2 NLSY samples //
*keep if sample==1 // this drops the NLSY79 observations //
ren pid ID
ren weight weight_altonji
gen year = 1979 if sample==0
replace year = 1997 if sample==1 
*drop sample age asvabAR pasvabAR // drop the other variables since I don't use them in my research //
preserve
	use `afqt97', clear
	keep pid male
	ren pid ID
	save `missings', replace
restore

preserve
	keep if sample==1
	merge 1:1 ID using `missings'
	tab _merge
	zscore asvabAR_std
	drop asvabAR_std
	ren z_asvabAR_std asvabAR_std
	keep if male==1
	sort ID
	outsheet ID asvabAR_std using altonjiAFQT.csv, comma nol replace
restore
save afqt_adjusted_final, replace 
save `finished_product', replace

tabstat asvabAR_std, by(sample) stats(n min max mean median)

isid ID year

* Test: the afqt distributions across age within sample should now be identical. There will still be very small deviations
* because of the coarseness of the above expansion, but we believe these to be third order. To allow this code to run 
* rapidly, we tolerate these deviations. 

**bys sample age: sum asvabAR_std [fw=weight], d

use `finished_product', clear
** Generate a NLSY79-only supplement:
drop if sample==1
save afqt_adjusted_final79, replace

use `finished_product', clear
** Generate a NLSY97-only supplement:
drop if sample==0
save afqt_adjusted_final97, replace

log close
exit
