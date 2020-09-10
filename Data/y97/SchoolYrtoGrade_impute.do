**to check the validity of these changes, type:
**bys ID: assert School_Yr_to_Grade[_n+1]>=School_Yr_to_Grade[_n]

* Replace "ungraded" or other error with "."
replace School_Yr_to_Grade = . if inrange(School_Yr_to_Grade,41,.)

* Impute Grade_t = (Grade_t+1)-1 if Grade_t is missing and person is of HS age
bys ID: replace School_Yr_to_Grade = School_Yr_to_Grade[_n+1]-1 if mi(School_Yr_to_Grade[_n]) & ~mi(School_Yr_to_Grade[_n+1]) & age_now==17
bys ID: replace School_Yr_to_Grade = School_Yr_to_Grade[_n+1]-1 if mi(School_Yr_to_Grade[_n]) & ~mi(School_Yr_to_Grade[_n+1]) & age_now==16
bys ID: replace School_Yr_to_Grade = School_Yr_to_Grade[_n+1]-1 if mi(School_Yr_to_Grade[_n]) & ~mi(School_Yr_to_Grade[_n+1]) & age_now==15
bys ID: replace School_Yr_to_Grade = School_Yr_to_Grade[_n+1]-1 if mi(School_Yr_to_Grade[_n]) & ~mi(School_Yr_to_Grade[_n+1]) & age_now==14
bys ID: replace School_Yr_to_Grade = School_Yr_to_Grade[_n+1]-1 if mi(School_Yr_to_Grade[_n]) & ~mi(School_Yr_to_Grade[_n+1]) & age_now==13
bys ID: replace School_Yr_to_Grade = School_Yr_to_Grade[_n+1]-1 if mi(School_Yr_to_Grade[_n]) & ~mi(School_Yr_to_Grade[_n+1]) & age_now==12

* Impute Grade_t = Grade_t+k if Grade_t-1 == Grade_t+k (i.e. impute a flat grades trajectory)
bys ID: replace School_Yr_to_Grade = School_Yr_to_Grade[_n-1] if mi(School_Yr_to_Grade[_n]) & School_Yr_to_Grade[_n-1] == School_Yr_to_Grade[_n+14] & ~mi(School_Yr_to_Grade[_n-1])
bys ID: replace School_Yr_to_Grade = School_Yr_to_Grade[_n-1] if mi(School_Yr_to_Grade[_n]) & School_Yr_to_Grade[_n-1] == School_Yr_to_Grade[_n+13] & ~mi(School_Yr_to_Grade[_n-1])
bys ID: replace School_Yr_to_Grade = School_Yr_to_Grade[_n-1] if mi(School_Yr_to_Grade[_n]) & School_Yr_to_Grade[_n-1] == School_Yr_to_Grade[_n+12] & ~mi(School_Yr_to_Grade[_n-1])
bys ID: replace School_Yr_to_Grade = School_Yr_to_Grade[_n-1] if mi(School_Yr_to_Grade[_n]) & School_Yr_to_Grade[_n-1] == School_Yr_to_Grade[_n+11] & ~mi(School_Yr_to_Grade[_n-1])
bys ID: replace School_Yr_to_Grade = School_Yr_to_Grade[_n-1] if mi(School_Yr_to_Grade[_n]) & School_Yr_to_Grade[_n-1] == School_Yr_to_Grade[_n+10] & ~mi(School_Yr_to_Grade[_n-1])
bys ID: replace School_Yr_to_Grade = School_Yr_to_Grade[_n-1] if mi(School_Yr_to_Grade[_n]) & School_Yr_to_Grade[_n-1] == School_Yr_to_Grade[_n+9]  & ~mi(School_Yr_to_Grade[_n-1])
bys ID: replace School_Yr_to_Grade = School_Yr_to_Grade[_n-1] if mi(School_Yr_to_Grade[_n]) & School_Yr_to_Grade[_n-1] == School_Yr_to_Grade[_n+8]  & ~mi(School_Yr_to_Grade[_n-1])
bys ID: replace School_Yr_to_Grade = School_Yr_to_Grade[_n-1] if mi(School_Yr_to_Grade[_n]) & School_Yr_to_Grade[_n-1] == School_Yr_to_Grade[_n+7]  & ~mi(School_Yr_to_Grade[_n-1])
bys ID: replace School_Yr_to_Grade = School_Yr_to_Grade[_n-1] if mi(School_Yr_to_Grade[_n]) & School_Yr_to_Grade[_n-1] == School_Yr_to_Grade[_n+6]  & ~mi(School_Yr_to_Grade[_n-1])
bys ID: replace School_Yr_to_Grade = School_Yr_to_Grade[_n-1] if mi(School_Yr_to_Grade[_n]) & School_Yr_to_Grade[_n-1] == School_Yr_to_Grade[_n+5]  & ~mi(School_Yr_to_Grade[_n-1])
bys ID: replace School_Yr_to_Grade = School_Yr_to_Grade[_n-1] if mi(School_Yr_to_Grade[_n]) & School_Yr_to_Grade[_n-1] == School_Yr_to_Grade[_n+4]  & ~mi(School_Yr_to_Grade[_n-1])
bys ID: replace School_Yr_to_Grade = School_Yr_to_Grade[_n-1] if mi(School_Yr_to_Grade[_n]) & School_Yr_to_Grade[_n-1] == School_Yr_to_Grade[_n+3]  & ~mi(School_Yr_to_Grade[_n-1])
bys ID: replace School_Yr_to_Grade = School_Yr_to_Grade[_n-1] if mi(School_Yr_to_Grade[_n]) & School_Yr_to_Grade[_n-1] == School_Yr_to_Grade[_n+2]  & ~mi(School_Yr_to_Grade[_n-1])
bys ID: replace School_Yr_to_Grade = School_Yr_to_Grade[_n-1] if mi(School_Yr_to_Grade[_n]) & School_Yr_to_Grade[_n-1] == School_Yr_to_Grade[_n+1]  & ~mi(School_Yr_to_Grade[_n-1])

