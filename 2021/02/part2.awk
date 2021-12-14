#!/usr/bin/env -S awk -f ${_} -- input.txt

/^forward/ { horiz += $2; depth += aim*$2 }
/^up/ { aim -= $2 }
/^down/ { aim += $2 }

END {
    print "depth " depth " horizontal " horiz " result " depth*horiz
}
