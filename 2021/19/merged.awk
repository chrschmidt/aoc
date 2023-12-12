#!/usr/bin/env -S awk -f ${_} -- input.txt
(FNR < NR) { exit }

/--- scanner [[:digit:]]+ ---/ { scanner = $3; values = 1 }
/-?[[:digit:]]+,-?[[:digit:]]+,-?[[:digit:]]+/ { input[scanner][values++] = $1 }

function trans(c, m, sx, sy, sz, cs, ms, retval) {
    split(c, cs, ",")
    split(m, ms, ",")
    retval =            cs[1]*ms[1] + cs[2]*ms[4] + cs[3]*ms[7] + sx
    retval = retval "," cs[1]*ms[2] + cs[2]*ms[5] + cs[3]*ms[8] + sy
    retval = retval "," cs[1]*ms[3] + cs[2]*ms[6] + cs[3]*ms[9] + sz
    return retval
}

function round(x) { if (x<=0) return int(x-0.5); else return int(x+0.5)  }

BEGIN {
    pi = atan2(0, -1)
    for (x=0; x<360; x+=90) {
        cx = round(cos(x*pi/180)); sx = round(sin(x*pi/180))
        for (y=0; y<360; y+=90) {
            cy = round(cos(y*pi/180)); sy = round(sin(y*pi/180))
            for (z=0; z<360; z+=90) {
                cz = round(cos(z*pi/180)); sz = round(sin(z*pi/180))
                key =         (cy*cz) "," (-cx*sz+sx*sy*cz) "," (sx*sz+cx*sy*cz)
                key = key "," (cy*sz) "," (cx*cz+sx*sy*sz)  "," (-sx*cz+cx*sy*sz)
                key = key "," (-sy)   "," (sx*cy)           "," (cx*cy)
                transpose[key] = key
            }
        }
    }
    print length(transpose) " transposition matrices generated"
}

function abs(a) { return a<0?-a:a }
function max(a, b) { return a>b?a:b }

function mdistance(a, b,  pointa, pointb) {
    split(a, pointa, ",")
    split(b, pointb, ",")
    return abs(pointa[1]-pointb[1]) + abs(pointa[2]-pointb[2]) + abs(pointa[3]-pointb[3])
}

function rotate(source, tid, comp, sx, sy, sz,  i) {
    for (i in source)
        comp[i] = trans(source[i], transpose[tid], sx, sy, sz)
}

function try_expand(inputa, dista, inputb, distb, start, seta, setb,  slen, rot, i, dx, dy, dz, pa, pb) {
    slen = length(seta)
    if (slen == 12) {
        for (t in transpose) {
            rotate(inputb, t, rot)
            split(inputa[seta[0]], pa, ",")
            split(rot[setb[0]], pb, ",")
            dx = pa[1] - pb[1]; dy = pa[2] - pb[2]; dz = pa[3] - pb[3]
            for (i=1; i<12; i++) {
                split(inputa[seta[i]], pa, ",")
                split(rot[setb[i]], pb, ",")
                if (dx != pa[1] - pb[1] || dy != pa[2] - pb[2] || dz != pa[3] - pb[3])
                    break
            }
            if (i!= 12) continue
            rotate(inputb, t, inputb, dx, dy, dz)
            distb["scanner"] = (-dx) "," (-dy) "," (-dz)
            return 1
        }
    } else {
        for (pa=start; pa<length(inputa)-10+slen; pa++) {
            seta[slen] = pa
            for (pb in inputb) {
                setb[slen] = pb
                for (i=0; i<slen; i++)
                    if (dista[seta[i],pa] != distb[setb[i],pb])
                        break
                if (i == slen && try_expand(inputa, dista, inputb, distb, pa+1, seta, setb))
                    return 1
            }
        }
    }
    delete seta[slen]
    delete setb[slen]
}

function try_match(inputa, dista, inputb, distb,  pa, pb, seta, setb) {
    for (pa=1; pa<length(inputa)-10; pa++) {
        seta[0] = pa
        for (pb in inputb) {
            setb[0] = pb
            if (try_expand(inputa, dista, inputb, distb, pa+1, seta, setb))
                return 1
        }
    }
}

END {
    for (sid in input)
        for (pa in input[sid])
            for (pb in input[sid])
                distances[sid][pa,pb] = mdistance(input[sid][pa],input[sid][pb])

    matched[0] = 1
    while (length(matched) != length(input)) {
        for (sida in matched) {
            if (matched[sida]++ > 1) continue
            for (sidb in input) {
                if (sidb in matched) continue
                print "Matching " sida " and " sidb
                if (try_match(input[sida], distances[sida], input[sidb], distances[sidb])) {
                    matched[sidb] = 1
                    print sida " and " sidb " matched!"
                    print "Scanner Position: " distances[sidb]["scanner"]
                }
            }
        }
    }
    for (sid in input)
        for (pa in input[sid])
            world[input[sid][pa]] = 1
    print "Part 1: " length(world)

    distances[0]["scanner"] = "0,0,0"
    for (sida in input)
        for (sidb in input)
            maxmdistance = max(maxmdistance, mdistance(distances[sida]["scanner"], distances[sidb]["scanner"]))
    print "Part 2: " maxmdistance
}
