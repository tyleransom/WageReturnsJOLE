* version 13.0
version 14.1
clear all
set more off
capture log close
log using NLSYagedCPSstats.log, replace

local NUMPIECES 3
forvalues X = 1/`NUMPIECES' {
	local EY = int(10000*uniform()) 
	!gunzip -fc  ../Data/CPS/CPS_data_pt`X'.dta.gz > tmp`EY'.dta
	append using tmp`EY'.dta
	!rm          tmp`EY'.dta
}
* keep if empFT | empPT

*****************************************************************************
* Calculate mean values made up of those who would be in the NLSY cohorts
*  to compare
*****************************************************************************
* Program to return a string of stars based on p-value
capture program drop star
program star
	if      `1' <= 0.01   c_local `2' "***"  
	else if `1' <= 0.05   c_local `2' "**"
	else if `1' <= 0.1    c_local `2' "*"
	else                  c_local `2' " "
end

*---------------------------------------------
* Generate variables
*---------------------------------------------
* undo shortyr
gen year = shortyr + 1978

* background variables
cap drop race
generat race = .
replace race = 1 if white | other
replace race = 2 if black
replace race = 3 if hispanic
lab def vlrace     1 "Non-black/Non-Hispanic" 2 "Black" 3 "Hispanic"
lab val race       vlrace
gen whiteOther = white | other

* gradHS, grad4yr are good
*  From CPS_import.do:
	*                 (For years 79-91)                                          (For years 92+)
	* gen byte hsonly    = (gradeat==12)                                       OR = (grade92==38 | grade92==39)
	* gen byte college   = (gradeat==16 | gradeat==17)                         OR = (grade92==43)
	* gen byte college2  = (gradeat>=16 & ~mi(gradeat)) // alt def of college  OR = (grade92>=43) & ~mi(grade92) // alt def of college
	* gen byte gradHS    = (gradeat>=12 & ~mi(gradeat))                        OR = (inrange(grade92,39,46))
	* gen byte grad4yr   = (gradeat>=16 & ~mi(gradeat))                        OR = (inrange(grade92,43,46))
	* gen byte HSdropout = (gradeat<=11 & ~mi(gradeat))                        OR = (grade92<=38)

* hgc created in CPS_import.do
* gen potExp
gen potExp = age-hgc-6

* female is indicator for female
* year is calendar year; we'll use age and year to get birthyr
generat birthyr = year - age - 1 if inrange(month,1,6)
replace birthyr = year - age     if inrange(month,7,12)

* create flags for NLSY79 and NLSY97
gen     cohortFlag = 1979 if inrange(birthyr,1959,1964) & inrange(age,16,36)
replace cohortFlag = 1997 if inrange(birthyr,1980,1984) & inrange(age,16,36)
keep if inlist(cohortFlag,1979,1997)

* Assume gradGrad if 18 or more years, and 'startCol' if more than 12
gen gradGrad = hgc>=18
* gen someCollege = hgc>12 & ~grad4yr 
* gen grad4yrCond = grad4yr if startCol

gen  startColOld = hgc>12
gen     startCol = gradeat>=12 if ~mi(gradeat)
replace startCol = grade92>=40 if  mi(gradeat)

corr startCol startColOld

* attainment variables
gen HSdropout  =  hgc<12
gen HSgraduate =  hgc==12
gen BAdropout  =  hgc>12 & ~grad4yr
gen BAgraduate =  grad4yr

* * alternative version of attainment variables (does not use hgc variable that was created by us)
* gen HSdropout  =  ~gradHS
* gen HSgraduate =  gradHS & ~startCol
* gen BAdropout  =  gradHS & startCol & ~grad4yr
* gen BAgraduate =  grad4yr


drop if female

global tbls_loc ./
*------------------------------------------------
* TABLE 5
* Use all 32 and 29 year olds
*------------------------------------------------
foreach age in 29 32 {
	foreach var in whiteOther black hispanic HSdropout HSgraduate BAdropout BAgraduate {
		qui mean `var' [aw=weight] if age==`age', over(cohortFlag)
		matrix m = e(b)\e(_N)
		* foreach cohort in 1979 1997 {
			* local mu_`var'_`cohort'_`age' = el(m,1,colnumb(m,"`var':`cohort'"))
			* local        N_`cohort'_`age' = el(m,2,colnumb(m,"`var':`cohort'"))
		* }
		local mu_`var'_1979_`age' = m[1,1]
		local mu_`var'_1997_`age' = m[1,2]
		local        N_1979_`age' = m[2,1]
		local        N_1997_`age' = m[2,2]
		local mu_`var'_diff_`age' = `mu_`var'_1997_`age'' - `mu_`var'_1979_`age''
		qui test[`var']1979 = [`var']1997
		star `r(p)' mu_`var'_star_`age'
	}
}


