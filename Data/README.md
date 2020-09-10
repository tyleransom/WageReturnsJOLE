# Steps to create NLSY data

For each cohort (NLSY79 and NLSY97---respectively in folders `y79/` and `y97/`) you should find three files:

1. `y??_import_all.do`: reads in the raw NLSY data, renames variables, and reshapes the data into "long" format
    - Within this file, other `y??_import` do-files are called; these are divided into "demographics", "school", and "work"
2. `y??_create_master.do`: takes the formatted data in the previous step and creates new variables that will eventually be used
    - Again, there are sub-do-files with the same three suffixes that were referenced above
    - The output of this do-file is `y??_master.dta` which is a person-year panel
3. `y??_create_trim.do`: this file creates additional variables, implements sample restrictions, and reshapes to a person-month panel

We then append the NLSY79 and NLSY97 together using the code in `data_append_t0_16.do`. In this file we generate the experience variables, convert wages to comparable units, and make further sample restrictions.

The file `create_vlad_scaled_t0_16.do` converts the combined data into a wide panel for use in the (non-Stata) software that estimates our maximum likelihood factor model.
