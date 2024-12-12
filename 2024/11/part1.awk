#!/usr/bin/env -S /bin/sh -c "exec awk -f ../../aoclib.awk -f ${_} input.txt"

function blink(i) {
    n=1
    for (i=1;i<=length(line);i++) {
        if (line[i]==0)
            nline[n++]=1
        else if (length(line[i])%2==0) {
            nline[n++]=int(substr(line[i],1,length(line[i])/2))
            nline[n++]=int(substr(line[i],length(line[i])/2+1))
        } else
            nline[n++] = line[i] * 2024
    }
    delete (line)
    for (i=1;i<n;i++)
        line[i]=nline[i]
    delete nline
}

{
    for (i=1;i<=NF;i++)
        line[i]=$i
    for (i=0;i<25;i++)
        blink()
    print "Part 1: " length(line)
}
