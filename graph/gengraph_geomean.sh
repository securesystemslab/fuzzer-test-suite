#!/usr/bin/awk -f

# Count number of files: increment on the first line of each new file
FNR == 1 { ++nfiles }

{
    # (Pseudo) 2D array summing up fields across files
    for (i = 1; i <= NF; ++i) {
        if(values[FNR, i] == 0)
            values[FNR, i] = 1
        values[FNR, i] = values[FNR,i] * $i
    }
    ++nfiles_per_rec[FNR]
}

END {
    # Loop over lines of array with sums
    for (i = 1; i <= FNR; ++i) {

        # Loop over fields of current line in array of sums
        for (j = 1; j <= NF; ++j) {

            # Build record with geomeans
            $j = values[i, j] ** (1.0/nfiles_per_rec[i])
        }
        print
    }
}
