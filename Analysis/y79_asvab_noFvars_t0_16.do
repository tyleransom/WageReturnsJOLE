version 13.1
clear all
set more off

capture log close
log using y79_asvab_noFvars_t0_16.log, replace
set matsize 4000

global graphics_path Graphics/

*****************************************************************************
* Perform mlogits on data to use at starting points for V++
*  MFX Model
*****************************************************************************
*============================================================================
* Import data, define macros, gen variables
*============================================================================

if "`c(username)'"=="jared"  global secretdir [REDACTED]
if "`c(username)'"=="ransom" global secretdir [REDACTED]

use if cohortFlag==1979 & ~female using ${secretdir}/yCombined_scaled_t0_16.dta, clear
drop if inlist(birthYear,1957,1958)

* structural
* asvab`asvab' = `Pvars79O' `Fvars'
* flex
* qui reg asvab`asvab' `Pvars79O' `Fvars1'  `Svars1'  `Zvars1'  `Evars0'  `Ivars3' `risk' `work'
* more flex
* qui reg asvab`asvab' `Pvars79O' `Fvars15' `Svars15' `Zvars25' `Evars25' `Ivars3' `risk' `work'
* most flex
* qui reg asvab`asvab' `Pvars79O' `Fvars2'  `Svars3'  `Zvars3'  `Evars3'  `Ivars3' `risk' `work'

* local Pvars79O black hispanic born1957 born1958 born1959          foreignBorn
* local Pvars79Y black hispanic born1961 born1962 born1963          foreignBorn
local Pvars79  black hispanic born1959 born1960 born1961 born1962 born1963 foreignBorn
local Pvars97  black hispanic born1980 born1981 born1982 born1983          foreignBorn
local Fvars    
local Fvars0   
local Fvars1   
local Fvars15  
local Fvars2   

local Svars    schoolOnlyt schoolOnlySq schoolOnlyCu
local Svars00  anySchoolt
local Svars0   anySchoolt  anySchoolSq
local Svars1   anySchoolt  anySchoolSq  anySchoolCu
local Svars2   anySchoolt  anySchoolSq  anySchoolCu
local Svars25  anySchoolt anySchoolBlack anySchoolHisp anySchoolSq anySchoolSqBlack anySchoolSqHisp anySchoolCu                              
local Svars3   anySchoolt anySchoolBlack anySchoolHisp anySchoolSq anySchoolSqBlack anySchoolSqHisp anySchoolCu anySchoolCuBlack anySchoolCuHisp anySchoolQr                              

local Zvars    workK12t workK12Sq workK12schoolOnly workK12Cu workColleget workCollegeSq workCollegeschoolOnly workCollegeCu
local Zvars00  workK12t workColleget  
local Zvars1   workK12t workK12Sq           workColleget workCollegeSq 
local Zvars15  workK12t workK12Black workK12Hisp workK12Sq workK12Cu workColleget workCollegeBlack workCollegeHisp workCollegeSq workCollegeCu                    
local Zvars2   workK12t workK12Sq workK12Cu workColleget workCollegeSq workCollegeCu
local Zvars3   workK12t workK12Black workK12Hisp workK12Sq workK12SqBlack workK12SqHisp workK12Cu workK12CuBlack workK12CuHisp workK12Qr workColleget workCollegeBlack workCollegeHisp workCollegeSq workCollegeSqBlack workCollegeSqHisp workCollegeCu workCollegeCuBlack workCollegeCuHisp workCollegeQr                    

