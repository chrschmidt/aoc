#!/usr/bin/env -S /bin/sh -c "exec awk -f ${_} -f ../../aoclib.awk input.txt"

BEGIN { for (i=32; i<=126; i++) chars[sprintf("%c",i)]=i }

function ord(c) { return chars[c] }

function hash(s, hashn,chars,i,l) {
    l=split(s,chars,"")
    for (i=1;i<=l;i++)
        hashn=and((hashn+ord(chars[i]))*17,255)
    return hashn
}

{
    l=split($0,input,",")
    for (i=1;i<=l;i++)
        part1+=hash(input[i])
}

END {
    print "Part 1: " part1
}
