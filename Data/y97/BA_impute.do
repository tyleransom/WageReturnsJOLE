**************************************************
* This do-file identifies individuals who reported
* receiving a BA or higher, but did not report the
* date of that BA
**************************************************

* generate a list of IDs in question
qui tab ID if inrange(Highest_degree_ever_cum,4,7) & year==2012 & mi(BA_date)
disp "Number of individuals for whom to impute graduation date: `r(r)'"

* create a numlist from this (to loop over)
preserve
	tempfile BAimp
	keep if inrange(Highest_degree_ever_cum,4,7) & mi(BA_date)
	
	* get last month and last year enrolled in undergraduate institution for these people
	foreach months in Jan Feb Mar Apr May Jun Jul Aug Sep Oct Nov Dec {
		gen undergrad`months' = 1 if College_enrollment_`months'==3
	}
	egen monthsUndergrad = rowtotal(undergrad???)
	
	generat lastMonthUndergrad = .
	replace lastMonthUndergrad = 1  if ~mi(undergradJan) & mi(undergradFeb) & mi(undergradMar) & mi(undergradApr) & mi(undergradMay) & mi(undergradJun) & mi(undergradJul) & mi(undergradAug) & mi(undergradSep) & mi(undergradOct) & mi(undergradNov) & mi(undergradDec)
	replace lastMonthUndergrad = 2  if ~mi(undergradFeb) & mi(undergradMar) & mi(undergradApr) & mi(undergradMay) & mi(undergradJun) & mi(undergradJul) & mi(undergradAug) & mi(undergradSep) & mi(undergradOct) & mi(undergradNov) & mi(undergradDec)
	replace lastMonthUndergrad = 3  if ~mi(undergradMar) & mi(undergradApr) & mi(undergradMay) & mi(undergradJun) & mi(undergradJul) & mi(undergradAug) & mi(undergradSep) & mi(undergradOct) & mi(undergradNov) & mi(undergradDec)
	replace lastMonthUndergrad = 4  if ~mi(undergradApr) & mi(undergradMay) & mi(undergradJun) & mi(undergradJul) & mi(undergradAug) & mi(undergradSep) & mi(undergradOct) & mi(undergradNov) & mi(undergradDec)
	replace lastMonthUndergrad = 5  if ~mi(undergradMay) & mi(undergradJun) & mi(undergradJul) & mi(undergradAug) & mi(undergradSep) & mi(undergradOct) & mi(undergradNov) & mi(undergradDec)
	replace lastMonthUndergrad = 6  if ~mi(undergradJun) & mi(undergradJul) & mi(undergradAug) & mi(undergradSep) & mi(undergradOct) & mi(undergradNov) & mi(undergradDec)
	replace lastMonthUndergrad = 7  if ~mi(undergradJul) & mi(undergradAug) & mi(undergradSep) & mi(undergradOct) & mi(undergradNov) & mi(undergradDec)
	replace lastMonthUndergrad = 8  if ~mi(undergradAug) & mi(undergradSep) & mi(undergradOct) & mi(undergradNov) & mi(undergradDec)
	replace lastMonthUndergrad = 9  if ~mi(undergradSep) & mi(undergradOct) & mi(undergradNov) & mi(undergradDec)
	replace lastMonthUndergrad = 10 if ~mi(undergradOct) & mi(undergradNov) & mi(undergradDec)
	replace lastMonthUndergrad = 11 if ~mi(undergradNov) & mi(undergradDec)
	replace lastMonthUndergrad = 12 if ~mi(undergradDec)
	replace lastMonthUndergrad = .  if monthsUndergrad==1 & lastMonthUndergrad>1 & ~mi(lastMonthUndergrad) // to correct for survey error
	
	generat YrEnrUndergrad = year*(~mi(lastMonthUndergrad))
	generat MoEnrUndergrad = lastMonthUndergrad*(~mi(lastMonthUndergrad))
	bys ID: egen LastYrEnrUndergrad = max(YrEnrUndergrad)
	recode LastYrEnrUndergrad (0 = .)
	gen LastMoEnrUndergradA = MoEnrUndergrad if year==LastYrEnrUndergrad
	bys ID: egen LastMoEnrUndergrad = mean(LastMoEnrUndergradA)
	
	* l ID year lastMonthUndergrad YrEnrUndergrad LastYrEnrUndergrad MoEnrUndergrad LastMoEnrUndergrad if inlist(ID,135,245,294,301,305) & year>1996, sepby(ID)
	mdesc LastYrEnrUndergrad LastMoEnrUndergrad
	keep ID year LastYrEnrUndergrad LastMoEnrUndergrad
	save `BAimp', replace
restore

* impute the month after this as the graduation date
merge 1:1 ID year using `BAimp', nogen

replace BA_month = LastMoEnrUndergrad   if mi(BA_month) & ~mi(LastMoEnrUndergrad)
replace BA_year  = LastYrEnrUndergrad   if mi(BA_year ) & ~mi(LastYrEnrUndergrad)
replace BA_date  = ym(BA_year,BA_month) if mi(BA_date ) & ~mi(LastYrEnrUndergrad)

drop LastMoEnrUndergrad LastYrEnrUndergrad

*------------------------------------------------------
* take away grad degrees that appear to be mis-reported
*------------------------------------------------------
replace Grad_date  = . if inlist(ID,435,2762,7852)
replace Grad_year  = . if inlist(ID,435,2762,7852)
replace Grad_month = . if inlist(ID,435,2762,7852)