* Impute missings linearly -- i.e. if Grade_t = 14 and Grade_t+k = 17 and all the in-betweens are missing
*k=12
bys ID: replace School_Yr_to_Grade = (School_Yr_to_Grade[_n+12]-School_Yr_to_Grade[_n-1])/(13) + School_Yr_to_Grade[_n-1] ///
if ///
age_now>=12 & School_Yr_to_Grade[_n-1]<. & School_Yr_to_Grade[_n+12]<. & School_Yr_to_Grade[_n]>=. & School_Yr_to_Grade[_n+1]>=. & School_Yr_to_Grade[_n+2]>=. & School_Yr_to_Grade[_n+3]>=. & School_Yr_to_Grade[_n+4]>=. & School_Yr_to_Grade[_n+5]>=. & School_Yr_to_Grade[_n+6]>=. & School_Yr_to_Grade[_n+7]>=. & School_Yr_to_Grade[_n+8]>=. & School_Yr_to_Grade[_n+9]>=. & School_Yr_to_Grade[_n+10]>=. & School_Yr_to_Grade[_n+11]>=.
*k=11
bys ID: replace School_Yr_to_Grade = (School_Yr_to_Grade[_n+11]-School_Yr_to_Grade[_n-1])/(12) + School_Yr_to_Grade[_n-1] ///
if ///
age_now>=12 & School_Yr_to_Grade[_n-1]<. & School_Yr_to_Grade[_n+11]<. & School_Yr_to_Grade[_n]>=. & School_Yr_to_Grade[_n+1]>=. & School_Yr_to_Grade[_n+2]>=. & School_Yr_to_Grade[_n+3]>=. & School_Yr_to_Grade[_n+4]>=. & School_Yr_to_Grade[_n+5]>=. & School_Yr_to_Grade[_n+6]>=. & School_Yr_to_Grade[_n+7]>=. & School_Yr_to_Grade[_n+8]>=. & School_Yr_to_Grade[_n+9]>=. & School_Yr_to_Grade[_n+10]>=.
*k=10
bys ID: replace School_Yr_to_Grade = (School_Yr_to_Grade[_n+10]-School_Yr_to_Grade[_n-1])/(11) + School_Yr_to_Grade[_n-1] ///
if ///
age_now>=12 & School_Yr_to_Grade[_n-1]<. & School_Yr_to_Grade[_n+10]<. & School_Yr_to_Grade[_n]>=. & School_Yr_to_Grade[_n+1]>=. & School_Yr_to_Grade[_n+2]>=. & School_Yr_to_Grade[_n+3]>=. & School_Yr_to_Grade[_n+4]>=. & School_Yr_to_Grade[_n+5]>=. & School_Yr_to_Grade[_n+6]>=. & School_Yr_to_Grade[_n+7]>=. & School_Yr_to_Grade[_n+8]>=. & School_Yr_to_Grade[_n+9]>=.
*k=9
bys ID: replace School_Yr_to_Grade = (School_Yr_to_Grade[_n+9]-School_Yr_to_Grade[_n-1])/(10) + School_Yr_to_Grade[_n-1] ///
if ///
age_now>=12 & School_Yr_to_Grade[_n-1]<. & School_Yr_to_Grade[_n+9]<. & School_Yr_to_Grade[_n]>=. & School_Yr_to_Grade[_n+1]>=. & School_Yr_to_Grade[_n+2]>=. & School_Yr_to_Grade[_n+3]>=. & School_Yr_to_Grade[_n+4]>=. & School_Yr_to_Grade[_n+5]>=. & School_Yr_to_Grade[_n+6]>=. & School_Yr_to_Grade[_n+7]>=. & School_Yr_to_Grade[_n+8]>=.
*k=8
bys ID: replace School_Yr_to_Grade = (School_Yr_to_Grade[_n+8]-School_Yr_to_Grade[_n-1])/(9) + School_Yr_to_Grade[_n-1] ///
if ///
age_now>=12 & School_Yr_to_Grade[_n-1]<. & School_Yr_to_Grade[_n+8]<. & School_Yr_to_Grade[_n]>=. & School_Yr_to_Grade[_n+1]>=. & School_Yr_to_Grade[_n+2]>=. & School_Yr_to_Grade[_n+3]>=. & School_Yr_to_Grade[_n+4]>=. & School_Yr_to_Grade[_n+5]>=. & School_Yr_to_Grade[_n+6]>=. & School_Yr_to_Grade[_n+7]>=.
*k=7
bys ID: replace School_Yr_to_Grade = (School_Yr_to_Grade[_n+7]-School_Yr_to_Grade[_n-1])/(8) + School_Yr_to_Grade[_n-1] ///
if ///
age_now>=12 & School_Yr_to_Grade[_n-1]<. & School_Yr_to_Grade[_n+7]<. & School_Yr_to_Grade[_n]>=. & School_Yr_to_Grade[_n+1]>=. & School_Yr_to_Grade[_n+2]>=. & School_Yr_to_Grade[_n+3]>=. & School_Yr_to_Grade[_n+4]>=. & School_Yr_to_Grade[_n+5]>=. & School_Yr_to_Grade[_n+6]>=.
*k=6
bys ID: replace School_Yr_to_Grade = (School_Yr_to_Grade[_n+6]-School_Yr_to_Grade[_n-1])/(7) + School_Yr_to_Grade[_n-1] ///
if ///
age_now>=12 & School_Yr_to_Grade[_n-1]<. & School_Yr_to_Grade[_n+6]<. & School_Yr_to_Grade[_n]>=. & School_Yr_to_Grade[_n+1]>=. & School_Yr_to_Grade[_n+2]>=. & School_Yr_to_Grade[_n+3]>=. & School_Yr_to_Grade[_n+4]>=. & School_Yr_to_Grade[_n+5]>=.
*k=5
bys ID: replace School_Yr_to_Grade = (School_Yr_to_Grade[_n+5]-School_Yr_to_Grade[_n-1])/(6) + School_Yr_to_Grade[_n-1] ///
if ///
age_now>=12 & School_Yr_to_Grade[_n-1]<. & School_Yr_to_Grade[_n+5]<. & School_Yr_to_Grade[_n]>=. & School_Yr_to_Grade[_n+1]>=. & School_Yr_to_Grade[_n+2]>=. & School_Yr_to_Grade[_n+3]>=. & School_Yr_to_Grade[_n+4]>=.
*k=4
bys ID: replace School_Yr_to_Grade = (School_Yr_to_Grade[_n+4]-School_Yr_to_Grade[_n-1])/(5) + School_Yr_to_Grade[_n-1] ///
if ///
age_now>=12 & School_Yr_to_Grade[_n-1]<. & School_Yr_to_Grade[_n+4]<. & School_Yr_to_Grade[_n]>=. & School_Yr_to_Grade[_n+1]>=. & School_Yr_to_Grade[_n+2]>=. & School_Yr_to_Grade[_n+3]>=.
*k=3
bys ID: replace School_Yr_to_Grade = (School_Yr_to_Grade[_n+3]-School_Yr_to_Grade[_n-1])/(4) + School_Yr_to_Grade[_n-1] ///
if ///
age_now>=12 & School_Yr_to_Grade[_n-1]<. & School_Yr_to_Grade[_n+3]<. & School_Yr_to_Grade[_n]>=. & School_Yr_to_Grade[_n+1]>=. & School_Yr_to_Grade[_n+2]>=.
*k=2
bys ID: replace School_Yr_to_Grade = (School_Yr_to_Grade[_n+2]-School_Yr_to_Grade[_n-1])/(3) + School_Yr_to_Grade[_n-1] ///
if ///
age_now>=12 & School_Yr_to_Grade[_n-1]<. & School_Yr_to_Grade[_n+2]<. & School_Yr_to_Grade[_n]>=. & School_Yr_to_Grade[_n+1]>=.
*k=1
bys ID: replace School_Yr_to_Grade = (School_Yr_to_Grade[_n+1]-School_Yr_to_Grade[_n-1])/(2) + School_Yr_to_Grade[_n-1] ///
if ///
age_now>=12 & School_Yr_to_Grade[_n-1]<. & School_Yr_to_Grade[_n+1]<. & School_Yr_to_Grade[_n]>=.

