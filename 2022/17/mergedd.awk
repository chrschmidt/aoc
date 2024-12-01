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
#        print ("Rock " r ": h=" rh[r] ", l=" rs[r], ", alt=", rc[r])
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

function vcomp(ina,inb, i,j,k) {
    for (i=3;i>-1;i--) {
        printf ("%d", i)
        for (j=0;j<7;j++) {
            if (and(ina,lshift(1,8*i+j)) && and (inb,lshift(1,8*i+j))) printf ("X")
            else if (and(ina,lshift(1,8*i+j))) printf ("a")
            else if (and(inb,lshift(1,8*i+j))) printf ("b")
            else printf (".")
        }
        printf ("\n");
    }
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

function insert(piece, shift,top,pieceheight,maxshift,i,dropping) {
    top=length(map)-1
# instantiate the appropiate rock, moving it two units to the right
# mathematically, moving is inverse (left shift to imply moving right)
# use an extra offset to have space for the walls
#    pieceheight=length(rock[piece])
    pieceheight=rh[piece]
    maxshift=rs[piece]
    shift=2
    dropping=1
# The first drops happen in free space
    for (i=0;i<4;i++) {
        if (jets[depth]==">") {
            if (shift<maxshift) shift++
        } else {
            if (shift) shift--
        }
        if (++depth > jetlen) depth=1
 #       print shift " at " i
    }
# 3 drops and 4 shifts happened so far 
    mapwin=map[top--]
    dropping=1
    do {
# Check Drop
#        vcomp(lshift(rc[piece],shift),mapwin)
#        print "window is " mapwin ", rock is " lshift(rc[piece],shift)
#        print shift " now"
        if (and(mapwin,lshift(rc[piece],shift))) {
# Collision, convert
            for (i=0;i<pieceheight;i++)
                map[top+i+2]=or(map[top+i+2],lshift(rock[piece][i],shift))
            dropping=0
        } else {
# Push
            if (jets[depth]==">") {
                if (shift<maxshift) {
#                    vcomp(lshift(rc[piece],shift+1), mapwin);
                    if (and(mapwin,lshift(rc[piece],shift+1))==0) shift++
                }
            } else {
                if (shift) {
#                    vcomp(lshift(rc[piece],shift-1), mapwin);
                    if (and(mapwin,lshift(rc[piece],shift-1))==0) shift--
                }
            }
            if (++depth>jetlen) depth=1
# Drop down by one
            mapwin=or(and(lshift(mapwin,8),0xffffff00),map[top--])
        }
    } while (dropping)
#    print "Map is now " length(map) " lines high"
#    dump(0,0)
}

END {
    map[0]=127
    depth=1
    for (i=0;i<2022;i++)
        insert(i%5)
    print "Part 1: " length(map)-1

    delete map
    map[0]=127
    depth=1
    for (i=0;i<1000;i++) {
        for (j=0;j<200;j++)
            for (k=0;k<5;k++)
                insert(k)
        compress()
    }
    print "Part 2: " length(map)-1+deleted
}
