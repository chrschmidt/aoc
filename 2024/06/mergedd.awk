#!/usr/bin/env -S /bin/sh -c "exec awk -f ../../aoclib.awk -f ${_} input.txt"

{
    mx=split($0,a,"")
    my=FNR
    for (x=1;x<=mx;x++)
        switch (a[x]) {
        case "#": map[FNR][x]=-1; break
        case "^": gx=x; gy=FNR
        case ".": map[FNR][x]=0
        }
}

function solve(phase,map,dir, nx,ny) {
    do {
        if (and(map[gy][gx],dir)) return 1
        map[gy][gx]=or(map[gy][gx],dir)
        switch (dir) {
        case 1: if (gy==1)  return 0; nx=gx; ny=gy-1; break
        case 2: if (gx==mx) return 0; nx=gx+1; ny=gy; break
        case 4: if (gy==my) return 0; nx=gx; ny=gy+1; break
        case 8: if (gx==1)  return 0; nx=gx-1; ny=gy
        }
        switch (map[ny][nx]) {
        case -1: dir=dir==8?1:2*dir; break
        case  0: if (phase==1) {
                     part1++
                     for (y=1;y<=my;y++)
                         for (x=1;x<=mx;x++)
                             tmap[y][x]=map[y][x]
                     tmap[ny][nx]=-1
                     part2+=solve(2,tmap,dir==8?1:2*dir)
                 }
        default: gx=nx; gy=ny
        }
    } while (1)
}

END {
    solve(1,map,1)
    print "Part 1: " part1+1
    print "Part 2: " part2
}
