***********************************************
* Create fed min wage and cpi
* http://www.dol.gov/whd/minwage/chart.htm
* http://lmi2.detma.org/lmi/pdf/MinimumWage.pdf
* and
* http://www.bls.gov/cpi/
***********************************************

gen         fedMinWage=0.25 if year==1938
qui replace fedMinWage=0.30 if year==1939
qui replace fedMinWage=0.30 if year==1940
qui replace fedMinWage=0.30 if year==1941
qui replace fedMinWage=0.30 if year==1942
qui replace fedMinWage=0.30 if year==1943
qui replace fedMinWage=0.30 if year==1944
qui replace fedMinWage=0.40 if year==1945
qui replace fedMinWage=0.40 if year==1946
qui replace fedMinWage=0.40 if year==1947
qui replace fedMinWage=0.40 if year==1948
qui replace fedMinWage=0.40 if year==1949
qui replace fedMinWage=0.75 if year==1950
qui replace fedMinWage=0.75 if year==1951
qui replace fedMinWage=0.75 if year==1952
qui replace fedMinWage=0.75 if year==1953
qui replace fedMinWage=0.75 if year==1954
qui replace fedMinWage=0.75 if year==1955
qui replace fedMinWage=1.00 if year==1956
qui replace fedMinWage=1.00 if year==1957
qui replace fedMinWage=1.00 if year==1958
qui replace fedMinWage=1.00 if year==1959
qui replace fedMinWage=1.00 if year==1960
qui replace fedMinWage=1.15 if year==1961
qui replace fedMinWage=1.15 if year==1962
qui replace fedMinWage=1.25 if year==1963
qui replace fedMinWage=1.25 if year==1964
qui replace fedMinWage=1.25 if year==1965
qui replace fedMinWage=1.25 if year==1966
qui replace fedMinWage=1.40 if year==1967
qui replace fedMinWage=1.60 if year==1968
qui replace fedMinWage=1.60 if year==1969
qui replace fedMinWage=1.60 if year==1970
qui replace fedMinWage=1.60 if year==1971
qui replace fedMinWage=1.60 if year==1972
qui replace fedMinWage=1.60 if year==1973
qui replace fedMinWage=2.00 if year==1974
qui replace fedMinWage=2.10 if year==1975
qui replace fedMinWage=2.30 if year==1976
qui replace fedMinWage=2.30 if year==1977
qui replace fedMinWage=2.65 if year==1978
qui replace fedMinWage=2.90 if year==1979
qui replace fedMinWage=3.10 if year==1980
qui replace fedMinWage=3.35 if year==1981
qui replace fedMinWage=3.35 if year==1982
qui replace fedMinWage=3.35 if year==1983
qui replace fedMinWage=3.35 if year==1984
qui replace fedMinWage=3.35 if year==1985
qui replace fedMinWage=3.35 if year==1986
qui replace fedMinWage=3.35 if year==1987
qui replace fedMinWage=3.35 if year==1988
qui replace fedMinWage=3.35 if year==1989
qui replace fedMinWage=3.80 if year==1990
qui replace fedMinWage=4.25 if year==1991
qui replace fedMinWage=4.25 if year==1992
qui replace fedMinWage=4.25 if year==1993
qui replace fedMinWage=4.25 if year==1994
qui replace fedMinWage=4.25 if year==1995
qui replace fedMinWage=4.75 if year==1996
qui replace fedMinWage=5.15 if year==1997
qui replace fedMinWage=5.15 if year==1998
qui replace fedMinWage=5.15 if year==1999
qui replace fedMinWage=5.15 if year==2000
qui replace fedMinWage=5.15 if year==2001
qui replace fedMinWage=5.15 if year==2002
qui replace fedMinWage=5.15 if year==2003
qui replace fedMinWage=5.15 if year==2004
qui replace fedMinWage=5.15 if year==2005
qui replace fedMinWage=5.15 if year==2006
qui replace fedMinWage=5.85 if year==2007
qui replace fedMinWage=6.55 if year==2008
qui replace fedMinWage=7.25 if year==2009
qui replace fedMinWage=7.25 if year==2010
qui replace fedMinWage=7.25 if year==2011
qui replace fedMinWage=7.25 if year==2012
qui replace fedMinWage=7.25 if year==2013
qui replace fedMinWage=7.25 if year==2014
qui replace fedMinWage=7.25 if year==2015
qui replace fedMinWage=7.25 if year==2016
qui replace fedMinWage=7.25 if year==2017

