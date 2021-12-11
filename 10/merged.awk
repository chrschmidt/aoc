#!/usr/bin/env -S awk -f ${_} -- input.txt
(FNR < NR) { exit }

BEGIN {
    pscores[")"] = 3
    pscores["]"] = 57
    pscores["}"] = 1197
    pscores[">"] = 25137
}

{
    delete stack
    for (i=1; i<=length($1); i++) {
        c = substr($1,i,1)
        if (index("([{<", c))
            stack[length(stack)+1] = c
        else {
            last = stack[length(stack)]
            delete stack[length(stack)]
            if (index(")]}>", c) != index("([{<", last)) {
                points1 += pscores[c]
                next
            }
        }
    }
    if (length(stack) == 0) next
    points = 0
    for (i=length(stack); i; i--)
        points = 5 * points + index("([{<", stack[i])
    scores[points] = points
}

END {
    print "Part 1: " points1
    asort(scores)
    print "Part 2: " scores[int(length(scores)/2)+1]
}
