// NJC 1.0.0 17 November 2006
// matrix row_or_column rename
program matrcrename
        version 14
        // syntax matrixname row_or_col which_row_or_col new_name

        // matrix name
        gettoken matrix 0 : 0
        confirm matrix `matrix'

        // row or column
        gettoken which 0 : 0
        local length = length("`which'")
        if lower("`which'") == substr("row",1,`length') {
                local which row
        }
        else if lower("`which'") == substr("column",1,`length') {
                local which col
        }
        else {
                di as err "second argument should specify row or column"
                exit 198
        }

        // which row or column
        gettoken where newname : 0
        if "`which'" == "row" {
                capture local found = inrange(`where', 1, rowsof(`matrix'))
                if _rc {
                        di as err "inappropriate row number?"
                        exit 498
                }
                if !`found' {
                        di as err "row out of range"
                        exit 498
                }
        }
        else {
                capture local found = inrange(`where', 1, colsof(`matrix'))
                if _rc {
                        di as err "inappropriate column number?"
                        exit 498
                }
                if !`found' {
                        di as err "column out of range"
                        exit 498
                }
        }

        // test newname
        tempname moo
        matrix `moo' = J(1,1,1)
        capture matrix rownames `moo' = `newname'
        if _rc {
                local what = cond("`which'" == "col", "column", "row")
                di as err "inappropriate `what' name?"
                exit 498
        }

        // in business!
        local names : `which'names `matrix'
        tokenize `names'
        local `where' `newname'
        local newnames "`*'"
        matrix `which'names `matrix' = `newnames'
end
