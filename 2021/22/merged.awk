#!/usr/bin/env -S awk -f ${_} -- input.txt

function min(a, b) { return a < b ? a : b }
function max(a, b) { return a > b ? a : b }
function abs(a) { return a < 0 ? -a : a }

/^(on|off) / {
    match ($0, /(.*) x=(-?[[:digit:]]+)\.\.(-?[[:digit:]]+),y=(-?[[:digit:]]+)\.\.(-?[[:digit:]]+),z=(-?[[:digit:]]+)\.\.(-?[[:digit:]]+)/, n)
    mode[FNR] = (n[1]=="on" ? 1 : 0) 
    cuboids[FNR] = n[2] "," n[3] "," n[4] "," n[5] "," n[6] "," n[7]
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

function getintersection(cuboida, cuboidb,  ca, cb, x, y, z) {
    split(cuboida, ca, ",");
    split(cuboidb, cb, ",");
    if (ca[1]>cb[2] || cb[1]>ca[2] || ca[3]>cb[4] || cb[3]>ca[4] || ca[5]>cb[6] || cb[5]>ca[6]) return
    x[0] = ca[1]; x[1] = ca[2]; x[2] = cb[1]; x[3] = cb[2]; asort(x)
    y[0] = ca[3]; y[1] = ca[4]; y[2] = cb[3]; y[3] = cb[4]; asort(y)
    z[0] = ca[5]; z[1] = ca[6]; z[2] = cb[5]; z[3] = cb[6]; asort(z)
    return (x[2] "," x[3] "," y[2] "," y[3] "," z[2] "," z[3])
}

function getsize(cuboid,  c) {
    split(cuboid, c, ",");
    return (abs(c[2]-c[1])+1) * (abs(c[4]-c[3])+1) * (abs(c[6]-c[5])+1)
}

function process(level, i, j, k, l, intersection, sorted, ik, jk, mo) {
    children[level+1][0]
    asorti(children[level], sorted)
    l = length(sorted)
    for (i=1; i<=l; i++)
        for (j=i+1; j<=l; j++) {
            ik = sorted[i]; jk = sorted[j]
            intersection = getintersection(ik, jk)
            if (intersection) {
                mo = max(children[level][ik]["order"], children[level][jk]["order"])
                if (intersection in children[level+1])
                    children[level+1][intersection]["order"] = max(children[level+1][intersection]["order"], mo)
                else
                    children[level+1][intersection]["order"] = mo
                children[level+1][intersection]["parents"][ik] = 1
                children[level+1][intersection]["parents"][jk] = 1
            }
        }
    delete children[level+1][0]
    if (length(children[level+1]) > 0)
        process(level+1)
    for (i in children[level]) {
        if (!(i in flattened)) {
            flattened[i][0] = children[level][i]["order"]
            flattened[i][1] = getsize(i)
            if ("children" in children[level][i])
                for (j in children[level][i]["children"])
                    flattened[i][1] -= flattened[j][1]
        }
        if ("parents" in children[level][i])
            for (j in children[level][i]["parents"]) {
                children[level-1][j]["children"][i] = 1
                if ("children" in children[level][i])
                    for (k in children[level][i]["children"])
                        children[level-1][j]["children"][k] = 1
            }
    }
}

function add_cuboid(order, cuboid,  i, intersection, sum) {
    if (!cuboid) return 0
    children[0][order]
    for (i=1; i<order; i++) {
        intersection = getintersection(cuboid, cuboids[i])
        if (intersection) children[0][intersection]["order"] = i
    }
    delete children[0][order]
    process(0)
    for (i in flattened)
        if (mode[flattened[i][0]])
            sum += flattened[i][1]
    delete flattened
    delete children
    return mode[order] * getsize(cuboids[order]) - sum
}

END {
    print "Part 1: " length(reactor)
    for (i=1; i<=length(cuboids); i++)
        sum += add_cuboid(i, cuboids[i])
    print "Part 2: " sum
}
