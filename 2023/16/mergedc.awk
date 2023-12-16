#!/usr/bin/env -S /bin/sh -c "exec awk -f ${_} -f ../../aoclib.awk input.txt"

{ split($1,world[NR],"") }

function step(x,y,dir) {
    switch(dir) {
    case 0: return trace(x,y-1,0)
    case 1: return trace(x+1,y,1)
    case 2: return trace(x,y+1,2)
    case 3: return trace(x-1,y,3)
    }
}

function trace(x,y,dir) {
    if(x==0 || x>length(world[1]) || y==0 || y>NR || dir in energized[x,y])
        return
    energized[x,y][dir]
    switch(world[y][x]) {
    case "/":
        if (dir>1) return step(x,y,5-dir)
        else       return step(x,y,1-dir)
    case "\\":
        return step(x,y,3-dir)
    case "-":
        if (dir==0 || dir==2) { step(x,y,3); return step(x,y,1) }
        break
    case "|":
        if (dir==1 || dir==3) { step(x,y,0); return step(x,y,2) }
    }
    return step(x,y,dir)
}

function run(x,y,dir) {
    delete energized
    trace(x,y,dir)
    part2=max(part2,length(energized))
}

END {
    trace(1,1,1)
    print "Part 1: " length(energized)
    for (x=1;x<=length(world[1]);x++) {
        run(x,1,2)
        run(x,NR,0)
    }
    for (y=1;y<NR;y++) {
        run(1,y,1)
        run(length(world[1]),y,3)
    }
    print "Part 2: " part2
}
