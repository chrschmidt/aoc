#!/usr/bin/env -S awk -f ${_} -- input.txt
(FNR < NR) { exit }

(NF == 1) { start = $1 }
(NF == 3) { insertions[$1] = $3 }

function addcache(cache, elements,  i, a) {
    split (cache, a, " ")
    for (i=1; i<length(a); i+=2)
        elements[a[i+1]] += a[i]
}

function calccacheline(pair, level,  p1, p2, i, e, ret) {
    p1 = substr(pair, 1, 1) insertions[pair]
    p2 = insertions[pair] substr(pair, 2, 1)

    addcache(cache[level-1][p1], e)
    addcache(cache[level-1][p2], e)
    e[insertions[pair]]++

    for (i in e)
        ret = ret " " e[i] " " i
    return ret
}

function buildcache(depth) {
    for (ins in insertions)
        cache[0][ins] = "1 " insertions[ins]
    for (level=1; level<depth; level++)
        for (pair in insertions)
            cache[level][pair] = calccacheline(pair, level)
}

END {
    buildcache(40)
    for (i=1; i<=length(start); i++)
        elements[substr(start, i, 1)]++
    for (i=1; i<length(start); i++)
        addcache(cache[39][substr(start, i, 2)], elements)

    asort(elements, elements, "@val_num_asc")
    print "Part 2: " elements[length(elements)] - elements[1]
}
