#!/usr/bin/env -S awk -f ${_} -- input.txt
(FNR < NR) { exit }

function sfexplode(numbers, syntax,  i, j, level) {
    for (i=0; i<length(syntax); i++)
        for (j=1; j<=length(syntax[i]); j++)
            if (substr(syntax[i], j, 1) == "[") {
                if (++level == 5) {
                    if (i > 0) numbers[i] += numbers[i+1]
                    if (i < length(numbers)-2) numbers[i+3] += numbers[i+2]
                    numbers[i+2] = 0
                    syntax[i] = substr(syntax[i], 1, length(syntax[i])-1)
                    syntax[i+2] = substr(syntax[i+2], 2)
                    for (j=i+1; j<length(numbers); j++) { numbers[j] = numbers[j+1]; syntax[j] = syntax[j+1] }
                    delete numbers[length(numbers)]
                    delete syntax[length(syntax)-1]
                    return 1
                }
            } else if (substr(syntax[i], j, 1) == "]") level--
    return 0
}

function sfsplit(numbers, syntax,  i, j, l) {
    l = length(numbers)
    for (i=1; i<=l; i++)
        if (numbers[i] >= 10) {
            for (j=l; j>=i; j--) { numbers[j+1] = numbers[j]; syntax[j+1] = syntax[j] }
            numbers[i+1] = numbers[i] -  int(numbers[i]/2)
            numbers[i] -= numbers[i+1]
            syntax[i-1] = syntax[i-1] "["
            syntax[i] = ","
            syntax[i+1] = "]" syntax[i+1]
            return 1
        }
    return 0
}

function sfreduce(numbers, syntax) {
    while (sfexplode(numbers, syntax) || sfsplit(numbers, syntax)) ;
}

function sfadd(a, b,  sum, i, numbers, syntax, retval) {
    sum = "[" a "," b "]"
    patsplit(sum, numbers, /[[:digit:]]+/, syntax)
    sfreduce(numbers, syntax)
    for (i=0; i<length(syntax); i++)
        retval = retval syntax[i] numbers[i+1]
    return retval
}

function sfmagnitude(number,  i, numbers, syntax, retval) {
    do {
        patsplit(number, numbers, /[[:digit:]]+,[[:digit:]]+/, syntax)
        for (i=1; i<=length(numbers); i++) {
            split(numbers[i], halves, ",")
            numbers[i] = 3*halves[1] + 2*halves[2]
            syntax[i-1] = substr(syntax[i-1], 1, length(syntax[i-1])-1)
            syntax[i] = substr(syntax[i], 2)
        }
        number = ""
        for (i=0; i<length(syntax); i++)
            number = number syntax[i] numbers[i+1]
    } while (!(number ~ /^[[:digit:]]+$/))
    return int(number)
}

{ input[FNR] = $1 }

function max(a,b) { return a > b ? a : b }

END {
    for (i=1; i<=length(input); i++)
        for (j=1; j<=length(input); j++)
            if (i != j)
                maxsum = max(maxsum, sfmagnitude(sfadd(input[i], input[j])))
    print "Part 2: " maxsum

}
