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
