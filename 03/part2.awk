#!/usr/bin/env -S awk -f ${_} -- input.txt

/^[01]/ { data[NR] = $1 }

function onecount(pos,arr,  count,i) {
    count = 0
    for (i in arr)
        if (substr(arr[i],pos,1) == "1")
            count++
    return count
}

function reduce(pos,arr,value, count,i) {
    for (i in arr)
        if (substr(arr[i],pos,1) != value)
            delete arr[i]
}

function oxgen(arr, pos) {
    for (pos=1; length(arr)>1; pos++) {
        count = onecount(pos, arr)
        if (count >= length(arr)/2)
            reduce(pos, arr, "1")
        else
            reduce(pos, arr, "0")
    }
    for (pos in arr)
        return arr[pos]
}

function co2scrub(arr, pos) {
    for (pos=1; length(arr)>1; pos++) {
        count = onecount(pos, arr)
        if (count < length(arr)/2)
            reduce(pos, arr, "1")
        else
            reduce(pos, arr, "0")
    }
    for (pos in arr)
        return arr[pos]
}

END {
    for (d in data)
        data2[d] = data[d]
    print oxgen(data) " " co2scrub(data2)
}
