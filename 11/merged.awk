#!/usr/bin/env -S awk -f ${_} -- input.txt
(FNR < NR) { exit }

{
    split($1,tmp,"")
    for (i in tmp) octopuses[i,FNR] = tmp[i]
}

function flash(fx, fy,  ix, iy) {
    sflashes++
    for (iy=fy-1; iy<=fy+1; iy++)
        for (ix=fx-1; ix<=fx+1; ix++)
            if ((ix,iy) in octopuses)
                if (++octopuses[ix,iy] == 10)
                    flash(ix, iy)
}

END {
    for (step=0; 1; step++) {
        sflashes = 0
        for (y=1; y<=10; y++)
            for (x=1; x<=10; x++)
                if (++octopuses[x,y] == 10)
                    flash(x, y)
        flashes += sflashes
        for (o in octopuses)
            if (octopuses[o] > 9)
                octopuses[o] = 0
        if (step == 99)
            print "Part 1: " flashes
        if (sflashes == 100)
            break
    }
    print "Part 2: " step+1
}
