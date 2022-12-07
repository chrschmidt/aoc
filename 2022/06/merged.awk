#!/usr/bin/env -S /bin/sh -c "exec awk -f ${_} input.txt"

function part(seqlen,  i, j, t) {
    for (i=0; i<=length(a)-seqlen; i++) {
        delete t
        for (j=1; j<=seqlen; j++)
            t[a[i+j]]=1
        if (length(t)==seqlen)
            return i+seqlen
    }
}

{
    split($0, a, "")
    print "Part 1: " part(4)
    print "Part 2: " part(14)
}
