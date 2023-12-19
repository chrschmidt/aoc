Part 1 is a clone of day 10 - use the input rules to generate the "pipe", trace the inside area of the pipe.

Part 1b is a pure speedup - do not search for lower/upper limits of x, but instead just iterate over the given elements in the line. This skips the tests for all of the empty space.

Part 1c eliminates the horizontal fills ("-"), and treats them as inside. This reduces the required space in x direction.

Part 1d also eliminates the vertical fills ("|"), and instead uses interpolated lines in between. This reduces the required space in y direction, too.

Only the memory reductions of 1d allows to solve part 2 with reasonable amounts of memory.
