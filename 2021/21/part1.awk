#!/usr/bin/env -S awk -f ${_} -- input.txt
(FNR < NR) { exit }

BEGIN { die = 0; player = 0 }

{ position[$2-1] = $5 - 1 }

function step() {
    rolls += 3
    position[player] = (position[player] + (3*die+6) % 100) % 10
    die = (die+3) % 100
    score[player] += position[player] + 1
    player = 1-player
}

END {
    while (score[0] < 1000 && score[1] < 1000) step()
    loser = score[1] < 1000
    print "Part 1: " score[loser] * rolls
}
