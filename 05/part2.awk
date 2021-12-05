#!/usr/bin/env -S gawk -f ${_} -- input.txt

function max(a,b) { if (a<b) return b; else return a }
function abs(a) { if (a<0) return -a; else return a }

($2 == "->") {
    split($1,a,",")
    split($3,b,",")
    if (a[1] == b[1]) xinc = 0; else if (a[1] < b[1]) xinc = 1; else xinc = -1
    if (a[2] == b[2]) yinc = 0; else if (a[2] < b[2]) yinc = 1; else yinc = -1
    len = max(abs(a[1]-b[1]), abs(a[2]-b[2]))
    x=a[1]; y=a[2]
    for (i=0; i<=len; i++) {
        map[x,y]++
        x+=xinc; y+=yinc
    }
}

END {
    for (point in map) if (map[point]>1) points++;
    print "result: " points
}
