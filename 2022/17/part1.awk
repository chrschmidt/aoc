#!/usr/bin/env -S /bin/sh -c "exec awk -f ${_} input.txt"

BEGIN {
    rock[0][0]=15
    rock[1][0]=2; rock[1][1]=7; rock[1][2]=2
    rock[2][0]=7; rock[2][1]=4; rock[2][2]=4
    rock[3][0]=1; rock[3][1]=1; rock[3][2]=1; rock[3][3]=1
    rock[4][0]=3; rock[4][1]=3
}

{
    jetlen=split($1,jets,"")
}

function dump(piece,pheight, x,y) {
    mh=length(map)-1
    for (y=0;y<=mh;y++) {
#        if (y<pheight) printf "@" piece[pheight-y-1]
        for (x=0;x<9;x++) {
            printf and(map[mh-y],lshift(1,x))?"#":
                (y<pheight && and(piece[pheight-y-1],lshift(1,x)))?"@":
                "."
        }
        print ""
    }
    print ""
}

function insert(piece, top,pieceheight,i,canmove) {
    top=length(map)
# instantiate the appropiate rock, moving it two units to the right
# mathematically, moving is inverse (left shift to imply moving right)
# use an extra offset to have space for the walls
    pieceheight=length(rock[piece])
    for (i=0; i<pieceheight; i++)
        dropped[i]=lshift(rock[piece][i],3)
# initialize the map - ensure the borders exist
    for (i=top; i<top+pieceheight+3; i++)
        map[i]=257
    top+=pieceheight+3
#    dump(dropped,pieceheight)
    dropping=1
    do {
        canmove=1
# Push
        if (jets[depth]==">") {
            for (i=0; i<pieceheight; i++)
                if (and(lshift(dropped[i],1),map[top-pieceheight+i]))
                    canmove=0
            if (canmove)
                for (i=0; i<pieceheight; i++)
                    dropped[i]=lshift(dropped[i],1);
        } else {
            for (i=0; i<pieceheight; i++)
                if (and(rshift(dropped[i],1),map[top-pieceheight+i]))
                    canmove=0
            if (canmove)
                for (i=0; i<pieceheight; i++)
                    dropped[i]=rshift(dropped[i],1);
        }
# Check Drop
        for (i=0; i<pieceheight; i++)
            if (and(dropped[i],map[top-pieceheight+i-1]))
                dropping=0
# Drop
        if (dropping) {
            top--
            if (map[length(map)-1]==257)
                delete map[length(map)-1]
        } else {
# Convert to Map
            for (i=0; i<pieceheight; i++)
                map[top-pieceheight+i]=or(map[top-pieceheight+i],dropped[i])
        }
            
        if (++depth > jetlen) depth=1
#        dump(dropped,pieceheight)
    } while (dropping)
}

END {
    map[0]=511
    depth=1
    for (i=0;i<2022;i++)
        insert(i%5)
    print "Part 1: " length(map)-1
}
