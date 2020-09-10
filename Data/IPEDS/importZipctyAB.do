version 14.1
capture log close
set more off
log using "importZipctyAB.log", replace
clear all

* Import massive zipcode-county data match from CDC
* https://wonder.cdc.gov/wonder/sci_data/codes/fips/type_txt/cntyxref.asp
* Should do the exact same thing as "make_zcty.R"

forvalues X = 1/10 {
	* Unzip the data
	if `X'<=2 {
		!unzip zipctyA1.zip zipcty`X'
	}
	if `X'>=3 & `X'<=5 {
		!unzip zipctyA2.zip zipcty`X'
	}
	if `X'>=6 & `X'<=7 {
		!unzip zipctyB1.zip zipcty`X'
	}
	if `X'>=8 & `X'<=10 {
		!unzip zipctyB2.zip zipcty`X'
	}

	* Give a valid text extension
	!mv zipcty`X' zipcty`X'.raw

	* Make a temporary dct file to read in data
	!echo "dictionary using zipcty`X'.raw {     " >> myzipcty.dct
	!echo "  _column(1)   float  zipcode    %5f " >> myzipcty.dct
	!echo "  _column(24)  str2   stabbr     %2s " >> myzipcty.dct
	!echo "  _column(26)  int    fips3      %3f " >> myzipcty.dct
	!echo "  _column(29)  str25  countyname %25s" >> myzipcty.dct
	!echo "}                                    " >> myzipcty.dct

	* Read in and save the data
	infile using myzipcty.dct, clear
	drop if _n==1 & mi(zipcode)
	contract _all
	drop _freq
	tempfile holder`X'
	save `holder`X'', replace

	* Delete raw data and temp dct files
	!rm myzipcty.dct
	!rm zipcty`X'.raw
}

* Combine, fix errors and save
clear all
forvalues X=1/10 {
	append using `holder`X''
}
* No state info for 39901, but yes fips
replace stabbr="GA" if zipcode==39901

* For some zipcodes, some of the matched 3-digit fips code
*  don't have a corresponding countyname. If so, and if there is at
*  least one fips3 that DOES have a countyname, drop the one without
bys zipcode: egen namers = total(~mi(countyname))
drop if mi(countyname) & namers>1
drop namers

contract _all
drop _freq

compress
save zipctyAB.dta, replace

log close
