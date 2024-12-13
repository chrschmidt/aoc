#!/usr/bin/env -S /bin/sh -c "exec awk -f ../../aoclib.awk -f ${_} input.txt"

/Button A/ { xa=substr($3,3,length($3)-3); ya=substr($4,3) }
/Button B/ { xb=substr($3,3,length($3)-3); yb=substr($4,3) }
/Prize/ {
    px=substr($2,3,length($2)-3); py=substr($3,3)
    m[1][1]=xa; m[1][2]=xb; m[1][3]=px
    m[2][1]=ya; m[2][2]=yb; m[2][3]=py
    gauss(m)
    if (int(m[1][3])==m[1][3] && int(m[2][3])==m[2][3])
        part1+=3*m[1][3]+m[2][3]
    m[1][1]=xa; m[1][2]=xb; m[1][3]=10000000000000+px
    m[2][1]=ya; m[2][2]=yb; m[2][3]=10000000000000+py
    gauss(m)
    if (int(m[1][3])==m[1][3] && int(m[2][3])==m[2][3])
        part2+=3*m[1][3]+m[2][3]
}

END {
    print "Part 1: " part1
    print "Part 2: " part2
}
