#!/usr/bin/env -S /bin/sh -c "exec awk -f ${_} input.txt"

/^mask/ {
    mask=$3
    ormask=0
    andmask=0
    for (i=1; i<37; i++) {
        if (substr($3,i,1) == "1") ormask=or(ormask, lshift (1, 36-i))
        if (substr($3,i,1) == "0") andmask=or(andmask, lshift(1, 36-i))
    }
}

function writev2(addr, val,  start, i) {
    for (i=start; i<36; i++) {
        if (substr(mask,i+1,1)=="X") {
            if (i==35) v2mem[and(addr, compl(lshift(1, 35-i)))] = val
            else writev2(and(addr, compl(lshift(1, 35-i))), val, i+1)
            addr=or(addr, lshift(1, 35-i))
        }
        if (i==35)
            v2mem[addr] = val
    }
}

/^mem/ {
    match($1,/[0-9]+/,a)
    v1mem[a[0]]=and(or($3, ormask), compl(andmask))
    writev2(or(a[0], ormask), $3)
}

END {
    for (m in v1mem)
        sum1+=v1mem[m]
    print "Part 1: " sum1
    for (m in v2mem)
        sum2+=v2mem[m]
    print "Part 2: " sum2
}
