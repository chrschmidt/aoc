#!/usr/bin/env -S /bin/sh -c "exec awk -f ../../aoclib.awk -f ${_} input.txt"

{
    PROCINFO["sorted_in"]="@ind_num_desc"
    l=split($0,files,"")
    while (l>2*f) {
        for (i=0;i<files[2*f+1];i++)
            part1+=f*fpos++
        for (i=0;l>2*(f+1) && i<files[2*(f+1)];i++) {
            part1+=lf=int(l/2)*fpos++
            if (--files[l] == 0)
                l-=2
        }
        f++
    }
    print "Part 1: " part1
    l=split($0,files,"")
    fpos=0
    for (i=int(l/2);i>=0;i--)
        for (j=0;j<i;j++)
            if (files[2*i+1]<=files[2*(j+1)]) {
                moved[i]=j
                used[j][i]
                files[2*(j+1)]-=files[2*i+1]
                break
            }
    for (f=0;l>2*f;f++) {
        if (!(f in moved))
            for (i=0;i<files[2*f+1];i++)
                part2+=f*fpos++
        else
            fpos+=files[2*f+1]
        if (f in used)
            for (m in used[f])
                for (i=0;i<files[2*m+1];i++)
                    part2+=m*fpos++
        fpos+=files[2*(f+1)]
    }
    print "Part 2: " part2
}
