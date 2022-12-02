#!/usr/bin/env -S awk -f ${_} -- input.txt
(FNR < NR) { exit }

BEGIN { for (i=65; i<=90; i++) chars[sprintf("%c", i)]=i-65 }
function ord(c) { return chars[substr(c,1,1)] }

{ elf[NR]=ord($1); play[NR]=ord($2)-23 }

function score(e, p) {
    if (p == -1) p=2
    if (e == p) return p+4
    else if (e == p-1 || (e==2 && p==0)) return p+7
    else return p+1
}

END {
    for (i in elf) {
        p1+=score(elf[i], play[i])
        if (play[i] == 0) p2+=score(elf[i], elf[i]-1)
        else if (play[i] == 1) p2+=score(elf[i], elf[i])
        else p2+=score(elf[i], (elf[i]+1)%3)
    }
    print "Part 1: " p1
    print "Part 2: " p2
}
