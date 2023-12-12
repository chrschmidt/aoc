#!/usr/bin/env -S awk -f ${_} -- input.txt
(FNR < NR) { exit }

function calculate() {
    sum1 += length(answers)
    for (i in answers) if (answers[i] == members) sum2++
    delete answers
    members=0
}

(NF == 0) { calculate() }
(NF > 0) { for (i=1; i<=length($1); i++) answers[substr($1,i,1)]++; members++ }

END {
    calculate()
    print "Part 1: " sum1
    print "Part 2: " sum2
}
