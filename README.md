# WageReturnsJOLE
Code and results for paper by Ashworth, Hotz, Maurel and Ransom published in *Journal of Labor Economics*.

## Steps to obtain access to restricted BLS data
Our analysis heavily relies on the restricted-access version of the NLSY79 and NLSY97 surveys. To obtain access, please visit https://www.bls.gov/nls/geocodeapp.htm and fill out the application. We include in this code repository all of the source code to compile our data with the raw restricted-access data.

## Steps to replicate our results:
We include publicly available data in this respository, but we also document the sources of each publicly available dataset below.

### 1.  Download Publicly Data from Various Sources
- NLSY (https://www.nlsinfo.org/investigator/pages/login)
    - For lists of variables used, see `Data/y79/AncillaryFiles/*.NLSY79` and `Data/y97/RawData/*.NLSY97`
- Other Data Sources
    - BEA: Data on County Income and County Employment Levels	
        * Series CA4, CA5, CA5N, CA25, and CA25N (from https://apps.bea.gov/regional/downloadzip.cfm)
    - BLS: CPI	and County level unemployment (1990- )
        * CPI comes from Economic Report of the President (2013, [here](https://obamawhitehouse.archives.gov/sites/default/files/docs/erp2013/full_2013_economic_report_of_the_president.pdf))
        * County-level unemployment rate comes from, e.g. https://download.bls.gov/pub/time.series/la/la.data.7.Alabama (see `downloader.sh` in the `Data/BLS/CountyUnemp` folder)
    - Census: County level population data	
        * 1970s: http://www.census.gov/popest/data/counties/asrh/pre-1980/co-asr-7079.html -> http://www.census.gov/popest/data/counties/asrh/pre-1980/tables/co-asr-7079.csv
        * 1980s: http://www.census.gov/popest/data/counties/asrh/1980s/PE-02.html -> individual links for years (great FireFox add-on to help: downThemAll)
        * 1990s: http://www.census.gov/popest/data/counties/asrh/1990s/CO-99-09.html -> individual links for states (great FireFox add-on to help: downThemAll)
        * 2000s: http://www.census.gov/popest/data/intercensal/county/county2010.html -> http://www.census.gov/popest/data/intercensal/county/files/CO-EST00INT-AGESEX-5YR.csv
        * 2010s: https://www2.census.gov/programs-surveys/popest/datasets/2010-2017/counties/asrh/cc-est2017-alldata.html -> https://www2.census.gov/programs-surveys/popest/datasets/2010-2017/counties/asrh/cc-est2017-alldata.csv
    - IPEDS: No. of local colleges, tuition at flagship university
        * see `_readme.txt` in the `Data/IPEDS/` folder
### 2. Data Creation / Cleaning
- Files to process non-NLSY data sources:
    * BEA: run `Data/BEA/BEA_create.do` (outputs `BEAcountyFIPS.dta`)
    * BLS Local Unemployment: run `Data/BLS/CountyUnemp/concatenator.do` (outputs `county_unemp_monthly.dta`)
    * BLS CPI: manually coded into `Data/BLS/cpi.do`
    * Census: run `Data/Census/import_census.do` (outputs `county_population.dta`)
    * IPEDS: run `Data/IPEDS/ipeds_all_combine.do` (outputs `ipeds_final.dta`)
    * **Combine all sources:**
        - run `Data/create_county_data.do` which creates `county_data.dta` which is a combination of all county-level information (employment rate, income per capita, number of BA-granting colleges, and tuition at state flagship university). Monetary variables are deflated in this file.
- Files to read in and process NLSY data:
    * NLSY79:
        - run `Data/y79/y79_import_all.do`, then `Data/y79/y79_create_master.do`, then `Data/y79/y79_create_trim.do`, which will output `y79_all.dta.zip`
    * NLSY97:
        - run `Data/y97/y97_import_all.do`, then `Data/y97/y97_create_master.do`, then `Data/y97/y97_create_trim.do`, which will output `y97_all.dta.zip`
    * NLSY Geocode Data:
        - run `Data/geocodeMaster.do`, which outputs the files `Data/y{79,97}/Geocode/y{79,97}_all2.dta.zip`. The `geocodeMaster.do` file also contains code that merges in the county-level information contained in `Data/county_data.dta`.
    * Combine NLSY cohorts:
        - run `Data/data_append_t0_16.do` which takes as inputs `Data/y{79,97}/Geocode/y{79,97}_all2.dta.zip` and outputs `Data/yCombinedAnalysis_t0_16.dta.zip`
- Set up Data to be readable in V++ software:
    - run `Data/create_vlad_scaled_t0_16.do` which takes `Data/yCombinedAnalysis_t0_16.dta.zip` as its input and outputs `y{79,97}_vlad_scaled_t0_16.csv` which are files read into the V++ software (which estimates factor analytic discrete choice models via Matlab C++ MEX files)
### 3. Data Analysis, Estimation, and Marginal Effects
* Descriptive Statistics:
    - run `Descriptives/activity_tabulations29.do` which outputs `Descriptives/T*_29.tex` (which are the descriptive tables in TeX format)
    - comparison descriptive statistics for the CPS are located in `Descriptives/NLSYagedCPSstats.do` which outputs `Descriptives/T5_29_CPS.tex` (which we report in an appendix)
* Descriptive Regressions, including various specifcations (Mincer, HLT, etc)
    - run `y{79,97}_mincerv7_t0_16_no_oldest.do` which outputs marginal effects from various specifications that are reported in Tables 9 and 10 of the paper
* No-unobserved-heterogeneity estimation in Stata:
    - run `Analysis/analysisMaster.do` which provides the following outputs that are beneficial because they provide useful starting values for the Matlab MEX optimization for the models with random factors: 
        * `y{79,97}_asvab_noFvars_t0_16_coef.csv` (for measurement system)
        * `y{79,97}_logits_all_binned_t0_16_coef.csv` (for choice equations)
        * `y{79,97}_wages_anyschool_school_interaction_t0_16_coef.csv` (for wage equation)
* Estimation of specifications with random factors in V++:
    - Without unobserved heterogeneity (essentially, replicating results from Stata):
        * run `V++/y{79,97}_t0_16/NoHetClusterSE/master.m` which outputs `results_cluster_se.csv` in the same folder (which are the complete parameter estimates of the entire model)
    - With unobserved heterogeneity:
        * run `V++/y{79,97}_t0_16/Het1Load??/master.m` which outputs `results_no_se.csv` in the same folder
        * run `V++/y{79,97}_t0_16/Het1Load??/ClusterSE/cluster_se.m` which outputs `results_cluster_se.csv` in the same folder (which are the complete parameter estimates of the entire model with unobserved heterogeneity)
        * Note: we run these results in 10 separate folders, representing 10 separate sets of starting values in search of the global optimum. The global optimum for the NLSY79 was in folder 03, while for the NLSY97 it was folder 10.
* Marginal effects
    - To obtain marginal effects from the estimation with unobserved heterogeneity, run the following:
        * run `V++/y{79,97}_t0_16/Het1Load??/ClusterSE/mfxExper{29,32}.m` which outputs `mfxExper{29,32}.csv` in the same folder. These results are reported in Tables 9 and 10 in the paper.
