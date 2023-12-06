#!/usr/bin/env -S /bin/sh -c "exec awk -f ${_} input.txt"

function min(a,b) { return a<b?a:b }
function max(a,b) { return a>b?a:b }

/seeds:/ { for (i=2; i<=NF; i++) seeds[i-2]=$i }
($2=="map:") { curmap++; curelem=1 }
/^[0-9]/ {
    maps[curmap][curelem][0]=$1
    maps[curmap][curelem][1]=$2
    maps[curmap][curelem++][2]=$3
}

function lookup(num,depth, i) {
    if (depth>curmap)
        return num
    for (i=1;i<=length(maps[depth]);i++)
        if (maps[depth][i][1]<=num && num<=maps[depth][i][1]+maps[depth][i][2]-1)
            return lookup(maps[depth][i][0]+(num-maps[depth][i][1]),depth+1)
    return lookup(num,depth+1)
}

function overlap(l1,u1,l2,u2) {
    if (u1<l2 || u2<l1) return 0
    return 1
}

function lookupr(s,l,depth, i,ollo,olhi,drange) {
    if (depth>curmap)
        return s;
    for (i=1;i<=length(maps[depth]);i++)
        if (overlap(s,s+l-1,maps[depth][i][1],maps[depth][i][1]+maps[depth][i][2]-1)) {
            ollo=max(s,maps[depth][i][1])
            olhi=min(s+l-1,maps[depth][i][1]+maps[depth][i][2]-1)
            if (ollo>s) drange[0]=lookupr(s,ollo-s,depth)
            drange[1]=lookupr(maps[depth][i][0]+(ollo-maps[depth][i][1]),olhi-ollo+1,depth+1)
            if (olhi<s+l-1) drange[2]=lookupr(olhi+1,s+l-1-olhi,depth)
            asort(drange)
            return drange[1]
        }
    return lookupr(s,l,depth+1)
}

END {
    for (i in seeds)
        l[i]=lookup(seeds[i],1)
    asort(l)
    print "Part 1: " l[1]

    for (i=0;i<length(seeds);i+=2)
        l2[i]=lookupr(seeds[i],seeds[i+1],1)
    asort(l2)
    print "Part 2: "l2[1]
}
