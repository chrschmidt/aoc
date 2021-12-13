#!/usr/bin/env -S awk -f ${_} -- input.txt
(FNR < NR) { exit }

(NF == 1) {
    split($1, tmp, ",")
    paper[tmp[1]][tmp[2]] = 1
    if (tmp[1] > maxx) maxx = tmp[1]
    if (tmp[2] > maxy) maxy = tmp[2]
}
(NF == 3) { folds[FNR] = $3 }

function fold(rule,  r, x, y) {
    split (rule,r,"=")
    if (r[1] == "y") {
        for (y=r[2]+1; y<=maxy; y++)
            for (x=0; x<=maxx; x++)
                if (paper[x][y])
                    paper[x][r[2]-(y-r[2])] = 1
        maxy = r[2]-1
    } else {
        for (y=0; y<=maxy; y++)
            for (x=r[2]+1; x<=maxx; x++)
                if (paper[x][y])
                    paper[r[2]-(x-r[2])][y] = 1
        maxx = r[2]-1
    }
}

function count(x, y, c) {
    for (x=0; x<=maxx; x++)
        for (y=0; y<=maxy; y++)
            if (paper[x][y]) c++
    return c
}

function dump(x, y) {
    for (y=0; y<=maxy; y++) {
        for (x=0; x<=maxx; x++)
            printf ("%c", paper[x][y] == 1 ? "#" : " ")
        printf ("\n")
    }
}

END {
    asort(folds, folds, "@ind_num_asc")
    for (f in folds) {
        fold(folds[f])
        if (f==1)
            print "Part 1: " count()
    }
    print "Part 2:"
    dump()
}
