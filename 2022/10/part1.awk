#!/usr/bin/env -S /bin/sh -c "exec awk -f ${_} input.txt"

BEGIN { X=1; icyc[20]; icyc[60]; icyc[100]; icyc[140]; icyc[180]; icyc[220] }

function cycle() { if (++cycles in icyc) sum+=cycles*X }

/addx/ { cycle(); cycle(); X+=$2 }
/noop/ { cycle() }

END {
    print "Part 1: " sum
}
