#!/usr/bin/env -S /bin/sh -c "exec awk -f ${_} input.txt"

BEGIN { delete lines }

function compare (a,b,  ca,cb) {
    if (a~/^[0-9]+/ && b~/^[0-9]+/) {
        if (int(a)<int(b)) return 1
        if (int(a)>int(b)) return -1
        return compare(gensub(/^[0-9]+/,"",1,a),gensub(/^[0-9]+/,"",1,b))
    }
    ca=substr(a,1,1)
    cb=substr(b,1,1)
    if (ca~/[\[\],]/ && ca==cb) return compare(substr(a,2),substr(b,2))
    if (ca=="]") return 1
    if (cb=="]") return -1
    if (ca=="[" && cb~/^[0-9]/) return compare(a,gensub(/^([0-9]+)/,"[\\1]",1,b))
    if (cb=="[" && ca~/^[0-9]/) return compare(gensub(/^([0-9]+)/,"[\\1]",1,a),b)
}

function scompare(i1,v1,i2,v2) { return -compare(v1,v2) }

$1 {
    l1=$1
    lines[length(lines)+1]=l1
    getline l2
    lines[length(lines)+1]=l2
    c++
    if (compare(l1,l2)==1)
        sum+=c
}

END {
    print "Part 1: " sum
    lines[length(lines)+1]="[[2]]"
    lines[length(lines)+1]="[[6]]"
    asort(lines,lines,"scompare")
    key=1
    for (i in lines)
        if (lines[i]=="[[2]]" || lines[i]=="[[6]]")
            key*=i
    print "Part 2: " key
}
