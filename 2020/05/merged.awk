#!/usr/bin/env -S awk -f ${_} -- input.txt
(FNR < NR) { exit }

{
    rowmin=0; rowmax=127; colmin=0; colmax=7
    for (i=1; i<8; i++)
        if (substr($1,i,1) == "F") rowmax -= int ((rowmax - rowmin) / 2) + 1
        else rowmin += int ((rowmax - rowmin) / 2) + 1
    for (i=8; i<11; i++)
        if (substr($1,i,1) == "L") colmax -= int ((colmax - colmin) / 2) + 1
        else colmin += int ((colmax - colmin) / 2) + 1
    seatid=rowmin*8+colmin
    if (seatid > maxid) maxid = seatid
    used[seatid] = seatid
}

END {
    print "Part 1: " maxid
    for (seat=9; seat<maxid; seat++)
        if (!(seat in used) && (seat-1 in used) && (seat+1 in used)) {
            print "Part 2: " seat
            exit
        }
}
