#!/usr/bin/env -S gawk -f ${_} -- input.txt

($2 == "->") {
    split($1,a,",")
    split($3,b,",")
    if (a[1] == b[1])
        if (a[2] <= b[2]) for (i=a[2]; i<=b[2]; i++) map[a[1], i]++
        else              for (i=b[2]; i<=a[2]; i++) map[a[1], i]++
    else if (a[2] == b[2])
        if (a[1] <= b[1]) for (i=a[1]; i<=b[1]; i++) map[i, a[2]]++
        else              for (i=b[1]; i<=a[1]; i++) map[i, a[2]]++
}

END {
    for (point in map) if (map[point]>1) points++;
    print "result: " points
}
