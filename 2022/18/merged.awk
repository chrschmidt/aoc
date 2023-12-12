#!/usr/bin/env -S /bin/sh -c "exec awk -F, -f ${_} input.txt"

{
    if (NR == 1) {
        cubes[$1,$2,$3]=6
        minx=$1; maxx=$1; miny=$2; maxy=$2; minz=$3; maxz=$3
    } else {
        cubes[$1,$2,$3]=6
        if ($1<minx) minx=$1; if ($1>maxx) maxx=$1
        if ($2<miny) miny=$2; if ($2>maxy) maxy=$2
        if ($3<minz) minz=$3; if ($3>maxz) maxz=$3

        if (($1-1,$2,$3) in cubes) { cubes[$1,$2,$3]--; cubes[$1-1,$2,$3]-- }
        if (($1+1,$2,$3) in cubes) { cubes[$1,$2,$3]--; cubes[$1+1,$2,$3]-- }
        if (($1,$2-1,$3) in cubes) { cubes[$1,$2,$3]--; cubes[$1,$2-1,$3]-- }
        if (($1,$2+1,$3) in cubes) { cubes[$1,$2,$3]--; cubes[$1,$2+1,$3]-- }
        if (($1,$2,$3-1) in cubes) { cubes[$1,$2,$3]--; cubes[$1,$2,$3-1]-- }
        if (($1,$2,$3+1) in cubes) { cubes[$1,$2,$3]--; cubes[$1,$2,$3+1]-- }
    }
}

function fill(x,y,z) {
    if ((x,y,z) in cubes)
        return
    cubes[x,y,z] = 0
    if (x>minx) fill(x-1,y,z)
    if (x<maxx) fill(x+1,y,z)
    if (y>miny) fill(x,y-1,z)
    if (y<maxy) fill(x,y+1,z)
    if (z>minz) fill(x,y,z-1)
    if (z<maxz) fill(x,y,z+1)
}

END {
    sum=0
    for (cube in cubes)
        sum+=cubes[cube]
    print "Part 1: " sum

    for (x=minx;x<=maxx;x++)
        for (y=miny;y<=maxy;y++) {
            fill(x,y,minz)
            fill(x,y,maxz)
        }
    for (x=minx;x<=maxx;x++)
        for (z=miny;z<=maxy;z++) {
            fill(x,miny,z)
            fill(x,maxy,z)
        }
    for (y=miny;y<=maxy;y++)
        for (z=miny;z<=maxy;z++) {
            fill(minx,y,z)
            fill(maxx,y,z)
        }

    for (x=minx;x<=maxx;x++)
        for (y=miny;y<=maxy;y++)
            for (z=minz;z<=maxz;z++)
                if (!((x,y,z) in cubes)) {
                    if ((x-1,y,z) in cubes) { if (cubes[x-1,y,z] > 0) cubes[x-1,y,z]-- }
                    if ((x+1,y,z) in cubes) { if (cubes[x+1,y,z] > 0) cubes[x+1,y,z]-- }
                    if ((x,y-1,z) in cubes) { if (cubes[x,y-1,z] > 0) cubes[x,y-1,z]-- }
                    if ((x,y+1,z) in cubes) { if (cubes[x,y+1,z] > 0) cubes[x,y+1,z]-- }
                    if ((x,y,z-1) in cubes) { if (cubes[x,y,z-1] > 0) cubes[x,y,z-1]-- }
                    if ((x,y,z+1) in cubes) { if (cubes[x,y,z+1] > 0) cubes[x,y,z+1]-- }
                }

    sum=0
    for (cube in cubes)
        sum+=cubes[cube]
    print "Part 2: " sum
}