/* Impute right-censored observations as flat for age > 18 (DON'T IMPUTE RIGHT-CENSORED OBSERVATIONS AT ALL, ACTUALLY)
replace School_Yr_to_Grade = School_Yr_to_Grade[_n-1] if age_now>=18 & School_Yr_to_Grade[_n-1]<. & School_Yr_to_Grade[_n]>=. & School_Yr_to_Grade[_n+1]>=. & School_Yr_to_Grade[_n+2]>=. & School_Yr_to_Grade[_n+3]>=. & School_Yr_to_Grade[_n+4]>=. & School_Yr_to_Grade[_n+5]>=. & School_Yr_to_Grade[_n+6]>=. & School_Yr_to_Grade[_n+7]>=. & School_Yr_to_Grade[_n+8]>=. & School_Yr_to_Grade[_n+9]>=. & School_Yr_to_Grade[_n+10]>=.
replace School_Yr_to_Grade = School_Yr_to_Grade[_n-1] if age_now>=18 & School_Yr_to_Grade[_n-1]<. & School_Yr_to_Grade[_n]>=. & School_Yr_to_Grade[_n+1]>=. & School_Yr_to_Grade[_n+2]>=. & School_Yr_to_Grade[_n+3]>=. & School_Yr_to_Grade[_n+4]>=. & School_Yr_to_Grade[_n+5]>=. & School_Yr_to_Grade[_n+6]>=. & School_Yr_to_Grade[_n+7]>=. & School_Yr_to_Grade[_n+8]>=. & School_Yr_to_Grade[_n+9]>=.
replace School_Yr_to_Grade = School_Yr_to_Grade[_n-1] if age_now>=18 & School_Yr_to_Grade[_n-1]<. & School_Yr_to_Grade[_n]>=. & School_Yr_to_Grade[_n+1]>=. & School_Yr_to_Grade[_n+2]>=. & School_Yr_to_Grade[_n+3]>=. & School_Yr_to_Grade[_n+4]>=. & School_Yr_to_Grade[_n+5]>=. & School_Yr_to_Grade[_n+6]>=. & School_Yr_to_Grade[_n+7]>=. & School_Yr_to_Grade[_n+8]>=.
replace School_Yr_to_Grade = School_Yr_to_Grade[_n-1] if age_now>=18 & School_Yr_to_Grade[_n-1]<. & School_Yr_to_Grade[_n]>=. & School_Yr_to_Grade[_n+1]>=. & School_Yr_to_Grade[_n+2]>=. & School_Yr_to_Grade[_n+3]>=. & School_Yr_to_Grade[_n+4]>=. & School_Yr_to_Grade[_n+5]>=. & School_Yr_to_Grade[_n+6]>=. & School_Yr_to_Grade[_n+7]>=.
replace School_Yr_to_Grade = School_Yr_to_Grade[_n-1] if age_now>=18 & School_Yr_to_Grade[_n-1]<. & School_Yr_to_Grade[_n]>=. & School_Yr_to_Grade[_n+1]>=. & School_Yr_to_Grade[_n+2]>=. & School_Yr_to_Grade[_n+3]>=. & School_Yr_to_Grade[_n+4]>=. & School_Yr_to_Grade[_n+5]>=. & School_Yr_to_Grade[_n+6]>=.
replace School_Yr_to_Grade = School_Yr_to_Grade[_n-1] if age_now>=18 & School_Yr_to_Grade[_n-1]<. & School_Yr_to_Grade[_n]>=. & School_Yr_to_Grade[_n+1]>=. & School_Yr_to_Grade[_n+2]>=. & School_Yr_to_Grade[_n+3]>=. & School_Yr_to_Grade[_n+4]>=. & School_Yr_to_Grade[_n+5]>=.
replace School_Yr_to_Grade = School_Yr_to_Grade[_n-1] if age_now>=18 & School_Yr_to_Grade[_n-1]<. & School_Yr_to_Grade[_n]>=. & School_Yr_to_Grade[_n+1]>=. & School_Yr_to_Grade[_n+2]>=. & School_Yr_to_Grade[_n+3]>=. & School_Yr_to_Grade[_n+4]>=.
replace School_Yr_to_Grade = School_Yr_to_Grade[_n-1] if age_now>=18 & School_Yr_to_Grade[_n-1]<. & School_Yr_to_Grade[_n]>=. & School_Yr_to_Grade[_n+1]>=. & School_Yr_to_Grade[_n+2]>=. & School_Yr_to_Grade[_n+3]>=.
replace School_Yr_to_Grade = School_Yr_to_Grade[_n-1] if age_now>=18 & School_Yr_to_Grade[_n-1]<. & School_Yr_to_Grade[_n]>=. & School_Yr_to_Grade[_n+1]>=. & School_Yr_to_Grade[_n+2]>=.
replace School_Yr_to_Grade = School_Yr_to_Grade[_n-1] if age_now>=18 & School_Yr_to_Grade[_n-1]<. & School_Yr_to_Grade[_n]>=. & School_Yr_to_Grade[_n+1]>=.
*/

