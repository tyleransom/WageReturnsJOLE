*** Impute the monthly hgc as a linear version of yearly hgc
replace hgc = . if month~=1
bys id: gen t = _n
bys id: ipolate hgc t, gen(hgc1)

drop hgc
ren  hgc1 hgc

*** fix left-censored HGC as 1/12 less than previous
replace hgc = hgc[_n+1]-1/12 if hgc[_n]>=. & hgc[_n+1]<. & age==13
replace hgc = hgc[_n+1]-1/12 if hgc[_n]>=. & hgc[_n+1]<. & age==13
replace hgc = hgc[_n+1]-1/12 if hgc[_n]>=. & hgc[_n+1]<. & age==13
replace hgc = hgc[_n+1]-1/12 if hgc[_n]>=. & hgc[_n+1]<. & age==13
replace hgc = hgc[_n+1]-1/12 if hgc[_n]>=. & hgc[_n+1]<. & age==13
replace hgc = hgc[_n+1]-1/12 if hgc[_n]>=. & hgc[_n+1]<. & age==13
replace hgc = hgc[_n+1]-1/12 if hgc[_n]>=. & hgc[_n+1]<. & age==13
replace hgc = hgc[_n+1]-1/12 if hgc[_n]>=. & hgc[_n+1]<. & age==13
replace hgc = hgc[_n+1]-1/12 if hgc[_n]>=. & hgc[_n+1]<. & age==13
replace hgc = hgc[_n+1]-1/12 if hgc[_n]>=. & hgc[_n+1]<. & age==13
replace hgc = hgc[_n+1]-1/12 if hgc[_n]>=. & hgc[_n+1]<. & age==13
replace hgc = hgc[_n+1]-1/12 if hgc[_n]>=. & hgc[_n+1]<. & age==13
replace hgc = hgc[_n+1]-1/12 if hgc[_n]>=. & hgc[_n+1]<. & age==13
replace hgc = hgc[_n+1]-1/12 if hgc[_n]>=. & hgc[_n+1]<. & age==13
replace hgc = hgc[_n+1]-1/12 if hgc[_n]>=. & hgc[_n+1]<. & age==13
replace hgc = hgc[_n+1]-1/12 if hgc[_n]>=. & hgc[_n+1]<. & age==13
replace hgc = hgc[_n+1]-1/12 if hgc[_n]>=. & hgc[_n+1]<. & age==13
replace hgc = hgc[_n+1]-1/12 if hgc[_n]>=. & hgc[_n+1]<. & age==13
replace hgc = hgc[_n+1]-1/12 if hgc[_n]>=. & hgc[_n+1]<. & age==13
replace hgc = hgc[_n+1]-1/12 if hgc[_n]>=. & hgc[_n+1]<. & age==13
replace hgc = hgc[_n+1]-1/12 if hgc[_n]>=. & hgc[_n+1]<. & age==13
replace hgc = hgc[_n+1]-1/12 if hgc[_n]>=. & hgc[_n+1]<. & age==13
replace hgc = hgc[_n+1]-1/12 if hgc[_n]>=. & hgc[_n+1]<. & age==13
replace hgc = hgc[_n+1]-1/12 if hgc[_n]>=. & hgc[_n+1]<. & age==13
replace hgc = hgc[_n+1]-1/12 if hgc[_n]>=. & hgc[_n+1]<. & age==13
replace hgc = hgc[_n+1]-1/12 if hgc[_n]>=. & hgc[_n+1]<. & age==13
replace hgc = hgc[_n+1]-1/12 if hgc[_n]>=. & hgc[_n+1]<. & age==13
replace hgc = hgc[_n+1]-1/12 if hgc[_n]>=. & hgc[_n+1]<. & age==13
replace hgc = hgc[_n+1]-1/12 if hgc[_n]>=. & hgc[_n+1]<. & age==13
replace hgc = hgc[_n+1]-1/12 if hgc[_n]>=. & hgc[_n+1]<. & age==13
replace hgc = hgc[_n+1]-1/12 if hgc[_n]>=. & hgc[_n+1]<. & age==13
replace hgc = hgc[_n+1]-1/12 if hgc[_n]>=. & hgc[_n+1]<. & age==13
replace hgc = hgc[_n+1]-1/12 if hgc[_n]>=. & hgc[_n+1]<. & age==13

*** fix right-censored HGC as constant
bys id: gen last_year_ish = (_N - _n <=16)
replace hgc = hgc[_n-1] if hgc[_n]>=. & last_year_ish==1

replace hgc = 0 if hgc<0

