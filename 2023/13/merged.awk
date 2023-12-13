#!/usr/bin/env -S /bin/sh -c "exec awk -f ${_} -f ../../aoclib.awk input.txt"

(NF==0) { calc() }
(NF==1) {
    split($1,pattern[++pattern[0]],"")
    for (i in pattern[pattern[0]])
        if (pattern[pattern[0]][i]=="#") pattern[pattern[0]][i]=1
        else pattern[pattern[0]][i]=0
}

function dump(hhl,hvl, i,j) {
    for (i=1;i<=pattern[0];i++) {
        for (j=1;j<length(pattern[1]);j++) {
            if (i==hvl||i==hvl+1||j==hhl||j==hhl+1)
                printf "\033[1;93m" pattern[i][j] "\033[0m"
            else
                printf pattern[i][j]
        }
        printf "\n"
    }
    printf "\n"
}

function cmpx(x1,x2, y) {
    for (y=1;y<=pattern[0];y++)
        if (pattern[y][x1]!=pattern[y][x2])
            return 0
    return 1
}

function checkx(s, xl,xu) {
    xl=s-1; xu=s+2
    while (xl>0&&xu<=length(pattern[1])) {
        if (!cmpx(xl,xu))
            return 0
        xl--; xu++
    }
    return 1
}

function cmpy(y1,y2, x) {
    for (x=1;x<=length(pattern[1]);x++)
        if (pattern[y1][x]!=pattern[y2][x])
            return 0
    return 1
}

function checky(s, yl,yu) {
    yl=s-1; yu=s+2
    while (yl>0&&yu<=pattern[0]) {
        if (!cmpy(yl,yu))
            return 0
        yl--; yu++
    }
    return 1
}

function calchv(last, x,y) {
    # Vertical mirror
    for (x=1;x<length(pattern[1]);x++) {
        if (last!=x&&cmpx(x,x+1)&&checkx(x)) {
            dump(x,-1)
            return x
        }
    }
    # Vertical mirror
    last/=100
    for (y=1;y<pattern[0];y++) {
        if (last!=y&&cmpy(y,y+1)&&checky(y)) {
            dump(-1,y)
            return 100*y
        }
    }
}

function calc(x,y,orig,result1,result2) {
    print "Pattern " ++patterns
    part1+=(result1=calchv(0))

    for (y=1;y<=pattern[0];y++)
        for (x=1;x<=length(pattern[1]);x++) {
            pattern[y][x]=!pattern[y][x]
            if ((result2=calchv(result1))) {
                delete pattern
                part2+=result2
                return
            }
            pattern[y][x]=!pattern[y][x]
        }
}

END {
    if (pattern[0]>0) calc()
    print "Part 1: " part1
    print "Part 2: " part2
}
