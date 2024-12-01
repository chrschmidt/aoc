#!/usr/bin/env -S /bin/sh -c "exec awk -f ../../aoclib.awk -f ${_} input.txt"

{
    list1[FNR]=$1
    list2[FNR]=$2
}

END {
    asort(list1)
    asort(list2)
    for (i in list1) {
        part1+=abs(list2[i]-list1[i])
        list2c[list2[i]]++
    }
    print "Part 1: " part1
    for (i in list1)
        part2+=list1[i]*list2c[list1[i]]
    print "Part 2: " part2
}
