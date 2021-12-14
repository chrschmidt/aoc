#!/usr/bin/env -S awk -F- -f ${_} -- input.txt
(FNR < NR) { exit }

{ connections[$1][$2] = 1; connections[$2][$1] = 1 }

function enter(cave, i) {
    if (tolower(cave) == cave)
        blocked[cave]++
    for (i in connections[cave])
        if (i == "start") continue
        else if (i == "end") paths++
        else if (toupper(i) == i) enter(i)
        else if (!blocked[i]) enter(i)
        else if (!twice) { twice = 1; enter(i) }
    if (twice && blocked[cave] == 2) {
        twice = 0
        blocked[cave] = 1
    } else {
        blocked[cave] = 0
    }
}

END {
    enter("start")
    print "Part 2: " paths
}
