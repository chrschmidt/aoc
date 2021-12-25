#!/usr/bin/env -S awk -f ${_} -- input.txt
(FNR < NR) { exit }

function min(a, b) { return a < b ? a : b }
function max(a, b) { return a > b ? a : b }

{
    match ($0, /(.*) x=(-?[[:digit:]]+)\.\.(-?[[:digit:]]+),y=(-?[[:digit:]]+)\.\.(-?[[:digit:]]+),z=(-?[[:digit:]]+)\.\.(-?[[:digit:]]+)/, n)
    if (n[2]<=50 && n[3]>=-50 && n[4]<=50 && n[5]>=-50 && n[6]<=50 && n[7]>=-50) {
        xmin = max(n[2], -50); xmax = min(n[3], 50)
        ymin = max(n[4], -50); ymax = min(n[5], 50)
        zmin = max(n[6], -50); zmax = min(n[7], 50)
        for (x=xmin; x<=xmax; x++)
            for (y=ymin; y<=ymax; y++)
                for (z=zmin; z<=zmax; z++)
                    if (n[1] == "on") reactor[x,y,z] = 1
                    else delete reactor[x,y,z]
    }
}

END {
    print "Part 1: " length(reactor)
}
