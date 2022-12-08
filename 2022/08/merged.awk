#!/usr/bin/env -S /bin/sh -c "exec awk -f ${_} input.txt"

{
    forest[NR][0]
    split($1,forest[NR],"")
}

function ivl(l) {
    for (l=x-1;l;l--)
        if (forest[y][x] <= forest[y][l])
            return 0
    return 1
}

function ivr(l) {
    for (l=x+1;l<=length(forest[1]);l++)
        if (forest[y][x] <= forest[y][l])
            return 0
    return 1
}

function ivt(l) {
    for (l=y-1;l;l--)
        if (forest[y][x] <= forest[l][x])
            return 0
    return 1
}

function ivb(l) {
    for (l=y+1;l<=length(forest);l++)
        if (forest[y][x] <= forest[l][x])
            return 0
    return 1
}

function isvis() {
    return ivl() || ivr() || ivt() || ivb()
}

function score(l, sl, sr, st, sb) {
    for (l=x-1;l;l--) {
        sl++
        if (forest[y][x] <= forest[y][l]) {
            break
        }
    }
    for (l=x+1;l<=length(forest[1]);l++) {
        sr++
        if (forest[y][x] <= forest[y][l]) {
            break
        }
    }
    for (l=y-1;l;l--) {
        st++
        if (forest[y][x] <= forest[l][x]) {
            break
        }
    }
    for (l=y+1;l<=length(forest);l++) {
        sb++
        if (forest[y][x] <= forest[l][x]) {
            break
        }
    }

    return sl*sr*st*sb
}

END {
    for (i=1;i<=length(forest);i++) {
        visible[i,1] = 1
        visible[i,length(forest[i])] = 1
    }
    for (i=1;i<=length(forest[1]);i++) {
        visible[1,i] = 1
        visible[length(forest),i] = 1
    }
    for (y=2; y<length(forest); y++)
        for (x=2; x<length(forest[1]); x++)
            if (isvis()) visible[x,y] = 1
    print "Part 1: " length(visible)

    for (y=2; y<length(forest); y++)
        for (x=2; x<length(forest[1]); x++)
            if (score() > max)
                max=score()
    print "Part 2: " max
}
