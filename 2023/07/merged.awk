#!/usr/bin/env -S /bin/sh -c "exec awk -f ${_} input.txt"

BEGIN {
    PROCINFO["sorted_in"]="@val_num_desc"
    typestr["11111"]=1
    typestr["2111"]=2
    typestr["221"]=3
    typestr["311"]=4
    typestr["32"]=5
    typestr["41"]=6
    typestr["5"]=7
}

function gettype(chars, i,tmp) { for (i in chars) tmp=tmp chars[i]; return typestr[tmp] }
function prepranks(string, i,l,tmp) { l=split(string,tmp,""); for (i=1;i<=l;i++) ranks[tmp[i]]=i }

{
    hands[NR]=$1
    bids[$1]=$2
    split($1,cards,"")
    delete ccnt
    for (i in cards) ccnt[cards[i]]++
    types[$1]=gettype(ccnt)
    jacks=ccnt["J"]
    delete ccnt["J"]
    asort(ccnt)
    ccnt[length(ccnt)]+=jacks
    types2[$1]=gettype(ccnt)
}

function compare_hands(i1,v1,i2,v2, i,c1,c2,r1,r2) {
    if (types[v1] > types[v2]) return 1
    if (types[v1] < types[v2]) return -1
    for (i=1;i<6;i++) {
        r1=ranks[substr(v1,i,1)]
        r2=ranks[substr(v2,i,1)]
        if (r1>r2) return 1
        if (r1<r2) return -1
    }
    return 0
}

function getwinnings(string, winnings) {
    prepranks(string)
    l=asort(hands,newhands,"compare_hands");
    for (i=1;i<=l;i++)
        winnings+=i*bids[newhands[i]]
    return winnings
}

END {
    print "Part 1: " getwinnings("23456789TJQKA")
    for (i in types2) types[i]=types2[i]
    print "Part 2: " getwinnings("J23456789TQKA")
}