local Evars    workPTonlyt workPTSq workPTschoolOnly workPTCu workFTonlyt workFTSq workFTschoolOnly workFTCu militaryt militarySq militaryCu othert otherSq otherCu
local Evars000 workPTonlyt workFTonlyt militaryt  
local Evars00  workPTonlyt workPTSq workFTonlyt workFTSq militaryt militarySq 
local Evars0   workPTonlyt workPTSq workPTCu workFTonlyt workFTSq workFTCu militaryt militarySq militaryCu
local Evars1   workPTonlyt workPTSq workFTonlyt workFTSq militaryt militarySq othert otherSq
local Evars2   workPTonlyt workPTSq workPTCu workFTonlyt workFTSq workFTanySchool  workFTCu militaryt militarySq militaryCu othert otherSq otherCu
local Evars25  workPTonlyt workPTBlack workPTHisp workPTSq workPTSqBlack workPTSqHisp workPTCu workFTonlyt workFTBlack workFTHisp workFTSq workFTSqBlack workFTSqHisp workFTCu militaryt militaryBlack militaryHisp militarySq militarySqBlack militarySqHisp militaryCu
local Evars3   workPTonlyt workPTBlack workPTHisp workPTSq workPTSqBlack workPTSqHisp workPTCu workPTCuBlack workPTCuHisp workPTQr workFTonlyt workFTBlack workFTHisp workFTSq workFTSqBlack workFTSqHisp workFTCu workFTCuBlack workFTCuHisp workFTQr militaryt militaryBlack militaryHisp militarySq militarySqBlack militarySqHisp militaryCu militaryCuBlack militaryCuHisp militaryQr
local Ivars3   workK12anySchool workCollegeanySchool workCollegeworkK12 workPTanySchool workPTworkK12 workPTworkCollege workFTanySchool workFTworkK12 workFTworkCollege workFTworkPT                              

local risk     gradHS grad4yr
local work     inSchWork PTwork

gen inSchWork  = (activity==2 | activity==12 | activity==22)
gen PTwork     = (activity==3 | activity==13 | activity==23)


*============================================================================
* Regressions
*============================================================================
capture program drop normal
program normal
version 11.2
args lnf Xb sigma
quietly replace `lnf'=ln(normalden(${ML_y1}, `Xb', `sigma'))
end

