#!/usr/bin/env -S /bin/sh -c "exec awk -f ../../aoclib.awk -f ${_} input.txt"

{
    split($1,pos[FNR],/=|,/)
    split($2,vel[FNR],/=|,/)
}

function step(map,object,objects,combine,sizes,slots) {
    for (i in pos) {
        pos[i][2]=wrap(pos[i][2]+vel[i][2],sx)
        pos[i][3]=wrap(pos[i][3]+vel[i][3],sy)
        map[pos[i][2]][pos[i][3]]++
    }
    for (y=0;y<sy;y++)
        for (x=0;x<sx;x++)
            if (map[x][y]) {
                if (objects[x-1][y-1])      objects[x][y]=objects[x-1][y-1]
                else if (objects[x-1][y])   objects[x][y]=objects[x-1][y]
                else if (objects[x][y-1])   objects[x][y]=objects[x][y-1]
                else if (objects[x+1][y-1]) objects[x][y]=objects[x+1][y-1]
                else objects[x][y]=++object
# Ignore "combination" pattern where [x-1][y-1] and [x+1][y-1] belong to different objects
                sizes[objects[x][y]]+=map[x][y]
            }
    for (i in sizes)
        if (sizes[i]>100) {
            print "Part2: " s
            for (y=0;y<sy;y++) {
                for (x=0;x<sy;x++)
                    if (map[x][y]) printf "%d", map[x][y]
                    else printf "."
                print ""
            }
            exit   
        }
}

END {
    sx=101; sy=103
    for (s=1;s<sx*sy;s++)
        step()
}
