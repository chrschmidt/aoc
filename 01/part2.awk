#!/usr/bin/env -S awk -f ${_} -- input.txt

{
    if (count>3 && (t2+t1+$1 > t3+t2+t1))
        larger++
    t3 = t2
    t2 = t1
    t1 = $1
    count++
}

END {
    print larger " larger measurements";
}
