#!/usr/bin/env -S /bin/sh -c "exec awk -f ../../aoclib.awk -f ${_} input.txt"

function opinc(i) {
    for (i=3;i<=NF;i++)
        if (opers[i]==2) {
            opers[i]=0
        } else {
            opers[i]=opers[i]+1
            return 1
        }
    return 0
}
    
{
    cal=substr($1,1,length($1)-1)
    for (i=3;i<=NF;i++)
        opers[i]=0
    do {
        res=$2
        p2=0
        for (j=3;j<=NF;j++)
            switch (opers[j]) {
            case 0: res+=$j; break
            case 1: res*=$j; break
            case 2: res=res $j; p2=1
            }
        if (cal==res) {
            part2+=res
            if (!p2)
                part1+=res
            next
        }
    } while (opinc())
}

END {
    print "Part 1: " part1
    print "Part 2: " part2
}
