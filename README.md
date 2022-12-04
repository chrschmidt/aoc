# aoc
Advent of Code Solutions

See <https://adventofcode.com> for more information on what this is about.

Written in GNU awk, if needed augmented with other languages.

part1.awk and, if existing, part2.awk are what's used for the solution.

merged.awk merges both parts and might be streamlined/optimized further.

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

At some point I realized that I can save that loc by double wrapping:

    #!/usr/bin/env -S /bin/sh -c "exec awk -f ${_} -- input.txt"
