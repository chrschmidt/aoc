#!/usr/bin/env -S /bin/sh -c "exec awk -f ${_} input.txt"

{
    split($1,world[FNR],"")
    lines[FNR]=$1
}

END {
    for (i in lines) {
        o=0
        for (s=lines[i];match(s,/[0-9]+/,a);s=substr(s,RSTART+RLENGTH)) {
            valid=0
            for (j=o+RSTART;j<o+RSTART+RLENGTH;j++)
                for (x=-1;x<2;x++)
                    for (y=-1;y<2;y++)
                        if (world[i+y][j+x] ~ /[^0-9.]/) {
                            valid=1
                            if (world[i+y][j+x]=="*")
                                gears[i+y,j+x][a[0]]=1
                        }
            if (valid)
                sum+=a[0]
            o+=RSTART+RLENGTH-1
        }
    }
    print "Part 1: " sum
    for (i in gears)
        if (asorti(gears[i])==2)
            gearsum+=gears[i][1]*gears[i][2]
    print "Part 2: " gearsum
}
