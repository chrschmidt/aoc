#!/usr/bin/env -S awk -f ${_} -- input.txt

function abs(a) { if (a<0) return -a; else return a }

{
    split($1,crabs,",")
    min=crabs[1]
    for (c in crabs) {
        if (max<crabs[c]) max = crabs[c]
        if (min>crabs[c]) min = crabs[c]
        horiz[crabs[c]]++
    }

    minpos = -1;
    for (pos=min; pos<=max; pos++) {
        fuel = 0
        for (h in horiz)
            fuel += horiz[h] * abs(int(h)-pos)
        if (minpos==-1 || fuel < minfuel) {
            minpos = pos
            minfuel = fuel
        }
    }
    print minfuel " @ " minpos
    exit
}
