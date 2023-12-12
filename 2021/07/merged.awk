#!/usr/bin/env -S awk -f ${_} -- input.txt

function abs(a) { if (a<0) return -a; else return a }
function sum(part, a) { return part == 1 ? a : a*(a+1)/2 }

function calc(part,  fuel) {
    minpos = -1
    for (pos=crabs[1]; pos<=crabs[length(crabs)]; pos++) {
        for (h in horiz)
            fuel[pos] += horiz[h] * sum(part, abs(h - pos))
    }
    asort(fuel)
    print "Part " part ": " fuel[1]
}

{
    split($1, crabs, ",")
    asort(crabs)
    for (c in crabs)
        horiz[crabs[c]]++
    calc(1)
    calc(2)
    exit
}
