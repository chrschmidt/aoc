#!/usr/bin/env -S /bin/sh -c "exec awk -f ${_} input.txt"

/ or / {
    gsub(/ or /, "-")
    split($0,w,": ")
    key=w[1]
    ranges[key][0]
    split(w[2],ranges[key],"-")
}

/^[0-9]/ {
    if (!ticket) ticket=$1;
    else nearby[NR]=$1;
}

function in_ranges(val, ranges) {
    return (val>=ranges[1] && val<=ranges[2]) || (val>=ranges[3] && val<=ranges[4])
}

function valid(val,  key, val_ok) {
    for (key in ranges)
        if (in_ranges(val, ranges[key]))
            return 1
    return 0
}

function dump() {
    print ""
    for (key in ranges) {
        printf key ":"
        for (i=1;i<=length(ranges);i++)
            if (i in fields[key])
                printf " " i
        printf "\n"
    }
}

function prticket() {
    split(ticket,vals,",")
    for (key in fields)
        print key ": " vals[fields[key][1]]
}

END {
    for (n in nearby) {
        split(nearby[n],vals,",")
        for (v in vals)
            if (!valid(vals[v])) {
                sum+=vals[v]
                delete nearby[n]
                break
            }
    }
    print "Part 1: " sum

    numfields=length(ranges)
    for (key in ranges)
        for (i=1;i<=length(ranges);i++)
            fields[key][i]
    for (n in nearby) {
        split(nearby[n],vals,",")
        for (v in vals)
            for (key in fields)
               if (v in fields[key] && !in_ranges(vals[v],ranges[key]))
                   delete fields[key][v]
    }
    loop=1
    while (loop) {
        loop=0
        for (key in fields)
            if (length(fields[key])==1) {
                for (erase in fields[key])
                    for (key2 in fields)
                        if (key != key2)
                            delete fields[key2][erase]
            } else
                loop=1
    }
    for (key in fields)
        asorti(fields[key])
    sum=1
    split(ticket,vals,",")
    for (key in fields)
        if (key~/^departure/)
            sum*=vals[fields[key][1]]
    print "Part 2: " sum
}