* Impute left-censored observations of HS age as (Grade_t+1)-1
replace School_Yr_to_Grade = School_Yr_to_Grade[_n+1]-1 if age_now <= 18 & age_now>=12 & ~mi(School_Yr_to_Grade[_n+1]) & mi(School_Yr_to_Grade[_n-6]) &  mi(School_Yr_to_Grade[_n-5]) & mi(School_Yr_to_Grade[_n-4]) & mi(School_Yr_to_Grade[_n-3]) & mi(School_Yr_to_Grade[_n-2]) & mi(School_Yr_to_Grade[_n-1]) & mi(School_Yr_to_Grade[_n]  )
replace School_Yr_to_Grade = School_Yr_to_Grade[_n+1]-1 if age_now <= 18 & age_now>=12 & ~mi(School_Yr_to_Grade[_n+1]) & mi(School_Yr_to_Grade[_n-5]) &  mi(School_Yr_to_Grade[_n-4]) & mi(School_Yr_to_Grade[_n-3]) & mi(School_Yr_to_Grade[_n-2]) & mi(School_Yr_to_Grade[_n-1]) & mi(School_Yr_to_Grade[_n]  )
replace School_Yr_to_Grade = School_Yr_to_Grade[_n+1]-1 if age_now <= 18 & age_now>=12 & ~mi(School_Yr_to_Grade[_n+1]) & mi(School_Yr_to_Grade[_n-4]) &  mi(School_Yr_to_Grade[_n-3]) & mi(School_Yr_to_Grade[_n-2]) & mi(School_Yr_to_Grade[_n-1]) & mi(School_Yr_to_Grade[_n]  )
replace School_Yr_to_Grade = School_Yr_to_Grade[_n+1]-1 if age_now <= 18 & age_now>=12 & ~mi(School_Yr_to_Grade[_n+1]) & mi(School_Yr_to_Grade[_n-3]) &  mi(School_Yr_to_Grade[_n-2]) & mi(School_Yr_to_Grade[_n-1]) & mi(School_Yr_to_Grade[_n]  )
replace School_Yr_to_Grade = School_Yr_to_Grade[_n+1]-1 if age_now <= 18 & age_now>=12 & ~mi(School_Yr_to_Grade[_n+1]) & mi(School_Yr_to_Grade[_n-2]) &  mi(School_Yr_to_Grade[_n-1]) & mi(School_Yr_to_Grade[_n]  )
replace School_Yr_to_Grade = School_Yr_to_Grade[_n+1]-1 if age_now <= 18 & age_now>=12 & ~mi(School_Yr_to_Grade[_n+1]) & mi(School_Yr_to_Grade[_n-1]) &  mi(School_Yr_to_Grade[_n]  )
replace School_Yr_to_Grade = School_Yr_to_Grade[_n+1]-1 if age_now <= 18 & age_now>=12 & ~mi(School_Yr_to_Grade[_n+1]) & mi(School_Yr_to_Grade[_n]  ) 

