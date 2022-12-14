#!/usr/bin/env -S /bin/sh -c "exec awk -f ${_} input.txt"

function isset(x,y,z,a) { return x SUBSEP y SUBSEP z in a }

{
    split($1,a,"")
    for (i in a)
        if (a[i]=="#")
            cube[i-1,NR-1,0]
    maxx=length($1)-1
    maxy=NR-1
}

function neighc(xc,yc,zc, x,y,z,neigh) {
#    print "Testing " xc "," yc "," zc
    for (x=xc-1;x<=xc+1;x++)
        for (y=yc-1;y<=yc+1;y++)
            for (z=zc-1;z<=zc+1;z++)
                if (isset(x,y,z,cube)) {
#                    print "  set in " x "," y "," z
                    neigh++
                }
    if (isset(xc,yc,zc,cube)) neigh--
    return neigh
}


function dump(x,y,z) {
    print "loop=" loop " minx=" minx " miny=" miny " minz=" minz
    for (z=minz;z<=maxz;z++) {
        print "z=" z
        for (y=miny;y<=maxy;y++) {
            for (x=minx;x<=maxx;x++)
                printf isset(x,y,z,cube)?"#":"."
            printf "\n"
        }
        printf "\n"
    }
}

function sn(x,y,z) {
#    print "    Setting " x "," y "," z
    newcube[x,y,z]
    if (x<minx) minx=x
    if (x>maxx) maxx=x
    if (y<miny) miny=y
    if (y>maxy) maxy=y
    if (z<minz) minz=z
    if (z>maxz) maxz=z
}
    
END {
    minx=miny=minz=maxz=0
    
    for (loop=0;loop<6;loop++) {
        dump()
        for (x=minx-1;x<=maxx+1;x++)
            for (y=miny-1;y<=maxy+1;y++)
                for (z=minz-1;z<=maxz+1;z++) {
                    nc=neighc(x,y,z)
                    if (isset(x,y,z,cube)) {
                        if (nc==2 || nc==3)
                            sn(x,y,z)
                    } else if (nc==3) {
                        sn(x,y,z)
                    }
                }
        delete cube
        for (c in newcube) cube[c]
        delete newcube
    }
    print "Part 1: " length(cube)
}    
