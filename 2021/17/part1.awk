#!/usr/bin/env -S awk -f ${_} -- input.txt
(FNR < NR) { exit }

{
    split(gensub(/[^-0-9]+/, " ", "g", $3), xa, " ")
    split(gensub(/[^-0-9]+/, " ", "g", $4), ya, " ")
}

END {
    for (minspeed=1; (minspeed * (minspeed + 1)) / 2 < xa[1]; minspeed++) ;
    for (sxvel=minspeed; sxvel<=xa[2]; sxvel++) {
        x = 0; xvel = sxvel
        for (steps=1; steps; steps++) {
            x += xvel; if (xvel > 0) xvel--
            if (x > xa[2])
                break
            if (x > xa[1]) {
                print "Hit the trench after " steps " steps at sxvel=" sxvel " (x=" x ", vel=" xvel ")"
                for (syvel=1; syvel<1000; syvel++) {
                    y = 0; yvel = syvel; ymax = 0
                    for (ysteps=1; ysteps<=steps; ysteps++) {
                        y += yvel; yvel--
                        if (y > ymax)
                            ymax = y
                    }
                    while (xvel == 0 && y > ya[2]) {
                        y += yvel; yvel--; ysteps++
                        if (y > ymax)
                            ymax = y
                    }
                    if (y > ya[2] || y < ya[1]) {
                        continue
                    }
                    if (ymax > gymax) {
                        print "new high of " ymax " at " sxvel "," syvel
                        gymax = ymax
                    }
                }
            }
            if (xvel == 0)
                break
        }
    }
    print "Part 1: " gymax
}