replace School_Yr_to_Grade = . if year>=2008
replace School_Yr_to_Grade = age_now-6 if year==1997 & inlist(ID,829,1242,1340,1529,2413,2974,3376,4566,6357,6853,8364,8664)

replace School_Yr_to_Grade = 7 if ID==383 & year==1997

replace School_Yr_to_Grade = 8 if ID==5002 & year==1997

replace School_Yr_to_Grade = 9 if ID==319 & year==1997

replace School_Yr_to_Grade = 7 if ID==381 & year==1994
replace School_Yr_to_Grade = 8 if ID==381 & year==1995
replace School_Yr_to_Grade = 9 if ID==381 & year==1996
replace School_Yr_to_Grade = 10 if ID==381 & year==1997
replace School_Yr_to_Grade = 11 if ID==381 & year==1998

replace School_Yr_to_Grade = 7 if ID==692 & year==1997

replace School_Yr_to_Grade = 8 if ID==1139 & year==1997

replace School_Yr_to_Grade = 8 if ID==1372 & year==1997

replace School_Yr_to_Grade = 9 if ID==1507 & year==1997

replace School_Yr_to_Grade = 8 if ID==1613 & year==1997

replace School_Yr_to_Grade = 8 if ID==2460 & year==1997

replace School_Yr_to_Grade = 6 if ID==2852 & year==1997

