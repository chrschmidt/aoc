#!/usr/bin/env -S awk -f ${_} -- input.txt

{
    if (FNR>3 && (t2+t1+$1 > t3+t2+t1))
        larger++
    t3 = t2
    t2 = t1
    t1 = $1
}

END {
    print larger " larger measurements";
}
