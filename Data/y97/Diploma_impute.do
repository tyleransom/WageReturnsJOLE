* replace Diploma=1 if ID==12 | ID==18 | ID==43 | ID==65 | ID==83 | ID==96 | ID==157 | ID==220 | ID==272 | ID==273 | ID==371 | ID==440 | ID==509 | ID==510 | ID==523 | ID==540 | ID==548 | ID==557 | ID==561 | ID==582 | ID==585 | ID==589 | ID==591 | ID==607 | ID==675 | ID==716 | ID==745 | ID==790 | ID==875 | ID==884 | ID==886 | ID==897 | ID==925 | ID==961 | ID==968 | ID==984 | ID==993 | ID==1054 | ID==1124 | ID==1146 | ID==1345 | ID==1409 | ID==1418 | ID==1422 | ID==1432 | ID==1510 | ID==1527 | ID==1638 | ID==1754 | ID==1792 | ID==1799 | ID==1843 | ID==1856 | ID==1862 | ID==1875 | ID==1883 | ID==1914 | ID==1923 | ID==1934 | ID==1942 | ID==1951 | ID==2025 | ID==2044 | ID==2102 | ID==2121 | ID==2122 | ID==2153 | ID==2156 | ID==2169 | ID==2174 | ID==2202 | ID==2213 | ID==2220 | ID==2232 | ID==2295 | ID==2306 | ID==2348 | ID==2360 | ID==2370 | ID==2380 | ID==2390 | ID==2397 | ID==2406 | ID==2422 | ID==2454 | ID==2456 | ID==2573 | ID==2608 | ID==2688 | ID==2727 | ID==2731 | ID==2751 | ID==2757 | ID==2802 | ID==2803 | ID==2827 | ID==2830 | ID==2887 | ID==2917 | ID==2991 | ID==3004 | ID==3006 | ID==3008 | ID==3011 | ID==3013 | ID==3015 | ID==3024 | ID==3051 | ID==3077 | ID==3080 | ID==3081 | ID==3093 | ID==3165 | ID==3223 | ID==3235 | ID==3239 | ID==3266 | ID==3317 | ID==3321 | ID==3349 | ID==3351 | ID==3368 | ID==3456 | ID==3492 | ID==3506 | ID==3508 | ID==3575 | ID==3597 | ID==3730 | ID==3736 | ID==3764 | ID==3793 | ID==3891 | ID==3897 | ID==3998 | ID==4081 | ID==4098 | ID==4107 | ID==4123 | ID==4124 | ID==4255 | ID==4333 | ID==4362 | ID==4364 | ID==4372 | ID==4396 | ID==4410 | ID==4419 | ID==4431 | ID==4455 | ID==4458 | ID==4467 | ID==4532 | ID==4553 | ID==4564 | ID==4575 | ID==4581 | ID==4583 | ID==4618 | ID==4630 | ID==4636 | ID==4641 | ID==4647 | ID==4653 | ID==4663 | ID==4688 | ID==4735 | ID==4792 | ID==4795 | ID==4833 | ID==4893 | ID==5030 | ID==5036 | ID==5072 | ID==5108 | ID==5128 | ID==5134 | ID==5143 | ID==5146 | ID==5177 | ID==5198 | ID==5257 | ID==5272 | ID==5278 | ID==5292 | ID==5344 | ID==5378 | ID==5392 | ID==5420 | ID==5438 | ID==5442 | ID==5452 | ID==5474 | ID==5485 | ID==5499 | ID==5529 | ID==5577 | ID==5684 | ID==5769 | ID==5798 | ID==5807 | ID==5962 | ID==5983 | ID==6019 | ID==6056 | ID==6126 | ID==6133 | ID==6239 | ID==6291 | ID==6338 | ID==6343 | ID==6417 | ID==6440 | ID==6467 | ID==6482 | ID==6542 | ID==6545 | ID==6574 | ID==6646 | ID==6650 | ID==6683 | ID==6704 | ID==6741 | ID==6826 | ID==6889 | ID==6932 | ID==6945 | ID==6976 | ID==6977 | ID==6978 | ID==6991 | ID==7056 | ID==7070 | ID==7091 | ID==7193 | ID==7301 | ID==7315 | ID==7426 | ID==7440 | ID==7525 | ID==7575 | ID==7612 | ID==7613 | ID==7631 | ID==7652 | ID==7686 | ID==7694 | ID==7708 | ID==7712 | ID==7720 | ID==7737 | ID==7897 | ID==7939 | ID==7999 | ID==8082 | ID==8088 | ID==8114 | ID==8179 | ID==8201 | ID==8214 | ID==8277 | ID==8309 | ID==8315 | ID==8357 | ID==8498 | ID==8533 | ID==8557 | ID==8572 | ID==8579 | ID==8614 | ID==8712 | ID==8817 | ID==8909

replace Highest_Grade_Completed = 9  if ID==7652 & year==1998
replace Highest_Grade_Completed = 10 if ID==7652 & year==1999
replace Highest_Grade_Completed = 11 if ID==7652 & year==2000
replace Highest_Grade_Completed = 12 if ID==7652 & year==2001

replace BA_year       = 2008 if ID==96
replace BA_month      = 5    if ID==96

/*
replace Diploma_year  = 2004 if ID==96   & Diploma_year >=.
replace Diploma_month = 6    if ID==96   & Diploma_month>=.

replace Diploma_year  = 1999 if ID==2397 & Diploma_year >=.
replace Diploma_month = 6    if ID==2397 & Diploma_month>=.

replace Diploma_year  = 2003 if ID==4532 & Diploma_year >=.
replace Diploma_month = 6    if ID==4532 & Diploma_month>=.

replace Diploma_year  = 2003 if ID==65   & Diploma_year >=.
replace Diploma_month = 6    if ID==65   & Diploma_month>=.

replace Diploma_year  = 2001 if ID==7652 & Diploma_year >=.
replace Diploma_month = 6    if ID==7652 & Diploma_month>=.
*/

* Impute HS graduation date as June of year HGC transitioned from 12 to 13
genera yr12Grade = Highest_Grade_Completed[_n-1]<12 & inrange(Highest_Grade_Completed[_n],12,.)
genera year12Grade = year*yr12Grade
recode year12Grade (0=.)
drop   yr12Grade
bys ID: egen yr12Grade = max(year12Grade)

replace Diploma_year = yr12Grade if mi(Diploma_year)
replace Diploma_year = 2001      if ID==96
replace Diploma_month = 6        if mi(Diploma_month) & ~mi(Diploma_year)
* replace Diploma = 1              if ~mi(Diploma_year)

replace HS_year  = Diploma_year                 if ~mi(Diploma_year ) &  mi(GED_year )
replace HS_year  = GED_year                     if  mi(Diploma_year ) & ~mi(GED_year )
replace HS_month = Diploma_month                if ~mi(Diploma_month) &  mi(GED_month)
replace HS_month = GED_month                    if  mi(Diploma_month) & ~mi(GED_month)
replace HS_year  = min(Diploma_year,GED_year)   if ~mi(Diploma_year ) & ~mi(GED_year )
replace HS_month = min(Diploma_month,GED_month) if ~mi(Diploma_month) & ~mi(GED_month)
