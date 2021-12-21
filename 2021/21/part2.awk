#!/usr/bin/env -S awk -f ${_} -- input.txt
(FNR < NR) { exit }

BEGIN { for (i=1; i<4; i++) for (j=1; j<4; j++) for (k=1; k<4; k++) u[i+j+k]++ }

{ position[$2-1] = $5 - 1 }

function max(a, b) { return a > b ? a : b }

function step(posa, scorea, posb, scoreb, player, universes, roll,  ui) {
    if (player == 0) {
        posa    = (posa + roll) % 10
        scorea += posa + 1
    } else {
        posb    = (posb + roll) % 10
        scoreb += posb + 1
    }
    if (scorea >= 21) player1wins += universes
    else if (scoreb >= 21) player2wins += universes
    else for (ui in u) step(posa, scorea, posb, scoreb, 1-player, universes*u[ui], ui )
}

END {
    step(position[0], 0, position[1], -position[1]-1, 1, 1, 0)
    print "player 1 wins " player1wins " times"
    print "player 2 wins " player2wins " times"
    print "Part 2: " max(player1wins, player2wins)
}
