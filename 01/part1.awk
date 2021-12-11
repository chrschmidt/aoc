#!/usr/bin/env -S awk -f ${_} -- input.txt
(FILENAME != "input.txt") { exit }

{
    if (FNR > 1 && $1 > last)
        larger++
    last = $1
}

END {
    print larger " larger measurements"
}
