#!/usr/bin/env -S awk -f ${_} -- input.txt

/^forward/ { horiz += $2 }
/^up/ { depth -= $2 }
/^down/ { depth += $2 }

END {
    print "depth " depth " horizontal " horiz " result " depth*horiz
}
