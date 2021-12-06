#!/usr/bin/env -S gawk -v days=80 -f ${_} -- input.txt

{
    split($1,fish,",")

    for (d=1; d<=days; d++) {
	fc = length(fish);
	for (f=1; f<=fc; f++)
	    if (fish[f]) fish[f]--
	    else {
	        fish[f] = 6
	        fish[length(fish)+1] = 8
	    }
    }
    print "There are " length(fish) " lanternfish"
    exit
}
