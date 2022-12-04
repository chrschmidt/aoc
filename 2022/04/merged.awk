#!/usr/bin/env -S awk -F, -f ${_} -- input.txt
(FNR < NR) { exit }

{
    if (int($1) < int($2)) { split($1,l,"-"); split($2,u,"-") }
    else { split($1,u,"-"); split($2,l,"-") }

    if (l[2]>=u[2] || (l[1]==u[1] && l[2]<=u[2]))
        sum1++
    if (l[2] >= u[1])
        sum2++
}

END {
    print "Part 1: " sum1
    print "Part 2: " sum2
}
