#!/usr/bin/env -S /bin/sh -c "exec awk -f ${_} -v X=1 input.txt"

function cycle() { if (!((++cycles+20)%40)) sum+=cycles*X }

{ cycle(); if ($2) { cycle(); X+=$2 } }

END { print "Part 1: " sum }
