#!/usr/bin/env -S awk -f ${_} -- input.txt

{
    if (count && $1 > last)
        larger++
    last = $1
    count++
}

END {
    print larger " larger measurements";
}
