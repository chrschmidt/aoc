#!/usr/bin/env -S /bin/sh -c "exec awk -f ${_} -f ../../aoclib.awk input.txt"

BEGIN {
    PROCINFO["sorted_in"]="@ind_num_asc"
    xlate["0"]="R"; xlate["1"]="D"; xlate["2"]="L"; xlate["3"]="U"
}

{
    $1=xlate[substr($3,8,1)]
    $2=strtonum("0x" substr($3,3,5))
    switch ($1) {
    case "R":
        if (last=="U") lagoon[y][x]="F"
        else if (last=="D") lagoon[y][x]="L"
        x+=$2
        break
    case "L":
        if (last=="U") lagoon[y][x]="7"
        else if (last=="D") lagoon[y][x]="J"
        x-=$2
        break
    case "U":
        if (last=="R") lagoon[y][x]="J"
        else if (last=="L") lagoon[y][x]="L"
        y-=$2
        break
    case "D":
        if (last=="R") lagoon[y][x]="7"
        else if (last=="L") lagoon[y][x]="F"
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
    else if (c0&&!c1&&!c2&&c3) lagoon[0][0]="L"
    else if (!c0&&c1&&c2&&!c3) lagoon[0][0]="7"
    else if (!c0&&!c1&&c2&&c3) lagoon[0][0]="J"
}

function linespace(line,v,lastx,x,c,open) {
    for (x in line) {
        switch (c=line[x]) {
        case "|":
        case "F":
        case "L":
            if (inside)
                v+=x-lastx-1
            if (c=="|")
                inside=!inside
            break
        case "7":
        case "J":
            v+=x-lastx-1
            if ((open=="L"&&c=="7")||(open=="F"&&c=="J"))
                inside=!inside
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
    lines=asorti(lagoon,a,"@ind_num_asc")
    v=linespace(lagoon[a[1]])
    for (y=2;y<=lines;y++) {
        v+=(a[y]-a[y-1]-1)*linespace(interpline)
        for (x in interpline)
            if (!(x in lagoon[a[y]]))
                lagoon[a[y]][x]="|"
        delete interpline
        v+=linespace(lagoon[a[y]])
    }
    return v
}

END {
    start()
    print "Part 2: " space()
}
