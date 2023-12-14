#!/usr/bin/env -S /bin/sh -c "exec awk -f ${_} -f ../../aoclib.awk input.txt"

{ split($1,world[NR],"") }

function slide_north(x,y,y2) {
    for (y=2;y<=NR;y++)
        for (x in world[1])
            if (world[y][x]=="O" && world[y-1][x]==".") {
                for (y2=y;y2>1&&world[y2-1][x]==".";y2--) ;
                world[y2][x]="O"
                world[y][x]="."
            }
}

function slide_west(x,x2,y) {
    for (x=2;x<=length(world[1]);x++)
        for (y in world)
            if (world[y][x]=="O" && world[y][x-1]==".") {
                for (x2=x;x2>1&&world[y][x2-1]==".";x2--) ;
                world[y][x2]="O"
                world[y][x]="."
            }
}

function slide_south(x,y,y2) {
    for (y=NR-1;y;y--)
        for (x in world[1])
            if (world[y][x]=="O" && world[y+1][x]==".") {
                for (y2=y;y2<NR&&world[y2+1][x]==".";y2++) ;
                world[y2][x]="O"
                world[y][x]="."
            }
}

function slide_east(x,x2,y) {
    for (x=length(world[1])-1;x;x--)
        for (y in world)
            if (world[y][x]=="O" && world[y][x+1]==".") {
                for (x2=x;x2<length(world[1])&&world[y][x2+1]==".";x2++) ;
                world[y][x2]="O"
                world[y][x]="."
            }
}

function mkworldstr(x,y,str) {
    for (y in world)
        for (x in world[y])
            str=str world[y][x]
    return str
}

function load_total(str, l,w,x,y,sum) {
    l=split(str,w,"")/length(world)
    for (y in world)
        for (x in world[y])
            if (w[(y-1)*l+x]=="O")
                sum+=NR-y+1
    return sum
}

function cycle(n, str) {
    if (n)
        slide_north()
    slide_west()
    slide_south()
    slide_east()
    str=mkworldstr()
    cycles++
    if (str in cache)
        return str
    cache[str]=cycles
    rcache[cycles]=str
    return 0
}

END {
    slide_north()
    part1=load_total(mkworldstr())
    cycle(0)
    while (!(worldstr=cycle(1))) ;
    worldnum=(1000000000-cache[worldstr])%(cycles-cache[worldstr])+cache[worldstr]
    part2=load_total(rcache[worldnum])
    print "Part 1: " part1
    print "Part 2: " part2
}
