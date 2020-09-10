* Import, rename, reshape, recode and label the schooling variables
!unzip y79_schoolV2.dct.zip
infile using y79_schoolV2.dct, clear
!rm y79_schoolV2.dct

****************
* Rename
****************

rename R0000100 id
rename R0000300 dob_mo1979
rename R0000500 dob_yr1979
rename R0015600 enroll_current1979
rename R0015700 grade_current1979
rename R0016900 end_sch_mo1979
rename R0017000 end_sch_yr1979
rename R0017200 high_grade_attend1979
rename R0017300 high_grade_comp_raw1979
rename R0017600 beg_sch_last_k12_mo1979
rename R0017700 beg_sch_last_k12_yr1979
rename R0018000 end_sch_last_k12_mo1979
rename R0018100 end_sch_last_k12_yr1979
rename R0018300 diploma_or_ged1979
rename R0018400 recd_diploma_mo1979
rename R0018500 recd_diploma_yr1979
rename R0021300 beg_1col_mo1979
rename R0021400 beg_1col_yr1979
rename R0137600 type_1degree_recd1979
rename R0137700 type_2degree_recd1979
rename R0137800 type_3degree_recd1979
rename R0137900 type_4degree_recd1979
rename R0139200 recd_1degree_mo1979
rename R0139300 recd_1degree_yr1979
rename R0139400 recd_2degree_mo1979
rename R0139500 recd_2degree_yr1979
rename R0139600 recd_3degree_mo1979
rename R0139700 recd_3degree_yr1979
rename R0139800 recd_4degree_mo1979
rename R0139900 recd_4degree_yr1979
rename R0172500 interview_mo1979
rename R0214700 race_screen
rename R0214800 sex
rename R0216601 enroll_status_svy1979
rename R0216701 high_grade_comp_May1979
rename R0228100 enroll_since_dli1980
rename R0228500 enroll_current1980
rename R0228600 grade_current1980
rename R0228700 end_sch_mo1980
rename R0228800 end_sch_yr1980
rename R0229100 high_grade_attend1980
rename R0229200 high_grade_comp_raw1980
rename R0230000 diploma_or_ged1980
rename R0230100 recd_diploma_mo1980
rename R0230200 recd_diploma_yr1980
rename R0230500 beg_1col_mo1980
rename R0230600 beg_1col_yr1980
rename R0297400 type_1degree_recd1980
rename R0297800 recd_1degree_mo1980
rename R0297810 recd_1degree_yr1980
rename R0298000 type_2degree_recd1980
rename R0298400 recd_2degree_mo1980
rename R0298410 recd_2degree_yr1980
rename R0329200 interview_mo1980
rename R0406401 high_grade_comp_May1980
rename R0406501 enroll_status_svy1980
rename R0414700 enroll_since_dli1981
rename R0414800 enroll_status_Jan_prev1981
rename R0414900 enroll_status_Feb_prev1981
rename R0415000 enroll_status_Mar_prev1981
rename R0415100 enroll_status_Apr_prev1981
rename R0415200 enroll_status_May_prev1981
rename R0415300 enroll_status_Jun_prev1981
rename R0415400 enroll_status_Jul_prev1981
rename R0415500 enroll_status_Aug_prev1981
rename R0415600 enroll_status_Sep_prev1981
rename R0415700 enroll_status_Oct_prev1981
rename R0415800 enroll_status_Nov_prev1981
rename R0415900 enroll_status_Dec_prev1981
rename R0416000 enroll_status_Jan_curr1981
rename R0416100 enroll_status_Feb_curr1981
rename R0416200 enroll_status_Mar_curr1981
rename R0416300 enroll_status_Apr_curr1981
rename R0416400 enroll_status_May_curr1981
rename R0416500 enroll_status_Jun_curr1981
rename R0416600 enroll_status_Jul_curr1981
rename R0416700 enroll_status_Aug_curr1981
rename R0416800 enroll_current1981
rename R0416900 grade_current1981
rename R0417000 end_sch_mo1981
rename R0417100 end_sch_yr1981
rename R0417300 high_grade_attend1981
rename R0417400 high_grade_comp_raw1981
rename R0418200 diploma_or_ged1981
rename R0418300 recd_diploma_mo1981
rename R0418400 recd_diploma_yr1981
rename R0418700 beg_1col_mo1981
rename R0418800 beg_1col_yr1981
rename R0419900 type_1degree_recd1981
rename R0420100 type_2degree_recd1981
rename R0530700 interview_mo1981
rename R0618901 high_grade_comp_May1981
rename R0619001 enroll_status_svy1981
rename R0661800 enroll_since_dli1982
rename R0661900 enroll_status_Jan_prev1982
rename R0662000 enroll_status_Feb_prev1982
rename R0662100 enroll_status_Mar_prev1982
rename R0662200 enroll_status_Apr_prev1982
rename R0662300 enroll_status_May_prev1982
rename R0662400 enroll_status_Jun_prev1982
rename R0662500 enroll_status_Jul_prev1982
rename R0662600 enroll_status_Aug_prev1982
rename R0662700 enroll_status_Sep_prev1982
rename R0662800 enroll_status_Oct_prev1982
rename R0662900 enroll_status_Nov_prev1982
rename R0663000 enroll_status_Dec_prev1982
rename R0663100 enroll_status_Jan_curr1982
rename R0663200 enroll_status_Feb_curr1982
rename R0663300 enroll_status_Mar_curr1982
rename R0663400 enroll_status_Apr_curr1982
rename R0663500 enroll_status_May_curr1982
rename R0663600 enroll_status_Jun_curr1982
rename R0663700 enroll_status_Jul_curr1982
rename R0663800 enroll_status_Aug_curr1982
rename R0663900 enroll_current1982
rename R0664000 grade_current1982
rename R0664100 end_sch_mo1982
rename R0664200 end_sch_yr1982
rename R0664400 high_grade_attend1982
rename R0664500 high_grade_comp_raw1982
rename R0665300 diploma_or_ged1982
rename R0665400 recd_diploma_mo1982
rename R0665500 recd_diploma_yr1982
rename R0665800 beg_1col_mo1982
rename R0665900 beg_1col_yr1982
rename R0667500 type_1degree_recd1982
rename R0667700 type_2degree_recd1982
rename R0809900 interview_mo1982
rename R0898201 high_grade_comp_May1982
rename R0898301 enroll_status_svy1982
rename R0903300 enroll_since_dli1983
rename R0903400 enroll_status_Jan_prev1983
rename R0903500 enroll_status_Feb_prev1983
rename R0903600 enroll_status_Mar_prev1983
rename R0903700 enroll_status_Apr_prev1983
rename R0903800 enroll_status_May_prev1983
rename R0903900 enroll_status_Jun_prev1983
rename R0904000 enroll_status_Jul_prev1983
rename R0904100 enroll_status_Aug_prev1983
rename R0904200 enroll_status_Sep_prev1983
rename R0904300 enroll_status_Oct_prev1983
rename R0904400 enroll_status_Nov_prev1983
rename R0904500 enroll_status_Dec_prev1983
rename R0904600 enroll_status_Jan_curr1983
rename R0904700 enroll_status_Feb_curr1983
rename R0904800 enroll_status_Mar_curr1983
rename R0904900 enroll_status_Apr_curr1983
rename R0905000 enroll_status_May_curr1983
rename R0905100 enroll_status_Jun_curr1983
rename R0905200 enroll_status_Jul_curr1983
rename R0905300 enroll_current1983
rename R0905400 grade_current1983
rename R0905500 end_sch_mo1983
rename R0905600 end_sch_yr1983
rename R0905800 high_grade_attend1983
rename R0905900 high_grade_comp_raw1983
rename R0906700 diploma_or_ged1983
rename R0906800 recd_diploma_mo1983
rename R0906900 recd_diploma_yr1983
rename R0907200 beg_1col_mo1983
rename R0907300 beg_1col_yr1983
rename R0908200 type_1degree_recd1983
rename R0908400 type_2degree_recd1983
rename R1045700 interview_mo1983
rename R1145001 high_grade_comp_May1983
rename R1145101 enroll_status_svy1983
rename R1203100 enroll_since_dli1984
rename R1203200 enroll_status_Jan_prev1984
rename R1203300 enroll_status_Feb_prev1984
rename R1203400 enroll_status_Mar_prev1984
rename R1203500 enroll_status_Apr_prev1984
rename R1203600 enroll_status_May_prev1984
rename R1203700 enroll_status_Jun_prev1984
rename R1203800 enroll_status_Jul_prev1984
rename R1203900 enroll_status_Aug_prev1984
rename R1204000 enroll_status_Sep_prev1984
rename R1204100 enroll_status_Oct_prev1984
rename R1204200 enroll_status_Nov_prev1984
rename R1204300 enroll_status_Dec_prev1984
rename R1204400 enroll_status_Jan_curr1984
rename R1204500 enroll_status_Feb_curr1984
rename R1204600 enroll_status_Mar_curr1984
rename R1204700 enroll_status_Apr_curr1984
rename R1204800 enroll_status_May_curr1984
rename R1204900 enroll_status_Jun_curr1984
rename R1205200 enroll_current1984
rename R1205300 grade_current1984
rename R1205400 end_sch_mo1984
rename R1205500 end_sch_yr1984
rename R1205700 high_grade_attend1984
rename R1205800 high_grade_comp_raw1984
rename R1206600 diploma_or_ged1984
rename R1206700 recd_diploma_mo1984
rename R1206800 recd_diploma_yr1984
rename R1207600 beg_1col_mo1984
rename R1207700 beg_1col_yr1984
rename R1208500 beg_2col_mo1984
rename R1208600 beg_2col_yr1984
rename R1209400 beg_3col_mo1984
rename R1209500 beg_3col_yr1984
rename R1212300 end_1col_mo1984
rename R1212400 end_1col_yr1984
rename R1213100 end_2col_mo1984
rename R1213200 end_2col_yr1984
rename R1213900 end_3col_mo1984
rename R1214000 end_3col_yr1984
rename R1214400 type_1degree_recd1984
rename R1214600 type_2degree_recd1984
rename R1427500 interview_mo1984
rename R1520201 high_grade_comp_May1984
rename R1520301 enroll_status_svy1984
rename R1602400 enroll_since_dli1985
rename R1602500 enroll_status_Jan_prev1985
rename R1602600 enroll_status_Feb_prev1985
rename R1602700 enroll_status_Mar_prev1985
rename R1602800 enroll_status_Apr_prev1985
rename R1602900 enroll_status_May_prev1985
rename R1603000 enroll_status_Jun_prev1985
rename R1603100 enroll_status_Jul_prev1985
rename R1603200 enroll_status_Aug_prev1985
rename R1603300 enroll_status_Sep_prev1985
rename R1603400 enroll_status_Oct_prev1985
rename R1603500 enroll_status_Nov_prev1985
rename R1603600 enroll_status_Dec_prev1985
rename R1603700 enroll_status_Jan_curr1985
rename R1603800 enroll_status_Feb_curr1985
rename R1603900 enroll_status_Mar_curr1985
rename R1604000 enroll_status_Apr_curr1985
rename R1604100 enroll_status_May_curr1985
rename R1604200 enroll_status_Jun_curr1985
rename R1604500 enroll_current1985
rename R1604600 grade_current1985
rename R1604700 end_sch_mo1985
rename R1604800 end_sch_yr1985
rename R1605000 high_grade_attend1985
rename R1605100 high_grade_comp_raw1985
rename R1605900 diploma_or_ged1985
rename R1606000 recd_diploma_mo1985
rename R1606100 recd_diploma_yr1985
rename R1606800 beg_1col_mo1985
rename R1606900 beg_1col_yr1985
rename R1607700 beg_2col_mo1985
rename R1607800 beg_2col_yr1985
rename R1608600 beg_3col_mo1985
rename R1608700 beg_3col_yr1985
rename R1609400 end_1col_mo1985
rename R1609500 end_1col_yr1985
rename R1609900 end_2col_mo1985
rename R1610000 end_2col_yr1985
rename R1610400 end_3col_mo1985
rename R1610500 end_3col_yr1985
rename R1794600 interview_mo1985
rename R1890901 high_grade_comp_May1985
rename R1891001 enroll_status_svy1985
rename R1902900 enroll_since_dli1986
rename R1903000 enroll_status_Jan_prev1986
rename R1903100 enroll_status_Feb_prev1986
rename R1903200 enroll_status_Mar_prev1986
rename R1903300 enroll_status_Apr_prev1986
rename R1903400 enroll_status_May_prev1986
rename R1903500 enroll_status_Jun_prev1986
rename R1903600 enroll_status_Jul_prev1986
rename R1903700 enroll_status_Aug_prev1986
rename R1903800 enroll_status_Sep_prev1986
rename R1903900 enroll_status_Oct_prev1986
rename R1904000 enroll_status_Nov_prev1986
rename R1904100 enroll_status_Dec_prev1986
rename R1904200 enroll_status_Jan_curr1986
rename R1904300 enroll_status_Feb_curr1986
rename R1904400 enroll_status_Mar_curr1986
rename R1904500 enroll_status_Apr_curr1986
rename R1904600 enroll_status_May_curr1986
rename R1904700 enroll_status_Jun_curr1986
rename R1904800 enroll_status_Jul_curr1986
rename R1905000 enroll_current1986
rename R1905100 grade_current1986
rename R1905200 end_sch_mo1986
rename R1905300 end_sch_yr1986
rename R1905500 high_grade_attend1986
rename R1905600 high_grade_comp_raw1986
rename R1906100 diploma_or_ged1986
rename R1906200 recd_diploma_mo1986
rename R1906300 recd_diploma_yr1986
rename R1907200 beg_1col_mo1986
rename R1907300 beg_1col_yr1986
rename R1908100 beg_2col_mo1986
rename R1908200 beg_2col_yr1986
rename R1909000 beg_3col_mo1986
rename R1909100 beg_3col_yr1986
rename R1909800 end_1col_mo1986
rename R1909900 end_1col_yr1986
rename R1910300 end_2col_mo1986
rename R1910400 end_2col_yr1986
rename R1910800 end_3col_mo1986
rename R1910900 end_3col_yr1986
rename R2156200 interview_mo1986
rename R2258001 high_grade_comp_May1986
rename R2258101 enroll_status_svy1986
rename R2303700 enroll_since_dli1987
rename R2303800 enroll_status_Jan_prev1987
rename R2303900 enroll_status_Feb_prev1987
rename R2304000 enroll_status_Mar_prev1987
rename R2304100 enroll_status_Apr_prev1987
rename R2304200 enroll_status_May_prev1987
rename R2304300 enroll_status_Jun_prev1987
rename R2304400 enroll_status_Jul_prev1987
rename R2304500 enroll_status_Aug_prev1987
rename R2304600 enroll_status_Sep_prev1987
rename R2304700 enroll_status_Oct_prev1987
rename R2304800 enroll_status_Nov_prev1987
rename R2304900 enroll_status_Dec_prev1987
rename R2305000 enroll_status_Jan_curr1987
rename R2305100 enroll_status_Feb_curr1987
rename R2305200 enroll_status_Mar_curr1987
rename R2305300 enroll_status_Apr_curr1987
rename R2305400 enroll_status_May_curr1987
rename R2305500 enroll_status_Jun_curr1987
rename R2305600 enroll_status_Jul_curr1987
rename R2305700 enroll_status_Aug_curr1987
rename R2305800 enroll_status_Sep_curr1987
rename R2305900 enroll_current1987
rename R2306000 grade_current1987
rename R2306100 end_sch_mo1987
rename R2306200 end_sch_yr1987
rename R2306400 high_grade_attend1987
rename R2306500 high_grade_comp_raw1987
rename R2307000 diploma_or_ged1987
rename R2307100 recd_diploma_mo1987
rename R2307200 recd_diploma_yr1987
rename R2365700 interview_mo1987
rename R2445401 high_grade_comp_May1987
rename R2445501 enroll_status_svy1987
rename R2505900 enroll_since_dli1988
rename R2506000 enroll_status_Jan_prev1988
rename R2506100 enroll_status_Feb_prev1988
rename R2506200 enroll_status_Mar_prev1988
rename R2506300 enroll_status_Apr_prev1988
rename R2506400 enroll_status_May_prev1988
rename R2506500 enroll_status_Jun_prev1988
rename R2506600 enroll_status_Jul_prev1988
rename R2506700 enroll_status_Aug_prev1988
rename R2506800 enroll_status_Sep_prev1988
rename R2506900 enroll_status_Oct_prev1988
rename R2507000 enroll_status_Nov_prev1988
rename R2507100 enroll_status_Dec_prev1988
rename R2507200 enroll_status_Jan_curr1988
rename R2507300 enroll_status_Feb_curr1988
rename R2507400 enroll_status_Mar_curr1988
rename R2507500 enroll_status_Apr_curr1988
rename R2507600 enroll_status_May_curr1988
rename R2507700 enroll_status_Jun_curr1988
rename R2507800 enroll_status_Jul_curr1988
rename R2507900 enroll_status_Aug_curr1988
rename R2508000 enroll_status_Sep_curr1988
rename R2508100 enroll_status_Oct_curr1988
rename R2508200 enroll_status_Nov_curr1988
rename R2508300 enroll_status_Dec_curr1988
rename R2508400 enroll_current1988
rename R2508500 grade_current1988
rename R2508600 end_sch_mo1988
rename R2508700 end_sch_yr1988
rename R2508900 high_grade_attend1988
rename R2509000 high_grade_comp_raw1988
rename R2509500 diploma_or_ged1988
rename R2509600 recd_diploma_mo1988
rename R2509700 recd_diploma_yr1988
rename R2509800 high_deg_recd1988
rename R2509900 recd_high_deg_mo1988
rename R2510000 recd_high_deg_yr1988
rename R2511100 beg_1col_mo1988
rename R2511200 beg_1col_yr1988
rename R2511900 end_1col_mo1988
rename R2512000 end_1col_yr1988
rename R2512600 beg_2col_mo1988
rename R2512700 beg_2col_yr1988
rename R2513300 end_2col_mo1988
rename R2513400 end_2col_yr1988
rename R2514000 beg_3col_mo1988
rename R2514100 beg_3col_yr1988
rename R2514700 end_3col_mo1988
rename R2514800 end_3col_yr1988
rename R2742500 interview_mo1988
rename R2871101 high_grade_comp_May1988
rename R2871201 enroll_status_svy1988
rename R2905000 enroll_since_dli1989
rename R2905100 enroll_status_Jan_prev1989
rename R2905200 enroll_status_Feb_prev1989
rename R2905300 enroll_status_Mar_prev1989
rename R2905400 enroll_status_Apr_prev1989
rename R2905500 enroll_status_May_prev1989
rename R2905600 enroll_status_Jun_prev1989
rename R2905700 enroll_status_Jul_prev1989
rename R2905800 enroll_status_Aug_prev1989
rename R2905900 enroll_status_Sep_prev1989
rename R2906000 enroll_status_Oct_prev1989
rename R2906100 enroll_status_Nov_prev1989
rename R2906200 enroll_status_Dec_prev1989
rename R2906300 enroll_status_Jan_curr1989
rename R2906400 enroll_status_Feb_curr1989
rename R2906500 enroll_status_Mar_curr1989
rename R2906600 enroll_status_Apr_curr1989
rename R2906700 enroll_status_May_curr1989
rename R2906800 enroll_status_Jun_curr1989
rename R2906900 enroll_status_Jul_curr1989
rename R2907000 enroll_status_Aug_curr1989
rename R2907100 enroll_status_Sep_curr1989
rename R2907200 enroll_status_Oct_curr1989
rename R2907300 enroll_status_Nov_curr1989
rename R2907400 enroll_status_Dec_curr1989
rename R2907500 enroll_current1989
rename R2907600 grade_current1989
rename R2907700 end_sch_mo1989
rename R2907800 end_sch_yr1989
rename R2908000 high_grade_attend1989
rename R2908100 high_grade_comp_raw1989
rename R2908600 diploma_or_ged1989
rename R2908700 recd_diploma_mo1989
rename R2908800 recd_diploma_yr1989
rename R2909200 high_deg_recd1989
rename R2909300 recd_high_deg_mo1989
rename R2909400 recd_high_deg_yr1989
rename R2910000 beg_1col_mo1989
rename R2910100 beg_1col_yr1989
rename R2910800 end_1col_mo1989
rename R2910900 end_1col_yr1989
rename R2911500 beg_2col_mo1989
rename R2911600 beg_2col_yr1989
rename R2912200 end_2col_mo1989
rename R2912300 end_2col_yr1989
rename R2912900 beg_3col_mo1989
rename R2913000 beg_3col_yr1989
rename R2913600 end_3col_mo1989
rename R2913700 end_3col_yr1989
rename R2986100 interview_mo1989
rename R3074801 high_grade_comp_May1989
rename R3074901 enroll_status_svy1989
rename R3107000 enroll_since_dli1990
rename R3107200 enroll_status_Jan_prev1990
rename R3107300 enroll_status_Feb_prev1990
rename R3107400 enroll_status_Mar_prev1990
rename R3107500 enroll_status_Apr_prev1990
rename R3107600 enroll_status_May_prev1990
rename R3107700 enroll_status_Jun_prev1990
rename R3107800 enroll_status_Jul_prev1990
rename R3107900 enroll_status_Aug_prev1990
rename R3108000 enroll_status_Sep_prev1990
rename R3108100 enroll_status_Oct_prev1990
rename R3108200 enroll_status_Nov_prev1990
rename R3108300 enroll_status_Dec_prev1990
rename R3108400 enroll_status_Jan_curr1990
rename R3108500 enroll_status_Feb_curr1990
rename R3108600 enroll_status_Mar_curr1990
rename R3108700 enroll_status_Apr_curr1990
rename R3108800 enroll_status_May_curr1990
rename R3108900 enroll_status_Jun_curr1990
rename R3109000 enroll_status_Jul_curr1990
rename R3109100 enroll_status_Aug_curr1990
rename R3109200 enroll_status_Sep_curr1990
rename R3109300 enroll_status_Oct_curr1990
rename R3109400 enroll_status_Nov_curr1990
rename R3109500 enroll_status_Dec_curr1990
rename R3109600 enroll_current1990
rename R3109700 grade_current1990
rename R3109800 end_sch_mo1990
rename R3109900 end_sch_yr1990
rename R3110100 high_grade_attend1990
rename R3110200 high_grade_comp_raw1990
rename R3110700 diploma_or_ged1990
rename R3110800 recd_diploma_mo1990
rename R3110900 recd_diploma_yr1990
rename R3111200 high_deg_recd1990
rename R3111300 recd_high_deg_mo1990
rename R3111400 recd_high_deg_yr1990
rename R3112000 beg_1col_mo1990
rename R3112100 beg_1col_yr1990
rename R3112800 end_1col_mo1990
rename R3112900 end_1col_yr1990
rename R3113500 beg_2col_mo1990
rename R3113600 beg_2col_yr1990
rename R3114200 end_2col_mo1990
rename R3114300 end_2col_yr1990
rename R3114900 beg_3col_mo1990
rename R3115000 beg_3col_yr1990
rename R3115600 end_3col_mo1990
rename R3115700 end_3col_yr1990
rename R3302500 interview_mo1990
rename R3401501 high_grade_comp_May1990
rename R3401601 enroll_status_svy1990
rename R3507000 enroll_since_dli1991
rename R3507200 enroll_status_Jan_prev1991
rename R3507300 enroll_status_Feb_prev1991
rename R3507400 enroll_status_Mar_prev1991
rename R3507500 enroll_status_Apr_prev1991
rename R3507600 enroll_status_May_prev1991
rename R3507700 enroll_status_Jun_prev1991
rename R3507800 enroll_status_Jul_prev1991
rename R3507900 enroll_status_Aug_prev1991
rename R3508000 enroll_status_Sep_prev1991
rename R3508100 enroll_status_Oct_prev1991
rename R3508200 enroll_status_Nov_prev1991
rename R3508300 enroll_status_Dec_prev1991
rename R3508400 enroll_status_Jan_curr1991
rename R3508500 enroll_status_Feb_curr1991
rename R3508600 enroll_status_Mar_curr1991
rename R3508700 enroll_status_Apr_curr1991
rename R3508800 enroll_status_May_curr1991
rename R3508900 enroll_status_Jun_curr1991
rename R3509000 enroll_status_Jul_curr1991
rename R3509100 enroll_status_Aug_curr1991
rename R3509200 enroll_status_Sep_curr1991
rename R3509300 enroll_status_Oct_curr1991
rename R3509400 enroll_status_Nov_curr1991
rename R3509500 enroll_status_Dec_curr1991
rename R3509600 enroll_current1991
rename R3509700 grade_current1991
rename R3509800 end_sch_mo1991
rename R3509900 end_sch_yr1991
rename R3510100 high_grade_attend1991
rename R3510200 high_grade_comp_raw1991
rename R3510700 diploma_or_ged1991
rename R3510800 recd_diploma_mo1991
rename R3510900 recd_diploma_yr1991
rename R3511200 high_deg_recd1991
rename R3511300 recd_high_deg_mo1991
rename R3511400 recd_high_deg_yr1991
rename R3573400 interview_mo1991
rename R3656901 high_grade_comp_May1991
rename R3657001 enroll_status_svy1991
rename R3707000 enroll_since_dli1992
rename R3707200 enroll_status_Jan_prev1992
rename R3707300 enroll_status_Feb_prev1992
rename R3707400 enroll_status_Mar_prev1992
rename R3707500 enroll_status_Apr_prev1992
rename R3707600 enroll_status_May_prev1992
rename R3707700 enroll_status_Jun_prev1992
rename R3707800 enroll_status_Jul_prev1992
rename R3707900 enroll_status_Aug_prev1992
rename R3708000 enroll_status_Sep_prev1992
rename R3708100 enroll_status_Oct_prev1992
rename R3708200 enroll_status_Nov_prev1992
rename R3708300 enroll_status_Dec_prev1992
rename R3708400 enroll_status_Jan_curr1992
rename R3708500 enroll_status_Feb_curr1992
rename R3708600 enroll_status_Mar_curr1992
rename R3708700 enroll_status_Apr_curr1992
rename R3708800 enroll_status_May_curr1992
rename R3708900 enroll_status_Jun_curr1992
rename R3709000 enroll_status_Jul_curr1992
rename R3709100 enroll_status_Aug_curr1992
rename R3709200 enroll_status_Sep_curr1992
rename R3709300 enroll_status_Oct_curr1992
rename R3709400 enroll_status_Nov_curr1992
rename R3709500 enroll_status_Dec_curr1992
rename R3709600 enroll_current1992
rename R3709700 grade_current1992
rename R3709800 end_sch_mo1992
rename R3709900 end_sch_yr1992
rename R3710100 high_grade_attend1992
rename R3710200 high_grade_comp_raw1992
rename R3710700 diploma_or_ged1992
rename R3710800 recd_diploma_mo1992
rename R3710900 recd_diploma_yr1992
rename R3711200 high_deg_recd1992
rename R3711300 recd_high_deg_mo1992
rename R3711400 recd_high_deg_yr1992
rename R3712500 beg_1col_mo1992
rename R3712600 beg_1col_yr1992
rename R3713300 end_1col_mo1992
rename R3713400 end_1col_yr1992
rename R3714000 beg_2col_mo1992
rename R3714100 beg_2col_yr1992
rename R3714700 end_2col_mo1992
rename R3714800 end_2col_yr1992
rename R3715400 beg_3col_mo1992
rename R3715500 beg_3col_yr1992
rename R3716100 end_3col_mo1992
rename R3716200 end_3col_yr1992
rename R3917600 interview_mo1992
rename R4007401 high_grade_comp_May1992
rename R4007501 enroll_status_svy1992
rename R4100200 interview_mo1993
rename R4100202 inverview_yr1993
rename R4134700 enroll_since_dli1993
rename R4134800 enroll_status_Jan_prev1993
rename R4134801 enroll_status_Feb_prev1993
rename R4134802 enroll_status_Mar_prev1993
rename R4134803 enroll_status_Apr_prev1993
rename R4134804 enroll_status_May_prev1993
rename R4134805 enroll_status_Jun_prev1993
rename R4134806 enroll_status_Jul_prev1993
rename R4134807 enroll_status_Aug_prev1993
rename R4134808 enroll_status_Sep_prev1993
rename R4134809 enroll_status_Oct_prev1993
rename R4134810 enroll_status_Nov_prev1993
rename R4134811 enroll_status_Dec_prev1993
rename R4134812 enroll_status_Jan_curr1993
rename R4134813 enroll_status_Feb_curr1993
rename R4134814 enroll_status_Mar_curr1993
rename R4134815 enroll_status_Apr_curr1993
rename R4134816 enroll_status_May_curr1993
rename R4134817 enroll_status_Jun_curr1993
rename R4134818 enroll_status_Jul_curr1993
rename R4134819 enroll_status_Aug_curr1993
rename R4134820 enroll_status_Sep_curr1993
rename R4134821 enroll_status_Oct_curr1993
rename R4134822 enroll_status_Nov_curr1993
rename R4134823 enroll_status_Dec_curr1993
rename R4137400 enroll_current1993
rename R4137500 grade_level_current1993
rename R4137600 end_sch_mo1993
rename R4137601 end_sch_yr1993
rename R4137800 hgc_attend1993
rename R4137900 hgc_complete1993
rename R4138500 diploma_or_ged1993
rename R4138600 recd_diploma_mo1993
rename R4138601 recd_diploma_yr1993
rename R4138900 high_deg_recd1993
rename R4139000 recd_high_deg_mo1993
rename R4139001 recd_high_deg_yr1993
rename R4140200 beg_1col_mo1993
rename R4140201 beg_1col_yr1993
rename R4140900 end_1col_mo1993
rename R4140901 end_1col_yr1993
rename R4141800 beg_2col_mo1993
rename R4141801 beg_2col_yr1993
rename R4142400 end_2col_mo1993
rename R4142401 end_2col_yr1993
rename R4143300 beg_3col_mo1993
rename R4143301 beg_3col_yr1993
rename R4143800 end_3col_mo1993
rename R4143801 end_3col_yr1993
rename R4418501 high_grade_comp_May1993
rename R4418601 enroll_status_svy1993
rename R4500201 interview_mo1994
rename R4500202 interview_yr1994
rename R4523300 enroll_since_dli1994
rename R4523400 enroll_status_Jan_prev1994
rename R4523401 enroll_status_Feb_prev1994
rename R4523402 enroll_status_Mar_prev1994
rename R4523403 enroll_status_Apr_prev1994
rename R4523404 enroll_status_May_prev1994
rename R4523405 enroll_status_Jun_prev1994
rename R4523406 enroll_status_Jul_prev1994
rename R4523407 enroll_status_Aug_prev1994
rename R4523408 enroll_status_Sep_prev1994
rename R4523409 enroll_status_Oct_prev1994
rename R4523410 enroll_status_Nov_prev1994
rename R4523411 enroll_status_Dec_prev1994
rename R4523412 enroll_status_Jan_curr1994
rename R4523413 enroll_status_Feb_curr1994
rename R4523414 enroll_status_Mar_curr1994
rename R4523415 enroll_status_Apr_curr1994
rename R4523416 enroll_status_May_curr1994
rename R4523417 enroll_status_Jun_curr1994
rename R4523418 enroll_status_Jul_curr1994
rename R4523419 enroll_status_Aug_curr1994
rename R4523420 enroll_status_Sep_curr1994
rename R4523421 enroll_status_Oct_curr1994
rename R4523422 enroll_status_Nov_curr1994
rename R4523423 enroll_status_Dec_curr1994
rename R4526000 enroll_current1994
rename R4526100 grade_current1994
rename R4526200 end_sch_mo1994
rename R4526201 end_sch_yr1994
rename R4526400 high_grade_attend1994
rename R4526500 high_grade_comp_raw1994
rename R4527100 diploma_or_ged1994
rename R4527200 recd_ged_mo1994
rename R4527201 recd_ged_yr1994
rename R4527300 recd_diploma_mo1994
rename R4527301 recd_diploma_yr1994
rename R4527600 high_deg_recd1994
rename R4527700 recd_high_deg_mo1994
rename R4527701 recd_high_deg_yr1994
rename R4528600 beg_1col_mo1994
rename R4528601 beg_1col_yr1994
rename R4529300 end_1col_mo1994
rename R4529301 end_1col_yr1994
rename R4529900 beg_2col_mo1994
rename R4529901 beg_2col_yr1994
rename R4530500 end_2col_mo1994
rename R4530501 end_2col_yr1994
rename R4531000 beg_3col_mo1994
rename R4531001 beg_3col_yr1994
rename R4531500 end_3col_mo1994
rename R4531501 end_3col_yr1994
rename R5103900 high_grade_comp_May1994
rename R5104000 enroll_status_svy1994
rename R5166901 high_grade_comp_May1996         
rename R5166902 enroll_status_svy1996
rename R5200201 interview_mo1996
rename R5200202 interview_yr1996
rename R5221000 enroll_since_dli1996
rename R5221100 enroll_status_Jan_2prev1996
rename R5221101 enroll_status_Feb_2prev1996
rename R5221102 enroll_status_Mar_2prev1996
rename R5221103 enroll_status_Apr_2prev1996
rename R5221104 enroll_status_May_2prev1996
rename R5221105 enroll_status_Jun_2prev1996
rename R5221106 enroll_status_Jul_2prev1996
rename R5221107 enroll_status_Aug_2prev1996
rename R5221108 enroll_status_Sep_2prev1996
rename R5221109 enroll_status_Oct_2prev1996
rename R5221110 enroll_status_Nov_2prev1996
rename R5221111 enroll_status_Dec_2prev1996
rename R5221112 enroll_status_Jan_prev1996
rename R5221113 enroll_status_Feb_prev1996
rename R5221114 enroll_status_Mar_prev1996
rename R5221115 enroll_status_Apr_prev1996
rename R5221116 enroll_status_May_prev1996
rename R5221117 enroll_status_Jun_prev1996
rename R5221118 enroll_status_Jul_prev1996
rename R5221119 enroll_status_Aug_prev1996
rename R5221120 enroll_status_Sep_prev1996
rename R5221121 enroll_status_Oct_prev1996
rename R5221122 enroll_status_Nov_prev1996
rename R5221123 enroll_status_Dec_prev1996
rename R5221200 enroll_status_Jan_curr1996
rename R5221201 enroll_status_Feb_curr1996
rename R5221202 enroll_status_Mar_curr1996
rename R5221203 enroll_status_Apr_curr1996
rename R5221204 enroll_status_May_curr1996
rename R5221205 enroll_status_Jun_curr1996
rename R5221206 enroll_status_Jul_curr1996
rename R5221207 enroll_status_Aug_curr1996
rename R5221208 enroll_status_Sep_curr1996
rename R5221209 enroll_status_Oct_curr1996
rename R5221210 enroll_status_Nov_curr1996
rename R5221211 enroll_status_Dec_curr1996
rename R5221300 enroll_current1996
rename R5221400 grade_current1996
rename R5221500 end_sch_mo1996
rename R5221501 end_sch_yr1996
rename R5221700 high_grade_attend1996
rename R5221800 high_grade_comp_raw1996
rename R5222400 diploma_or_ged1996
rename R5222500 recd_GED_mo1996
rename R5222501 recd_GED_yr1996
rename R5222600 recd_diploma_mo1996
rename R5222601 recd_diploma_yr1996
rename R5222900 high_deg_recd1996
rename R5223000 recd_high_deg_mo1996
rename R5223001 recd_high_deg_yr1996
rename R5223900 beg_1col_mo1996
rename R5223901 beg_1col_yr1996
rename R5224600 end_1col_mo1996
rename R5224601 end_1col_yr1996
rename R5225200 beg_2col_mo1996
rename R5225201 beg_2col_yr1996
rename R5225800 end_2col_mo1996
rename R5225801 end_2col_yr1996
rename R5226400 beg_3col_mo1996
rename R5226401 beg_3col_yr1996
rename R5226900 end_3col_mo1996
rename R5226901 end_3col_yr1996
rename R5821100 enroll_since_dli1998          
rename R5821200 enroll_status_Jan_2prev1998   
rename R5821201 enroll_status_Feb_2prev1998   
rename R5821202 enroll_status_Mar_2prev1998   
rename R5821203 enroll_status_Apr_2prev1998   
rename R5821204 enroll_status_May_2prev1998   
rename R5821205 enroll_status_Jun_2prev1998   
rename R5821206 enroll_status_Jul_2prev1998   
rename R5821207 enroll_status_Aug_2prev1998   
rename R5821208 enroll_status_Sep_2prev1998   
rename R5821209 enroll_status_Oct_2prev1998   
rename R5821210 enroll_status_Nov_2prev1998   
rename R5821211 enroll_status_Dec_2prev1998   
rename R5821212 enroll_status_Jan_prev1998    
rename R5821213 enroll_status_Feb_prev1998    
rename R5821214 enroll_status_Mar_prev1998    
rename R5821215 enroll_status_Apr_prev1998    
rename R5821216 enroll_status_May_prev1998    
rename R5821217 enroll_status_Jun_prev1998    
rename R5821218 enroll_status_Jul_prev1998    
rename R5821219 enroll_status_Aug_prev1998    
rename R5821220 enroll_status_Sep_prev1998    
rename R5821221 enroll_status_Oct_prev1998    
rename R5821222 enroll_status_Nov_prev1998    
rename R5821223 enroll_status_Dec_prev1998    
rename R5821224 enroll_status_Jan_curr1998    
rename R5821225 enroll_status_Feb_curr1998    
rename R5821226 enroll_status_Mar_curr1998    
rename R5821227 enroll_status_Apr_curr1998    
rename R5821228 enroll_status_May_curr1998    
rename R5821229 enroll_status_Jun_curr1998    
rename R5821230 enroll_status_Jul_curr1998    
rename R5821231 enroll_status_Aug_curr1998    
rename R5821232 enroll_status_Sep_curr1998    
rename R5821233 enroll_status_Oct_curr1998    
rename R5821234 enroll_status_Nov_curr1998    
rename R5821235 enroll_status_Dec_curr1998    
rename R5821300 enroll_current1998            
rename R5821400 grade_current1998             
rename R5821500 end_sch_mo1998                
rename R5821501 end_sch_yr1998                
rename R5821700 high_grade_attend1998         
rename R5821800 high_grade_comp_raw1998       
rename R5822300 diploma_or_ged1998            
rename R5822500 recd_diploma_mo1998           
rename R5822501 recd_diploma_yr1998           
rename R5822800 high_deg_recd1998             
rename R5822900 recd_high_deg_mo1998          
rename R5822901 recd_high_deg_yr1998          
rename R5824500 beg_1col_mo1998               
rename R5824501 beg_1col_yr1998               
rename R5824600 beg_2col_mo1998               
rename R5824601 beg_2col_yr1998               
rename R5824700 beg_3col_mo1998               
rename R5824701 beg_3col_yr1998               
rename R5826200 end_1col_mo1998               
rename R5826201 end_1col_yr1998               
rename R5826300 end_2col_mo1998               
rename R5826301 end_2col_yr1998               
rename R5826400 end_3col_mo1998               
rename R5826401 end_3col_yr1998               
rename R6435301 interview_mo1998              
rename R6435302 interview_yr1998              
rename R6479600 high_grade_comp_May1998       
rename R6479700 enroll_status_svy1998         
rename R6539800 enroll_since_dli2000         
rename R6539900 enroll_status_Jan_2prev2000  
rename R6539901 enroll_status_Feb_2prev2000  
rename R6539902 enroll_status_Mar_2prev2000  
rename R6539903 enroll_status_Apr_2prev2000  
rename R6539904 enroll_status_May_2prev2000  
rename R6539905 enroll_status_Jun_2prev2000  
rename R6539906 enroll_status_Jul_2prev2000  
rename R6539907 enroll_status_Aug_2prev2000  
rename R6539908 enroll_status_Sep_2prev2000  
rename R6539909 enroll_status_Oct_2prev2000  
rename R6539910 enroll_status_Nov_2prev2000  
rename R6539911 enroll_status_Dec_2prev2000  
rename R6539912 enroll_status_Jan_prev2000   
rename R6539913 enroll_status_Feb_prev2000   
rename R6539914 enroll_status_Mar_prev2000   
rename R6539915 enroll_status_Apr_prev2000   
rename R6539916 enroll_status_May_prev2000   
rename R6539917 enroll_status_Jun_prev2000   
rename R6539918 enroll_status_Jul_prev2000   
rename R6539919 enroll_status_Aug_prev2000   
rename R6539920 enroll_status_Sep_prev2000   
rename R6539921 enroll_status_Oct_prev2000   
rename R6539922 enroll_status_Nov_prev2000   
rename R6539923 enroll_status_Dec_prev2000   
rename R6539924 enroll_status_Jan_curr2000   
rename R6539925 enroll_status_Feb_curr2000   
rename R6539926 enroll_status_Mar_curr2000   
rename R6539927 enroll_status_Apr_curr2000   
rename R6539928 enroll_status_May_curr2000   
rename R6539929 enroll_status_Jun_curr2000   
rename R6539930 enroll_status_Jul_curr2000   
rename R6539931 enroll_status_Aug_curr2000   
rename R6539932 enroll_status_Sep_curr2000   
rename R6539933 enroll_status_Oct_curr2000   
rename R6539934 enroll_status_Nov_curr2000   
rename R6539935 enroll_status_Dec_curr2000   
rename R6540000 enroll_current2000           
rename R6540100 grade_current2000            
rename R6540300 high_grade_attend2000        
rename R6540400 high_grade_comp_raw2000      
rename R6540900 diploma_or_ged2000           
rename R6541100 recd_diploma_mo2000          
rename R6541101 recd_diploma_yr2000          
rename R6541400 high_deg_recd2000            
rename R6541500 recd_high_deg_mo2000         
rename R6541501 recd_high_deg_yr2000         
rename R6543000 beg_1col_mo2000              
rename R6543001 beg_1col_yr2000              
rename R6543100 beg_2col_mo2000              
rename R6543101 beg_2col_yr2000              
rename R6543200 beg_3col_mo2000              
rename R6543201 beg_3col_yr2000              
rename R6545100 end_1col_mo2000              
rename R6545101 end_1col_yr2000              
rename R6545200 end_2col_mo2000              
rename R6545201 end_2col_yr2000              
rename R6545300 end_3col_mo2000              
rename R6545301 end_3col_yr2000              
rename R6963301 interview_mo2000             
rename R6963302 interview_yr2000             
rename R7007300 high_grade_comp_May2000      
rename R7007400 enroll_status_svy2000        
rename R7103000 enroll_since_dli2002        
rename R7103100 enroll_status_Jan_3prev2002 
rename R7103101 enroll_status_Feb_3prev2002 
rename R7103102 enroll_status_Mar_3prev2002 
rename R7103103 enroll_status_Apr_3prev2002 
rename R7103104 enroll_status_May_3prev2002 
rename R7103105 enroll_status_Jun_3prev2002 
rename R7103106 enroll_status_Jul_3prev2002 
rename R7103107 enroll_status_Aug_3prev2002 
rename R7103108 enroll_status_Sep_3prev2002 
rename R7103109 enroll_status_Oct_3prev2002 
rename R7103110 enroll_status_Nov_3prev2002 
rename R7103111 enroll_status_Dec_3prev2002 
rename R7103112 enroll_status_Jan_2prev2002 
rename R7103113 enroll_status_Feb_2prev2002 
rename R7103114 enroll_status_Mar_2prev2002 
rename R7103115 enroll_status_Apr_2prev2002 
rename R7103116 enroll_status_May_2prev2002 
rename R7103117 enroll_status_Jun_2prev2002 
rename R7103118 enroll_status_Jul_2prev2002 
rename R7103119 enroll_status_Aug_2prev2002 
rename R7103120 enroll_status_Sep_2prev2002 
rename R7103121 enroll_status_Oct_2prev2002 
rename R7103122 enroll_status_Nov_2prev2002 
rename R7103123 enroll_status_Dec_2prev2002 
rename R7103124 enroll_status_Jan_prev2002  
rename R7103125 enroll_status_Feb_prev2002  
rename R7103126 enroll_status_Mar_prev2002  
rename R7103127 enroll_status_Apr_prev2002  
rename R7103128 enroll_status_May_prev2002  
rename R7103129 enroll_status_Jun_prev2002  
rename R7103130 enroll_status_Jul_prev2002  
rename R7103131 enroll_status_Aug_prev2002  
rename R7103132 enroll_status_Sep_prev2002  
rename R7103133 enroll_status_Oct_prev2002  
rename R7103134 enroll_status_Nov_prev2002  
rename R7103135 enroll_status_Dec_prev2002  
rename R7103136 enroll_status_Jan_curr2002  
rename R7103137 enroll_status_Feb_curr2002  
rename R7103138 enroll_status_Mar_curr2002  
rename R7103139 enroll_status_Apr_curr2002  
rename R7103140 enroll_status_May_curr2002  
rename R7103141 enroll_status_Jun_curr2002  
rename R7103142 enroll_status_Jul_curr2002  
rename R7103143 enroll_status_Aug_curr2002  
rename R7103144 enroll_status_Sep_curr2002  
rename R7103145 enroll_status_Oct_curr2002  
rename R7103146 enroll_status_Nov_curr2002  
rename R7103147 enroll_status_Dec_curr2002  
rename R7103200 enroll_current2002          
rename R7103300 grade_current2002           
rename R7103500 high_grade_attend2002       
rename R7103600 high_grade_comp_raw2002     
rename R7104100 diploma_or_ged2002          
rename R7104300 recd_diploma_mo2002         
rename R7104301 recd_diploma_yr2002         
rename R7104600 high_deg_recd2002           
rename R7104700 recd_high_deg_mo2002        
rename R7104701 recd_high_deg_yr2002        
rename R7106200 beg_1col_mo2002             
rename R7106201 beg_1col_yr2002             
rename R7106300 beg_2col_mo2002             
rename R7106301 beg_2col_yr2002             
rename R7106400 beg_3col_mo2002             
rename R7106401 beg_3col_yr2002             
rename R7108200 end_1col_mo2002             
rename R7108201 end_1col_yr2002             
rename R7108300 end_2col_mo2002             
rename R7108301 end_2col_yr2002             
rename R7108400 end_3col_mo2002             
rename R7108401 end_3col_yr2002             
rename R7656301 interview_mo2002            
rename R7656302 interview_yr2002            
rename R7704600 high_grade_comp_May2002     
rename R7704700 enroll_status_svy2002       
rename R7800501 interview_mo2004            
rename R7800502 interview_yr2004            
rename R7809900 enroll_since_dli2004        
rename R7810000 enroll_status_Jan_2prev2004 
rename R7810001 enroll_status_Feb_2prev2004 
rename R7810002 enroll_status_Mar_2prev2004 
rename R7810003 enroll_status_Apr_2prev2004 
rename R7810004 enroll_status_May_2prev2004 
rename R7810005 enroll_status_Jun_2prev2004 
rename R7810006 enroll_status_Jul_2prev2004 
rename R7810007 enroll_status_Aug_2prev2004 
rename R7810008 enroll_status_Sep_2prev2004 
rename R7810009 enroll_status_Oct_2prev2004 
rename R7810010 enroll_status_Nov_2prev2004 
rename R7810011 enroll_status_Dec_2prev2004 
rename R7810012 enroll_status_Jan_prev2004  
rename R7810013 enroll_status_Feb_prev2004  
rename R7810014 enroll_status_Mar_prev2004  
rename R7810015 enroll_status_Apr_prev2004  
rename R7810016 enroll_status_May_prev2004  
rename R7810017 enroll_status_Jun_prev2004  
rename R7810018 enroll_status_Jul_prev2004  
rename R7810019 enroll_status_Aug_prev2004  
rename R7810020 enroll_status_Sep_prev2004  
rename R7810021 enroll_status_Oct_prev2004  
rename R7810022 enroll_status_Nov_prev2004  
rename R7810023 enroll_status_Dec_prev2004  
rename R7810024 enroll_status_Jan_curr2004  
rename R7810025 enroll_status_Feb_curr2004  
rename R7810026 enroll_status_Mar_curr2004  
rename R7810027 enroll_status_Apr_curr2004  
rename R7810028 enroll_status_May_curr2004  
rename R7810029 enroll_status_Jun_curr2004  
rename R7810030 enroll_status_Jul_curr2004  
rename R7810031 enroll_status_Aug_curr2004  
rename R7810032 enroll_status_Sep_curr2004  
rename R7810033 enroll_status_Oct_curr2004  
rename R7810034 enroll_status_Nov_curr2004  
rename R7810035 enroll_status_Dec_curr2004  
rename R7810100 enroll_current2004          
rename R7810200 grade_current2004           
rename R7810400 high_grade_attend2004       
rename R7810500 high_grade_comp_raw2004     
rename R7811000 diploma_or_ged2004          
rename R7811200 recd_diploma_mo2004         
rename R7811201 recd_diploma_yr2004         
rename R7811500 high_deg_recd2004           
rename R7811600 recd_high_deg_mo2004        
rename R7811601 recd_high_deg_yr2004        
rename R7813100 beg_1col_mo2004             
rename R7813101 beg_1col_yr2004             
rename R7813200 beg_2col_mo2004             
rename R7813201 beg_2col_yr2004             
rename R7813300 beg_3col_mo2004             
rename R7813301 beg_3col_yr2004             
rename R7814800 end_1col_mo2004             
rename R7814801 end_1col_yr2004             
rename R7814900 end_2col_mo2004             
rename R7814901 end_2col_yr2004             
rename R7815000 end_3col_mo2004             
rename R7815001 end_3col_yr2004             
rename R8497000 high_grade_comp_May2004     
rename R8497100 enroll_status_svy2004       
rename T0000901 interview_mo2006            
rename T0000902 interview_yr2006            
rename T0013800 enroll_since_dli2006        
rename T0013900 enroll_status_Jan_2prev2006 
rename T0013901 enroll_status_Feb_2prev2006 
rename T0013902 enroll_status_Mar_2prev2006 
rename T0013903 enroll_status_Apr_2prev2006 
rename T0013904 enroll_status_May_2prev2006 
rename T0013905 enroll_status_Jun_2prev2006 
rename T0013906 enroll_status_Jul_2prev2006 
rename T0013907 enroll_status_Aug_2prev2006 
rename T0013908 enroll_status_Sep_2prev2006 
rename T0013909 enroll_status_Oct_2prev2006 
rename T0013910 enroll_status_Nov_2prev2006 
rename T0013911 enroll_status_Dec_2prev2006 
rename T0013912 enroll_status_Jan_prev2006  
rename T0013913 enroll_status_Feb_prev2006  
rename T0013914 enroll_status_Mar_prev2006  
rename T0013915 enroll_status_Apr_prev2006  
rename T0013916 enroll_status_May_prev2006  
rename T0013917 enroll_status_Jun_prev2006  
rename T0013918 enroll_status_Jul_prev2006  
rename T0013919 enroll_status_Aug_prev2006  
rename T0013920 enroll_status_Sep_prev2006  
rename T0013921 enroll_status_Oct_prev2006  
rename T0013922 enroll_status_Nov_prev2006  
rename T0013923 enroll_status_Dec_prev2006  
rename T0013924 enroll_status_Jan_curr2006  
rename T0013925 enroll_status_Feb_curr2006  
rename T0013926 enroll_status_Mar_curr2006  
rename T0013927 enroll_status_Apr_curr2006  
rename T0013928 enroll_status_May_curr2006  
rename T0013929 enroll_status_Jun_curr2006  
rename T0013930 enroll_status_Jul_curr2006  
rename T0013931 enroll_status_Aug_curr2006  
rename T0013932 enroll_status_Sep_curr2006  
rename T0013933 enroll_status_Oct_curr2006  
rename T0013934 enroll_status_Nov_curr2006  
rename T0013935 enroll_status_Dec_curr2006  
rename T0014000 enroll_current2006          
rename T0014100 grade_current2006           
rename T0014300 high_grade_attend2006       
rename T0014400 high_grade_comp_raw2006     
rename T0014900 diploma_or_ged2006          
rename T0015100 recd_diploma_mo2006         
rename T0015101 recd_diploma_yr2006         
rename T0015400 high_deg_recd2006           
rename T0015500 recd_high_deg_mo2006        
rename T0015501 recd_high_deg_yr2006        
rename T0017000 beg_1col_mo2006             
rename T0017001 beg_1col_yr2006             
rename T0017100 beg_2col_mo2006             
rename T0017101 beg_2col_yr2006             
rename T0017200 beg_3col_mo2006             
rename T0017201 beg_3col_yr2006             
rename T0019000 end_1col_mo2006             
rename T0019001 end_1col_yr2006             
rename T0019100 end_2col_mo2006             
rename T0019101 end_2col_yr2006             
rename T0019200 end_3col_mo2006             
rename T0019201 end_3col_yr2006             
rename T0988800 high_grade_comp_May2006     
rename T0988900 enroll_status_svy2006       
rename T1200701 interview_mo2008             
rename T1200702 interview_yr2008             
rename T1213700 enroll_since_dli2008         
rename T1213800 enroll_status_Jan_2prev2008  
rename T1213801 enroll_status_Feb_2prev2008  
rename T1213802 enroll_status_Mar_2prev2008  
rename T1213803 enroll_status_Apr_2prev2008  
rename T1213804 enroll_status_May_2prev2008  
rename T1213805 enroll_status_Jun_2prev2008  
rename T1213806 enroll_status_Jul_2prev2008  
rename T1213807 enroll_status_Aug_2prev2008  
rename T1213808 enroll_status_Sep_2prev2008  
rename T1213809 enroll_status_Oct_2prev2008  
rename T1213810 enroll_status_Nov_2prev2008  
rename T1213811 enroll_status_Dec_2prev2008  
rename T1213812 enroll_status_Jan_prev2008   
rename T1213813 enroll_status_Feb_prev2008   
rename T1213814 enroll_status_Mar_prev2008   
rename T1213815 enroll_status_Apr_prev2008   
rename T1213816 enroll_status_May_prev2008   
rename T1213817 enroll_status_Jun_prev2008   
rename T1213818 enroll_status_Jul_prev2008   
rename T1213819 enroll_status_Aug_prev2008   
rename T1213820 enroll_status_Sep_prev2008   
rename T1213821 enroll_status_Oct_prev2008   
rename T1213822 enroll_status_Nov_prev2008   
rename T1213823 enroll_status_Dec_prev2008   
rename T1213824 enroll_status_Jan_curr2008   
rename T1213825 enroll_status_Feb_curr2008   
rename T1213826 enroll_status_Mar_curr2008   
rename T1213827 enroll_status_Apr_curr2008   
rename T1213828 enroll_status_May_curr2008   
rename T1213829 enroll_status_Jun_curr2008   
rename T1213830 enroll_status_Jul_curr2008   
rename T1213831 enroll_status_Aug_curr2008   
rename T1213832 enroll_status_Sep_curr2008   
rename T1213833 enroll_status_Oct_curr2008   
rename T1213834 enroll_status_Nov_curr2008   
rename T1213835 enroll_status_Dec_curr2008   
rename T1213900 enroll_current2008           
rename T1214000 grade_current2008            
rename T1214200 high_grade_attend2008        
rename T1214300 high_grade_comp_raw2008      
rename T1214900 diploma_or_ged2008           
rename T1215100 recd_diploma_mo2008          
rename T1215101 recd_diploma_yr2008          
rename T1215400 high_deg_recd2008            
rename T1215500 recd_high_deg_mo2008         
rename T1215501 recd_high_deg_yr2008         
rename T1217400 beg_1col_mo2008              
rename T1217401 beg_1col_yr2008              
rename T1217500 beg_2col_mo2008              
rename T1217501 beg_2col_yr2008              
rename T1217600 beg_3col_mo2008              
rename T1217601 beg_3col_yr2008              
rename T1219400 end_1col_mo2008              
rename T1219401 end_1col_yr2008              
rename T1219500 end_2col_mo2008              
rename T1219501 end_2col_yr2008              
rename T2210700 high_grade_comp_May2008      
rename T2260601 interview_mo2010            
rename T2260602 interview_yr2010            
rename T2272200 enroll_since_dli2010        
rename T2272300 enroll_status_Jan_2prev2010 
rename T2272301 enroll_status_Feb_2prev2010 
rename T2272302 enroll_status_Mar_2prev2010 
rename T2272303 enroll_status_Apr_2prev2010 
rename T2272304 enroll_status_May_2prev2010 
rename T2272305 enroll_status_Jun_2prev2010 
rename T2272306 enroll_status_Jul_2prev2010 
rename T2272307 enroll_status_Aug_2prev2010 
rename T2272308 enroll_status_Sep_2prev2010 
rename T2272309 enroll_status_Oct_2prev2010 
rename T2272310 enroll_status_Nov_2prev2010 
rename T2272311 enroll_status_Dec_2prev2010 
rename T2272312 enroll_status_Jan_prev2010  
rename T2272313 enroll_status_Feb_prev2010  
rename T2272314 enroll_status_Mar_prev2010  
rename T2272315 enroll_status_Apr_prev2010  
rename T2272316 enroll_status_May_prev2010  
rename T2272317 enroll_status_Jun_prev2010  
rename T2272318 enroll_status_Jul_prev2010  
rename T2272319 enroll_status_Aug_prev2010  
rename T2272320 enroll_status_Sep_prev2010  
rename T2272321 enroll_status_Oct_prev2010  
rename T2272322 enroll_status_Nov_prev2010  
rename T2272323 enroll_status_Dec_prev2010  
rename T2272324 enroll_status_Jan_curr2010  
rename T2272325 enroll_status_Feb_curr2010  
rename T2272326 enroll_status_Mar_curr2010  
rename T2272327 enroll_status_Apr_curr2010  
rename T2272328 enroll_status_May_curr2010  
rename T2272329 enroll_status_Jun_curr2010  
rename T2272330 enroll_status_Jul_curr2010  
rename T2272331 enroll_status_Aug_curr2010  
rename T2272332 enroll_status_Sep_curr2010  
rename T2272333 enroll_status_Oct_curr2010  
rename T2272334 enroll_status_Nov_curr2010  
rename T2272335 enroll_status_Dec_curr2010  
rename T2272400 enroll_current2010          
rename T2272500 grade_current2010           
rename T2272700 high_grade_attend2010       
rename T2272800 high_grade_comp_raw2010     
rename T2273400 diploma_or_ged2010          
rename T2273600 recd_diploma_mo2010         
rename T2273601 recd_diploma_yr2010         
rename T2273900 high_deg_recd2010           
rename T2274000 recd_high_deg_mo2010        
rename T2274001 recd_high_deg_yr2010        
rename T2275500 beg_1col_mo2010             
rename T2275501 beg_1col_yr2010             
rename T2275600 beg_2col_mo2010             
rename T2275601 beg_2col_yr2010             
rename T2276900 end_1col_mo2010             
rename T2276901 end_1col_yr2010             
rename T2277000 end_2col_mo2010             
rename T2277001 end_2col_yr2010             
rename T3108600 high_grade_comp_May2010     
rename T3195601 interview_mo2012             
rename T3195602 interview_yr2012             
rename T3212300 enroll_since_dli2012         
rename T3212400 enroll_status_Jan_2prev2012  
rename T3212401 enroll_status_Feb_2prev2012  
rename T3212402 enroll_status_Mar_2prev2012  
rename T3212403 enroll_status_Apr_2prev2012  
rename T3212404 enroll_status_May_2prev2012  
rename T3212405 enroll_status_Jun_2prev2012  
rename T3212406 enroll_status_Jul_2prev2012  
rename T3212407 enroll_status_Aug_2prev2012  
rename T3212408 enroll_status_Sep_2prev2012  
rename T3212409 enroll_status_Oct_2prev2012  
rename T3212410 enroll_status_Nov_2prev2012  
rename T3212411 enroll_status_Dec_2prev2012  
rename T3212412 enroll_status_Jan_prev2012   
rename T3212413 enroll_status_Feb_prev2012   
rename T3212414 enroll_status_Mar_prev2012   
rename T3212415 enroll_status_Apr_prev2012   
rename T3212416 enroll_status_May_prev2012   
rename T3212417 enroll_status_Jun_prev2012   
rename T3212418 enroll_status_Jul_prev2012   
rename T3212419 enroll_status_Aug_prev2012   
rename T3212420 enroll_status_Sep_prev2012   
rename T3212421 enroll_status_Oct_prev2012   
rename T3212422 enroll_status_Nov_prev2012   
rename T3212423 enroll_status_Dec_prev2012   
rename T3212424 enroll_status_Jan_curr2012   
rename T3212425 enroll_status_Feb_curr2012   
rename T3212426 enroll_status_Mar_curr2012   
rename T3212427 enroll_status_Apr_curr2012   
rename T3212428 enroll_status_May_curr2012   
rename T3212429 enroll_status_Jun_curr2012   
rename T3212430 enroll_status_Jul_curr2012   
rename T3212431 enroll_status_Aug_curr2012   
rename T3212432 enroll_status_Sep_curr2012   
rename T3212433 enroll_status_Oct_curr2012   
rename T3212434 enroll_status_Nov_curr2012   
rename T3212435 enroll_status_Dec_curr2012   
rename T3212436 enroll_status_Jan_1next2012  
rename T3212437 enroll_status_Feb_1next2012  
rename T3212438 enroll_status_Mar_1next2012  
rename T3212439 enroll_status_Apr_1next2012  
rename T3212440 enroll_status_May_1next2012  
rename T3212441 enroll_status_Jun_1next2012  
rename T3212500 enroll_current2012           
rename T3212600 grade_current2012            
rename T3212800 high_grade_attend2012        
rename T3212900 high_grade_comp_raw2012      
rename T3213500 diploma_or_ged2012           
rename T3213700 recd_diploma_mo2012          
rename T3213701 recd_diploma_yr2012          
rename T3214000 high_deg_recd2012            
rename T3214100 recd_high_deg_mo2012         
rename T3214101 recd_high_deg_yr2012         
rename T3216000 beg_1col_mo2012              
rename T3216001 beg_1col_yr2012              
rename T3216100 beg_2col_mo2012              
rename T3216101 beg_2col_yr2012              
rename T3216200 beg_3col_mo2012              
rename T3216201 beg_3col_yr2012              
rename T3218000 end_1col_mo2012              
rename T3218001 end_1col_yr2012              
rename T3218100 end_2col_mo2012              
rename T3218101 end_2col_yr2012              
rename T3218200 end_3col_mo2012              
rename T3218201 end_3col_yr2012              
rename T4113100 high_grade_comp_May2012      
rename T4181101 interview_mo2014              
rename T4181102 interview_yr2014              
rename T4200400 enroll_since_dli2014          
rename T4200500 enroll_status_Jan_2prev2014   
rename T4200501 enroll_status_Feb_2prev2014   
rename T4200502 enroll_status_Mar_2prev2014   
rename T4200503 enroll_status_Apr_2prev2014   
rename T4200504 enroll_status_May_2prev2014   
rename T4200505 enroll_status_Jun_2prev2014   
rename T4200506 enroll_status_Jul_2prev2014   
rename T4200507 enroll_status_Aug_2prev2014   
rename T4200508 enroll_status_Sep_2prev2014   
rename T4200509 enroll_status_Oct_2prev2014   
rename T4200510 enroll_status_Nov_2prev2014   
rename T4200511 enroll_status_Dec_2prev2014   
rename T4200512 enroll_status_Jan_prev2014    
rename T4200513 enroll_status_Feb_prev2014    
rename T4200514 enroll_status_Mar_prev2014    
rename T4200515 enroll_status_Apr_prev2014    
rename T4200516 enroll_status_May_prev2014    
rename T4200517 enroll_status_Jun_prev2014    
rename T4200518 enroll_status_Jul_prev2014    
rename T4200519 enroll_status_Aug_prev2014    
rename T4200520 enroll_status_Sep_prev2014    
rename T4200521 enroll_status_Oct_prev2014    
rename T4200522 enroll_status_Nov_prev2014    
rename T4200523 enroll_status_Dec_prev2014    
rename T4200524 enroll_status_Jan_curr2014    
rename T4200525 enroll_status_Feb_curr2014    
rename T4200526 enroll_status_Mar_curr2014    
rename T4200527 enroll_status_Apr_curr2014    
rename T4200528 enroll_status_May_curr2014    
rename T4200529 enroll_status_Jun_curr2014    
rename T4200530 enroll_status_Jul_curr2014    
rename T4200531 enroll_status_Aug_curr2014    
rename T4200532 enroll_status_Sep_curr2014    
rename T4200533 enroll_status_Oct_curr2014    
rename T4200534 enroll_status_Nov_curr2014    
rename T4200535 enroll_status_Dec_curr2014    
rename T4200536 enroll_status_Jan_1next2014   
rename T4200537 enroll_status_Feb_1next2014   
rename T4200538 enroll_status_Mar_1next2014   
rename T4200539 enroll_status_Apr_1next2014   
rename T4200540 enroll_status_May_1next2014   
rename T4200541 enroll_status_Jun_1next2014   
rename T4200542 enroll_status_Jul_1next2014   
rename T4200543 enroll_status_Aug_1next2014   
rename T4200544 enroll_status_Sep_1next2014   
rename T4200545 enroll_status_Oct_1next2014   
rename T4200546 enroll_status_Nov_1next2014   
rename T4200547 enroll_status_Dec_1next2014   
rename T4200600 enroll_current2014            
rename T4200700 grade_current2014             
rename T4201000 high_grade_attend2014         
rename T4201100 high_grade_comp_raw2014       
rename T4201700 diploma_or_ged2014            
rename T4201900 recd_diploma_mo2014           
rename T4201901 recd_diploma_yr2014           
rename T4202200 high_deg_recd2014             
rename T4202300 recd_high_deg_mo2014          
rename T4202301 recd_high_deg_yr2014          
rename T4205300 beg_1col_mo2014               
rename T4205301 beg_1col_yr2014               
rename T4205400 beg_2col_mo2014               
rename T4205401 beg_2col_yr2014               
rename T4205500 beg_3col_mo2014               
rename T4205501 beg_3col_yr2014               
rename T4207600 end_1col_mo2014               
rename T4207601 end_1col_yr2014               
rename T4207700 end_2col_mo2014               
rename T4207701 end_2col_yr2014               
rename T5023500 high_grade_comp_May2014       


