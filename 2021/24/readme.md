# Day 24 s..^w is not so great

Unlike the other days, it's not possible to infer the solution reasonably by writing code from the description alone, processing the input, as in all other days.

## 01_noextra - The Unreasonable Solution

The code in 01_noextra still does exactly that, even if it means leaving the True Path of AWK. It uses awk to convert the math described by the input into a C function, which is then run with an arbitrary thread count for a full brute force.

It turns out ok-ish on my desktop with ca. 1.5 minutes for part 1 and 5.5 minutes for part 2 with 32threads, probably running purely in L1.
