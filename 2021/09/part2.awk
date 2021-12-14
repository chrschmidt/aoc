#!/usr/bin/env -S awk -f ${_} -- input.txt
(FNR < NR) { exit }

{
    split($1, tmp, "")
    for (i in tmp) heightmap[i,FNR] = tmp[i]
}

function cb(x, y, h,  h2) {
    if (!(x,y) in heightmap) return 0
    h2 = heightmap[x,y]
    if ((x,y) in visited || h2 < h || h2 == 9) return 0
    visited[x,y] = 1
    return 1 + cb(x-1, y, h2) + cb(x+1, y, h2) + cb(x, y-1, h2) + cb(x, y+1, h2)
}

END {
    for (y=1; y; y++) {
        if (!(1,y) in heightmap) break
        for (x=1; x; x++) {
            if (!(x,y) in heightmap) break
            h = heightmap[x,y]
            if ((x-1,y) in heightmap && heightmap[x-1,y] < h) continue
            if ((x+1,y) in heightmap && heightmap[x+1,y] < h) continue
            if ((x,y-1) in heightmap && heightmap[x,y-1] < h) continue
            if ((x,y+1) in heightmap && heightmap[x,y+1] < h) continue
	    delete visited
	    visited[x,y] = 1
            basins[x,y] = 1 + cb(x-1, y, h) + cb(x+1, y, h) + cb(x, y-1, h) + cb(x, y+1, h)
        }
    }
    asorti(basins,bysize,"@val_num_desc")
    print "Total: " basins[bysize[1]] * basins[bysize[2]] * basins[bysize[3]]
}
