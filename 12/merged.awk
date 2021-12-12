#!/usr/bin/env -S awk -F- -f ${_} -- input.txt
(FNR < NR) { exit }

($1 != "start") { connections[$2][$1] = 1 }
($2 != "start") { connections[$1][$2] = 2 }

function enter(cave, twice,  i, paths) {
    visited[cave]++
    for (i in connections[cave])
        if (i == "end") paths++
        else if (toupper(i) == i || !visited[i]) paths += enter(i, twice)
        else if (!twice) paths += enter(i, 1)
    visited[cave]--
    return paths
}

END {
    print "Part 1: " enter("start", 1)
    print "Part 2: " enter("start", 0)
}
