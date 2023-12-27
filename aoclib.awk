# Greatest Common Divisor by Euclid's algorithm implemented as modulo
# Input is expected as a,b>0
function gcd(a,b, t) {
    while (b!=0) {
        t=a%b
        a=b
        b=t
    }
    return a
}

# Least Common Multiple implemented by using the greatest common divisor
function lcm(a,b) {
    return a*b/gcd(a,b)
}

# Manhattan distance between two coordinates
function manhattan(x1,y1,x2,y2) {
    return abs(x1-x2)+abs(y1-y2)
}

function min(a,b) {
    return (a<b)?a:b
}

function max(a,b) {
    return (a>b)?a:b
}

function abs(a) {
    return (a<0)?-a:a
}

# Linear equation system solver using Gaussian Elimination
function gauss(m, h,w,i,j,k,mul1,mul2,t) {
    h=length(m); w=length(m[1])
    if (w!=h+1) { print "ERROR: Gauss solver: matrix has wrong dimensions"; exit }

    for (i=1;i<h;i++) {
        if (m[i][i]==0) {
            for (j=i;j<=h;j++) {
                if (m[j][i]!=0) {
                    for (k=1;k<=w;k++) { t=m[i][k]; m[i][k]=m[j][k]; m[j][k]=t }
                    break
                }
            }
        }
        if (m[i][i]==0) { print "ERROR: Gauss solver: unrecoverable 0 in diagonal"; exit }
        mul1=m[i][i]
        for (j=i+1;j<=h;j++) {
            mul2=m[j][i]
            for (k=i;k<=w;k++)
                m[j][k]=mul1*m[j][k]-mul2*m[i][k]
        }
    }

    for (i=h;i;i--) {
        for (j=i+1;j<w;j++) {
            m[i][w]-=m[i][j]*m[j][w]
            m[i][j]=0
        }
        m[i][w]/=m[i][i]
        m[i][i]=1
    }
}

