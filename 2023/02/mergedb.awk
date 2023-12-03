#!/usr/bin/env -S /bin/sh -c "exec awk -f ${_} input.txt"

{
    possible=1
    mr=mg=mb=0
    gsub(/[;,]/, "")
    for (i=3;i<NF;i+=2)
        switch ($(i+1)) {
            case "red":   if ($i>12) possible=0; if ($i>mr) mr=$i; break
            case "green": if ($i>13) possible=0; if ($i>mg) mg=$i; break
            case "blue":  if ($i>14) possible=0; if ($i>mb) mb=$i; break
        }
    sum+=possible*FNR
    powersum+=mr*mg*mb
}

END {
    print "Part 1: " sum
    print "Part 2: " powersum
}
