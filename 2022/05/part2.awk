#!/usr/bin/env -S /bin/sh -c "exec awk -f ${_} input.txt"

/\[/ {
    sl=length($0)/4
    for (s=0;s<sl;s++)
        rd[s][NR] = substr($0,4*s+2,1)
}

/^$/ {
    for (col=0;col<length(rd);col++)
        for (row=1;row<=length(rd[col]);row++)
            if (rd[col][row]!=" ")
                stacks[col+1][length(rd[col])-row]=rd[col][row]
}     

/move/ {
    for (i=0; i<$2; i++)
        stacks[$6][length(stacks[$6])] = stacks[$4][length(stacks[$4])-$2+i]
    for (i=0; i<$2; i++) 
        delete stacks[$4][length(stacks[$4])-1]
}

END {
    printf "Part 2: "
    for (i=1;i<=length(stacks); i++)
        printf "%s", stacks[i][length(stacks[i])-1];
    printf "\n"
}
