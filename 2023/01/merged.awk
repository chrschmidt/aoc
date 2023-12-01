#!/usr/bin/env -S /bin/sh -c "exec awk -f ${_} input.txt"

BEGIN {
    for (i=1;i<=9;i++) tl[i]=i
    tl["one"]=1;   tl["two"]=2;   tl["three"]=3
    tl["four"]=4;  tl["five"]=5;  tl["six"]=6
    tl["seven"]=7; tl["eight"]=8; tl["nine"]=9
    for (t in tl) r=r "|" t
    sr=substr(r,2)
    er=".*(" sr ")"
}

{
    split($1,a,/[1-9]/,s)
    part1+=10*s[1]+s[length(s)]
    split($1,a,sr,s)
    match($1,er,b)
    part2+=10*tl[s[1]]+tl[b[1]]
}

END {
    print "Part 1: " part1
    print "Part 2: " part2
}
