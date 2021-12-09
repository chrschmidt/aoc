# aoc2021
Advent of Code 2021 Solutions

Written in awk, if needed augmented with bash.

If you see this unusual abort condition:

    (FILENAME != "input.txt") { exit }

This is nedded for having the file executable via

    #!/usr/bin/env -S awk -f ${_} -- input.txt

1. Using env is necessary to give multiple paramaters, the script via ${_} and input.txt
2. awk itself does not see multiple parameters - it will turn everything after -f into a single filename
3. env appends the name of the script at the end of the input line
4. awk will happily process the script
5. Sometimes this will mess up the results, and so an extra abort is inserted
