# TOO MUCH MATH AND THINKING

## Introduction

Part 1 is considered trivial. With an even number of steps, since you can go forth and back, any field with an even number of steps to it can be a final field. Make 64 steps, and count the number of fields that have been reached with an even number of steps.

Part 2 is where things get tricky, and assumptions have to be made again.

## Assumptions

These assumptions are:

1. A certain degree of symmetry can be reached to interpolate without having to walk all worlds.
2. This degree of symmetry is
    1. The height and length of the world is identical, so horizontal and vertical interpolation is equal.
    2. The height and length are odd numbers, and
    3. The starting point is exactly in the center so there is no offset in any direction.
3. The horizontal and vertical center lines are open, they do not contain any rocks.
4. The outside has an empty ring. This becomes necessary for later calculations.
5. The ending point is at the edge of the last block.

With these assumptions, the furthest out points lie 26501365 steps (puzzle text) straight up, right, down, or left from the starting point. Any other point is enclosed within diagonal lines from these points due to the 90° stepping scheme.

## Counting

This yields 14 types of worlds to be considered:

1. Complete worlds in which any odd numbered point can be an ending point (the number of steps is odd, see part 1).
2. Complete worlds in which any even numbered point can be an ending point. Since the length/height of a world is odd, every other world is odd/even.
3. 4 V-shaped world on the outermost ends (<, ^, >, or v shaped, to be precise)
4. 4 / or \ split world types, for each diagonal line. Since symmetry demands that we start in the middle of a world, We end up with differene shapes and corners. Corners depend on the two connected end points, and shapes/size alternate per line, so
   1. 4 small triangualar block
   2. 4 large blocks where the triangle would expand beyond the reach of the block
5. There might be more than one incomplete end, if the ending point is in the first half of the last block. We'll assume that the length of the data set is 131, which, with 26501365 steps, gets us to exactly to the end of the 202300th world after the starting block.

In the following, only the length (wl) is used; height could be used synonymously due to symmetry.

### Complete worlds

Starting with 1. and 2., it makes sense to first calculate the total number of worlds. 

(1) The starting point is ((number of steps - steps in the center world)/ world length), rounded down to ignore partial steps in the final world, for the complete worlds between the starting and the outsidemost world.
```
d=int((26501365-int(xl/2))/xl) (d for diameter of our resulting giant world)
```
If the end of the final world is reached, d needs to be decreased by one. Due to assumption 4, this is always the case.

(2) Double (1) for symmetry, plus 1 for the center world, is the number of complete worlds in the center line.
```
cl=2*d+1 (cl for center line)
```

(3) Due to the fractional stepping and symmetry, every lane up or down is two worlds shorter. The number of worlds in a stack above or below the center line thus is
```
sum for s=1..d over cl-2*s
        = d*cl - sum for s=1..d over 2*s
        = d*cl - 2*sum for s=1..d over s
        = d*cl - 2* (d(d+1)/2)  (Formula for partial sum of triangular numbers)
        = d*cl - d*(d+1)
        = d*(cl-(d+1))
        = d*(cl-d-1)            using (2)
        = d*(2*d+1-d-1)
        = d*(2*d-d)
        = d²*(2-1)
        = d²
```
(4) So the total number of worlds is
```
cl + 2*d² (since the stack extends both above and below)
= 2*d + 1 + 2*d²
```


(5) The total number of odd worlds out of these is
```
clo=1+2*floor(d/2) for the center line (since by definition, our center tile is odd)
```
plus
```
sum for s=(cl-1)..1 over s
```
for the blocks above and below, since every line is two clocks shorter, and with the inversion of pattern, this causes exactly one to go. 

(6) Using the partial sum again, and adding(5), yields the total number of odd blocks as
```
odd=clo+2*((clo-1)(clo-1+1)/2)
=clo+(clo-1)(clo)
=clo*(1+(clo-1))
=clo²
```

(7) Obviously, the number of even worlds then is (4) - (6):
```
even = 2*d+1+2*d² - clo²
= 2d(d+1)+1 - clo²
```
Multiply by the number of odd/even steps in a full world and continue.

### Outermost parts

The outermost parts are all either odd or even, depending on the number world worlds. If the number of worlds between the center and the outside, d (1), is odd, the outside will have the same same counting as the center part, and thus be odd. It is neccessary to trace these block individually, with different starting points and lengths.

### Incomplete blocks at the edges

Two different kinds of edge blocks exist. INSERT IMAGE HERE IF BORED.

#### Small Triangular Blocks

These are entered at their corner point. The maximum number of steps can be easily infered from one bordering an outermost world - since it is entered at the center with a maximum of length-1 steps, when one runs along the conveniently empty outer lines to enter a small triangular block, half a length, rounded down, needs to be subtracted from this.

This are encountered on every step, so d+1 times.

#### Large Clipped Triangular Blocks

These are entered at their corner point. The maximum number of steps can again be easily infered from the outermost one of it's kind. Since it is bordering the last complete block, which is enteres at the center with a maximum of 2*length-1 steps, when one runs along the outer lines to enter a large triangular block, again half a length, rounded down, needs to be subtracted from this.

These are only encountered on intermediate steps, so d times. Due to inversion effects, these have the oppite odd/even from the other outside tiles (and are followed by Small Triangular Blocks).
