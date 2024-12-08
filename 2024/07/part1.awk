#!/usr/bin/env -S /bin/sh -c "exec awk -f ../../aoclib.awk -f ${_} input.txt"

{
    cal=substr($1,1,length($1)-1)
    for (i=0;i<lshift(1,NF-2);i++) {
        res=$2
        for (j=3;j<=NF;j++)
            if (and(i,lshift(1,j-3)))
                res*=$j
            else
                res+=$j
        if (res==cal) {
            part1+=cal
            next
        }
    }
}

END {
    print "Part 1: " part1
}
