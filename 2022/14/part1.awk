#!/usr/bin/env -S /bin/sh -c "exec awk -f ${_} input.txt"

BEGIN { minx=maxx=500; miny=maxy=0 }

function abs(a) { return a<0?-a:a }
function sign(a) { return a?a/abs(a):0 }

function set(x,y,val) {
    cave[x,y]=val
    if (y>maxy) maxy=y
}

{
    for (l=1;l<NF;l+=2) {
        split($l,start,",")
        split($(l+2),end,",")
        set(start[1],start[2],"#")
        while (start[1]!=end[1] || start[2]!=end[2]) {
            start[1]-=sign(start[1]-end[1])
            start[2]-=sign(start[2]-end[2])
            set(start[1],start[2],"#")
        }
    }
}

END {
    do {
        drops++
        sandx=500
        sandy=0
        do {
            moved=0
            if (!((sandx,sandy+1) in cave)) { sandy++; moved=1 }
            else if (!((sandx-1,sandy+1) in cave)) { sandx--; sandy++; moved=1 }
            else if (!((sandx+1,sandy+1) in cave)) { sandx++; sandy++; moved=1 }
            else cave[sandx,sandy]="o"
            if (sandy>maxy) { finished=1; break }
        } while (moved)
    } while (!finished)
    print "Part 1: " drops-1
}
