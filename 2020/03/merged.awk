#!/usr/bin/env -S awk -f ${_} -- input.txt
(FNR < NR) { exit }

{ map[FNR] = $1 }

function slope(sx,sy,  x, y, trees) {
    for (y=1; y<=NR; y+=sy) {
        if (substr(map[y], (x%maplen)+1, 1) == "#")
            trees++
        x+=sx
    }
    return trees
}

END {
    maplen=length(map[1])
    slope31=slope(3,1)
    print "Part 1: " slope31
    print "Part 2: " slope31 * slope(1,1) * slope(5,1) * slope(7,1) * slope(1,2)
}