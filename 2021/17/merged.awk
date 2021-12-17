#!/usr/bin/env -S awk -f ${_} -- input.txt
(FNR < NR) { exit }

{
    split(gensub(/[^-0-9]+/, " ", "g", $3), xa, " ")
    split(gensub(/[^-0-9]+/, " ", "g", $4), ya, " ")

    for (sxvel=1; sxvel<=xa[2]; sxvel++) {
        if (sxvel*(sxvel+1)/2 < xa[1])
            continue
        for (steps=1; steps<=sxvel; steps++) {
            x = steps * (sxvel - (steps-1)/2)
            if (x > xa[2])
                break
            if (x >= xa[1]) {
                for (syvel=ya[1]; syvel<=-ya[1]; syvel++) {
                    y = steps * (syvel - (steps-1)/2)
                    if (sxvel == steps)
                        for (ysteps=steps+1; y > ya[2]; ysteps++)
                            y = ysteps * (syvel - (ysteps-1)/2)
                    if (y > ya[2] || y < ya[1])
                        continue
                    ymax = syvel*(syvel+1)/2
                    if (syvel > 0 && ymax > gymax)
                        gymax = ymax
                    hits[sxvel,syvel] = 1
                }
            }
        }
    }
    print "Part 1: " gymax
    print "Part 2: " length(hits)
    exit
}
