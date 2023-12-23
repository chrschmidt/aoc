#!/usr/bin/env -S /bin/sh -c "exec awk -f ${_} -f ../../aoclib.awk input.txt"

{
    xl=split($1,world[NR],"")
    if (!startx && (startx=index($1,"S")))
        starty=NR
}

function test(x,y,s) {
    if (x==0 || x>xl || y==0 || y>NR || x in newworld[y])
        return 0
    newworld[y][x]=s+1
    return 1
}

function step(s, x,y,sum) {
    for (y in newworld) {
        y=int(y)
        for (x in newworld[y]) {
            x=int(x)
             if (newworld[y][x]==s) {
                 sum+=test(x-1,y,s)
                 sum+=test(x+1,y,s)
                 sum+=test(x,y-1,s)
                 sum+=test(x,y+1,s)
             }
        }
    }
}

function count(odd, x,y,sum) {
    for (y in newworld)
        for (x in newworld[y])
            if (newworld[y][x]%2==odd)
                sum++
    return sum
}

END {
    for (y in world)
        for (x in world[y])
            if (world[y][x]=="#")
                newworld[y][x]=-1
    newworld[starty][startx]=0

    for (i=0;i<64;i++)
        step(i)
    print "Part 1: " count(0)

    for (;i<2*NR;i++)
        step(i)

    print "odd: " count(1) " even: " count(0)
#    print "Part 2: " part2
}
