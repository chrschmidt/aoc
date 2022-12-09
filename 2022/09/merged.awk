#!/usr/bin/env -S /bin/sh -c "exec awk -f ${_} input.txt"

function abs(a) { return a<0?-a:a }
function sign(a) { return a?a/abs(a):0 }

function move(dx,dy,steps,  s,k) {
    for (s=0;s<steps;s++) {
        kx[0]+=dx; ky[0]+=dy
        for (k=1;k<10;k++)
            if (abs(kx[k-1]-kx[k])>1 || abs(ky[k-1]-ky[k])>1) {
                kx[k]+=sign(kx[k-1]-kx[k])
                ky[k]+=sign(ky[k-1]-ky[k])
            }
        kp1[kx[1],ky[1]]
        kp9[kx[9],ky[9]]
    }
}

/^R/ { move(1,0,$2) }
/^L/ { move(-1,0,$2) }
/^U/ { move(0,1,$2) }
/^D/ { move(0,-1,$2) }

END {
    print "Part 1: " length(kp1)
    print "Part 2: " length(kp9)
}
