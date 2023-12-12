#!/usr/bin/env -S /bin/sh -c "exec awk -f ${_} -f ../../aoclib.awk input.txt"

{
    split($1,line,"")
    for (i in line)
        if (line[i]=="#") {
            galaxies[galaxies[0]+1][0]=i
            galaxies[++galaxies[0]][1]=NR
            nonempty[0][i]
            nonempty[1][NR]
        }
}

function calc(empty, go,gi,sum,i,j,inc,dist) {
    for (go=1;go<galaxies[0];go++)
        for (gi=go+1;gi<=galaxies[0];gi++)
            for (i=0;i<=1;i++) {
                dist=galaxies[gi][i]-galaxies[go][i]
                if (!dist) continue
                inc=dist/abs(dist)
                for (j=galaxies[go][i];j!=galaxies[gi][i];j+=inc)
                    sum+=(i in nonempty && j in nonempty[i])?1:empty
            }
    return sum
}

END {
    print "Found " galaxies[0] " galaxies"
    print "Part 1: " calc(2)
    print "Part 2: " calc(1000000)
}
