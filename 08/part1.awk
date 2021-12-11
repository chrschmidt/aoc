#!/usr/bin/env -S awk -F| -f ${_} -- input.txt
(FNR < NR) { exit }

{
    split ($2, digits, " ")
    for (digit in digits) lenghts[length(digits[digit])]++
}

END {
    print lenghts[2] + lenghts[4] + lenghts[3] + lenghts[7]
}
