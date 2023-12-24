#!/usr/bin/env -S /bin/sh -c "exec awk -f ${_} -f ../../aoclib.awk input.txt"

{ split($1,bricks[NR],/[,~]/) }

function drop(brick,sx,sy,sz,ex,ey,ez, x,y,z,hit) {
    for (z=sz;z>1&&!hit;z--)
        for (x=sx;x<=ex;x++)
            for (y=sy;y<=ey;y++)
                if (x in world[z-1][y]) {
                    hit=1
                    resting[brick][world[z-1][y][x]]
                    supporting[world[z-1][y][x]][brick]
                }
    if (hit) z++
    ez-=sz-z
    for (;z<=ez;z++)
        for (x=sx;x<=ex;x++)
            for (y=sy;y<=ey;y++)
                world[z][y][x]=brick
}

function compare(i1,v1,i2,v2) {
    if (v1[3]<v2[3]) return -1
    else if (v1[3]>v2[3]) return 1
    return 0
}

function chain(brick,force, i) {
    if (brick in disintegrated)
        return
    if (!force)
        for (i in resting[brick])
            if (!(i in disintegrated))
                return
    disintegrated[brick]
    for (i in supporting[brick])
        chain(i,0)
}

END {
    asort(bricks,bricks,"compare")
    for (brick=1;brick<=NR;brick++)
        drop(brick,bricks[brick][1],bricks[brick][2],bricks[brick][3],
             bricks[brick][4],bricks[brick][5],bricks[brick][6])
    
    for (i in resting)
        if (length(resting[i])==1)
            for (j in resting[i])
                protected[j]
    print "Part 1: " NR-length(protected)

    for (i in supporting) {
        delete disintegrated
        chain(i,1)
        part2+=length(disintegrated)-1
    }
    print "Part 2: " part2
}
