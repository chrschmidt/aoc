#!/usr/bin/env -S /bin/sh -c "exec awk -f ../../aoclib.awk -f ${_} input.txt"

function blink(i) {
    for (i in line)
        if (i==0)
            nline[1]+=line[0]
        else if (length(i)%2==0) {
            nline[int(substr(i,1,length(i)/2))]+=line[i]
            nline[int(substr(i,length(i)/2+1))]+=line[i]
        } else
            nline[i*2024]+=line[i]
    delete (line)
    for (i in nline)
        line[i]=nline[i]
    delete nline
        
}

{
    for (i=1;i<=NF;i++)
        line[$i]++
    for (i=0;i<25;i++)
        blink()
    for (i in line)
        part1+=line[i]
    print "Part 1: " part1
    for (i=25;i<75;i++)
        blink()
    for (i in line)
        part2+=line[i]
    print "Part 2: " part2
}
