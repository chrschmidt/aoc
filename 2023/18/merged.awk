#!/usr/bin/env -S /bin/sh -c "exec awk -f ${_} -f ../../aoclib.awk input.txt"

BEGIN {
    PROCINFO["sorted_in"]="@ind_num_asc"
    lagoon1["x"]=0; lagoon1["y"]=0
    lagoon2["x"]=0; lagoon2["y"]=0
    xlate["0"]="R"; xlate["1"]="D"; xlate["2"]="L"; xlate["3"]="U"
}

function add(lagoon,c,l,last) {
    switch (c) {
    case "R":
        if (last=="U") lagoon[lagoon["y"]][lagoon["x"]]="F"
        else if (last=="D") lagoon[lagoon["y"]][lagoon["x"]]="L"
        lagoon["x"]+=l
        break
    case "L":
        if (last=="U") lagoon[lagoon["y"]][lagoon["x"]]="7"
        else if (last=="D") lagoon[lagoon["y"]][lagoon["x"]]="J"
        lagoon["x"]-=l
        break
    case "U":
        if (last=="R") lagoon[lagoon["y"]][lagoon["x"]]="J"
        else if (last=="L") lagoon[lagoon["y"]][lagoon["x"]]="L"
        lagoon["y"]-=l
        break
    case "D":
        if (last=="R") lagoon[lagoon["y"]][lagoon["x"]]="7"
        else if (last=="L") lagoon[lagoon["y"]][lagoon["x"]]="F"
        lagoon["y"]+=l
    }
}

{
    add(lagoon1,$1,$2,last1)
    if (!first1) first1=$1
    last1=$1
    $1=xlate[substr($3,8,1)]
    $2=strtonum("0x" substr($3,3,5))
    add(lagoon2,$1,$2,last2)
    if (!first2) first2=$1
    last2=$1
}

function start(lagoon,first,last) {
    if (first=="R" || last=="L") c0=1
    if (first=="D" || last=="U") c1=1
    if (first=="L" || last=="R") c2=1
    if (first=="U" || last=="D") c3=1
    if      (c0&&c1&&!c2&&!c3) lagoon[0][0]="F"
    else if (c0&&!c1&&!c2&&c3) lagoon[0][0]="L"
    else if (!c0&&c1&&c2&&!c3) lagoon[0][0]="7"
    else if (!c0&&!c1&&c2&&c3) lagoon[0][0]="J"
    delete lagoon["x"]
    delete lagoon["y"]
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

function space(lagoon,x,y,a,v,open,lines) {
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
    start(lagoon1,first1,last1)
    print "Part 1: " space(lagoon1)
    start(lagoon2,first2,last2)
    print "Part 2: " space(lagoon2)
}
