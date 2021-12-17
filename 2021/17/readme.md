# The math behind the solution
## Definitions
Let
*sxvel* be the initial velocity in x direction
*syvel* be the initial velocity in y direction
*t* be the number of steps taken
## Positions
The rules state that the velocity decreases by 1 each step due to drag or gravity.

    t=0: x = 0, y=0
    t=1: x = sxvel, y = syvel
    t=2: x = sxvel + (sxvel-1), y = syvel + (syvel-1)
    t=3: x = sxvel + (sxvel-1) + (sxvel-2), y = syvel + (syvel-1) + (syvel-2)
    ...

So the formula for the positions over time is

    (1) x(t) = sxvel + sxvel-1 + ... + sxvel-(t-1) for t=0..sxvel
    (2) y(t) = syvel + syvel-1 + ... + syvel-(t-1) for t>=0

which is equal to:

    (3) x(t) = t*sxvel - sum(0..t-1)
    (4) y(t) = t*syvel - sum(0..t-1)

Using Gauss' Trick this becomes a closed formula:

    (5) x(t) = t * sxvel - (t-1)*(t)/2
             = t * (sxvel - (t-1)/2)
    (6) y(t) = t * syvel - (t-1)*(t)/2
             = t * (syvel - (t-1)/2)
## Range
The range in x direction is limited to when the velocity drops to 0. This happens after *syvel* steps, which sees an increase in x direction of *sxvel + (sxvel-1) + ... + 1* or 
 
     (7) range(sxvel) = sxvel*(sxvel+1)/2
 
 Gauss' Trick again.
## Part 1
The highest point in the trajectory is

    0 for any syvel <= 0
    the turning point of the graph for syvel > 0

The former can be ignored - any upward trajectory will be better. The latter can be found using the derivative. Changing (6) to something more convenient:

    (8)  y(t) = t*syvel - (t-1)*(t)/2
              = t*syvel - (t²-t)/2
              = t*syvel - t²/2 + t/2
              = t*(syvel+1/2) - t²/2

And the derivative is:

    (9) dy/t(t) = syvel+1/2 - t

The turning point is at

    (10) syvel+1/2 - t = 0
             syvel+1/2 = t

Since t must be an integer, look at t=syvel and t=syvel+1 to check if both are needed:

    (11) y(syvel) = syvel*syvel - (syvel-1)*syvel/2
                  = syvel² - syvel²/2 + syvel/2
                  = syvel²/2 + syvel/2
                  = syvel(syvel+1)/2
    (12) y(syvel+1) = (syvel+1)*syvel - syvel*(syvel+1)/2
                    = syvel²+syvel - syvel²/2-syvel/2
                    = syvel²/2 + syvel/2
                    = syvel(syvel+1)/2

Since 11 and 12 are the same, this can be used to calculate the highest point in a trajectory without using a maximum function, depending only on the starting velocity.
Not much surprisingly, this is exactly identical to the range defined above - after the velocity in y direction drops to 0, it turns negative and the drone drops. Oops.