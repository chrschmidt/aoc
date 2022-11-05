#!/usr/bin/env -S awk -f ${_} -- input.txt
(FNR < NR) { exit }

BEGIN { die = 0; player = 0 }

{ position[$2-1] = $5 - 1 }

function step(posa, scorea, posb, scoreb, player) {
    rolls += 3
    roll = (3*die+6) % 100
    die = (die+3) % 100

    if (player == 0) {
        posa    = (posa + roll) % 10
        scorea += posa + 1
    } else {
        posb    = (posb + roll) % 10
        scoreb += posb + 1
    }
    if (scorea >= 1000) print "Part 1: " scoreb * rolls
    else if (scoreb >= 1000) print "Part 1: " scorea * rolls
    else step(posa, scorea, posb, scoreb, 0)
}

END {
    step(position[0], 0, position[1], 0, 0)
}
