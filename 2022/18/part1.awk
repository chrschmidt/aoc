#!/usr/bin/env -S /bin/sh -c "exec awk -F, -f ${_} input.txt"

{
    cubes[$1,$2,$3]=6
    if (($1-1,$2,$3) in cubes) { cubes[$1,$2,$3]--; cubes[$1-1,$2,$3]-- }
    if (($1+1,$2,$3) in cubes) { cubes[$1,$2,$3]--; cubes[$1+1,$2,$3]-- }
    if (($1,$2-1,$3) in cubes) { cubes[$1,$2,$3]--; cubes[$1,$2-1,$3]-- }
    if (($1,$2+1,$3) in cubes) { cubes[$1,$2,$3]--; cubes[$1,$2+1,$3]-- }
    if (($1,$2,$3-1) in cubes) { cubes[$1,$2,$3]--; cubes[$1,$2,$3-1]-- }
    if (($1,$2,$3+1) in cubes) { cubes[$1,$2,$3]--; cubes[$1,$2,$3+1]-- }
}

END {
    sum=0
    for (cube in cubes)
        sum+=cubes[cube]
    print "Part 1: " sum
}
