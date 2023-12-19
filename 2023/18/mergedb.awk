#!/usr/bin/env -S /bin/sh -c "exec awk -f ${_} -f ../../aoclib.awk input.txt"

BEGIN {
    PROCINFO["sorted_in"]="@ind_num_asc"
    lagoon1["x"]=0; lagoon1["y"]=0
    lagoon2["x"]=0; lagoon2["y"]=0
    xlate["0"]="R"; xlate["1"]="D"; xlate["2"]="L"; xlate["3"]="U"
}

function add(lagoon,c,l,x,y,last) {
    x=lagoon["x"]
    y=lagoon["y"]
    last=lagoon["last"]
    switch (c) {
    case "R":
        if (last=="U") lagoon[y][x]="F"
        else if (last=="D") lagoon[y][x]="L"
        lagoon["x"]+=l
        break
    case "L":
        if (last=="U") lagoon[y][x]="7"
        else if (last=="D") lagoon[y][x]="J"
        lagoon["x"]-=l
        break
    case "U":
        if (last=="R") lagoon[y][x]="J"
        else if (last=="L") lagoon[y][x]="L"
        lagoon["y"]-=l
        break
    case "D":
        if (last=="R") lagoon[y][x]="7"
        else if (last=="L") lagoon[y][x]="F"
        lagoon["y"]+=l
    }
    if (!("first" in lagoon))
        lagoon["first"]=c
    lagoon["last"]=c
}

{
    add(lagoon1,$1,$2)
    add(lagoon2,xlate[substr($3,8,1)],strtonum("0x" substr($3,3,5)))
}

function start(lagoon,edge) {
    edge=lagoon["first"] lagoon["last"]
    if (edge~/RU|DL/) lagoon[0][0]="F"
    if (edge~/RD|UL/) lagoon[0][0]="L"
    if (edge~/LU|DR/) lagoon[0][0]="7"
    if (edge~/LD|UR/) lagoon[0][0]="J"
    delete lagoon["x"]
    delete lagoon["y"]
    delete lagoon["first"]
    delete lagoon["last"]
}

function linespace(line,v,x,c,lastx,lastc) {
    for (x in line) {
        if ((c=line[x]) ~ /[FL|]/) {
            if (inside)
                v+=x-lastx-1
            if (c=="|")
                inside=!inside
            v++
        } else {
            v+=x-lastx
            if (lastc c ~ /L7|FJ/)
                inside=!inside
        }
        if (c~/[F7|]/)
            interpline[x]="|"
        lastx=x
        lastc=c
    }
    return v
}

function space(lagoon,y,a,v) {
    asorti(lagoon,a,"@ind_num_asc")
    v=linespace(lagoon[a[1]])
    for (y=2;y<=length(a);y++) {
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
    start(lagoon1)
    print "Part 1: " space(lagoon1)
    start(lagoon2)
    print "Part 2: " space(lagoon2)
}
