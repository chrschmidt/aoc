#!/usr/bin/env -S /bin/sh -c "exec awk -f ${_} -f ../../aoclib.awk input.txt"

{
    gsub (/[:]/,"")
    for (i=2;i<=NF;i++) {
       conns[$1][$i]
       conns[$i][$1]
    }
}

function try(g,sbc,i,j,l,sum) {
    for (i in conns)
        g[i]=0
    do {
        l=asorti(g,sbc,"@val_num_desc")
        for (i=1;i<=l&&g[sbc[i]]==g[sbc[1]];i++) ;
        delete g[sbc[int(rand()*(i-1))+1]]
        sum=0
        for (i in g) {
            g[i]=0
            for (j in conns[i])
                if (!(j in g))
                    g[i]++
            sum+=g[i]
        }
    } while (sum>3)
    if (sum==3) return length(g)
}

END {
    srand()
    do { t=try() } while (!t)
    print "Part 1: " t*(length(conns)-t)
}
