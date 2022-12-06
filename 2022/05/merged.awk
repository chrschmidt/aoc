#!/usr/bin/env -S /bin/sh -c "exec awk -f ${_} input.txt"

/\[/ {
    for (s=2; s<length($0); s+=4)
        if (substr($0,s,1) != " ")
            stacks1[(s+2)/4] = substr($0,s,1) stacks1[(s+2)/4]
}

/^$/ { for (s in stacks1) stacks2[s]=stacks1[s] }

/move/ {
    for (i=0; i<$2; i++)
        stacks1[$6] = stacks1[$6] substr(stacks1[$4],length(stacks1[$4])-i,1)
    stacks2[$6] = stacks2[$6] substr(stacks2[$4],length(stacks2[$4])-$2+1)
    stacks1[$4] = substr(stacks1[$4],1,length(stacks1[$4])-$2)
    stacks2[$4] = substr(stacks2[$4],1,length(stacks2[$4])-$2)
}

END {
    for (i=1; i<=length(stacks1); i++) {
        part1 = part1 substr(stacks1[i],length(stacks1[i]))
        part2 = part2 substr(stacks2[i],length(stacks2[i]))
    }
    print "Part 1: " part1
    print "Part 2: " part2
}
