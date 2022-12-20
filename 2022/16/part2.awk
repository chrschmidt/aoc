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

function calcscore(time1,time2,pos1,pos2,score, v) {
    if (time1>=time2) {
        for (v in flow)
            if (!(v in visited) && (time1-dist[pos1][v])>2) {
#                path1=path1 " " v
                time1=time1-dist[pos1][v]-1
                score+=(time1*flow[v])
                if (score>highscore)
                    highscore=score
                visited[v]
                calcscore(time1,time2,v,pos2,score)
                delete visited[v]
                score-=(time1*flow[v])
                time1=time1+dist[pos1][v]+1
#                path1=substr(path1,1,length(path1)-3)
            }
    } else {
        for (v in flow)
            if (!(v in visited) && (time2-dist[pos2][v])>2) {
#                path2=path2 " " v
                time2=time2-dist[pos2][v]-1
                score+=(time2*flow[v])
                if (score>highscore)
                    highscore=score
                visited[v]
                calcscore(time1,time2,pos1,v,score)
                delete visited[v]
                score-=(time2*flow[v])
                time2=time2+dist[pos2][v]+1
#                path2=substr(path2,1,length(path2)-3)
            }
    }
}

END {
    calcpaths()
    calcscore(26,26,"AA","AA",0)
    print "Part 2: " highscore
}
