#!/usr/bin/env -S /bin/sh -c "exec awk -f ${_} -f ../../aoclib.awk input.txt"

{ split($1,world[NR],"") }

function dump(y,x) {
    for (y in world) {
        for (x in world[y])
            printf world[y][x]
        printf "\n"
    }
    printf "\n"
}

function slide_north() {
    for (y=2;y<=NR;y++) {
        for (x in world[NR])
            if (world[y][x]=="O") {
                if (world[y-1][x]==".") {
                    for (y2=y;y2>1&&world[y2-1][x]==".";y2--) ;
                    world[y2][x]="O"
                    world[y][x]="."
                }
            }
    }
}

function load_total() {
    for (y in world) {
        for (x in world) {
            if (world[y][x]=="O")
                part1+=NR-y+1
        }
    }
}

END {
    dump()
    slide_north()
    dump()
    load_total()
    print "Part 1: " part1
    print "Part 2: " part2
}
