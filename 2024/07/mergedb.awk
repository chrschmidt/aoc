#!/usr/bin/env -S /bin/sh -c "exec awk -f ../../aoclib.awk -f ${_} input.txt"

{
    cal=substr($1,1,length($1)-1)
    top=3^(NF-2)
    for (i=0;i<top;i++) {
        res=$2
        opers=i
        p2=0
        for (j=3;j<=NF;j++) {
            switch (int(opers%3)) {
            case 0: res+=$j; break
            case 1: res*=$j; break
            case 2: res=res $j; p2=1
            }
            opers=int(opers/3)
        }
        if (cal==res) {
            part2+=res
            if (!p2)
                part1+=res
            next
        }
    }
}

END {
    print "Part 1: " part1
    print "Part 2: " part2
}
