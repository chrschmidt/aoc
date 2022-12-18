#!/usr/bin/env -S /bin/sh -c "exec awk -f ${_} input.txt"

{
    l=split($0,a,/[=;,]? */)
    if(a[6])
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

function calcscore(time,pos,score, v) {
    for (v in flow)
        if (!(v in visited) && (time-dist[pos][v])>2) {
            time=time-dist[pos][v]-1
            score+=(time*flow[v])
            if (score>highscore)
                highscore=score
            visited[v]
            calcscore(time,v,score)
            delete visited[v]
            score-=(time*flow[v])
            time=time+dist[pos][v]+1
        }
}

END {
    calcpaths()
    calcscore(30,"AA",0)
    print "Part 1: " highscore
}
