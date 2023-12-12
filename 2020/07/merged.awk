#!/usr/bin/env -S awk -f ${_} -- input.txt
(FNR < NR) { exit }

{
    if ($0 ~ /no other bags/) bags[$1$2]=""
    else for (i=5; i<NF; i+=4)
        bags[$1$2][$(i+1)$(i+2)]=$i
}

function hasrecurse(haystack, needle,  bag) {
    if (haystack == needle) return 1
    if (!isarray(bags[haystack])) return 0
    for (bag in bags[haystack])
        if (hasrecurse(bag, needle))
            return 1
    return 0
}

function sumbags(color,  sum) {
    if (!isarray(bags[color])) return 1
    for (bag in bags[color])
        sum+=bags[color][bag]*sumbags(bag)
    return sum+1
}

END {
    for (bag in bags)
        if (hasrecurse(bag, "shinygold"))
            sum1++
    print "Part 1: " sum1-1
    print "Part 2: " sumbags("shinygold")-1
}
