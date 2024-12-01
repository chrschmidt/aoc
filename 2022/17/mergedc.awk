#!/usr/bin/env -S /bin/sh -c "exec awk -f ${_} input.txt"

BEGIN {
    rock[0][0]=15
    rock[1][0]=2; rock[1][1]=7; rock[1][2]=2
    rock[2][0]=7; rock[2][1]=4; rock[2][2]=4
    rock[3][0]=1; rock[3][1]=1; rock[3][2]=1; rock[3][3]=1
    rock[4][0]=3; rock[4][1]=3

    for (r=0;r<length(rock);r++) {
        rh[r]=length(rock[r])
        rs[r]=0
        for (l=0;l<rh[r];l++) {
            rc[r]+=lshift(rock[r][l],8*l)
            for (i=3;i;i--)
                if (and(rock[r][l],lshift(1,i)) && i>rs[r])
                    rs[r]=i
        }
        rs[r]=6-rs[r]
#        print ("Rock " r ": h=" rh[r] ", l=" rs[r])
    }
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

function compress(newmap,top,i,j,remaining) {
    top=length(map)
    sum=0
    for (i=top-1; i; i--) {
        newmap[i]=map[i]
        sum=or(sum,map[i])
        if (sum==127)
            break
    }
#    print "Map has " top " entries, deleting " i
    delete map
    for (j=0;j<top-i;j++)
        map[j]=newmap[i+j]
    deleted+=i
#    print "Deleted " deleted " total."
#    dump(0,0)
}

function insert(piece, shift,top,pieceheight,maxshift,i,canmove,dropping) {
    top=length(map)
# instantiate the appropiate rock, moving it two units to the right
# mathematically, moving is inverse (left shift to imply moving right)
# use an extra offset to have space for the walls
#    pieceheight=length(rock[piece])
    pieceheight=rh[piece];
    maxshift=rs[piece];
    shift=2
#    for (i=0; i<pieceheight; i++)
#        dropped[i]=lshift(rock[piece][i],3)
# initialize the map
    for (i=top; i<top+pieceheight; i++)
        map[i]=0
    top+=pieceheight
#    dump(dropped,pieceheight)
    dropping=1
# The first drops happen in free space
    for (i=0;i<4;i++) {
        if (jets[depth]==">") {
            if (shift<maxshift)
                shift++;
        } else {
            if (shift)
                shift--;
        }
        if (++depth > jetlen) depth=1
#        print shift " at " i
    }

    do {
# Check Drop
#        print "window is " mapwin ", rock is " lshift(rc[piece],shift)
        for (i=0; i<pieceheight; i++)
            if (and(lshift(rock[piece][i],shift),map[top-pieceheight+i-1]))
                dropping=0
# Drop
        if (dropping) {
            top--
            if (map[length(map)-1]==0)
                delete map[length(map)-1]
            canmove=1
# Push
            if (jets[depth]==">") {
                if (shift<maxshift) {
                    for (i=0; i<pieceheight; i++)
                        if (and(lshift(rock[piece][i],shift+1),map[top-pieceheight+i]))
                            canmove=0
                    if (canmove)
                        shift++
                }
            } else {
                if (shift) {
                    for (i=0; i<pieceheight; i++)
                        if (and(lshift(rock[piece][i],shift-1),map[top-pieceheight+i]))
                            canmove=0
                    if (canmove)
                        shift--
                }
#                for (i=0; i<pieceheight; i++)
#                    dropped[i]=rshift(dropped[i],1);
            }
#            print shift " now"
            if (++depth > jetlen) depth=1
        } else {
# Convert to Map
            for (i=0; i<pieceheight; i++)
                map[top-pieceheight+i]=or(map[top-pieceheight+i],lshift(rock[piece][i],shift))
        }
            
#        dump(dropped,pieceheight)
    } while (dropping)
#    print length(map) " lines"
#    dump(0,0)
}

END {
    map[0]=255
    depth=1
    for (i=0;i<2022;i++)
        insert(i%5)
    print "Part 1: " length(map)-1

    delete map
    map[0]=255
    depth=1
    for (i=0;i<1000;i++) {
        for (j=0;j<200;j++)
            for (k=0;k<5;k++)
                insert(k)
        compress()
    }
    print "Part 2: " length(map)-1+deleted
}
