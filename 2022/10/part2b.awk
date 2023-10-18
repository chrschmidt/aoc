#!/usr/bin/env -S /bin/sh -c "exec awk -v X=1 -f ${_} input.txt"

function abs(a) { return a<0?-a:a }

function cycle() {
    printf (abs(cycles%40-X)<2)?"#":" "
    if (!(++cycles%40)) printf "\n"
}

{ cycle(); if ($2) { cycle(); X+=$2 } }
