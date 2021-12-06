#!/usr/bin/env -S gawk -v days=256 -f ${_} -- input.txt

{
    split($1,fish,",")
    for (f in fish) fishstate[fish[f]]++

    for (d=1; d<=days; d++) {
        tmp = fishstate[0]
        for (i=0; i<8; i++)
	    fishstate[i] = fishstate[i+1]
        fishstate[8] = tmp
        fishstate[6] += tmp
	sum = 0
	for (f in fishstate) sum += fishstate[f]
	print "After day " d ": " sum " fishes"
    }
    exit
}
