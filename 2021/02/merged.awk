#!/usr/bin/env -S awk -f ${_} -- input.txt

/^forward/ { horiz += $2; depth2 += depth * $2 }
/^up/ { depth -= $2 }
/^down/ { depth += $2 }

END {
    print "Part 1: " depth * horiz
    print "Part 2: " depth2 * horiz
}