* Pvars only
foreach asvab in AR CS MK NO PC WK {
	ml model lf normal (asvab`asvab' = `Pvars79' ) /sigma if ~m_asvab`asvab' & firstObs
	ml max
	estimates store       reg`asvab'
	predict asvab`asvab'hatStructFirstObs, xb
	qui reg asvab`asvab' `Pvars79' if ~m_asvab`asvab' & agemo==2801
	predict asvab`asvab'hatStruct if e(sample), xb
	matrix asvab`asvab'StructR2a = e(r2_a)
	svmat  asvab`asvab'StructR2a
	generat Dasvab`asvab'Struct = asvab`asvab'-asvab`asvab'hatStruct
}

qui outreg2 [regAR regCS regMK regNO regPC regWK] using y79_asvab_noFvars_t0_16, excel replace bdec(4) sdec(4) ctitle(asvabs)

*--------------------------------------
* More flexible specification (fit), including engogenous variable, estimated at agemo==2801
*--------------------------------------
capture program drop normal
program normal
version 11.2
args lnf Xb sigma
quietly replace `lnf'=ln(normalden(${ML_y1}, `Xb', `sigma'))
end

* Pvars and Fvars and more, oh my
foreach asvab in AR CS MK NO PC WK {
	* Linear specification
	qui reg asvab`asvab' `Pvars79' `Fvars0'  `Svars00'  `Zvars00'  `Evars000' `risk' `work' if ~m_asvab`asvab' & agemo==2801
	predict asvab`asvab'hatLin if e(sample), xb
	matrix asvab`asvab'LinR2a = e(r2_a)
	svmat  asvab`asvab'LinR2a
	generat Dasvab`asvab'Lin = asvab`asvab'-asvab`asvab'hatLin
	qui estat ic
	matrix ic`asvab'Lin = r(S)
	local aic`asvab'Lin = ic`asvab'Lin[1,5]
	local bic`asvab'Lin = ic`asvab'Lin[1,6]
	
	* Quadratic specification
	qui reg asvab`asvab' `Pvars79' `Fvars'  `Svars0'  `Zvars1'  `Evars00' `risk' `work' if ~m_asvab`asvab' & agemo==2801
	predict asvab`asvab'hatQuad if e(sample), xb
	matrix asvab`asvab'QuadR2a = e(r2_a)
	svmat  asvab`asvab'QuadR2a
	generat Dasvab`asvab'Quad = asvab`asvab'-asvab`asvab'hatQuad
	qui estat ic
	matrix ic`asvab'Quad = r(S)
	local aic`asvab'Quad = ic`asvab'Quad[1,5]
	local bic`asvab'Quad = ic`asvab'Quad[1,6]
	
	* Preferred specification (currently listed in the NPdecompositions document)
	qui reg asvab`asvab' `Pvars79' `Fvars1'  `Svars1'  `Zvars1'  `Evars0'  `Ivars3' `risk' `work' if ~m_asvab`asvab' & agemo==2801
	estimates store       reg`asvab'fit
	predict asvab`asvab'hat if e(sample), xb
	matrix asvab`asvab'R2a = e(r2_a)
	svmat  asvab`asvab'R2a
	generat Dasvab`asvab' = asvab`asvab'-asvab`asvab'hat
	qui estat ic
	matrix ic`asvab' = r(S)
	local aic`asvab' = ic`asvab'[1,5]
	local bic`asvab' = ic`asvab'[1,6]
	
	* More flexible specification
	qui reg asvab`asvab' `Pvars79' `Fvars15' `Svars15' `Zvars25' `Evars25' `Ivars3' `risk' `work' if ~m_asvab`asvab' & agemo==2801
	qui estat ic
	matrix ic`asvab'hatMoreFlex = r(S)
	local aic`asvab'hatMoreFlex = ic`asvab'hatMoreFlex[1,5]
	local bic`asvab'hatMoreFlex = ic`asvab'hatMoreFlex[1,6]
	predict asvab`asvab'hatMoreFlex if e(sample), xb
	matrix asvab`asvab'MoreFlexR2a = e(r2_a)
	svmat  asvab`asvab'MoreFlexR2a
	generat Dasvab`asvab'MoreFlex = asvab`asvab'-asvab`asvab'hatMoreFlex
	
	* Most flexible specification
	qui reg asvab`asvab' `Pvars79' `Fvars2'  `Svars3'  `Zvars3'  `Evars3'  `Ivars3' `risk' `work' if ~m_asvab`asvab' & agemo==2801
	qui estat ic
	matrix ic`asvab'hatMostFlex = r(S)
	local aic`asvab'hatMostFlex = ic`asvab'hatMostFlex[1,5]
	local bic`asvab'hatMostFlex = ic`asvab'hatMostFlex[1,6]
	predict asvab`asvab'hatMostFlex if e(sample), xb
	matrix asvab`asvab'MostFlexR2a = e(r2_a)
	svmat  asvab`asvab'MostFlexR2a
	generat Dasvab`asvab'MostFlex = asvab`asvab'-asvab`asvab'hatMostFlex
}

* compare model fits
sum asvab?? Dasvab* if agemo==2801, sep(0)

foreach asvab in AR CS MK NO PC WK {
	* qui gen SSE_`asvab'         = sum((asvab`asvab' - asvab`asvab'hat        )^2)
	* qui gen SSE_`asvab'MoreFlex = sum((asvab`asvab' - asvab`asvab'hatMoreFlex)^2)
	* qui gen SSE_`asvab'MostFlex = sum((asvab`asvab' - asvab`asvab'hatMostFlex)^2)
	
	disp "`asvab': AIC"
	disp `aic`asvab''
	disp `aic`asvab'hatMoreFlex'
	disp `aic`asvab'hatMostFlex'

	disp "`asvab': BIC"
	disp `bic`asvab''
	disp `bic`asvab'hatMoreFlex'
	disp `bic`asvab'hatMostFlex'
	
	* Graphs of adjusted R2
	capture drop specCat specR2a
	capture label drop vlspecR2a
	lab def vlspecR2a 1 "Linear" 2 "Quadratic" 3 "Flexible" 4 "More flexible" 5 "Most flexible"
	generat specCat = _n if _n<=5
	generat specR2a = .
	lab val specR2a vlspecR2a
	replace specR2a = asvab`asvab'LinR2a1[1] if _n==1
	replace specR2a = asvab`asvab'QuadR2a1[1] if _n==2
	replace specR2a = asvab`asvab'R2a1[1] if _n==3
	replace specR2a = asvab`asvab'MoreFlexR2a1[1] if _n==4
	replace specR2a = asvab`asvab'MostFlexR2a1[1] if _n==5
	
	l specR2a asvab`asvab'LinR2a1 asvab`asvab'QuadR2a1 asvab`asvab'R2a1 asvab`asvab'MoreFlexR2a1 asvab`asvab'MostFlexR2a1 in 1/5
	
	graph bar specR2a, over(specCat) graphregion(color(white)) ytitle("Adjusted R{superscript:2}") yscale(range(0 .55)) ylabel(0(.1).5)
	graph export ${graphics_path}asvab`asvab'R2aFit79o.eps, replace // can change to PNG if desired
	
	* Graphs of residuals
	_pctile Dasvab`asvab'Struct if agemo==2801 & ~m_asvab`asvab', percentiles(50)
	scalar median1 = r(r1)
	_pctile Dasvab`asvab'Lin if agemo==2801 & ~m_asvab`asvab', percentiles(50)
	scalar median2 = r(r1)
	_pctile Dasvab`asvab'Quad if agemo==2801 & ~m_asvab`asvab', percentiles(50)
	scalar median3 = r(r1)
	_pctile Dasvab`asvab' if agemo==2801 & ~m_asvab`asvab', percentiles(50)
	scalar median4 = r(r1)
	_pctile Dasvab`asvab'MoreFlex if agemo==2801 & ~m_asvab`asvab', percentiles(50)
	scalar median5 = r(r1)
	_pctile Dasvab`asvab'MostFlex if agemo==2801 & ~m_asvab`asvab', percentiles(50)
	scalar median6 = r(r1)
	graph twoway ( kdensity Dasvab`asvab'Lin if agemo==2801 & ~m_asvab`asvab') ( kdensity Dasvab`asvab'Quad if agemo==2801 & ~m_asvab`asvab') ( kdensity Dasvab`asvab' if agemo==2801 & ~m_asvab`asvab', lpattern(_) ) ( kdensity Dasvab`asvab'MoreFlex if agemo==2801 & ~m_asvab`asvab', lpattern("...") ) ( kdensity Dasvab`asvab'MostFlex if agemo==2801 & ~m_asvab`asvab', lpattern("-.") ) ///
	, xline(`=median1', lcolor(navy)) xline(`=median2', lpattern(_) lcolor(maroon)) xline(`=median3', lpattern("...") lcolor(forest_green)) xline(`=median4', lpattern("-.") lcolor(dkorange)) ///
	  legend(label(1 "Linear") label(2 "Quadratic") label(3 "Flexible") label(4 "More flexible") label(5 "Most flexible") cols(2) symxsize(10) keygap(1) ) graphregion(color(white)) xscale(range(-3.5 3.5)) xlabel(-3(1)3) xtitle("Residual") ytitle("Density")
	graph export ${graphics_path}Dasvab`asvab'fit79o.eps, replace // can change to PNG if desired
	
	_pctile asvab`asvab'hatStruct if agemo==2801 & ~m_asvab`asvab', percentiles(50)
	scalar median7 = r(r1)
	_pctile asvab`asvab'hatLin if agemo==2801 & ~m_asvab`asvab', percentiles(50)
	scalar median8 = r(r1)
	_pctile asvab`asvab'hatQuad if agemo==2801 & ~m_asvab`asvab', percentiles(50)
	scalar median9 = r(r1)
	_pctile asvab`asvab'hat if agemo==2801 & ~m_asvab`asvab', percentiles(50)
	scalar median10 = r(r1)
	_pctile asvab`asvab'hatMoreFlex if agemo==2801 & ~m_asvab`asvab', percentiles(50)
	scalar median11 = r(r1)
	_pctile asvab`asvab'hatMostFlex if agemo==2801 & ~m_asvab`asvab', percentiles(50)
	scalar median12 = r(r1)
	_pctile asvab`asvab' if agemo==2801 & ~m_asvab`asvab', percentiles(50)
	scalar median13 = r(r1)
	
	graph twoway ( kdensity asvab`asvab' if agemo==2801 & ~m_asvab`asvab') ( kdensity asvab`asvab'hatLin if agemo==2801 & ~m_asvab`asvab', lcolor(teal) lpattern("--..")) ( kdensity asvab`asvab'hatQuad if agemo==2801 & ~m_asvab`asvab', lcolor(maroon) lpattern(_)) ( kdensity asvab`asvab'hat if agemo==2801 & ~m_asvab`asvab', lcolor(forestgreen) lpattern("...") ) ( kdensity asvab`asvab'hatMostFlex if agemo==2801 & ~m_asvab`asvab', lcolor(dkorange) lpattern("-.") ) ///
	, xline(`=median8', lcolor(teal) lpattern("--..")) xline(`=median9', lpattern(_) lcolor(maroon)) xline(`=median10', lpattern("...") lcolor(forest_green)) xline(`=median12', lpattern("-.") lcolor(dkorange)) xline(`=median13', lcolor(navy)) ///
	  legend(label(1 "Data") label(2 "Linear") label(3 "Quadratic") label(4 "Flexible") label(5 "Most flexible") cols(2) symxsize(10) keygap(1) ) graphregion(color(white)) xscale(range(-3.5 3.5)) xlabel(-3(1)3) xtitle("Test Score") ytitle("Density")
	graph export ${graphics_path}Dasvab`asvab'compareDensity79.eps, replace // can change to PNG if desired
	
	graph twoway ( scatter Dasvab`asvab'Struct asvab`asvab' if agemo==2801 & ~m_asvab`asvab') ( scatter Dasvab`asvab' asvab`asvab' if agemo==2801 ) ( scatter Dasvab`asvab'MoreFlex asvab`asvab' if agemo==2801 ) ( scatter Dasvab`asvab'MostFlex asvab`asvab' if agemo==2801 ) ///
	, legend(label(1 "Structural") label(2 "Flexible") label(3 "More flexible") label(4 "Most flexible") cols(2) symxsize(10) keygap(1) ) graphregion(color(white)) xtitle("Actual ASVAB") ytitle("Actual - Predicted ASVAB")
	graph export ${graphics_path}Dasvab`asvab'scatter79o.eps, replace // can change to PNG if desired

	graph twoway ( scatter Dasvab`asvab'Struct   asvab`asvab' if agemo==2801 & ~m_asvab`asvab') ///
	, graphregion(color(white)) xtitle("Actual ASVAB") ytitle("Actual - Predicted ASVAB")
	graph export ${graphics_path}Dasvab`asvab'scatterStruct79o.eps, replace // can change to PNG if desired
	
	graph twoway ( scatter Dasvab`asvab'Lin   asvab`asvab' if agemo==2801 & ~m_asvab`asvab') ///
	, graphregion(color(white)) xtitle("Actual ASVAB") ytitle("Actual - Predicted ASVAB")
	graph export ${graphics_path}Dasvab`asvab'scatterLin79o.eps, replace // can change to PNG if desired
	
	graph twoway ( scatter Dasvab`asvab'Quad   asvab`asvab' if agemo==2801 & ~m_asvab`asvab') ///
	, graphregion(color(white)) xtitle("Actual ASVAB") ytitle("Actual - Predicted ASVAB")
	graph export ${graphics_path}Dasvab`asvab'scatterQuad79o.eps, replace // can change to PNG if desired
	
	graph twoway ( scatter Dasvab`asvab'         asvab`asvab' if agemo==2801 & ~m_asvab`asvab') ///
	, graphregion(color(white)) xtitle("Actual ASVAB") ytitle("Actual - Predicted ASVAB")
	graph export ${graphics_path}Dasvab`asvab'scatterFlex79o.eps, replace // can change to PNG if desired
	
	graph twoway ( scatter Dasvab`asvab'MoreFlex asvab`asvab' if agemo==2801 & ~m_asvab`asvab') ///
	, graphregion(color(white)) xtitle("Actual ASVAB") ytitle("Actual - Predicted ASVAB")
	graph export ${graphics_path}Dasvab`asvab'scatterMoreFlex79o.eps, replace // can change to PNG if desired
	
	graph twoway ( scatter Dasvab`asvab'MostFlex asvab`asvab' if agemo==2801 & ~m_asvab`asvab') ///
	, graphregion(color(white)) xtitle("Actual ASVAB") ytitle("Actual - Predicted ASVAB")
	graph export ${graphics_path}Dasvab`asvab'scatterMostFlex79o.eps, replace // can change to PNG if desired
}

* export data
preserve
	keep if firstObs==1 | agemo==2801
	bys id (year month): keep if _n==_N
	outsheet id year age agemo asvabAR asvabCS asvabMK asvabNO asvabPC asvabWK m_asvabAR m_asvabCS m_asvabMK m_asvabNO m_asvabPC m_asvabWK `Pvars79' `Fvars0' `Svars00' `Zvars00' `Evars000'        `risk' `work' using y79_asvab_fit_dataLinear.csv, comma replace nolabel
	outsheet id year age agemo asvabAR asvabCS asvabMK asvabNO asvabPC asvabWK m_asvabAR m_asvabCS m_asvabMK m_asvabNO m_asvabPC m_asvabWK `Pvars79' `Fvars1' `Svars1'  `Zvars1'  `Evars0' `Ivars3' `risk' `work' using y79_asvab_fit_dataChosen.csv, comma replace nolabel
	outsheet id year age agemo asvabAR asvabCS asvabMK asvabNO asvabPC asvabWK m_asvabAR m_asvabCS m_asvabMK m_asvabNO m_asvabPC m_asvabWK `Pvars79' `Fvars2' `Svars3'  `Zvars3'  `Evars3' `Ivars3' `risk' `work' using y79_asvab_fit_data.csv      , comma replace nolabel
restore

qui outreg2 [regARfit regCSfit regMKfit regNOfit regPCfit regWKfit] using y79_asvab_noFvars_t0_16_fit, excel replace bdec(4) sdec(4) ctitle(asvabs)

*============================================================================
* Create output for starting values for V++
*============================================================================
* Create a [K+size(sigma)] x [6] matrix

foreach asvab in AR CS MK NO PC WK {
	estimates restore reg`asvab'
	matrix           parm`asvab'   = e(b)'
	matrix           parm`asvab'v  = vecdiag(e(V))'
	matmap           parm`asvab'v parm`asvab'se, map(sqrt(@)) 
	matrix           like`asvab'   = e(ll)
}

* Now extract the coef and sigma matrix; then vec and combine them
matrix parmAll  = [parmAR , parmCS , parmMK , parmNO , parmPC , parmWK]
matrix coefAll  = parmAll[1..rowsof(parmAll)-1 , 1..6]
matrix coefAll  = vec(coefAll)
matrix sigmaAll = parmAll[rowsof(parmAll)      , 1..6]
matrix sigmaAll = vec(sigmaAll)

matrix parmSeAll  = [parmARse , parmCSse , parmMKse , parmNOse , parmPCse , parmWKse]
matrix coefSeAll  = parmSeAll[1..rowsof(parmSeAll)-1 , 1..6]
matrix coefSeAll  = vec(coefSeAll)
matrix sigmaSeAll = parmSeAll[rowsof(parmSeAll)      , 1..6]
matrix sigmaSeAll = vec(sigmaSeAll)

matrix coefSigmaAll   = [coefAll   \ sigmaAll]
matrix coefSigmaSeAll = [coefSeAll \ sigmaSeAll]

svmat  coefSigmaAll
svmat  coefSigmaSeAll

matrix coef_output  = [coefAll  , coefSeAll]
matrix sigma_output = [sigmaAll , sigmaSeAll]

matrix likeSum =  likeAR + likeCS + likeMK + likeNO + likePC + likeWK
matrix likeAll = [likeAR \ likeCS \ likeMK \ likeNO \ likePC \ likeWK \ likeSum]

* Export
preserve
	keep coefSigmaAll
	drop if coefSigmaAll==.
	outsheet coefSigmaAll using y79_asvab_noFvars_coef_t0_16.csv, comma replace
restore

putexcel A1=("AsvabCoefs")  A2=matrix(coef_output ,rownames) using y79_asvab_noFvars_t0_16.xlsx, sheet ("AsvabCoefs")  modify
putexcel F1=("AsvabLikes")  F2=matrix(likeAll     ,rownames) using y79_asvab_noFvars_t0_16.xlsx, sheet ("AsvabCoefs")  modify
putexcel A1=("AsvabSigmas") A2=matrix(sigma_output,rownames) using y79_asvab_noFvars_t0_16.xlsx, sheet ("AsvabSigmas") modify

log close
