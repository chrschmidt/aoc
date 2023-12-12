#!/usr/bin/env -S awk -f ${_} -- input.txt
(FNR < NR) { exit }

(NF == 1) { start = $1 }
(NF == 3) { insertions[$1] = $3 }

function insert(start, i, result) {
    result = substr(start, 1, 1)
    for (i=1; i<length(start); i++) {
        key = substr (start, i, 2)
        result = result insertions[key] substr (key, 2)
    }
    return result
}

END {
    for (i=1; i<=10; i++)
        start = insert(start)

    for (i=1; i<=length(start); i++)
        elements[substr(start,i,1)]++

    asort(elements, elements, "@val_num_asc")
    print "Part 1: " elements[length(elements)] - elements[1]
}
