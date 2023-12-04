# Part 1

Part 1 is pretty trivial and probably needs no further explanation.

# Part 2

I solved part 2 in two steps:

1. Flatten the "tree" of the calculations, unless only a constant remains on one side, and a path of rules leading um to "humn" remains (`precalc`)
2. What's left are equations that need to be resolved in reverse: we know the desired result, `value`, the operation, `op`, another constant, `v(monkey)`, and the name of the next monkey, `m(monkey)`.

These operations come in two form:
1. `value = const op name`, the *left form*, checked with `left(monkey)`
2. `value = name op const`, the *right form*

Forms are named after the side the constant is on.

With four operations this yields eight combinations for the next `newvalue` to be passed on (used interchangeably with `name`), in given and in resolved form:
1. `value = const + name`, or `newvalue = value - const`
2. `value = name + const`, or (the same) `newvalue = value - const`
3. `value = const - name`, or `newvalue = const - value`
4. `value = name - const`, or `newvalue = value + const`
5. `value = const * name`, or `newvalue = value / const`
6. `value = name * const`, or (the same) `newvalue = value / const`
7. `value = const / name`, or `newvalue = const / value`
8. `value = name / const`, or `newvalue = value * const`

Once *humn* is hit, the `value` is the answer to part 2.
