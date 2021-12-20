#!/usr/bin/env -S awk -f ${_} -- input.txt
(FNR < NR) { exit }

(FNR == 1) { key = gensub(/\./, "0", "g", gensub(/#/, "1", "g")) }
(FNR > 1 && NF == 1) { image[imgy++] = gensub(/\./, "0", "g", gensub(/#/, "1", "g")) }

function pix(x, y) { return (x>=0 && x<imgx && y>=0 && y<imgy) ? substr(image[y], x+1, 1) : outside }
function getsum(x, y) { return 256*pix(x-1,y-1)+128*pix(x,y-1)+64*pix(x+1,y-1)+32*pix(x-1,y)+16*pix(x,y)+8*pix(x+1,y)+4*pix(x-1,y+1)+2*pix(x,y+1)+pix(x+1,y+1) }

function iterate(y, x, i, newimg) {
    for (y=-1; y<=imgy; y++)
        for (x=-1; x<=imgx; x++)
            newimg[y+1] = newimg[y+1] substr(key, 1+getsum(x, y), 1)
    for (i in newimg)
	image[i] = newimg[i]
    imgx += 2; imgy += 2
    outside = outside == 0 ? substr(key, 1, 1) : substr(key, 512, 1)
}

function sum(s) {
    for (y=0; y<imgy; y++)
	for (x=1; x<=imgx; x++)
	    s = s + substr(image[y], x, 1)
    return s
}

END {
    imgx = length(image[0])
    iterate()
    iterate()
    print "Part 1: " sum()
    for (i=0; i<48; i++)
	iterate()
    print "Part 2: " sum()
}
