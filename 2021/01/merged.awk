#!/usr/bin/env -S awk -f ${_} -- input.txt
(FNR < NR) { exit }

{
    if ((FNR > 1) && ($1 > t1))
	part1++
    if ((FNR > 3) && (t2+t1+$1 > t3+t2+t1))
        part2++
    t3 = t2
    t2 = t1
    t1 = $1
}

END {
    print "Part 1: " part1
    print "Part 2: " part2
}
