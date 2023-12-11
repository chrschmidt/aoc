#!/usr/bin/env -S /bin/sh -c "exec awk -f ${_} -f ../../aoclib.awk input.txt"

{
    wl=split($1,line,"")
    for (i=1;i<=wl;i++)
        world[2*NR][2*i]=line[i]
    if ($1 ~ /^\.+$/)
        for (i=1;i<=wl;i++)
            world[2*NR+1][2*i]="."
}

function dump(x,y) {
    for (y in world) {
        for (x in world[y])
            printf world[y][x]
        printf "\n"
    }
    printf "\n"
}

END {
    dump()
    for (x=1;x<=wl;x++) {
        add=1
        for (y in world)
            if (world[y][2*x]=="#")
                add=0
        if (add)
            for (y in world)
                world[y][2*x+1]="."
    }
    dump()
    asort(world,world,"@ind_num_asc")
    for (y in world)
        asort(world[y],world[y],"@ind_num_asc")
    dump()
    for (y in world)
        for (x in world[y])
            if (world[y][x]=="#") {
                galaxies[galaxies[0]+1][0]=x
                galaxies[++galaxies[0]][1]=y
            }
    for (go=1;go<galaxies[0];go++)
        for (gi=go+1;gi<=galaxies[0];gi++)
            part1+=manhattan(galaxies[go][0],galaxies[go][1],
                             galaxies[gi][0],galaxies[gi][1])
    print "Part 1: " part1
}
