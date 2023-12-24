#!/usr/bin/env -S /bin/sh -c "exec awk -f ${_} -f ../../aoclib.awk input.txt"

{
    lx=split($1,world[NR],"")
    if (NR==1) sx=index($1,".")
}

function solve1(x,y,sum, tmp) {
    tmp=world[y][x]
    world[y][x]="O"
    if (y==NR) {
        solutions[sum+1]
    } else {
        if (world[y][x+1]~/[.>]/) solve1(x+1,y,sum+1)
        if (world[y][x-1]~/[.<]/) solve1(x-1,y,sum+1)
        if (world[y+1][x]~/[.v]/) solve1(x,y+1,sum+1)
        if (world[y-1][x]~/[.^]/) solve1(x,y-1,sum+1)
    }
    world[y][x]=tmp
}

function enq(x,y,sum)

function solve2(x,y,sum, tmp) {
    tmp=world[y][x]
    world[y][x]="#"
    if (y==NR) {
        solutions[sum+1]
    } else {
        if (world[y][x+1]!="#") solve2(x+1,y,sum+1)
        if (world[y][x-1]!="#") solve2(x-1,y,sum+1)
        if (world[y+1][x]!="#") solve2(x,y+1,sum+1)
        if (world[y-1][x]!="#") solve2(x,y-1,sum+1)
    }
    world[y][x]=tmp
}  

END {
    world[1][sx]="#"
    solve1(sx,2,0)
    asorti(solutions,solutions,"@ind_num_desc")
    print "Part 1: " solutions[1]
    delete solutions
    solve2(sx,2,0)
    asorti(solutions,solutions,"@ind_num_desc")
    print "Part 2: " solutions[1]
}
