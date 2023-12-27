# MAAAAAATH

This solutions requires enabled Bignum support in awk.

## Input

Consider the input a list of 6-element arrays of numbers after removing syntactic sugar. A line a is given as x0=a1, y0=a2, z0=a3, dx=a4, dy=a5, dz=a6.

## Part 1

The input can be considered lines in parametric form. Thus the intersection is the point where
```
(1) a1+t*a4 = b1+s*b4 ⟺ a1-b1=s*b4-t*a4 
(2) a2+t*a5 = b2+s*b5 ⟺ a2-b2=s*b5-t*a5
```
Let c1=a1-b1 and c2=a2-b2
```
(1) c1=s*b4-t*a4
(2) c2=s*b5-t*a5 ⟺ c2+t*a5=s*b5 ⟺ (c2+t*a5)/b5=s
```
Insert (2) into (1)
```
c1=(c2+t*a5)/b5*b4-t*a4
⟺ t*a4=(c2+t*a5)/b5*b4-c1
⟺ t*a4=c2*b4/b5 + t*a5*b4/b5 - c1
⟺ t*a4 - t*a5*b4/b5 = c2*b4/b5 - c1
⟺ t (a4 - a5*b4/b5) = c2*b4/b5 - c1
⟺ t = (c2*b4/b5 - c1) / (a4 - a5*b4/b5)
```
Things can go wrong (division by zero). In this case, a b5 of 0 is mathematically unsolvable, although it can logically exist (y is constant).
If b5 and a5 are zero, the lines are parallel, and if b2 and a2 equal overlap and thus intersect all the way, else they never intersect. Would be pointless and is not checked.
If only b5 is zero, we can swap the indices and try again.

A second division by zero can occur if a4 equals a5*b4/b5. Again, this means they run in parallel.

Insert the the result into (2) to get s. Check if both are positive, and if the resulting intersection is in the required window.

## Part 2

Given the wording is is safe to assume that a solution exists. This yields 6 unknowns for the required throw:
```
x(t) = x0 + t*dx
y(t) = y0 + t*dy
z(t) = z0 + t*dz
```
To intersect with any line a, the same principle as in part1 can be used, except now the time needs to be identical, and the z axis taken into accound.
```
(1) x0+ta*dx = a1+ta*a4 ⟺ ta*dx-ta*a4 = a1-x0 ⟺ ta(dx-a4) = a1-x0 ⟺ ta = (a1-x0)/(dx-a4)
(2) y0+ta*dy = a2+ta*a5 ⟺ … ⟺ ta = (a2-y0)/(dy-a5)
(3) z0+ta*dz = a3+ta*a6 ⟺ … ⟺ ta = (a3-z0)/(dz-a6)
```
equating (1) and (2) eliminates ta:
```
(4) (a1-x0)/(dx-a4) = (a2-y0)/(dy-a5) 
⟺  (a1-x0)*(dy-a5) = (a2-y0)*(dx-a4)
⟺  a1*dy-a1*a5-x0*dy+x0*a5 = a2*dx-a2*a4-y0*dx+y0*a4
⟺  y0*dx-x0*dy = a2*dx-a2*a4+y0*a4-a1*dy+a1*a5-x0*a5
```
The left-hand side now only has terms that are independent of what the line intersects with. Using a second line b this yields a very similar equation:
```
(5) y0*dx-x0*dy = b2*dx-b2*b4+y0*b4-b1*dy+b1*b5-x0*b5
```
Equating these two yields:
```
(6) a2*dx-a2*a4+y0*a4-a1*dy+a1*a5-x0*a5 = b2*dx-b2*b4+y0*b4-b1*dy+b1*b5-x0*b5
⟺ -a5*x0+a4*y0+a2*dx-a1*dy-a2*a4+a1*a5 = -b5*x0+b4*y0+b2*dx-b1*dy-b2*b4+b1*b5
⟺ (b5-a5)*x0+(a4-b4)*y0+(a2-b2)*dx+(b1-a1)*dy = a2*a4-a1*a5-b2*b4+b1*b5
```
Which is a linear equation with 4 variables. This means a system of (at least) four such equations is needed. There's two ways of expanding this:
1. adding more lines, generating three more of (6), solving for t in at least two lines, solving for two points in two lines to get z coordinates, solving for dz from there, then solving for z0.
2. expanding toward x/z and y/z for 3 equations with 6 variables, then adding only a third line for 6 equations, and directly getting z0.

Equating (1) and (3) leaves (7), with line b results in (8):
```
(7) z0*dx-x0*dz = a3*dx-a3*a4+z0*a4-a1*dz+a1*a6-x0*a6
(8) (b6-a6)*x0+(a4-b4)*z0+(a3-b3)*dx+(b1-a1)*dz = a3*a4-a1*a6-b3*b4+b1*b6
```
Equating (2) and (3) leaves (9), with line b results in (10):
```
(9) z0*dy-y0*dz = a3*dy-a3*a5+z0*a5-a2*dz+a2*a6-y0*a6
(10) (b6-a6)*y0+(a5-b5)*z0+(a3-b3)*dy+(b2-a2)*dz = a3*a5-a2*a6-b3*b5+b2*b6
```
Adding a third line, c, in place of b leads to the required 6 equations, and the matrix
```
x0     y0      z0     dx     dy     dz    |
------------------------------------------+------------------------
b5-a5  a4-b4   0      a2-b2  b1-a1  0     | a2*a4-a1*a5-b2*b4+b1*b5
b6-a6  0       a4-b4  a3-b3  0      b1-a1 | a3*a4-a1*a6-b3*b4+b1*b6
0      b6-a6   a5-b5  0      a3-b3  b2-a2 | a3*a5-a2*a6-b3*b5+b2*b6
c5-a5  a4-c4   0      a2-c2  c1-a1  0     | a2*a4-a1*a5-c2*c4+c1*c5
c6-a6  0       a4-c4  a3-c3  0      c1-a1 | a3*a4-a1*a6-c3*c4+c1*c6
0      c6-a6   a5-c5  0      a3-c3  c2-a2 | a3*a5-a2*a6-c3*c5+c2*c6
```
which can be solved using Gaussian elimination.
