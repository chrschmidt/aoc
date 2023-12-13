#!/usr/bin/env -S /bin/sh -c "exec awk -f ${_} -f ../../aoclib.awk input.txt"

(NF==1) {
    hpattern[++hpattern[0]]=$1
    vpattern[0]=split($1,line,"")
    for (i in line)
        vpattern[i]="" vpattern[i] line[i]
}

function dump2(n,p,h, i) {
    print n ":"
    for (i=1;i<=p[0];i++) {
        if (i==h || i==h+1)
            print "\033[1;93m" p[i] "\033[0m"
        else
            print p[i]
    }
}

function dump1(n,p, i) {
    print n ":"
    for (i=1;i<=p[0];i++)
        print p[i]
}

function dump() {
    dump1("H", hpattern)
    dump1("V", vpattern)
}

function check(pattern,mirror,  i) {
    mirror+=2
    for (i=mirror-3;i>0&&mirror<=pattern[0];i--) {
        if (pattern[i]!=pattern[mirror]) {
            print "Check failed at " i "<>" mirror
            return 0
        }
        mirror++
    }
    return 1
}

function reflection(n,pattern, i) {
    for (i=1;i<pattern[0];i++){
        if (pattern[i]==pattern[i+1] && check(pattern,i)) {
            dump2(n,pattern,i)
            return i
        }
    }
    return 0
}

(NF == 0) {
    print "H: " (h=reflection("H",hpattern)) " V: " (v=reflection("V",vpattern))
    if (h==0 && v==0) {
        print "Error: no reflection found"
        dump()
        exit
    }

    part1+=v+100*h
    delete hpattern
    delete vpattern
}

END {
    print "H: " (h=reflection("H",hpattern)) " V: " (v=reflection("V",vpattern))
    if (h==0 && v==0) {
        print "Error: no reflection found"
        dump()
        exit
    }

    part1+=v+100*h
    print "Part 1: " part1
    print "Part 2: " part2
}
