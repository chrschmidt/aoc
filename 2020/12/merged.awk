#!/usr/bin/env -S awk -f ${_} -- input.txt

BEGIN { dir = 90; x = 0; y = 0; wpx = 10; wpy = 1; sx = 0; sy = 0 }

function abs(a) { if (a<0) return -a; else return a }

function rot(degs) {
    dir+=degs; dir%=360
    if (degs == 90) { tmp = wpx; wpx = wpy; wpy = -tmp }
    else if (degs == 180) { wpx = -wpx; wpy = -wpy }
    else if (degs == 270) { tmp = wpx; wpx = -wpy; wpy = tmp}
}

/N/ { dist = substr($0,2); y+=dist; wpy+=dist }
/S/ { dist = substr($0,2); y-=dist; wpy-=dist }
/E/ { dist = substr($0,2); x+=dist; wpx+=dist }
/W/ { dist = substr($0,2); x-=dist; wpx-=dist }
/L/ { degs = substr($0,2); rot(360-degs) }
/R/ { degs = substr($0,2); rot(degs) }
/F/ {
    dist = substr($0,2)
    if (dir == 0) y+=dist
    else if (dir == 90) x+=dist
    else if (dir == 180) y-=dist
    else if (dir == 270) x-=dist
    sx+=dist*wpx; sy+=dist*wpy
}

END {
    print "Part 1: " abs(x)+abs(y)
    print "Part 2: " abs(sx)+abs(sy)
}
