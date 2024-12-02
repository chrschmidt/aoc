#!/usr/bin/env -S /bin/sh -c "exec awk -f ../../aoclib.awk -f ${_} input.txt"

function check(inp, a,l,s,i) {
    l=split(inp,a)
    s=sign(a[1]-a[2])
    for (i=1; i<l; i++) {
        if (a[i]==a[i+1]) return 0
        if (abs(a[i]-a[i+1])>3) return 0
        if (sign(a[i]-a[i+1])!=s) return 0
    }
    return 1
}

{
    part1+=check($0)
    for (i=1; i<=NF; i++) {
        tmp=$i
        $i=""
        if (check($0)) {
            part2++
            next
        }
        $i=tmp
    }
}

END {
    print "Part 1: " part1
    print "Part 2: " part2
}
