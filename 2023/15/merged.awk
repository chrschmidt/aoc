#!/usr/bin/env -S /bin/sh -c "exec awk -f ${_} -f ../../aoclib.awk input.txt"

BEGIN { for (i=32; i<=126; i++) chars[sprintf("%c",i)]=i }

function ord(c) { return chars[c] }

function hash(s, hashn,chars,i,l) {
    l=split(s,chars,"")
    for (i=1;i<=l;i++)
        hashn=and((hashn+ord(chars[i]))*17,255)
    return hashn
}

function power(b,l,p) {
    for (b in boxes)
        for (l in boxes[b][1])
            p+=(b+1)*l*boxes[b][2][boxes[b][1][l]]
    return p
}

{
    inputs=split($0,input,",");
    for (i=1;i<=inputs;i++) {
        part1+=hash(input[i])
        split(input[i],vals,/[=-]/,op);
        box=hash(vals[1])
        if (op[1]=="=") {
            if (!(vals[1] in boxes[box][2]))
                boxes[box][1][++boxes[box][0]]=vals[1]
            boxes[box][2][vals[1]]=vals[2]
        } else {
            if (vals[1] in boxes[box][2]) {
                if (boxes[box][0]==1) {
                    delete boxes[box]
                } else {
                    delete boxes[box][2][vals[1]]
                    for (b in boxes[box][1])
                        if (boxes[box][1][b]==vals[1]) {
                            delete boxes[box][1][b]
                            boxes[box][0]=asort(boxes[box][1],boxes[box][1],"@ind_num_asc")
                        }
                }
            }
        }
    }
}

END {
    print "Part 1: " part1
    print "Part 2: " power()
}
