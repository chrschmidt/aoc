#!/usr/bin/env -S awk -n -f ${_} -- input.txt
(FNR < NR) { exit }

{
    for (i=0; i<length($1); i++)
        for (j=0; j<4; j++)
            bits[4*i+j] = and(int("0x" substr($1, i+1, 1)), lshift(1,3-j)) ? 1 : 0
}

function getbits(len,  i, ret) {
    for (i=0; i<len; i++)
        ret = lshift(ret,1) + bits[bitpos++]
    return ret
}

function readpacket(type, cont, data, tpc, tbitpos, tmp, i) {
    vsum += getbits(3)
    type = getbits(3)
    if (type == 4) {
        do {
            cont = getbits(1)
            data = lshift(data, 4) + getbits(4)
        } while(cont)
    } else {
        if (getbits(1)) tpc = getbits(11)
        else tbitpos = getbits(15) + bitpos
        data = readpacket()
        if (type < 4)
            while ((tbitpos && bitpos < tbitpos) || --tpc>0) {
                tmp = readpacket()
                if      (type == 0) data += tmp
                else if (type == 1) data *= tmp
                else if (type == 2 && tmp < data) data = tmp
                else if (type == 3 && tmp > data) data = tmp
            }
        else if (type == 5) data = data > readpacket()
        else if (type == 6) data = data < readpacket()
        else if (type == 7) data = data == readpacket()
    }
    return data
}

END {
    result = readpacket()
    print "Part 1: " vsum
    print "Part 2: " result
}
