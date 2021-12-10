#!/usr/bin/env -S awk -f ${_} -- input.txt

(FILENAME != "input.txt") { exit }

{
    delete stack
    for (i=1; i<=length($1); i++) {
        c = substr($1,i,1)
        if (index("([{<", c))
            stack[length(stack)+1] = c
        else {
            last = stack[length(stack)]
            delete stack[length(stack)]
            if (index(")]}>", c) != index("([{<", last)) next
        }
    }
    if (length(stack) == 0) next
    points = 0
    for (i=length(stack); i; i--)
        points = 5 * points + index("([{<", stack[i])
    scores[points] = points
}

END {
    asort(scores)
    print scores[int(length(scores)/2)+1]
}
