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

function min(a,b) {
    return (a<b)?a:b
}

function max(a,b) {
    return (a>b)?a:b
}
