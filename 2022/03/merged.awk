#!/usr/bin/env -S awk -f ${_} -- input.txt
(FNR < NR) { exit }

BEGIN {
    for (i=1; i<=26; i++) prio[sprintf("%c", i+96)]=i
    for (i=27; i<=52; i++) prio[sprintf("%c", i+38)]=i
}

function cprio(s1, s2, s3,  items1, items2, items3) {
    split(s1,letters,""); for (l in letters) items1[letters[l]]=1
    split(s2,letters,""); for (l in letters) items2[letters[l]]=1
    split(s3,letters,""); for (l in letters) items3[letters[l]]=1
    for (i in items1)
	if (i in items2 && (!s3 || i in items3))
	    return prio[i]
}

{
    sum1+=cprio(substr($1, 1, length($1)/2), substr($1, length($1)/2+1))
    l3=l2
    l2=l1
    l1=$1
    if ((NR-1)%3==2) sum2+=cprio(l1, l2, l3)
}

END {
    print "Part 1: " sum1
    print "Part 2: " sum2
}
