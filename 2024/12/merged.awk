#!/usr/bin/env -S /bin/sh -c "exec awk -f ../../aoclib.awk -f ${_} input.txt"

{ sx=split($0,map[FNR],"") }

function region(x,y,p) {
    if (map[y][x]==p) {
        sizes[regions]++
        map[y][x]=regions
        perimeters[regions]+=region(x-1,y,p)
        perimeters[regions]+=region(x+1,y,p)
        perimeters[regions]+=region(x,y-1,p)
        perimeters[regions]+=region(x,y+1,p)
    } else if (map[y][x]!=regions)
        return 1
}

END {
    sy=FNR
    for (y=1;y<=sy;y++)
        for (x=1;x<=sx;x++)
            if (typeof(map[y][x])=="string") {
                regions++
                region(x,y,map[y][x])
            }
    for (i=1;i<=regions;i++)
        part1+=perimeters[i]*sizes[i]
    print "Part 1: " part1
    for (y=1;y<=sy;y++)
        for (x=1;x<=sx;x++)
            if (map[y][x]!=map[y][x-1] && (map[y][x]!=map[y-1][x] || map[y][x]==map[y-1][x-1]))
                sides[map[y][x]]++    
    for (y=1;y<=sy;y++)
        for (x=sx;x;x--)
            if (map[y][x]!=map[y][x+1] && (map[y][x]!=map[y-1][x] || map[y][x]==map[y-1][x+1]))
                sides[map[y][x]]++
    for (x=1;x<=sx;x++)
        for (y=1;y<=sy;y++)
            if (map[y][x]!=map[y-1][x] && (map[y][x]!=map[y][x-1] || map[y][x]==map[y-1][x-1]))
                sides[map[y][x]]++
    for (x=1;x<=sx;x++)
        for (y=sy;y;y--)
            if (map[y][x]!=map[y+1][x] && (map[y][x]!=map[y][x-1] || map[y][x]==map[y+1][x-1]))
                sides[map[y][x]]++
    for (i=1;i<=regions;i++)
        part2+=sides[i]*sizes[i]
    print "Part 2: " part2
}
