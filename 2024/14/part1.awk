#!/usr/bin/env -S /bin/sh -c "exec awk -f ../../aoclib.awk -f ${_} input.txt"

{
    split($1,pos[FNR],/=|,/)
    split($2,vel[FNR],/=|,/)
}

END {
    sx=101; sy=103
    hx=sx/2-0.5; hy=sy/2-0.5
    for (i in pos) {
        pos[i][2]=wrap(pos[i][2]+100*vel[i][2],sx)
        pos[i][3]=wrap(pos[i][3]+100*vel[i][3],sy)
        if (pos[i][2]==hx || pos[i][3]==hy)
            continue
        if (pos[i][2]<hx) {
            if (pos[i][3]<hy) q0++
            else              q1++
        } else {
            if (pos[i][3]<hy) q2++
            else              q3++
        }
    }
    print "Part 1: " q0*q1*q2*q3
}
