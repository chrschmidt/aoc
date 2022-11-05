#!/usr/bin/env -S awk -f ${_} -- input.txt
(FNR < NR) { exit }

{
    split($1, range, "-")
    letter=substr($2,1,1)
    hits=0
    for (i=1; i<=length($3); i++)
        if (substr($3,i,1)==letter)
            hits++
    if (hits >= range[1] && hits <= range[2])
        valid1++
    hits=0
    if (substr($3,range[1],1)==letter)
        hits++
    if (substr($3,range[2],1)==letter)
        hits++
    if (hits==1)
        valid2++
}

END {
    print "Part 1: " valid1
    print "Part 2: " valid2
}
