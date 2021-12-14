#!/usr/bin/env -S awk -f ${_} -- input.txt

{
    for (i=1; i<=length($1); i++)
        if (substr($1,i,1) == "1")
            ones[i]++
    count++
}

END {
    for (i=1; i<=length(ones); i++)
      if (ones[i] > (NR/2)) gamma = gamma "1"
      else gamma = gamma "0"
    print gamma
}
