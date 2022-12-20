#!/usr/bin/env -S /bin/sh -c "exec awk -f ${_} input.txt"

function compare (ia,a,ib,b,  ca,cb) {
    if (a~/^[0-9]+/ && b~/^[0-9]+/) {
        if (int(a)<int(b)) return -1
        if (int(a)>int(b)) return 1
        return compare(0,gensub(/^[0-9]+/,"",1,a),0,gensub(/^[0-9]+/,"",1,b))
    }
    ca=substr(a,1,1)
    cb=substr(b,1,1)
    if (ca~/[\[\],]/ && ca==cb) return compare(0,substr(a,2),0,substr(b,2))
    if (ca=="]") return -1
    if (cb=="]") return 1
    if (ca=="[" && cb~/^[0-9]/) return compare(0,a,0,gensub(/^([0-9]+)/,"[\\1]",1,b))
    return compare(0,gensub(/^([0-9]+)/,"[\\1]",1,a),0,b)
}

$1 {
    lines[NR]=$1
    getline lines[NR+1]
    c++
    if (compare(0,lines[NR-1],0,lines[NR])==-1)
        sum+=c
}

END {
    print "Part 1: " sum
    lines[NR+1]="[[2]]"
    lines[NR+2]="[[6]]"
    asort(lines,lines,"compare")
    for (i in lines)
        if (lines[i]~/^\[\[[26]\]\]$/)
            key=key?key*i:i
    print "Part 2: " key
}
