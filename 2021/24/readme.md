# Day 24 s..^w is not so great

Unlike the other days, it's not possible to infer the solution reasonably by writing code from the description alone to process the input, as in all other days.

## 01_brute_force - The Unreasonable Solution

The code in 01_brute_force still does exactly that, even if it means leaving the True Path of AWK. It uses awk to convert the math described by the input into a C function, which is then run with an arbitrary thread count for a full brute force.

It turns out ok-ish on my desktop with ca. 1.5 minutes for part 1 and 5.5 minutes for part 2 with 32threads, probably running purely in L1.

## 02_aoc_optimized - Fast enough for AWK

If you look at the generated code, you'll notice that there's some kind of common theme:

    x[1] = ((z[0] % 26) + 11) != w[1];

or

    x[5] = ((z[4] % 26) + -8) != w[5];

In the first case, the result is constant, as a positive integer + 11 will always differ from any input in the range [1..9]. This can therefor be substituted with 1.

The result of this operation is then used for a multiplication:

    x[1] = ((z[0] % 26) + 11) != w[1];
    y[1] = (25 * x[1]) + 1;
    z[1] = z[0] * y[1];

So, depending on the outcome of the check against the input, z will be multiplied with 26 or 1. Furthermore, there is only a limited amount of divisions in the code:

    z[5] = (z[4] / 26) * y[5];

If we want to read z=0 in the end, the number of multiplications can not be different from the number of divisions. At least in my input, the number of cases where the comparison can be derived to be constant "1" and the number of divisions is identical. This allows the assumption that all other cases must evaluate to 0.

Implementing this yields shorter code, and also adds an early out for cases with a "0" outcome.

The solution generates two awk scripts from the input and runs them.

