#!/usr/bin/env -S /bin/sh -c "exec awk -f ${_} -f ../../aoclib.awk input.txt"

BEGIN { queueend = queuestart = 0 }

{ split($1,world[NR],"") }

function enq(x,y,dir,stepcnt,sum) {
    if (x==0 || x>length(world[1]) || y==0 || y>NR)
        return
    queue[queueend][0]=x
    queue[queueend][1]=y
    queue[queueend][2]=dir
    queue[queueend][3]=stepcnt
    queue[queueend++][4]=sum
}

function enqstep(x,y,dir,stepcnt,sum, mindex) {
    dir=(dir+4)%4
    switch(dir) {
    case  0: y--; break
    case  1: x++; break
    case  2: y++; break
    case  3: x--
    }
    enq(x,y,dir,stepcnt,sum)
}

function trace(x,y,dir,stepcnt,sum) {
    while (queuestart<queueend) {
        x=queue[queuestart][0]
        y=queue[queuestart][1]
        dir=queue[queuestart][2]
        stepcnt=queue[queuestart][3]
        sum=queue[queuestart][4]
        sum+=world[y][x]
        if (minvals[x][y][dir][stepcnt]>sum) {
            minvals[x][y][dir][stepcnt]=sum
            if (stepcnt<3) enqstep(x,y,dir,stepcnt+1,sum)
            enqstep(x,y,dir-1,1,sum)
            enqstep(x,y,dir+1,1,sum)
        }
        delete queue[queuestart]
        queuestart++
    }
}

END {
    end=length(world[1])*NR+NR
    for (i=1;i<=NR; i++)
        for (j=1;j<=length(world[i]);j++)
            for (k=0;k<=3;k++)
                for (l=1;l<=3;l++)
                    minvals[j][i][k][l]=10*end
    minvals[1,1]=0
    enq(2,1,1,1,0)
    enq(1,2,2,1,0)
    trace()

    for (i in minvals[length(world[1])][NR])
        for (j in minvals[length(world[1])][NR][i])
            results[++results[0]]=minvals[length(world[1])][NR][i][j]
    delete results[0]
    asort(results)
    print "Part 1: " results[1]
}