***************************************************
* Reshape and recode certain variables.
***************************************************

* exclued from reshape: id (i), race_screen, sex, dob_yr1979, dob_mo1979
forvalues yr=1970/2014 {
	gen temp`yr'=0
}
reshape long temp  beg_1col_mo beg_1col_yr beg_2col_mo beg_2col_yr beg_3col_mo beg_3col_yr beg_sch_last_k12_mo beg_sch_last_k12_yr diploma_or_ged end_1col_mo end_1col_yr end_2col_mo end_2col_yr end_3col_mo end_3col_yr end_sch_last_k12_mo end_sch_last_k12_yr end_sch_mo end_sch_yr enroll_current enroll_since_dli enroll_status_Apr_1next enroll_status_Apr_2prev enroll_status_Apr_3prev enroll_status_Apr_curr enroll_status_Apr_prev enroll_status_Aug_1next enroll_status_Aug_2prev enroll_status_Aug_3prev enroll_status_Aug_curr enroll_status_Aug_prev enroll_status_Dec_1next enroll_status_Dec_2prev enroll_status_Dec_3prev enroll_status_Dec_curr enroll_status_Dec_prev enroll_status_Feb_1next enroll_status_Feb_2prev enroll_status_Feb_3prev enroll_status_Feb_curr enroll_status_Feb_prev enroll_status_Jan_1next enroll_status_Jan_2prev enroll_status_Jan_3prev enroll_status_Jan_curr enroll_status_Jan_prev enroll_status_Jul_1next enroll_status_Jul_2prev enroll_status_Jul_3prev enroll_status_Jul_curr enroll_status_Jul_prev enroll_status_Jun_1next enroll_status_Jun_2prev enroll_status_Jun_3prev enroll_status_Jun_curr enroll_status_Jun_prev enroll_status_Mar_1next enroll_status_Mar_2prev enroll_status_Mar_3prev enroll_status_Mar_curr enroll_status_Mar_prev enroll_status_May_1next enroll_status_May_2prev enroll_status_May_3prev enroll_status_May_curr enroll_status_May_prev enroll_status_Nov_1next enroll_status_Nov_2prev enroll_status_Nov_3prev enroll_status_Nov_curr enroll_status_Nov_prev enroll_status_Oct_1next enroll_status_Oct_2prev enroll_status_Oct_3prev enroll_status_Oct_curr enroll_status_Oct_prev enroll_status_Sep_1next enroll_status_Sep_2prev enroll_status_Sep_3prev enroll_status_Sep_curr enroll_status_Sep_prev enroll_status_svy grade_current high_deg_recd high_grade_attend high_grade_comp_May high_grade_comp_raw interview_mo recd_1degree_mo recd_1degree_yr recd_2degree_mo recd_2degree_yr recd_3degree_mo recd_3degree_yr recd_4degree_mo recd_4degree_yr recd_diploma_mo recd_diploma_yr recd_high_deg_mo recd_high_deg_yr type_1degree_recd type_2degree_recd type_3degree_recd type_4degree_recd, i(id) j(year)
drop temp
drop if id==.

recode _all (-1 = .r) (-2 = .d) (-3 = .i) (-4 = .v) (-5 = .n)
recode enroll_status_Jan* enroll_status_Feb* enroll_status_Mar* ///
       enroll_status_Apr* enroll_status_May* enroll_status_Jun* /// 
       enroll_status_Jul* enroll_status_Aug* enroll_status_Sep* /// 
       enroll_status_Oct* enroll_status_Nov* enroll_status_Dec* (2/36 = 1)
recode *_yr* (50 = 1950) (51 = 1951) (52 = 1952) (53 = 1953) (54 = 1954) (55 = 1955) (55 = 1955) (57 = 1957) (58 = 1958) (59 = 1959) ///
             (60 = 1960) (61 = 1961) (62 = 1962) (63 = 1963) (64 = 1964) (65 = 1965) (66 = 1966) (67 = 1967) (68 = 1968) (69 = 1969) ///
             (70 = 1970) (71 = 1971) (72 = 1972) (73 = 1973) (74 = 1974) (75 = 1975) (76 = 1976) (77 = 1977) (78 = 1978) (79 = 1979) ///
             (80 = 1980) (81 = 1981) (82 = 1982) (83 = 1983) (84 = 1984) (85 = 1985) (86 = 1986) (87 = 1987) (88 = 1988) (89 = 1989) ///
             (90 = 1990) (91 = 1991) (92 = 1992) (93 = 1993) (94 = 1994) (95 = 1995) (96 = 1996) (97 = 1997) (99 = 1999) (99 = 1999)

***************************************************
* Label variables and values
***************************************************

label var id                       "ID"
label var year                     "YEAR"
label var dob_mo1979               "DATE OF BIRTH - MONTH 79"
label var dob_yr1979               "DATE OF BIRTH - YR 79"
label var race_screen              "RACL/ETHNIC COHORT /SCRNR"
label var sex                      "SEX"
label var beg_1col_mo              "MONTH ENROLLED CURRENT/MOST-RCNT COLL"
label var beg_1col_yr              "YEAR ENROLLED CURRENT/MOST-RCNT COLL"
label var beg_2col_mo              "MONTH ENROLLED 2ND MOST-RCNT COLL"
label var beg_2col_yr              "YEAR ENROLLED 2ND MOST-RCNT COLL"
label var beg_3col_mo              "MONTH ENROLLED 3RD MOST-RCNT COLL"
label var beg_3col_yr              "YEAR ENROLLED 3RD MOST-RCNT COLL"
label var beg_sch_last_k12_mo      "MONTH BGN @ CUR/LAST SCHL GRDS 1-12"
label var beg_sch_last_k12_yr      "YR BGN @ CUR/LAST SCHL GRDS 1-12"
label var diploma_or_ged           "IS HS DEGREE A DIPLOMA OR GED"
label var end_1col_mo              "MONTH LAST ENROLLED CURRENT/MOST-RCNT COLL"
label var end_1col_yr              "YEAR LAST ENROLLED CURRENT/MOST-RCNT COLL"
label var end_2col_mo              "MONTH LAST ENROLLED 2ND MOST-RCNT COLL"
label var end_2col_yr              "YEAR LAST ENROLLED 2ND MOST-RCNT COLL"
label var end_3col_mo              "MONTH LAST ENROLLED 3RD MOST-RCNT COLL"
label var end_3col_yr              "YEAR LAST ENROLLED 3RD MOST-RCNT COLL"
label var end_sch_last_k12_mo      "MONTH LAST IN SCHL GRDS 1-12"
label var end_sch_last_k12_yr      "YR LAST ENROLLED SCHL GRDS 1-12"
label var end_sch_mo               "MONTH LAST IN SCHL (NOT ENROLLED)"
label var end_sch_yr               "YR LAST IN SCHL (NOT ENROLLED)"
label var enroll_current           "CURRENTLY ATTEND/ENROLLED IN SCHL"
label var enroll_since_dli         "IN SCHL @ ALL SUMMER SIN LINT"
label var enroll_status_Apr_1next	"MONTHLY ENROLLMENT - NEXT APR"
label var enroll_status_Apr_2prev	"MONTHLY ENROLLMENT - 2 YR PREV APR"
label var enroll_status_Apr_3prev	"MONTHLY ENROLLMENT - 3 YR PREV APR"
label var enroll_status_Apr_curr	"MONTHLY ENROLLMENT - CURR APR"
label var enroll_status_Apr_prev	"MONTHLY ENROLLMENT - PREV APR"
label var enroll_status_Aug_1next	"MONTHLY ENROLLMENT - NEXT AUG"
label var enroll_status_Aug_2prev	"MONTHLY ENROLLMENT - 2 YR PREV AUG"
label var enroll_status_Aug_3prev	"MONTHLY ENROLLMENT - 3 YR PREV AUG"
label var enroll_status_Aug_curr	"MONTHLY ENROLLMENT - CURR AUG"
label var enroll_status_Aug_prev	"MONTHLY ENROLLMENT - PREV AUG"
label var enroll_status_Dec_1next	"MONTHLY ENROLLMENT - NEXT DEC"
label var enroll_status_Dec_2prev	"MONTHLY ENROLLMENT - 2 YR PREV DEC"
label var enroll_status_Dec_3prev	"MONTHLY ENROLLMENT - 3 YR PREV DEC"
label var enroll_status_Dec_curr	"MONTHLY ENROLLMENT - CURR DEC"
label var enroll_status_Dec_prev	"MONTHLY ENROLLMENT - PREV DEC"
label var enroll_status_Feb_1next	"MONTHLY ENROLLMENT - NEXT FEB"
label var enroll_status_Feb_2prev	"MONTHLY ENROLLMENT - 2 YR PREV FEB"
label var enroll_status_Feb_3prev	"MONTHLY ENROLLMENT - 3 YR PREV FEB"
label var enroll_status_Feb_curr	"MONTHLY ENROLLMENT - CURR FEB"
label var enroll_status_Feb_prev	"MONTHLY ENROLLMENT - PREV FEB"
label var enroll_status_Jan_1next	"MONTHLY ENROLLMENT - NEXT JAN"
label var enroll_status_Jan_2prev	"MONTHLY ENROLLMENT - 2 YR PREV JAN"
label var enroll_status_Jan_3prev	"MONTHLY ENROLLMENT - 3 YR PREV JAN"
label var enroll_status_Jan_curr	"MONTHLY ENROLLMENT - CURR JAN"
label var enroll_status_Jan_prev	"MONTHLY ENROLLMENT - PREV JAN"
label var enroll_status_Jul_1next	"MONTHLY ENROLLMENT - NEXT JUL"
label var enroll_status_Jul_2prev	"MONTHLY ENROLLMENT - 2 YR PREV JUL"
label var enroll_status_Jul_3prev	"MONTHLY ENROLLMENT - 3 YR PREV JUL"
label var enroll_status_Jul_curr	"MONTHLY ENROLLMENT - CURR JUL"
label var enroll_status_Jul_prev	"MONTHLY ENROLLMENT - PREV JUL"
label var enroll_status_Jun_1next	"MONTHLY ENROLLMENT - NEXT JUN"
label var enroll_status_Jun_2prev	"MONTHLY ENROLLMENT - 2 YR PREV JUN"
label var enroll_status_Jun_3prev	"MONTHLY ENROLLMENT - 3 YR PREV JUN"
label var enroll_status_Jun_curr	"MONTHLY ENROLLMENT - CURR JUN"
label var enroll_status_Jun_prev	"MONTHLY ENROLLMENT - PREV JUN"
label var enroll_status_Mar_1next	"MONTHLY ENROLLMENT - NEXT MAR"
label var enroll_status_Mar_2prev	"MONTHLY ENROLLMENT - 2 YR PREV MAR"
label var enroll_status_Mar_3prev	"MONTHLY ENROLLMENT - 3 YR PREV MAR"
label var enroll_status_Mar_curr	"MONTHLY ENROLLMENT - CURR MAR"
label var enroll_status_Mar_prev	"MONTHLY ENROLLMENT - PREV MAR"
label var enroll_status_May_1next	"MONTHLY ENROLLMENT - NEXT MAY"
label var enroll_status_May_2prev	"MONTHLY ENROLLMENT - 2 YR PREV MAY"
label var enroll_status_May_3prev	"MONTHLY ENROLLMENT - 3 YR PREV MAY"
label var enroll_status_May_curr	"MONTHLY ENROLLMENT - CURR MAY"
label var enroll_status_May_prev	"MONTHLY ENROLLMENT - PREV MAY"
label var enroll_status_Nov_1next	"MONTHLY ENROLLMENT - NEXT NOV"
label var enroll_status_Nov_2prev	"MONTHLY ENROLLMENT - 2 YR PREV NOV"
label var enroll_status_Nov_3prev	"MONTHLY ENROLLMENT - 3 YR PREV NOV"
label var enroll_status_Nov_curr	"MONTHLY ENROLLMENT - CURR NOV"
label var enroll_status_Nov_prev	"MONTHLY ENROLLMENT - PREV NOV"
label var enroll_status_Oct_1next	"MONTHLY ENROLLMENT - NEXT OCT"
label var enroll_status_Oct_2prev	"MONTHLY ENROLLMENT - 2 YR PREV OCT"
label var enroll_status_Oct_3prev	"MONTHLY ENROLLMENT - 3 YR PREV OCT"
label var enroll_status_Oct_curr	"MONTHLY ENROLLMENT - CURR OCT"
label var enroll_status_Oct_prev	"MONTHLY ENROLLMENT - PREV OCT"
label var enroll_status_Sep_1next	"MONTHLY ENROLLMENT - NEXT SEP"
label var enroll_status_Sep_2prev	"MONTHLY ENROLLMENT - 2 YR PREV SEP"
label var enroll_status_Sep_3prev	"MONTHLY ENROLLMENT - 3 YR PREV SEP"
label var enroll_status_Sep_curr	"MONTHLY ENROLLMENT - CURR SEP"
label var enroll_status_Sep_prev	"MONTHLY ENROLLMENT - PREV SEP"
label var enroll_status_svy        "ENROLLMT STAT - REV (AS OF MAY 1)"
label var grade_current            "GRD ATTENDING"
label var high_deg_recd            "HIGHEST DGR RCVD"
label var high_grade_attend        "HIGHEST GRD ATND"
label var high_grade_comp_May      "HIGHEST GRADE COMPLETED (AS OF MAY 1)"
label var high_grade_comp_raw      "HIGHEST GRADE COMPLETED (SURVEY DATE)"
label var interview_mo             "INTERVIEW MONTH"
label var recd_1degree_mo          "MONTH RCVD 1ST COLLEGE DEGREE"
label var recd_1degree_yr          "YEAR RCVD 1ST COLLEGE DEGREE"
label var recd_2degree_mo          "MONTH RCVD 2ND COLLEGE DEGREE"
label var recd_2degree_yr          "YEAR RCVD 2ND COLLEGE DEGREE"
label var recd_3degree_mo          "MONTH RCVD 3RD COLLEGE DEGREE"
label var recd_3degree_yr          "YEAR RCVD 3RD COLLEGE DEGREE"
label var recd_4degree_mo          "MONTH RCVD 4TH COLLEGE DEGREE"
label var recd_4degree_yr          "YEAR RCVD 4TH COLLEGE DEGREE"
label var recd_diploma_mo          "MONTH RCVD HS DPLMA/GED"
label var recd_diploma_yr          "YR RCVD INC HS DPLMA/GED"
label var recd_high_deg_mo         "MONTH RCVD HIGHEST DGR"
label var recd_high_deg_yr         "YR R COMPLETED HIGHEST DGR"
label var type_1degree_recd        "DEGREE TYPE OF 1ST COLLEGE DEGREE"
label var type_2degree_recd        "DEGREE TYPE OF 2ND COLLEGE DEGREE"
label var type_3degree_recd        "DEGREE TYPE OF 3RD COLLEGE DEGREE"
label var type_4degree_recd        "DEGREE TYPE OF 4TH COLLEGE DEGREE"

* label define vl_race   1 "HISPANIC"  2 "BLACK"  3 "NON-BLACK, NON-HISPANIC" // prev defined
label values race_screen vl_race

* label define vl_sex   1 "MALE"  2 "FEMALE" // prev defined
label values sex vl_sex

* label define vl_grade   0 "NONE"  1 "1ST GRADE"  2 "2ND GRADE"  3 "3RD GRADE"  4 "4TH GRADE"  5 "5TH GRADE"  6 "6TH GRADE"  7 "7TH GRADE"  8 "8TH GRADE"  9 "9TH GRADE"  10 "10TH GRADE"  11 "11TH GRADE"  12 "12TH GRADE"  13 "1ST YR COL"  14 "2ND YR COL"  15 "3RD YR COL"  16 "4TH YR COL"  17 "5TH YR COL"  18 "6TH YR COL"  19 "7TH YR COL"  20 "8TH YR COL OR MORE"  95 "UNGRADED" // prev defined
label values grade_current       vl_grade
label values high_grade_attend   vl_grade
label values high_grade_comp_May vl_grade
label values high_grade_comp_raw vl_grade

label define vl_diploma  1 "HIGH SCHOOL DIPLOMA"  2 "GED"  3 "BOTH"
label values diploma_or_ged

label define vl_enroll_status  1 "NOT ENROLLED, COMPLETED LESS THAN 12TH GRADE"  2 "ENROLLED IN HIGH SCHOOL"  3 "ENROLLED IN COLLEGE"  4 "NOT ENROLLED, HIGH SCHOOL GRADUATE"
label values enroll_status_svy vl_enroll_status

* Bring together degree data
label define vl_degree_long   1 "HIGH SCHOOL DIPLOMA (OR EQUIVALENT)"  2 "ASSOCIATE/JUNIOR COLLEGE (AA)"  3 "BACHELOR'S DEGREE/BACHELOR OF ARTS DEGREE (BA)"  4 "BACHELOR OF SCIENCE (BS)"  5 "MASTER'S DEGREE (MA,MBA,MS,MSW)"  6 "DOCTORAL DEGREE (PHD)"  7 "PROFESSIONAL DEGREE (MD,LLD,DDS)"  8 "OTHER"
* label define vl_degree_short  1 "ASSOCIATE'S DEGREE"  2 "BACHELOR'S DEGREE"  3 "MASTER'S DEGREE"  4 "OTHER"
recode type_*degree_recd (4/290 = 8) (3 = 5) (2 = 3) (1 = 2)
label values high_deg_recd     vl_degree_long
label values type_1degree_recd vl_degree_long
label values type_2degree_recd vl_degree_long
label values type_3degree_recd vl_degree_long
label values type_4degree_recd vl_degree_long
