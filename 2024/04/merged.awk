#!/usr/bin/env -S /bin/sh -c "exec awk -f ../../aoclib.awk -f ${_} input.txt"

BEGIN { word[0]="X"; word[1]="M"; word[2]="A"; word[3]="S" }

{ field[NR][0]; split($0,field[NR],"") }

function step(x,y,xi,yi,d) {
    if (field[y][x]!=word[d]) return 0
    if (d==3) return 1
    return (step(x+xi,y+yi,xi,yi,d+1))
}

function search(x,y, sum) {
    sum+=step(x,y,1,-1,0)
    sum+=step(x,y,1,0,0)
    sum+=step(x,y,1,1,0)
    sum+=step(x,y,-1,-1,0)
    sum+=step(x,y,-1,0,0)
    sum+=step(x,y,-1,1,0)
    sum+=step(x,y,0,1,0)
    sum+=step(x,y,0,-1,0)
    return sum
}

END {
    xlen=length(field[1])
    ylen=length(field)
    for (y=1;y<=ylen;y++)
        for (x=1;x<=xlen;x++)
            if (field[y][x]=="X")
                part1+=search(x,y)
            else if (field[y][x]=="A" &&
                     ((field[y-1][x-1]=="M" && field[y+1][x+1]=="S") ||
                      (field[y-1][x-1]=="S" && field[y+1][x+1]=="M")) &&
                     ((field[y-1][x+1]=="M" && field[y+1][x-1]=="S") ||
                      (field[y-1][x+1]=="S" && field[y+1][x-1]=="M")))
                part2++
    print "Part 1: " part1
    print "Part 2: " part2
}
