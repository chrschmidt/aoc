#!/usr/bin/env -S /bin/sh -c "exec awk -f ../../aoclib.awk -f ${_} input.txt"

{
    l=split($0,a,"")
    for (i=1;i<=l;i++)
        if (a[i]!=".")
            antennas[a[i]][i,FNR]
}

function add1(x,y) {
    if (x>0 && x<=l && y>0 && y<=FNR)
        antinodes1[x,y]
}

function add2(x,y) {
    if (x>0 && x<=l && y>0 && y<=FNR) {
        antinodes2[x,y]
        return 1
    }
    return 0
}

END {
    for (i in antennas)
        for (j in antennas[i]) {
            split (j,a1,SUBSEP)
            for (k in antennas[i])
                if (j!=k) {
                    split(k,a2,SUBSEP)
                    dx=a2[1]-a1[1]
                    dy=a2[2]-a1[2]
                    add1(a1[1]-dx,a1[2]-dy)
                    add1(a2[1]+dx,a2[2]+dy)
                    x=a1[1]; y=a1[2]
                    while (add2(x,y)) { x-=dx; y-=dy }
                    x=a2[1]; y=a2[2]
                    while (add2(x,y)) { x+=dx; y+=dy }
                }
        }
    print "Part 1: " length(antinodes1)
    print "Part 2: " length(antinodes2)
}