* foreach age in 28 31 {
	* foreach var in whiteOther black hispanic  HSdropout gradHS someCollege grad4yr {
		* foreach cohort in 1979 1997 {
			* qui sum `var' [aw=weight] if cohortFlag==`cohort' & age==`age'
			* local mu_`var'_`cohort'_`age' = `r(mean)'
			* local en_`var'_`cohort'_`age' = `r(N)'
		* }
		* local mu_`var'_diff_`age' = `mu_`var'_1997_`age'' - `mu_`var'_1979_`age''
		* qui ttest `var' if age==`age', by(cohortFlag) 
		* if      `r(p)' <= 0.01    local mu_`var'_star_`age' "***"  
        * else if `r(p)' <= 0.05    local mu_`var'_star_`age' "**"
        * else if `r(p)' <= 0.1     local mu_`var'_star_`age' "*"
        * else                      local mu_`var'_star_`age' " "
	* }
* }



capture file close T5
file open T5 using "${tbls_loc}T5_29_CPSuseHGC.tex", write replace
file write T5 "\begin{table}[ht]" _n
file write T5 "\caption{Demographics and Schooling Attainment of NLSY-Aged Cohorts in NLSY and CPS}" _n
file write T5 "\label{tab:gradprobsCPS}" _n
file write T5 "\centering" _n
file write T5 "\scalebox{1.0}[1.0]{% " _n
file write T5 "\begin{threeparttable}" _n
file write T5 "\begin{tabular}{lrrr@{}lrrr@{}l}" _n
file write T5 "\toprule " _n
file write T5 "         & \multicolumn{4}{c}{NLSY} & \multicolumn{4}{c}{CPS} \\" _n
file write T5 "\cmidrule(r){2-5}\cmidrule(l){6-9} " _n
file write T5 "Variable & NLSY79 & NLSY97 & \multicolumn{2}{c}{97--79} & NLSY79 & NLSY97 & \multicolumn{2}{c}{97--79} \\" _n
file write T5 "\midrule " _n
file write T5 "\multicolumn{9}{l}{\emph{Demographics:}} \\" _n
file write T5 "~~White:     " "       & 0.79 & 0.71 & -0.08 & ***  & " %4.2f (`mu_whiteOther_1979_29') "  & " %4.2f (`mu_whiteOther_1997_29') "  & " %4.2f (`mu_whiteOther_diff_29') "  & `mu_whiteOther_star_29' \\ " _n
file write T5 "~~Black:     " "       & 0.15 & 0.16 & 0.01  &      & " %4.2f (`mu_black_1979_29') "       & " %4.2f (`mu_black_1997_29') "       & " %4.2f (`mu_black_diff_29') "       & `mu_black_star_29' \\ " _n
file write T5 "~~Hispanic:  " "       & 0.07 & 0.14 & 0.07  & ***  & " %4.2f (`mu_hispanic_1979_29') "    & " %4.2f (`mu_hispanic_1997_29') "    & " %4.2f (`mu_hispanic_diff_29') "    & `mu_hispanic_star_29' \\ " _n
file write T5 "\vspace{-6pt} \\" _n
file write T5 "\multicolumn{9}{l}{\emph{Schooling attainment by age 29:}} \\" _n
file write T5 "~~\% HS Dropouts " "        & 0.11 & 0.09 & -0.01 &    **  & " %4.2f (`mu_HSdropout_1979_29') "  & " %4.2f (`mu_HSdropout_1997_29') "  & " %4.2f (`mu_HSdropout_diff_29') "  & `mu_HSdropout_star_29' \\ " _n
file write T5 "~~\% HS Graduates " "       & 0.29 & 0.25 & -0.05 &   ***  & " %4.2f (`mu_HSgraduate_1979_29') " & " %4.2f (`mu_HSgraduate_1997_29') " & " %4.2f (`mu_HSgraduate_diff_29') " & `mu_HSgraduate_star_29' \\ " _n
file write T5 "~~\% Some College " "       & 0.38 & 0.40 & 0.03 &    **   & " %4.2f (`mu_BAdropout_1979_29') "  & " %4.2f (`mu_BAdropout_1997_29') "  & " %4.2f (`mu_BAdropout_diff_29') "  & `mu_BAdropout_star_29' \\ " _n
file write T5 "~~\% College Graduates " "  & 0.22 & 0.26 & 0.04 &   ***   & " %4.2f (`mu_BAgraduate_1979_29') " & " %4.2f (`mu_BAgraduate_1997_29') " & " %4.2f (`mu_BAgraduate_diff_29') " & `mu_BAgraduate_star_29' \\ " _n
file write T5 "\$N\$ " "                   & 3,464 &  3,569 &   &         & " %6.0fc (`N_1979_29') "            & " %6.0fc (`N_1997_29') "            &                                     & \\ " _n
file write T5 "%\vspace{-6pt} \\" _n
file write T5 "%\multicolumn{9}{l}{\emph{Schooling attainment by age 32:}} \\" _n
file write T5 "%~~\% HS Dropouts " "       & " %4.2f (`mu_HSdropout_1979_32') "  & " %4.2f (`mu_HSdropout_1997_32') "  & " %4.2f (`mu_HSdropout_diff_32') "  & `mu_HSdropout_star_32' \\ " _n
file write T5 "%~~\% HS Graduates " "      & " %4.2f (`mu_HSgraduate_1979_32') " & " %4.2f (`mu_HSgraduate_1997_32') " & " %4.2f (`mu_HSgraduate_diff_32') " & `mu_HSgraduate_star_32' \\ " _n
file write T5 "%~~\% Some College " "      & " %4.2f (`mu_BAdropout_1979_32') "  & " %4.2f (`mu_BAdropout_1997_32') "  & " %4.2f (`mu_BAdropout_diff_32') "  & `mu_BAdropout_star_32' \\ " _n
file write T5 "%~~\% College Graduates " " & " %4.2f (`mu_BAgraduate_1979_32') " & " %4.2f (`mu_BAgraduate_1997_32') " & " %4.2f (`mu_BAgraduate_diff_32') " & `mu_BAgraduate_star_32' \\ " _n
file write T5 "%\$N\$ " "                  & " %6.0fc (`N_1979_32') "            & " %6.0fc (`N_1997_32') "            &                                     & \\ " _n
file write T5 "\bottomrule " _n
file write T5 "\end{tabular} " _n
file write T5 "\footnotesize{Notes: \emph{HS Graduates} included in this table are those who have either a GED or a diploma but who never attended college. \emph{Some College} are those who attended college but did not graduate with a 4-year degree.     \emph{College Graduates} are those who graduated with a 4-year degree. Statistics weighted by CPS sampling weights. Significance reported at the 1\% (***), 5\% (**), and 10\% (*) levels.}" _n
file write T5 "\end{threeparttable} " _n
file write T5 "} " _n
file write T5 "\end{table} " _n
file close T5















/*
capture file close T5
file open T5 using "${tbls_loc}T5_29_CPS.tex", write replace
file write T5 "\begin{table}[ht]" _n 
file write T5 "\caption{Graduation probabilities by age}" _n 
file write T5 "\label{tab:gradprobsCPS}" _n 
file write T5 "\centering" _n 
file write T5 "\scalebox{1.0}[1.0]{% " _n 
file write T5 "\begin{threeparttable}" _n 
file write T5 "\begin{tabular}{lrrr@{}l}" _n 
file write T5 "\toprule " _n 
file write T5 "Variable & NLSY79 & NLSY97 & \multicolumn{2}{c}{97--79} \\" _n 
file write T5 "\midrule " _n 
file write T5 "\multicolumn{5}{l}{\emph{Schooling attainment by age 29:}} \\" _n 
file write T5 "~~\% HS Dropouts " " & " %4.2f (`mu_HSdropout_1979_29') " & " %4.2f (`mu_HSdropout_1997_29') " & " %4.2f (`mu_HSdropout_diff_29') " & `mu_HSdropout_star_29' \\ " _n
file write T5 "~~\% HS Graduates " " & " %4.2f (`mu_HSgraduate_1979_29') " & " %4.2f (`mu_HSgraduate_1997_29') " & " %4.2f (`mu_HSgraduate_diff_29') " & `mu_HSgraduate_star_29' \\ " _n
file write T5 "~~\% Some College " " & " %4.2f (`mu_BAdropout_1979_29') " & " %4.2f (`mu_BAdropout_1997_29') " & " %4.2f (`mu_BAdropout_diff_29') " & `mu_BAdropout_star_29' \\ " _n
file write T5 "~~\% College Graduates " " & " %4.2f (`mu_BAgraduate_1979_29') " & " %4.2f (`mu_BAgraduate_1997_29') " & " %4.2f (`mu_BAgraduate_diff_29') " & `mu_BAgraduate_star_29' \\ " _n
file write T5 "\$N\$ " " & " %6.0fc (`N_1979_29') " & " %6.0fc (`N_1997_29') " & & \\ " _n
file write T5 "%\vspace{-6pt} \\" _n 
file write T5 "%\multicolumn{5}{l}{\emph{Schooling attainment by age 32:}} \\" _n 
file write T5 "%~~\% HS Dropouts " " & " %4.2f (`mu_HSdropout_1979_32') " & " %4.2f (`mu_HSdropout_1997_32') " & " %4.2f (`mu_HSdropout_diff_32') " & `mu_HSdropout_star_32' \\ " _n
file write T5 "%~~\% HS Graduates " " & " %4.2f (`mu_HSgraduate_1979_32') " & " %4.2f (`mu_HSgraduate_1997_32') " & " %4.2f (`mu_HSgraduate_diff_32') " & `mu_HSgraduate_star_32' \\ " _n
file write T5 "%~~\% Some College " " & " %4.2f (`mu_BAdropout_1979_32') " & " %4.2f (`mu_BAdropout_1997_32') " & " %4.2f (`mu_BAdropout_diff_32') " & `mu_BAdropout_star_32' \\ " _n
file write T5 "%~~\% College Graduates " " & " %4.2f (`mu_BAgraduate_1979_32') " & " %4.2f (`mu_BAgraduate_1997_32') " & " %4.2f (`mu_BAgraduate_diff_32') " & `mu_BAgraduate_star_32' \\ " _n
file write T5 "%\$N\$ " " & " %6.0fc (`N_1979_32') " & " %6.0fc (`N_1997_32') " & & \\ " _n
file write T5 "\bottomrule " _n 
file write T5 "\end{tabular} " _n 
file write T5 "\footnotesize{Notes: \emph{HS Graduates} included in this table are those who have either a GED or a diploma but who never attended college. \emph{Some College} are those who attended college but did not graduate with a 4-year degree. \emph{College Graduates} are those who graduated with a 4-year degree. Statistics weighted by CPS sampling weights. Significance reported at the 1\% (***), 5\% (**), and 10\% (*) levels.}" _n 
file write T5 "\end{threeparttable} " _n 
file write T5 "} " _n 
file write T5 "\end{table} " _n 
file close T5
*/

log close
