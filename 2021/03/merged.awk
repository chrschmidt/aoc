#!/usr/bin/env -S awk -f ${_} -- input.txt

/^[01]/ { data[FNR] = $1 }

function onecount(pos, arr,  count, i) {
    for (i in arr)
        count += substr(arr[i], pos, 1) == "1"
    return count
}

function reduce(pos, arr, value,  i) {
    for (i in arr)
        if (substr(arr[i], pos, 1) != value)
            delete arr[i]
}

function oxgen(arr,  pos) {
    for (pos=1; length(arr)>1; pos++)
        reduce(pos, arr, onecount(pos, arr) >= length(arr)/2)
    for (pos in arr)
        return arr[pos]
}

function co2scrub(arr,  pos) {
    for (pos=1; length(arr)>1; pos++)
        reduce(pos, arr, onecount(pos, arr) < length(arr)/2)
    for (pos in arr)
        return arr[pos]
}

function gamma(arr,  i, j, ones, gammas) {
    for (i in arr)
        for (j=1; j<=length(arr[i]); j++)
            if (substr(arr[i], j, 1) == "1")
                ones[j]++
    for (i=1; i<=length(ones); i++)
        if (ones[i] > (length(arr)/2)) gammas = gammas "1"
	else gammas = gammas "0"
    return gammas
}

END {
    for (d in data)
        data2[d] = data[d]
    print gamma(data) " " oxgen(data) " " co2scrub(data2)
}
