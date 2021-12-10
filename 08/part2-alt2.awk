#!/usr/bin/env -S awk -f ${_} -- input.txt

BEGIN { digits[8] = 127; split("abcdefg", chars, ""); PROCINFO["sorted_in"]="lsort" }

function atoi(a,  i, ret) {
    for (i in chars)
        if (index(a, chars[i]))
            ret = or(ret, lshift(1, i-1))
    return ret
}

function lsort(i1, v1, i2, v2) { return v1 == v2 ? 0 : v1 == 5 || (v1 > v2 && v2 != 5) ? 1 : -1 }

($11 == "|") {
    for (i=1; i<=NF; i++)
        lengths[i] = length($i)
    for (i in lengths) {
        num = atoi($i)
        if (lengths[i] == 2) digits[1] = num
        else if (lengths[i] == 3) digits[7] = num
        else if (lengths[i] == 4) digits[4] = num
        else if (lengths[i] == 5) {
            if (and(num, digits[7]) == digits[7]) digits[3] = num
            else if (and(num, digits[9]) == num) digits[5] = num
            else digits[2] = num
        } else if (lengths[i] == 6) {
            if (and(num, digits[1]) != digits[1]) digits[6] = num
            else if (and(num, digits[4]) == digits[4]) digits[9] = num
            else digits[0] = num
        }
    }
    for (i in digits) keys[digits[i]] = i

    sum += 1000*keys[atoi($12)] + 100*keys[atoi($13)] + 10*keys[atoi($14)] + keys[atoi($15)]
}

END {
    print "sum: " sum
}
