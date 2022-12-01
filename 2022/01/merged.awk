#!/usr/bin/env -S awk -f ${_} -- input.txt
(FNR < NR) { exit }

/^$/ { elf++ }
/[0-9]+/ { sums[elf]+=$1 }

END {
    asort(sums,sums,"@val_num_desc")
    print "Part 1: " sums[1]
    print "Part 2: " sums[1]+sums[2]+sums[3]
}
