#!/usr/bin/env -S /bin/sh -c "exec awk -f ${_} input.txt"

function isset(x,y,z,w,a) { return (x,y,z,w) in a }

{
    split($1,a,"")
    for (i in a)
        if (a[i]=="#")
            cube[i-1,NR-1,0,0]
    maxx=length($1)-1
    maxy=NR-1
}

function neighc(xc,yc,zc,wc, x,y,z,w,neigh) {
#    print "Testing " xc "," yc "," zc
    for (x=xc-1;x<=xc+1;x++)
        for (y=yc-1;y<=yc+1;y++)
            for (z=zc-1;z<=zc+1;z++)
                for (w=wc-1;w<=wc+1;w++)
                    if (isset(x,y,z,w,cube)) {
#                    print "  set in " x "," y "," z
                        neigh++
                    }
    if (isset(xc,yc,zc,wc,cube)) neigh--
    return neigh
}


function dump(x,y,z) {
    print "loop=" loop
    for (w=minw;w<=maxw;w++)
        for (z=minz;z<=maxz;z++) {
            print "z=" z ", w=" w
            for (y=miny;y<=maxy;y++) {
                for (x=minx;x<=maxx;x++)
                    printf isset(x,y,z,w,cube)?"#":"."
                printf "\n"
            }
            printf "\n"
        }
}

function sn(x,y,z,w) {
#    print "    Setting " x "," y "," z
    newcube[x,y,z,w]
    if (x<minx) minx=x
    if (x>maxx) maxx=x
    if (y<miny) miny=y
    if (y>maxy) maxy=y
    if (z<minz) minz=z
    if (z>maxz) maxz=z
    if (w<minw) minw=w
    if (w>maxw) maxw=w
}

END {
    minx=miny=minz=maxz=minw=maxw=0

    for (loop=0;loop<6;loop++) {
        dump()
        for (x=minx-1;x<=maxx+1;x++)
            for (y=miny-1;y<=maxy+1;y++)
                for (z=minz-1;z<=maxz+1;z++)
                    for (w=minw-1;w<=maxw+1;w++) {
                        nc=neighc(x,y,z,w)
                        if (isset(x,y,z,w,cube)) {
                            if (nc==2 || nc==3)
                                sn(x,y,z,w)
                        } else if (nc==3) {
                            sn(x,y,z,w)
                        }
                    }
        delete cube
        for (c in newcube) cube[c]
        delete newcube
    }
    print "Part 2: " length(cube)
}
