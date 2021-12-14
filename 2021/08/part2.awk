#!/usr/bin/env -S awk -f ${_} -- input.txt
(FNR < NR) { exit }

BEGIN { digits[8] = "abcdefg" }

function ssort(a,  ret, i, tmp) {
    split(a, tmp, "")
    asort(tmp)
    for (i=1; i<=length(tmp); i++)
        ret = ret tmp[i]
    return ret
}

function not_in(a, b,  i) {
    for (i=1; i<=length(a); i++)
        if (!index(b, substr(a,i,1)))
            return substr(a,i,1)
}

{
    for (i=1; i<=NF; i++)
        if (length($i)==2) digits[1] = $i
        else if (length($i) == 3) digits[7] = $i
        else if (length($i) == 4) digits[4] = $i
    for (i=1; i<=NF; i++) if (length($i) == 6) {
            digits[6] = $i
            segc = not_in(digits[1], $i)
            if (segc) break
    }
    segf = not_in(digits[1], segc)
    for (i=1; i<=NF; i++)
        if (length($i) == 5) {
            tmp = not_in(digits[1], $i)
            if (tmp == segc) digits[5] = $i
            else if (tmp == segf) digits[2] = $i
            else digits[3] = $i
        }
    sege = not_in(digits[2], digits[3])
    segb = not_in(digits[5], digits[3])
    segd = not_in(digits[4], digits[1] segb)
    segg = not_in(digits[3], digits[7] segd)
    digits[9] = digits[5] segc
    digits[0] = digits[7] segb sege segg
    for (i in digits) keys[ssort(digits[i])] = i

    sum += 1000*keys[ssort($12)] + 100*keys[ssort($13)]
    sum += 10*keys[ssort($14)] + keys[ssort($15)]
}

END {
    print "sum: " sum
}
