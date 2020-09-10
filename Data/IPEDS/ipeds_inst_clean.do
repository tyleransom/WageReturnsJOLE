version 14.1
capture log close
set more off
log using ipeds_inst_clean.log, replace

clear all

*****************************************************************************
* Clean instutional data
*****************************************************************************
!unzip inst_all.dta.zip 
use inst_all.dta, clear
!rm inst_all.dta

*============================================================================
* Initial cleaning
*============================================================================
* Clean instnm and city for the IPEDS data
do college_clean.do

*==================================================
* Final cleaning/adjustments to allow for matching
*==================================================
*  Note: years are school years and thus 2009 is 2008-2009
* Need to get so there is one observation per nm/year/st/city combo.
*  Simplest solution: keep the smallest unitid per combo but only 
*   choose from the set that contains the mode(inst_control)
bys instnm year stabbr city: egen mode_control = mode(inst_control), minmode
gen control_not_mode = (inst_control!=mode_control)

bys  instnm year stabbr city (control_not_mode unitid): drop if _n!=1

isid instnm year stabbr city
drop mode_control control_not_mode

label data "IPEDS Institutions, clean instnm and city"

* Individual fix
* Eastern NM U and E NM U Central switched unitids. Manual override
replace instnm="EASTERN NEW MEXICO UNIVERSITY"         if unitid==187648
replace instnm="EASTERN NEW MEXICO UNIVERSITY CENTRAL" if unitid==187657

compress
save ipeds_inst_final.dta, replace
!zip -m ipeds_inst_final.dta.zip ipeds_inst_final.dta

log close
