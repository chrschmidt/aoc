#!/usr/bin/env -S /bin/sh -c "exec awk -f ${_} input.txt"

function abs(a) { return a<0?-a:a }

function cycle() {
    if (abs(cycles%40-X-1)<2) printf "#"
    else                      printf " "
    if (++cycles%40==0)       printf "\n"
}

{ cycle(); if ($2) { cycle(); X+=$2 } }
