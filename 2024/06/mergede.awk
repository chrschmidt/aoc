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

function solve(phase,dir, nx,ny) {
    do {
        if (and(map[gy][gx],dir)) return 1
        if (phase==2 && (!(gy in rollback) || !(gx in rollback[gy])))
            rollback[gy][gx]=map[gy][gx]
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
                     rollback[ny][nx]=map[ny][nx]
                     map[ny][nx]=-1
                     part2+=solve(2,dir==8?1:2*dir)
                     for (y in rollback)
                         for (x in rollback[y])
                             map[y][x]=rollback[y][x]
                     delete rollback
                 }
        default: gx=nx; gy=ny
        }
    } while (1)
}

END {
    solve(1,1)
    print "Part 1: " part1+1
    print "Part 2: " part2
}
