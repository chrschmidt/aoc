#!/usr/bin/env -S /bin/sh -c "exec awk -f ../../aoclib.awk -f ${_} input.txt"

{
    patsplit($0,m,/mul\([0-9]+,[0-9]+\)|do(n't)?\(\)/)
    for (i=1;i<=length(m);i++) {
        switch (m[i]) {
        case "do()": disabled=0; break
        case "don't()": disabled=1; break
        default:
            match(m[i],/([0-9]+),([0-9]+)/,n)
            part1+=n[1]*n[2]
            if (!disabled)
                part2+=n[1]*n[2]
        }
    }
}

END {
    print "Part 1: " part1
    print "Part 2: " part2
}
