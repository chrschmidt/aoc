#!/usr/bin/env -S /bin/sh -c "exec awk -f ${_} input.txt"

{
    l=split($0,a,/[=;,]? */)
    if (a[6])
        flow[a[2]]=a[6]
    for (i=11;i<=l;i++)
        tunnels[a[2]][a[i]]=a[i]
}

function calcpaths() {
    for (src in tunnels) {
        dist[src][src]=0
        level=0
        do {
            found=0
            for (tl in dist[src]) {
                if (dist[src][tl]==level)
                    found=1
                    for (t in tunnels[tl])
                        if (!(t in dist[src]))
                            dist[src][t]=level+1
            }
            level++
        } while (found)
    }
}

function calcscore(time1,pos1,time2,pos2, v) {
    if (time1>=time2) {
        for (v in flow)
            if (!(v in visited) && (time1-dist[pos1][v])>2) {
                time1=time1-dist[pos1][v]-1
                score+=(time1*flow[v])
                if (score>highscore)
                    highscore=score
                visited[v]
                calcscore(time1,v,time2,pos2)
                delete visited[v]
                score-=(time1*flow[v])
                time1=time1+dist[pos1][v]+1
            }
    } else {
        for (v in flow)
            if (!(v in visited) && (time2-dist[pos2][v])>2) {
                time2=time2-dist[pos2][v]-1
                score+=(time2*flow[v])
                if (score>highscore)
                    highscore=score
                visited[v]
                calcscore(time1,pos1,time2,v)
                delete visited[v]
                score-=(time2*flow[v])
                time2=time2+dist[pos2][v]+1
            }
    }
    return highscore
}

END {
    calcpaths()
    print "Part 1: " calcscore(30,"AA")
    print "Part 2: " calcscore(26,"AA",26,"AA")
}
