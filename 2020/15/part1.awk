#!/usr/bin/env -S /bin/sh -c "exec awk -F, -f ${_} input.txt"

{
    for (i=1; i<NF; i++) numbers[$i]=i
    last=$NF
    start=NF+1
}

END {
    for (turn=start; turn<=2020; turn++) {
        prev=last
        if (last in numbers) last=turn-1-numbers[last]
        else last=0
        numbers[prev]=turn-1
    }
    print "Part 1: " last
}