replace School_Yr_to_Grade = 9 if ID==3720 & year==1997

replace School_Yr_to_Grade = 8 if ID==3781 & year==1997

replace School_Yr_to_Grade = 7 if ID==3798 & year==1997

replace School_Yr_to_Grade = 8 if ID==3948 & year==1997

replace School_Yr_to_Grade = 7 if ID==4225 & year==1994
replace School_Yr_to_Grade = 8 if ID==4225 & year==1995
replace School_Yr_to_Grade = 9 if ID==4225 & year==1996
replace School_Yr_to_Grade = 10 if ID==4225 & year==1997

replace School_Yr_to_Grade = 8 if ID==4232 & year==1997

replace School_Yr_to_Grade = 8 if ID==4567 & year==1997

replace School_Yr_to_Grade = 8 if ID==4605 & year==1997

replace School_Yr_to_Grade = 8 if ID==4925 & year==1997

replace School_Yr_to_Grade = 7 if ID==4964 & year==1997

replace School_Yr_to_Grade = 9 if ID==6300 & year==1997

replace School_Yr_to_Grade = 8 if ID==6356 & year==1997

replace School_Yr_to_Grade = 8 if ID==7459 & year==1997

replace School_Yr_to_Grade = 6 if ID==8191 & year==1997


* Hand-coding a few more:
replace School_Yr_to_Grade = 10 if ID==120 & year==1997
replace School_Yr_to_Grade = 10 if ID==124 & year==1997
replace School_Yr_to_Grade = 10 if ID==330 & year==1997
replace School_Yr_to_Grade = Highest_Grade_Completed+2 if ID==436 & year>=1996 & year<=2000
replace School_Yr_to_Grade = Highest_Grade_Completed+1 if ID==769 & year>=1994 & year<=1999
replace School_Yr_to_Grade = 10 if ID==1069 & year==1997
replace School_Yr_to_Grade = 9  if ID==1742 & year==1997
replace School_Yr_to_Grade = 10 if ID==2034 & year==1997
replace School_Yr_to_Grade = 10 if ID==2269 & year==1997
replace School_Yr_to_Grade = Highest_Grade_Completed+2 if ID==2725 & year>=1996 & year<=2000
replace School_Yr_to_Grade = 9  if ID==3158 & year==1997
replace School_Yr_to_Grade = 8  if ID==3208 & year==1997
replace School_Yr_to_Grade = 10 if ID==3355 & year==1997
replace School_Yr_to_Grade = 9  if ID==3567 & year==1997
replace School_Yr_to_Grade = 10 if ID==4233 & year==1997
replace School_Yr_to_Grade = Highest_Grade_Completed if ID==4404 & year>=1994 & year<=1997
replace School_Yr_to_Grade = 10 if ID==4823 & year==1997
replace School_Yr_to_Grade = 9  if ID==5074 & year==1997
replace School_Yr_to_Grade = 9  if ID==5527 & year==1997
replace School_Yr_to_Grade = 10 if ID==6404 & year==1997
replace School_Yr_to_Grade = 10 if ID==6527 & year==1997
replace School_Yr_to_Grade = Highest_Grade_Completed+1 if ID==6663 & year>=1994 & year<=1997
replace School_Yr_to_Grade = 10 if ID==6673 & year==1997
replace School_Yr_to_Grade = 9  if ID==6916 & year==1996
replace School_Yr_to_Grade = 11 if ID==6999 & year==1997
replace School_Yr_to_Grade = 10 if ID==7127 & year==1997
replace School_Yr_to_Grade = Highest_Grade_Completed+1 if ID==7620 & year>=1997 & year<=2001
replace School_Yr_to_Grade = Highest_Grade_Completed+2 if ID==7715 & year>=1996 & year<=1998
replace School_Yr_to_Grade = 8  if ID==8295 & year==1995
replace School_Yr_to_Grade = 10 if ID==8331 & year==1997
replace School_Yr_to_Grade = 9  if ID==8517 & year==1997
replace School_Yr_to_Grade = 11 if ID==1255 & year==1997
replace School_Yr_to_Grade = 10 if ID==2429 & year==1997


