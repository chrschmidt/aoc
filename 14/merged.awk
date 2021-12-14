#!/usr/bin/env -S awk -f ${_} -- input.txt
(FNR < NR) { exit }

(NF == 1) { start = $1 }
(NF == 3) { insertions[$1] = $3 }

function addcache(cache, elements,  i) {
    for (i in cache)
        elements[i] += cache[i]
}

function calccacheelement(pair, level) {
    cache[level][pair][insertions[pair]] = 1
    addcache(cache[level-1][substr(pair, 1, 1) insertions[pair]], cache[level][pair])
    addcache(cache[level-1][insertions[pair] substr(pair, 2, 1)], cache[level][pair])
}

function buildcache(depth,  level, pair) {
    for (pair in insertions)
        cache[0][pair][insertions[pair]] = 1
    for (level=1; level<depth; level++)
        for (pair in insertions)
            calccacheelement(pair, level)
}

function calcpart(part, depth,  elements) {
    for (i=1; i<=length(start); i++)
        elements[substr(start, i, 1)]++
    for (i=1; i<length(start); i++)
        addcache(cache[depth][substr(start, i, 2)], elements)
    asort(elements, elements, "@val_num_asc")
    print "Part " part ": " elements[length(elements)] - elements[1]
}

END {
    buildcache(40)
    calcpart(1, 9)
    calcpart(2, 39)
}
