#!/usr/bin/env -S awk -f ${_} -- input.txt
(FNR < NR) { exit }

(NF == 1) { start = $1 }
(NF == 3) { insertions[$1] = $3 }

function addcache(cache, elements,  i) { for (i in cache) elements[i] += cache[i] }

# The basic idea of turning the exponential growth into something that can be
# processed in linear time is that we do not need the sequence itself, but only
# the number of characters in it.
# There are only n different pairs. For each iteration, we can calculate what is
# inserted into a given pair. In the first iteration (level = 0), this is the
# character given through the input file. In every further iteration, this is
# this character, plus the previous level calculation for the newly created pairs
# of [left character, new character] and [new character, right character].
# Since only the number of characters that need to be inserted are tracked, the
# memory usage can even be kept constant - after calculating the insertions at
# level n using level n-1, the data for level n-1 could be discarded. This is
# not done here, as the data amount is insignificant, and we need two different
# levels for the two parts of the solution.

function buildcache(depth,  level, pair) {
    for (pair in insertions)
        cache[0][pair][insertions[pair]] = 1
    for (level=1; level<depth; level++)
        for (pair in insertions) {
            cache[level][pair][insertions[pair]] = 1
	    addcache(cache[level-1][substr(pair, 1, 1) insertions[pair]], cache[level][pair])
	    addcache(cache[level-1][insertions[pair] substr(pair, 2, 1)], cache[level][pair])
	}
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
