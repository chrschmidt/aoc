#!/usr/bin/env -S /bin/sh -c "exec awk -f ${_} input.txt" #

/^[0-9]+$/ { timestamp = $1 }
/,/ { split($0,busses,",") }

END {
    mindelay=timestamp
    for (bus in busses)
        if (busses[bus] != "x") {
            line = busses[bus]
            if (timestamp % line == 0) { mindelay = 0; tline = line }
            else {
                delay = line * (int(timestamp/line)+1) - timestamp
                if (delay < mindelay) { mindelay = delay; tline = line }
            }
        }
    print "Part 1: " tline*mindelay

    mod=busses[1]
    for (bus=2; bus<=length(busses); bus++)
        if (busses[bus]!="x") {
            for (i=time+bus-1; i%busses[bus]; i+=mod) ;
            time=i-bus+1
            mod*=busses[bus]
        }
    print "Part 2: " time
}
