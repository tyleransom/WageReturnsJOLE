clear all
version 14.2
set matsize 11000
set more off
capture log close
log using concatenator_annual.log, replace

* foreach state in al {
foreach state in al ak az ar ca co ct dc de fl ga hi id il in ia ks ky la me md ma mi mn ms mo mt ne nv nh nj nm ny nc nd oh ok or pa ri sc sd tn tx ut vt va wa wv wi wy {
    tempfile `state'
    insheet using `state'.txt, clear
    
    drop if substr(series_id,1,5)~="LAUCN"
    drop if period~="M13"
    
    gen FIPS    = substr(series_id,6,5)
    gen state   = substr(FIPS,1,2)
    gen county  = substr(FIPS,3,3)
    gen vartype = substr(series_id,20,1)
    gen month   = substr(period,2,2)
    drop period series_id month
    
    destring state county vartype, replace
    
    reshape wide value, i(state county year) j(vartype)
    ren value3 urate
    ren value4 unemployed
    ren value5 employed
    ren value6 labor_force
    destring urate unemployed employed labor_force, replace force
    
    sort FIPS year
    order FIPS state county year labor_force employed unemployed urate
    save ``state'', replace
}

use `al', clear
foreach state in ak az ar ca co ct dc de fl ga hi id il in ia ks ky la me md ma mi mn ms mo mt ne nv nh nj nm ny nc nd oh ok or pa ri sc sd tn tx ut vt va wa wv wi wy {
    append using ``state''
}

compress
save county_unemp_annual, replace
drop footnote_codes
outsheet using county_unemp_annual.csv, comma nol replace

log close

