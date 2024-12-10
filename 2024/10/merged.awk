#!/usr/bin/env -S /bin/sh -c "exec awk -f ../../aoclib.awk -f ${_} input.txt"

{ xs=split($0,map[FNR],"") }

function trace(px,py,v) {
    if (px==0 || px>xs || py==0 || py>ys) return 0
    if (map[py][px]!=v) return 0
    if (map[py][px]==9) {
        heads[x,y][px,py]
        return 1
    } else {
        v++
        return trace(px-1,py,v)+trace(px,py-1,v)+trace(px+1,py,v)+trace(px,py+1,v)
    }
}
    
END {
    ys=FNR
    for (y=1;y<=ys;y++)
        for (x=1;x<=xs;x++) {
            part2+=trace(x,y,0)
            part1+=length(heads[x,y])
        }
    print "Part 1: " part1
    print "Part 2: " part2
}
