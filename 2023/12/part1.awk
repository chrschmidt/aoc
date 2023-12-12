#!/usr/bin/env -S /bin/sh -c "exec awk -f ${_} -f ../../aoclib.awk input.txt"
function valid(start,run, pos,i,sum,upper) {
#    printf "  Validating run %d of length %d at position %d\n", run, sizes[run], start
    for (pos=start;pos<start+sizes[run];pos++)
        if (line[pos]==".")
            return 0
#    print "    Passed test 1, pos is now " pos
    if (pos<=length(line) && line[pos]=="#")
        return 0
#    print "    Passed test 2"
    pos++
    if (run==length(sizes)) {
        for (;pos<=length(line);pos++)
            if (line[pos]=="#")
                return 0
#            else print pos
#        print "    Passed test 3"
        return 1
    }
    run++
    for (i=run;i<=length(sizes);i++) upper+=sizes[i]+1
    upper=length(line)-(upper-1)+1
#    print "    Not complete, upper " upper
    for (;pos<=upper;pos++)
        switch (line[pos]) {
        case "#": return sum+valid(pos,run)
        case "?": sum+=valid(pos,run)
        }
    return sum
}        

function calc(i,upper,pos,sum) {
    for (i=1;i<=length(sizes);i++) upper+=sizes[i]+1
    upper=length(line)-(upper-1)+1
#    print "Calc line " NR ": upper is " upper " length is " length(line)
    for (pos=1;pos<=upper;pos++)
        switch (line[pos]) {
        case "#": return sum+valid(pos,1)
        case "?": sum+=valid(pos,1)
        }
    return sum
}

{
    split($1,line,"")
    split($2,sizes,/,/)
    t=calc()
    part1+=t
#    printf "Line %4d: %2d\n", NR, t
}

END {
    print "Part 1: " part1
}
