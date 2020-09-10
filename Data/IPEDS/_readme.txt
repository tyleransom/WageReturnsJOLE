The files "ipeds_inst_combine.do", "ipeds_comp_combine.do" and "ipeds_enroll.do" created "inst_all.dta", "comp_all.dta" and "enroll_all.dta", 
respectively, in another part of server, where there are individual year files for both "inst" data and "comp" data.
Rather than copy all of those individual files over, only the final product was copied over. These do files are read-only.

"ipeds_inst_clean.do" uses "college_clean.do" and some other commands to help clean the college names for an easy match.

"college_clean.do" would need to be applied on any other dataset in order to perform a match

"ipeds_all_combine.do" combines the relevant files together for the specific purpose at hand:

--County data in IPEDS isn't awful; rely on the zip codes to be better and use those (primarily)
--By county, determine the number of 4-yr colleges, 2-yr colleges and average tuitions for
  various cuts of college type (highest degree as well as control)

  
  
Some sources:

----------------------------------
zipctyA.zip
zipctyB.zip

https://wonder.cdc.gov/wonder/sci_data/codes/fips/type_txt/cntyxref.asp

Background

 The County Cross Reference File is a product which provides a
 relationship between ZIP+4 codes and Federal Information
 Processing Standard (FIPS) county codes.  The file allows users
 who have assigned ZIP+4 codes to their address files to obtain
 county data at the ZIP+4 level.

 The County Cross Reference File was originally available on tape or cartridge.
 The data are now available as a series of 10 simple-text fixed-format records, 
 compressed into 2 "zip" files.

 The copyright on the 1st file indicates these data are are from September, 1988.

   -- Annoying: original zipctyA(B).zip files are 70M...had to split 'em up. Code to do that:

unzip zipctyA.zip
zip -m zipctyA1.zip zipcty1
zip -m zipctyA1.zip zipcty2
zip -m zipctyA2.zip zipcty3
zip -m zipctyA2.zip zipcty4
zip -m zipctyA2.zip zipcty5

unzip zipctyB.zip
zip -m zipctyB1.zip zipcty6
zip -m zipctyB1.zip zipcty7
zip -m zipctyB2.zip zipcty8
zip -m zipctyB2.zip zipcty9
zip -m zipctyB2.zip zipcty10
 
------------------------------------
 statefips.csv comes from https://www.census.gov/geo/reference/ansi_statetables.html
------------------------------------

 statefipsflagship.csv combines the above data with a list of flagship Universities from:
 https://trends.collegeboard.org/college-pricing/figures-tables/tuition-fees-flagship-universities-over-time

