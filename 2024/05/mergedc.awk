#!/usr/bin/env -S /bin/sh -c "exec awk -f ../../aoclib.awk -f ${_} input.txt"

/\|/ {
    split($0,a,/\|/)
    order[a[1]][a[2]]
}

function check(s, i,j,t) {
    for (i=s;i<l;i++)
        for (j=i+1;j<=l;j++)
            if ((a[j] in order) && (a[i] in order[a[j]])) {
                t=a[i]
                a[i]=a[j]
                a[j]=t
                return i
            }
    return 0
}

/,/ {
    l=split($0,a,/,/)
    c=check(1)
    if (c) {
        do c=check(c); while(c)
        part2+=a[l/2+.5]
    } else
        part1+=a[l/2+.5]
}

END {
    print "Part 1: " part1
    print "Part 2: " part2
}
