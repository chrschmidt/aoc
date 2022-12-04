# aoc
Advent of Code Solutions

See <https://adventofcode.com> for more information on what this is about.

# Language

Written in GNU awk, if needed augmented with other languages. All of AoC is based on text input, which is parsed and processed.

AWK is the obvious choice for this, except when it isn't and becomes painful.

# Solutions

part1.awk and part2.awk, if existing, are what's used for a single solution.

merged.awk merges both parts and might be streamlined/optimized further.

mergedb.awk, mergedc.awk, ... if existing are further optimizations, for profit through fun.

# The hashbang

## Old style

If you see this unusual abort condition:

    (FNR < NR) { exit }

This is needed for having the file executable via

    #!/usr/bin/env -S awk -f ${_} -- input.txt

because:

1. Using env is necessary to give multiple parameters, the script via ${_} and input.txt
2. awk itself does not see multiple parameters - it will turn everything after -f into a single filename
3. env appends the name of the script at the end of the input line
4. awk will happily process its program as input
5. Sometimes this will mess up the results, and so an extra abort is inserted

## New style

At some point I realized that I can save that loc by double wrapping:

    #!/usr/bin/env -S /bin/sh -c "exec awk -f ${_} -- input.txt"
