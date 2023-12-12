#!/usr/bin/env -S awk -f ${_} -- input.txt
(FNR < NR) { exit }

{
    split($1,tmp,"")
    for (i in tmp) octopuses[i,FNR] = tmp[i]
}

function dump() {
    printf ("Step %d: %d flashes\n", step, flashes)
    for (y=1; y<=10; y++) {
        for (x=1; x<=10; x++)
            if ((x,y) in octopuses)
                printf ("%d", octopuses[x,y])
        printf ("\n")
    }
    printf ("\n")
}

function flash(fx, fy,  ix, iy) {
    if (flashed[fx,fy]) return
    flashed[fx,fy] = 1
    for (iy=-1; iy<=1; iy++)
        for (ix=-1; ix<=1; ix++)
            if ((fx+ix,fy+iy) in octopuses)
                if (++octopuses[fx+ix,fy+iy] > 9)
                    flash(fx+ix, fy+iy)
}

END {
    flashed[0]
    for (step=0; 1; step++) {
        dump()
        delete flashed
        for (y=1; y<=10; y++)
            for (x=1; x<=10; x++)
                if (++octopuses[x,y] > 9)
                    flash(x, y)
        flashes += length(flashed)
        for (o in octopuses)
            if (octopuses[o] > 9)
                octopuses[o] = 0
    }
    dump()
    print "Part 1: " flashes
}
