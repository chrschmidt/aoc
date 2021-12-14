#!/usr/bin/env -S awk -F- -f ${_} -- input.txt
(FNR < NR) { exit }

{ connections[$1][$2] = 1; connections[$2][$1] = 1 }

function enter(cave, i) {
    if (tolower(cave) == cave)
        blocked[cave] = 1
    for (i in connections[cave])
        if (i == "end") paths++
        else if (toupper(i) == i) enter(i)
        else if (!blocked[i]) enter(i)
    blocked[cave] = 0
}

END {
    enter("start")
    print "Part 1: " paths
}
