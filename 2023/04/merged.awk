#!/usr/bin/env -S /bin/sh -c "exec awk -f ${_} input.txt"

{
    delete winning
    for (i=3;$i!="|";i++)
        winning[$i]=$i
    for (i++;i<=NF;i++)
        if ($i in winning)
            matches[NR]++
}

END {
    for (i=1;i<=NR;i++) {
        if (i in matches)
            sum+=2^(matches[i]-1)
        sum2+=++stack[i]
        for (j=i+1;j<=i+matches[i];j++)
            stack[j]+=stack[i]
    }
    print "Part 1: " sum
    print "Part 2: " sum2
}
