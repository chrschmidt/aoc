#!/usr/bin/env -S awk -f ${_} -- input.txt
(FNR < NR) { exit }

BEGIN  { preamble=25 }

{ value[FNR]=$1 }

END {
    for (part1=preamble+1; part1<NR; part1++) {
        valid=0
        for (i=part1-preamble-1; i<part1-1; i++)
            for (j=i+1; j<part1; j++)
                if (value[part1]==value[i]+value[j])
                    valid=1
        if (!valid)
            break
    }
    print "Part 1: " value[part1]
    for (part2=1; part2<NR; part2++) {
        sum=value[part2]
        for (i=part2; sum<value[part1]; i++)
            sum+=value[i+1]
        if (sum==value[part1] && value[part2]!=value[part1]) {
            min=value[part2]; max=value[part2]
            for (j=part2+1; j<=i; j++) {
                if (value[j]<min) min=value[j]
                if (value[j]>max) max=value[j]
            }
            break
        }
    }
    print "Part 2: " min+max
}
