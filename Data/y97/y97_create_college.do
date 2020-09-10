*------------------------------------------------------------------
* Make sure school info is truly missing with .n before backfilling
*------------------------------------------------------------------
forvalues x = 1/8 {
    forvalues y = 1/18 {
        disp "College `x', Term `y'"
        qui replace Major1_Coll`x'_Term`y'_ = .n if miss_interview
        qui replace Major2_Coll`x'_Term`y'_ = .n if miss_interview
    }
}

*----------------------------
* Backfill School Information
*----------------------------
gsort ID -year
forvalues x = 1/8 {
    forvalues y = 1/18 {
        by ID: replace Major1_Coll`x'_Term`y'_ = Major1_Coll`x'_Term`y'_[_n-1] if ~mi(Major1_Coll`x'_Term`y'_[_n-1]) & Major1_Coll`x'_Term`y'_[_n] ==.n 
        by ID: replace Major2_Coll`x'_Term`y'_ = Major2_Coll`x'_Term`y'_[_n-1] if ~mi(Major2_Coll`x'_Term`y'_[_n-1]) & Major2_Coll`x'_Term`y'_[_n] ==.n 
    }
}
sort ID year

*--------------------------------------------------------------------------
* Now only use the backfilled information for the actual year it applies to
*--------------------------------------------------------------------------
forvalues x = 1/8 {
    forvalues y = 1/18 {
        replace Major1_Coll`x'_Term`y'_ = . if EnrY_Coll`x'_Term`y'_~=year
        replace Major2_Coll`x'_Term`y'_ = . if EnrY_Coll`x'_Term`y'_~=year
    }
}

local months Jan Feb Mar Apr May Jun Jul Aug Sep Oct Nov Dec
foreach month of local months {
    gen Enrolled_4yr_college_`month' = inrange(College_enrollment_`month',3,3)
}
egen Months_in_4yr_college = rowtotal(Enrolled_4yr_college_Jan Enrolled_4yr_college_Feb Enrolled_4yr_college_Mar Enrolled_4yr_college_Apr Enrolled_4yr_college_May Enrolled_4yr_college_Jun Enrolled_4yr_college_Jul Enrolled_4yr_college_Aug Enrolled_4yr_college_Sep Enrolled_4yr_college_Oct Enrolled_4yr_college_Nov Enrolled_4yr_college_Dec)
gen in_4yr = Months_in_4yr_college>0 & ~mi(Months_in_4yr_college)

*-----------------------------------------------------------------------------
* Collapse the College Term specific data into one array, evaluated at October
*-----------------------------------------------------------------------------
egen    Major    = rowfirst(Major?_Coll*_Term*_)
replace Major    = . if in_4yr==0
lab val Major    vl_Majors

tab Major    if in_4yr, mi

generat scienceMajor = inlist(Major,6,7,9,11,13,21,22,25,27,29,30)
generat DKMajor      = Major==0
generat missingMajor = mi(Major)
generat otherMajor   = ~inlist(Major,6,7,9,11,13,21,22,25,27,29,30) & Major~=0 & ~mi(Major)
replace scienceMajor = . if in_4yr==0
replace DKMajor      = . if in_4yr==0
replace missingMajor = . if in_4yr==0
replace otherMajor   = . if in_4yr==0

*-----------------------------------------------------------------------------
* Create a variable for final major --- last non-missing Major for graduates
*-----------------------------------------------------------------------------
bys ID (year): egen everGrad4yr = max(grad4yr)
bys ID (year): egen finalMajorA = lastnm(Major) if everGrad4yr==1
bys ID (year): egen finalMajor  = mean(finalMajorA)
count if year==BA_year
count if finalMajorA<.
* 27 and 29 are pre-dental, pre-med. These at one point were in the science major but then the data didn't work so I'm seeing if they were causing the problem
gen finalSciMajor     = (inlist(finalMajor,6,7,9,11,13,21,22,25,27,29,30) & finalMajor<.)
