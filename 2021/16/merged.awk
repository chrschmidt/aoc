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

function readpacket(packet,  cont, data, sp, spc, i) {
    if (isarray(packet)) delete packet
    packet["version"] = getbits(3)
    vsum += packet["version"]
    packet["type"] = getbits(3)
    if (packet["type"] == 4) {
        do {
            cont = bits[bitpos++]
            data = lshift(data, 4) + getbits(4)
        } while(cont)
        packet["value"] = data
    } else {
        if (bits[bitpos++] == 0) {
            sp = bitpos + getbits(15) + 15
            do {
                packet["sub"][++spc][0]
                readpacket(packet["sub"][spc])
            } while (bitpos < sp)
        } else {
            sp = getbits(11)
            for (spc=1; spc<=sp; spc++) {
                packet["sub"][spc][0]
                readpacket(packet["sub"][spc])
            }
        }
        if (packet["type"] == 0) {
            for (i=1; i<=length(packet["sub"]); i++)
                packet["value"] += packet["sub"][i]["value"]
        } else if (packet["type"] == 1) {
            packet["value"] = 1
            for (i=1; i<=length(packet["sub"]); i++)
                packet["value"] *= packet["sub"][i]["value"]
        } else if (packet["type"] == 2) {
            packet["value"] = packet["sub"][1]["value"]
            for (i=2; i<=length(packet["sub"]); i++)
                if (packet["sub"][i]["value"] < packet["value"])
                    packet["value"] = packet["sub"][i]["value"]
        } else if (packet["type"] == 3) {
            packet["value"] = packet["sub"][1]["value"]
            for (i=2; i<=length(packet["sub"]); i++)
                if (packet["sub"][i]["value"] > packet["value"])
                    packet["value"] = packet["sub"][i]["value"]
        } else if (packet["type"] == 5) {
            packet["value"] = packet["sub"][1]["value"] > packet["sub"][2]["value"]
        } else if (packet["type"] == 6) {
            packet["value"] = packet["sub"][1]["value"] < packet["sub"][2]["value"]
        } else if (packet["type"] == 7) {
            packet["value"] = packet["sub"][1]["value"] == packet["sub"][2]["value"]
        }
    }
}

END {
    tobits()
    readpacket(packet)
    print "Part 1: " vsum
    print "Part 2: " packet["value"]
}
