#!/usr/bin/env -S awk -f ${_} -- input.txt
(FNR < NR) { exit }

{
    split($1,tmp,"")
    for (i in tmp) heightmap[i,FNR] = tmp[i]
}

END {
    for (y=1; y; y++) {
        if (!(1,y) in heightmap) break
        for (x=1; x; x++) {
            if (!(x,y) in heightmap) break
            if ((x-1,y) in heightmap && heightmap[x-1,y] <= heightmap[x,y]) continue
            if ((x+1,y) in heightmap && heightmap[x+1,y] <= heightmap[x,y]) continue
            if ((x,y-1) in heightmap && heightmap[x,y-1] <= heightmap[x,y]) continue
            if ((x,y+1) in heightmap && heightmap[x,y+1] <= heightmap[x,y]) continue
            sum += heightmap[x,y] + 1
        }
    }
    print sum
}