gen         cpi= 14.100 if year==1938
qui replace cpi= 13.900 if year==1939
qui replace cpi= 14.000 if year==1940
qui replace cpi= 14.700 if year==1941
qui replace cpi= 16.300 if year==1942
qui replace cpi= 17.300 if year==1943
qui replace cpi= 17.600 if year==1944
qui replace cpi= 18.000 if year==1945
qui replace cpi= 19.500 if year==1946
qui replace cpi= 22.300 if year==1947
qui replace cpi= 24.100 if year==1948
qui replace cpi= 23.800 if year==1949
qui replace cpi= 24.100 if year==1950
qui replace cpi= 26.000 if year==1951
qui replace cpi= 26.500 if year==1952
qui replace cpi= 26.700 if year==1953
qui replace cpi= 26.900 if year==1954
qui replace cpi= 26.800 if year==1955
qui replace cpi= 27.200 if year==1956
qui replace cpi= 28.100 if year==1957
qui replace cpi= 28.900 if year==1958
qui replace cpi= 29.100 if year==1959
qui replace cpi= 29.600 if year==1960
qui replace cpi= 29.900 if year==1961
qui replace cpi= 30.200 if year==1962
qui replace cpi= 30.600 if year==1963
qui replace cpi= 31.000 if year==1964
qui replace cpi= 31.500 if year==1965
qui replace cpi= 32.400 if year==1966
qui replace cpi= 33.400 if year==1967
qui replace cpi= 34.800 if year==1968
qui replace cpi= 36.700 if year==1969
qui replace cpi= 38.800 if year==1970
qui replace cpi= 40.500 if year==1971
qui replace cpi= 41.800 if year==1972
qui replace cpi= 44.400 if year==1973
qui replace cpi= 49.300 if year==1974
qui replace cpi= 53.800 if year==1975
qui replace cpi= 56.900 if year==1976
qui replace cpi= 60.600 if year==1977
qui replace cpi= 65.200 if year==1978
qui replace cpi= 72.600 if year==1979
qui replace cpi= 82.400 if year==1980
qui replace cpi= 90.900 if year==1981
qui replace cpi= 96.500 if year==1982
qui replace cpi= 99.600 if year==1983
qui replace cpi=103.900 if year==1984
qui replace cpi=107.600 if year==1985
qui replace cpi=109.600 if year==1986
qui replace cpi=113.600 if year==1987
qui replace cpi=118.300 if year==1988
qui replace cpi=124.000 if year==1989
qui replace cpi=130.700 if year==1990
qui replace cpi=136.200 if year==1991
qui replace cpi=140.300 if year==1992
qui replace cpi=144.500 if year==1993
qui replace cpi=148.200 if year==1994
qui replace cpi=152.400 if year==1995
qui replace cpi=156.900 if year==1996
qui replace cpi=160.500 if year==1997
qui replace cpi=163.000 if year==1998
qui replace cpi=166.600 if year==1999
qui replace cpi=172.200 if year==2000
qui replace cpi=177.100 if year==2001
qui replace cpi=179.900 if year==2002
qui replace cpi=184.000 if year==2003
qui replace cpi=188.900 if year==2004
qui replace cpi=195.300 if year==2005
qui replace cpi=201.600 if year==2006
qui replace cpi=207.342 if year==2007
qui replace cpi=215.303 if year==2008
qui replace cpi=214.537 if year==2009
qui replace cpi=218.056 if year==2010
qui replace cpi=224.939 if year==2011
qui replace cpi=229.594 if year==2012
qui replace cpi=232.957 if year==2013
qui replace cpi=236.736 if year==2014
qui replace cpi=237.017 if year==2015
qui replace cpi=240.007 if year==2016
qui replace cpi=245.120 if year==2017

qui replace fedMinWage = fedMinWage*100
qui replace cpi=cpi/100

lab var fedMinWage "Federal Minimum Wage (undeflated)"
lab var cpi "CPI-Urban/100 (1982-84)"