/* People still in "Other Activities" at age 13: (they look like drop-outs)
620
1256
1523
*/ 

/* People still in "Other Activities" at age 14: (they look like drop-outs)
620
1256
1523
*/ 

/*
        +-----------------------------------------------------+
        |   id   year   age         hgc   grade_~t   annual~k |
        |-----------------------------------------------------|
  1551. |  120   1997    14   8TH GRADE         .v          0 |
  1583. |  124   1997    14   8TH GRADE         .v          0 |
  4163. |  330   1997    14   8TH GRADE         .v          0 |
  5524. |  436   1997    14   8TH GRADE         .v          0 |
  5755. |  453   1997    14   7TH GRADE         .v          0 |
        |-----------------------------------------------------|
  7885. |  620   1995    14   2ND GRADE         .v       1040 |
  9808. |  769   1995    14   9TH GRADE         .v       1420 |
 13627. | 1069   1997    14   9TH GRADE         .v          0 |
 19531. | 1523   1999    14   5TH GRADE         .v          0 |
 22252. | 1742   1997    14   8TH GRADE         .v          0 |
        |-----------------------------------------------------|
 25997. | 2034   1997    14   9TH GRADE         .v          0 |
 29071. | 2269   1997    14   8TH GRADE         .v          0 |
 34111. | 2657   1997    14   8TH GRADE         .v          0 |
 35048. | 2725   1997    14   8TH GRADE         .v          0 |
 35526. | 2760   1996    14   5TH GRADE         .v          0 |
        |-----------------------------------------------------|
 40620. | 3158   1997    14   7TH GRADE         .v          0 |
 41246. | 3208   1997    14   7TH GRADE         .v          0 |
 43172. | 3355   1997    14   8TH GRADE         .v          0 |
 45846. | 3567   1997    14   7TH GRADE         .v          0 |
 50548. | 3931   1997    14   6TH GRADE         .v          0 |
        |-----------------------------------------------------|
 50572. | 3933   1995    14   6TH GRADE         .v        925 |
 54605. | 4233   1997    14   9TH GRADE         .v          0 |
 56846. | 4404   1995    14   8TH GRADE         .v          0 |
 62306. | 4823   1997    14   8TH GRADE         .v          0 |
 64602. | 5002   1998    14   9TH GRADE         .v          0 |
        |-----------------------------------------------------|
 65576. | 5074   1997    14   7TH GRADE         .v          0 |
 65950. | 5105   1997    14   7TH GRADE         .v          0 |
 68821. | 5324   1997    14   6TH GRADE         .v          0 |
 71504. | 5527   1997    14   7TH GRADE         .v          0 |
 83084. | 6404   1997    14   9TH GRADE         .v          0 |
        |-----------------------------------------------------|
 84687. | 6527   1997    14   8TH GRADE         .v          0 |
 86392. | 6663   1995    14   8TH GRADE         .v       1196 |
 86512. | 6673   1997    14   8TH GRADE         .v          0 |
 88441. | 6822   1999    14   8TH GRADE         .v          0 |
 89657. | 6916   1996    14   6TH GRADE         .v          0 |
        |-----------------------------------------------------|
 89784. | 6925   1997    14   8TH GRADE         .v          0 |
 90731. | 6999   1997    14   9TH GRADE         .v          0 |
 92387. | 7127   1997    14   8TH GRADE         .v          0 |
 95474. | 7353   1997    14   8TH GRADE         .v          0 |
 99004. | 7620   1998    14   9TH GRADE         .v          0 |
        |-----------------------------------------------------|
100219. | 7715   1997    14   6TH GRADE         .v          0 |
100842. | 7762   1998    14   6TH GRADE         .v          0 |
107958. | 8295   1995    14   5TH GRADE         .v          0 |
108458. | 8331   1997    14   8TH GRADE         .v          0 |
110849. | 8517   1997    14   7TH GRADE         .v          0 |
        |-----------------------------------------------------|
112484. | 8636   1999    14   5TH GRADE         .v          0 |
        +-----------------------------------------------------+
*/

