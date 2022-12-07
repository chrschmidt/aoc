#!/usr/bin/env -S /bin/sh -c "exec awk -f ${_} input.txt"

function parent(d) { return gensub(/(.*\/)[^/]+\//, "\\1", "g", d) }

/^\$ cd/ {
    if ($NF == "/")       path="/"
    else if ($NF == "..") path=parent(path)
    else                  path=path $NF "/"
    dirsize[path]
}

/^[0-9]+/ { dirsize[path]+=$1 }

END {
    dirs=asorti (dirsize, dirnames, "@ind_str_desc")
    for (i=1; i<dirs; i++) {
        dirsize[parent(dirnames[i])]+=dirsize[dirnames[i]]
        if (dirsize[dirnames[i]] <= 100000)
            sum+=dirsize[dirnames[i]]
    }
    print "Part 1: " sum
    delreq=30000000-(70000000-dirsize["/"])
    mindel=70000000
    for (d in dirsize)
        if (dirsize[d]>=delreq && dirsize[d]<mindel)
            mindel=dirsize[d]
    print "Part 2: " mindel
}
