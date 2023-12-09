#!/usr/bin/env -S /bin/sh -c "exec awk -f ${_} -f ../../aoclib.awk input.txt"

{
    num=split($0,lines[0])
    do {
        allzeroes=1
        for (i=1;i<num;i++) {
            lines[level+1][i]=lines[level][i+1]-lines[level][i]
            if (lines[level+1][i]!=0)
                allzeroes=0
        }
       level++
       num--
    } while (!allzeroes)

    lines[level][++num]=0
    lines[level][0]=0
    for (;level;level--) {
        lines[level-1][num+1]=lines[level-1][num]+lines[level][num]
        lines[level-1][0]=lines[level-1][1]-lines[level][0]
        num++
    }
    part1+=lines[0][num]
    part2+=lines[0][0]
}

END {
    print "Part 1: " part1
    print "Part 2: " part2
}
