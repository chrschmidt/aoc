#!/usr/bin/env -S awk -n -f ${_} -- input.txt
(FNR < NR) { exit }

{ inputlen = split($1, nibbles, "") }

function tobits(i, j, dec) {
    for (i=1; i<=inputlen; i++) {
        dec = int("0x" nibbles[i])
        for (j=3; j>=0; j--)
            bits[4*(i-1)+3-j] = and(dec, lshift(1,j)) ? 1 : 0
    }
        
}

function getbits(len,  i, ret) {
    for (i=0; i<len; i++)
        ret = lshift(ret,1) + bits[bitpos++]
    return ret
}

function readpacket(packet,  len, cont, data, ltid, dlen, splen, spnum, i, spc) {
    if (isarray(packet)) delete packet
    packet["version"] = getbits(3)
    vsum += packet["version"]
    packet["type"] = getbits(3)
    len = 6
    if (packet["type"] == 4) {
        do {
            cont = bits[bitpos++]
            data = lshift(data, 4) + getbits(4)
            len += 5
        } while(cont)
        packet["value"] = data
    } else {
        ltid = bits[bitpos++]
        len++
        if (ltid == 0) {
            splen = getbits(15)
            len += 15
            do {
                packet["sub"][++spc][0]
                dlen += readpacket(packet["sub"][spc])
            } while (dlen < splen)
            len += dlen
        } else {
            spnum = getbits(11)
            len += 11
            for (i=0; i<spnum; i++) {
                packet["sub"][++spc][0]
                dlen += readpacket(packet["sub"][spc])
            }
            len += dlen
        }
    }
    packet["length"] = len
    return len
}

END {
    tobits()
    do {
        packets++
        rd += readpacket(packet)
        print "packet " packets " total " rd " " packet["version"] " " packet["type"]
    } while (rd < 4*inputlen-11)
    print "Part 1: " vsum
}
