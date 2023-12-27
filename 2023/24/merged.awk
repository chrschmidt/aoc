#!/usr/bin/env -S /bin/sh -c "exec awk -M -f ${_} -f ../../aoclib.awk input.txt"

{ split($0,stones[NR],/[, @]+/) }

function intersect_one(a,b,rl,ru, a1,a2,a4,a5,b1,b2,b4,b5,c1,c2,t,x,y) {
    a1=stones[a][1]; a2=stones[a][2]; a4=stones[a][4]; a5=stones[a][5]
    b1=stones[b][1]; b2=stones[b][2]; b4=stones[b][4]; b5=stones[b][5]
    c1=a1-b1; c2=a2-b2

    if (a5==0 && b5==0) # Paths are parallel, with dy=0
        return 0
    if (b5==0)          # libe b runs parallel to y-axis
        return intersect_one(b,a,rl,ru)
    if (a4 == a5*b4/b5) # Paths are parallal
        return 0
    t[0]=(c2*b4/b5-c1)/(a4-a5*b4/b5)
    t[1]=(c2+t[0]*a5)/b5
    if (t[0]<0 || t[1]<0)
        return 0

    x=a1+t[0]*a4
    y=a2+t[0]*a5
    if (x>=rl && x<=ru && y>=rl && y<=ru)
        return 1
    return 0
}

function intersect(rl,ru, i,j,sum) {
    for (i=1;i<NR;i++)
        for (j=i+1;j<=NR;j++)
            if (intersect_one(i,j,rl,ru))
                sum++
    return sum
}

END {
    print "Part 1: " intersect(200000000000000,400000000000000)

    a1=stones[1][1]; a2=stones[1][2]; a3=stones[1][3]; a4=stones[1][4]; a5=stones[1][5]; a6=stones[1][6]
    b1=stones[2][1]; b2=stones[2][2]; b3=stones[2][3]; b4=stones[2][4]; b5=stones[2][5]; b6=stones[2][6]
    c1=stones[3][1]; c2=stones[3][2]; c3=stones[3][3]; c4=stones[3][4]; c5=stones[3][5]; c6=stones[3][6]
    m[1][1]=b5-a5; m[1][2]=a4-b4; m[1][3]=0;     m[1][4]=a2-b2; m[1][5]=b1-a1; m[1][6]=0;     m[1][7]=a2*a4-a1*a5-b2*b4+b1*b5
    m[2][1]=b6-a6; m[2][2]=0;     m[2][3]=a4-b4; m[2][4]=a3-b3; m[2][5]=0;     m[2][6]=b1-a1; m[2][7]=a3*a4-a1*a6-b3*b4+b1*b6
    m[3][1]=0;     m[3][2]=b6-a6; m[3][3]=a5-b5; m[3][4]=0;     m[3][5]=a3-b3; m[3][6]=b2-a2; m[3][7]=a3*a5-a2*a6-b3*b5+b2*b6
    m[4][1]=c5-a5; m[4][2]=a4-c4; m[4][3]=0;     m[4][4]=a2-c2; m[4][5]=c1-a1; m[4][6]=0;     m[4][7]=a2*a4-a1*a5-c2*c4+c1*c5
    m[5][1]=c6-a6; m[5][2]=0;     m[5][3]=a4-c4; m[5][4]=a3-c3; m[5][5]=0;     m[5][6]=c1-a1; m[5][7]=a3*a4-a1*a6-c3*c4+c1*c6
    m[6][1]=0;     m[6][2]=c6-a6; m[6][3]=a5-c5; m[6][4]=0;     m[6][5]=a3-c3; m[6][6]=c2-a2; m[6][7]=a3*a5-a2*a6-c3*c5+c2*c6
    gauss(m)
    print "Part 2: " m[1][7]+m[2][7]+m[3][7]
}
