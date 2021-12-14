#!/usr/bin/env -S gawk -f ${_} -- input.txt

function printres(part, f, sum) {
    for (f in fishstate) sum += fishstate[f]
    print "Part " part ": " sum
}

{
    split($1,fish,",")
    for (f in fish) fishstate[fish[f]]++

    for (d=1; d<=256; d++) {
	tmp = fishstate[0]
	for (i=0; i<8; i++)
	    fishstate[i] = fishstate[i+1]
	fishstate[8] = tmp
	fishstate[6] += tmp
	if (d == 80) printres(1)
    }
    printres(2)
    exit
}
