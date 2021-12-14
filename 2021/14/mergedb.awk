#!/usr/bin/env -S awk -f ${_} -- input.txt
(FNR < NR) { exit }

(NF == 1) { start = $1 }
(NF == 3) { insertions[$1] = $3 }

# Inspired by https://github.com/theck

function calcpart(part, depth,  pairs, elements) {
    for (i=1; i<length(start); i++)
        pairs[substr(start, i, 2)]++
    for (i=1; i<=depth; i++) {
	for (pair in pairs) {
	    newpairs[substr(pair,1,1) insertions[pair]] += pairs[pair]
	    newpairs[insertions[pair] substr(pair,2,1)] += pairs[pair]
	}
	delete pairs
	for (pair in newpairs) pairs[pair] = newpairs[pair]
	delete newpairs
    }
    for (pair in pairs)
	elements[substr(pair,2,1)] += pairs[pair]
    elements[substr(pair,1,1)]++
    asort(elements, elements, "@val_num_asc")
    print "Part " part ": " elements[length(elements)] - elements[1]
}

END {
    calcpart(1, 10)
    calcpart(2, 40)
}
