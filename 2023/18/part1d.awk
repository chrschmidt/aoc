#!/usr/bin/env -S /bin/sh -c "exec awk -f ${_} -f ../../aoclib.awk demo.txt"

BEGIN { x=0; y=0; last="S"; PROCINFO["sorted_in"]="@ind_num_asc" }

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
        y-=$2
        break
    case "D":
        if (last=="R") lagoon[y][x]="7"
        else if (last=="L") lagoon[y][x]="F"
        else if (last!="S") { print "ERROR: " last "->" $1; exit }
        y+=$2
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

function linespace(line,v,x,c,open) {
    for (x in line) {    
        printf " %c@%d", line[x], x
        switch (c=line[x]) {
        case "|":
        case "F":
        case "L":
            if (inside) {
                printf " A: " x-lastx-1
                v+=x-lastx-1
            }
            if (c=="|")
                inside=!inside
            break
        case "7":
        case "J":
            printf " A: " x-lastx-1
            v+=x-lastx-1
            if ((open=="L"&&c=="7")||(open=="F"&&c=="J"))
                inside=!inside
            break
        default:
            print "ERROR: " c
            exit
        }
        if (c~/[F7|]/)
            interpline[x]="|"
        v++
        lastx=x
        open=c
    }
    return v
}

function space(x,y,a,v,open,lines) {
    dump()
    lines=asorti(lagoon,a)
    print "Have " lines " lines"
    printf "%5d (%3d):", a[1], length(lagoon[a[1]])    
    v=linespace(lagoon[a[1]])
    printf " Total: " v "\n"
    for (y=2;y<=lines;y++) {
        printf "%dx (%d):", a[y]-a[y-1]-1, length(interpline)
        v+=(a[y]-a[y-1]-1)*linespace(interpline)
        print " Total: " v
        for (x in interpline)
            if (!(x in lagoon[a[y]]))
                lagoon[a[y]][x]="|"
        delete interpline
        printf "%5d (%3d):", a[y], length(lagoon[a[y]])
        v+=linespace(lagoon[a[y]])
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
