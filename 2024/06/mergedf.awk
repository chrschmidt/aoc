#!/usr/bin/env -S /bin/sh -c "exec awk -f ../../aoclib.awk -f ${_} input.txt"

{
    mx=split($0,map[FNR],"")
    my=FNR
    if (!gx) {
        gx=index($0,"^")
        gy=FNR
    }
}

function solve(phase,x,y,dir, nx,ny,t) {
    if (and(map[y][x],dir)) return 1
    switch (dir) {
    case 1: if (y==1)  return 0; nx=x; ny=y-1; break
    case 2: if (x==mx) return 0; nx=x+1; ny=y; break
    case 4: if (y==my) return 0; nx=x; ny=y+1; break
    case 8: if (x==1)  return 0; nx=x-1; ny=y
    }
    t=map[y][x]
    map[y][x]=or(map[y][x],dir)
    switch (map[ny][nx]) {
    case "#": s=solve(phase,x,y,dir==8?1:2*dir); break
    case ".": if (phase==1) {
                  part1++
                  map[ny][nx]="#"
                  part2+=solve(2,x,y,dir==8?1:2*dir)
              }
    default:  s=solve(phase,nx,ny,dir)
    }
    map[y][x]=t
    return s
}

END {
    solve(1,gx,gy,1)
    print "Part 1: " part1+1
    print "Part 2: " part2
}
