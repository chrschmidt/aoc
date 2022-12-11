#!/usr/bin/env -S /bin/sh -c "exec awk -f ${_} -v X=1 input.txt"

function abs(a) { return a<0?-a:a }

function cycle() {
    text=text (abs(cycles%40-X)<2?"#":" ")
    if (!((++cycles+20)%40)) sum+=cycles*X
}

{ cycle(); if ($2) { cycle(); X+=$2 } }

END {
    print "Part 1: " sum
    print "Part 2:"
    for (i=1;i<length(text); i+=40) print substr(text,i,40)
}
