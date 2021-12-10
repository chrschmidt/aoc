#!/usr/bin/env -S awk -f ${_} -- input.txt

(FILENAME != "input.txt") { exit }

BEGIN {
    scores[")"] = 3
    scores["]"] = 57
    scores["}"] = 1197
    scores[">"] = 25137
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
                points += scores[c]
                next
            }
        }
    }
}

END {
    print points
}