/* IDs who are NOT in school at age 14:
 120: replace School_Yr_to_Grade = 10 if ID==120 & year==1997
 124: replace School_Yr_to_Grade = 10 if ID==124 & year==1997
 330: replace School_Yr_to_Grade = 10 if ID==330 & year==1997
 436: replace School_Yr_to_Grade = Highest_Grade_Completed+2 if ID==436 & year>=1996 & year<=2000
 453: looks OK
 620: looks OK
 769: replace School_Yr_to_Grade = Highest_Grade_Completed+1 if ID==769 & year>=1994 & year<=1999
1069: replace School_Yr_to_Grade = 10 if ID==1069 & year==1997
1523: looks OK
1742: replace School_Yr_to_Grade = 9  if ID==1742 & year==1997
2034: replace School_Yr_to_Grade = 10 if ID==2034 & year==1997
2269: replace School_Yr_to_Grade = 10 if ID==2269 & year==1997
2657: looks OK
2725: replace School_Yr_to_Grade = Highest_Grade_Completed+2 if ID==2725 & year>=1996 & year<=2000
2760: looks OK
3158: replace School_Yr_to_Grade = 9  if ID==3158 & year==1997
3208: replace School_Yr_to_Grade = 8  if ID==3208 & year==1997
3355: replace School_Yr_to_Grade = 10 if ID==3355 & year==1997
3567: replace School_Yr_to_Grade = 9  if ID==3567 & year==1997
3931: looks OK
3933: looks OK
4233: replace School_Yr_to_Grade = 10 if ID==4233 & year==1997
4404: replace School_Yr_to_Grade = Highest_Grade_Completed if ID==4404 & year>=1994 & year<=1997
4823: replace School_Yr_to_Grade = 10 if ID==4823 & year==1997
5002: looks OK
5074: replace School_Yr_to_Grade = 9  if ID==5074 & year==1997
5105: looks OK
5324: looks OK
5527: replace School_Yr_to_Grade = 9  if ID==5527 & year==1997
6404: replace School_Yr_to_Grade = 10 if ID==6404 & year==1997
6527: replace School_Yr_to_Grade = 10 if ID==6527 & year==1997
6663: replace School_Yr_to_Grade = Highest_Grade_Completed+1 if ID==6663 & year>=1994 & year<=1997
6673: replace School_Yr_to_Grade = 10 if ID==6673 & year==1997
6822: looks OK
6916: replace School_Yr_to_Grade = 9  if ID==6916 & year==1996
6925: looks OK
6999: replace School_Yr_to_Grade = 11 if ID==6999 & year==1997
7127: replace School_Yr_to_Grade = 10 if ID==7127 & year==1997
7353: looks OK
7620: replace School_Yr_to_Grade = Highest_Grade_Completed+1 if ID==7620 & year>=1997 & year<=2001
7715: replace School_Yr_to_Grade = Highest_Grade_Completed+2 if ID==7715 & year>=1996 & year<=1998
7762: looks OK
8295: replace School_Yr_to_Grade = 8  if ID==8295 & year==1995
8331: replace School_Yr_to_Grade = 10 if ID==8331 & year==1997
8517: replace School_Yr_to_Grade = 9  if ID==8517 & year==1997
8636: looks OK
1255: replace School_Yr_to_Grade = 11 if ID==1255 & year==1997
1256: looks OK
2429: replace School_Yr_to_Grade = 10 if ID==2429 & year==1997
2546: looks OK
2645: looks OK
3003: looks OK
4923: looks OK
6802: looks OK
*/

exit
