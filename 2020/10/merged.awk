#!/usr/bin/env -S awk -f ${_} -- input.txt
(FNR < NR) { exit }

{ jolts[FNR] = $1 }

END {
    asort(jolts,jolts,"@val_num_asc")
    jolts[0]=0
    jolts[NR]=jolts[NR-1]+3
    for (i=0; i<NR; i++)
        diffs[jolts[i+1]-jolts[i]]++
    print "Part 1: " diffs[1]*diffs[3]

    arrangements[NR] = 1
    for (i=NR-1; i>=0; i--)
        for (j=i+1; j<=i+3 && j<=NR; j++)
            if (jolts[j] - jolts[i] <=3)
                arrangements[i] += arrangements[j]
    print "Part 2: " arrangements[0]
}
