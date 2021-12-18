#!/usr/bin/env -S awk -f ${_} -- input.txt
(FNR < NR) { exit }

{ input[FNR] = $1 }

function sfexplode(number,  i, level, lastnum, n) {
    lastnum=1
    for (i=1; i<length(number); i++) {
        if (substr(number, i, 1) == "[") {
            if (++level == 5) {
                match(substr(number, lastnum), /([[:digit:]]*)([],[]+)\[([[:digit:]]+),([[:digit:]]+)\]([],[]+)([[:digit:]]*)/, n)
                return (n[1,"length"] ? substr(number, 1, lastnum-1) n[1] + n[3] : "")  n[2] 0 n[5] (n[6,"length"] ? n[4] + n[6] substr(number, lastnum + RLENGTH) : "") 
            }
        } else if (substr(number, i, 1) == "]") level--
        else if (substr(number, i, 1) != "," && (substr(number, i-1, 1) == "," || substr(number, i-1, 1) == "[")) lastnum = i
    }
    return number
}

function sfsplit(number,  n) {
    if (match(number, /[[:digit:]]{2,}/, n)) return substr(number, 1, RSTART-1) "[" int(n[0]/2) "," n[0]-int(n[0]/2) "]" substr(number, RSTART + RLENGTH)
    return number
}

function sfreduce(number, len) {
    do {
        len = length(number)
        number = sfexplode(number)
        if (len == length(number)) number = sfsplit(number)
    } while (len != length(number))
    return number
}

function sfmagnitude(number,  numbers) {
    while (match(number, /\[([[:digit:]]+),([[:digit:]]+)\]/, numbers))
        number = substr(number, 1, RSTART-1) 3*numbers[1] + 2*numbers[2] substr(number, RSTART + RLENGTH)
    return int(number)
}

function max(a,b) { return a > b ? a : b }

END {
    sum = input[1]
    for (i=2; i<=length(input); i++)
        sum = sfreduce("[" sum ","  input[i] "]")
    print "Part 1: " sfmagnitude(sum)

    for (i=1; i<=length(input); i++)
        for (j=1; j<=length(input); j++)
            if (i != j)
                maxsum = max(maxsum, sfmagnitude(sfreduce("[" input[i] "," input[j] "]")))
    print "Part 2: " maxsum
}
