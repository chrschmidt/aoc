#!/usr/bin/env -S /bin/sh -c "exec awk -f ${_} -f ../../aoclib.awk input.txt"

BEGIN { lagoon[0][0]="S"; x=0; y=0; last="S"; PROCINFO["sorted_in"]="@ind_num_asc" }

function dump(x,y,minx,maxx) {
    minx=1000000; maxx=-1000000
    for (y in lagoon)
        for (x in lagoon[y]) {
            if (int(x)<minx) minx=int(x)
            if (int(x)>maxx) maxx=int(x)
        }
    for (y in lagoon) {
        printf "%5d: ", y
        for (x=minx;x<=maxx;x++)
            if (x in lagoon[y])
                printf lagoon[y][x]
            else
                printf "."
        printf "\n"
    }
    printf "\n"
}

{
#    printf $0
    dy=0
    switch ($1) {
    case "R":
        if (last=="U") lagoon[y][x]="F"
        else if (last=="D") lagoon[y][x]="L"
        else if (last!="S") { print "ERROR: " last "->" $1; exit }
        x+=$2
        break
    case "L":
        if (last=="U") lagoon[y][x]="7"
        else if (last=="D") lagoon[y][x]="J"
        else if (last!="S") { print "ERROR: " last "->" $1; exit }
        x-=$2
        break
    case "U":
        if (last=="R") lagoon[y][x]="J"
        else if (last=="L") lagoon[y][x]="L"
        else if (last!="S") { print "ERROR: " last "->" $1; exit }
        dy=-1
        break
    case "D":
        if (last=="R") lagoon[y][x]="7"
        else if (last=="L") lagoon[y][x]="F"
        else if (last!="S") { print "ERROR: " last "->" $1; exit }
        dy=1
    }
    if (dy) {
        do {
            y+=dy
            lagoon[y][x]="|"
            $2--
        } while ($2)
    }
    if (!first) first=$1
    last=$1
}

function start() {
    if (first=="R" || last=="L") c0=1
    if (first=="D" || last=="U") c1=1
    if (first=="L" || last=="R") c2=1
    if (first=="U" || last=="D") c3=1
    if      (c0&&c1&&!c2&&!c3) lagoon[0][0]="F"
#    else if (c0&&!c1&&c2&&!c3) lagoon[0][0]="-"
    else if (c0&&!c1&&!c2&&c3) lagoon[0][0]="L"
    else if (!c0&&c1&&c2&&!c3) lagoon[0][0]="7"
    else if (!c0&&c1&&!c2&&c3) lagoon[0][0]="|"
    else if (!c0&&!c1&&c2&&c3) lagoon[0][0]="J"
    else printf "ERROR: %d,%d,%d,%d\n", c0, c1, c2, c3
}
        

function space(x,y,a,v,open) {
    dump()
    for (y in lagoon) {
        printf "%5d (%3d):", y, length(lagoon[y])
        for (x in lagoon[y]) {
            printf " %c@%d", lagoon[y][x], x
            switch (c=lagoon[y][x]) {
            case "|":
            case "F":
            case "L":
                if (inside) {
                    printf " A: " x-lastx-1
                    v+=x-lastx-1
                }
                if (c=="|") {
                    inside=!inside
                } else {
                    open=c
                }
                break
            case "7":
                printf " A: " x-lastx-1
                v+=x-lastx-1
                if (open=="L")
                    inside=!inside
                break
            case "J":
                printf " A: " x-lastx-1
                v+=x-lastx-1
                if (open=="F")
                    inside=!inside
            }
            v++
            lastx=x
        }
        if (inside) {
            print "ERROR: line " y " ended inside"
            exit
        }
        printf " Total: %d\n", v
    }
    return v
}

END {
    start()
    print "Part 1: " space()
#    print "Part 1: " length(energized)
#    print "Part 2: " part2
}
