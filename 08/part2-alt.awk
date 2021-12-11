#!/usr/bin/env -S awk -f ${_} -- input.txt

BEGIN { digits[8] = 127; split("abcdefg", chars, "") }

function atoi(a,  i, ret) {
    for (i in chars)
        if (index(a, chars[i]))
            ret = or(ret, lshift(1, i-1))
    return ret
}

($11 == "|") {
    for (i=1; i<=NF; i++)
        if (length($i)==2) digits[1] = atoi($i)
        else if (length($i) == 3) digits[7] = atoi($i)
        else if (length($i) == 4) digits[4] = atoi($i)
    for (i=1; i<=NF; i++)
        if (length($i) == 6) {
            digits[6] = atoi($i)
            segf = and(digits[6], digits[1])
            if (segf != digits[1]) break
        }
    segc = xor(digits[1], segf)
    for (i=1; i<=NF; i++)
        if (length($i) == 5) {
            inum = atoi($i)
            tmp = and(digits[1], inum)
            if (tmp == segf) digits[5] = inum
            else if (tmp == segc) digits[2] = inum
            else digits[3] = inum
        }
    digits[9] = or(digits[5], segc)
    digits[0] = xor(digits[8], and(digits[3], digits[4], compl(digits[1])))
    for (i in digits) keys[digits[i]] = i

    sum += 1000*keys[atoi($12)] + 100*keys[atoi($13)] + 10*keys[atoi($14)] + keys[atoi($15)]
}

END {
    print "sum: " sum
}
