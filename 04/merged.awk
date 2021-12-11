#!/usr/bin/env -S gawk --bignum -f ${_} -- input.txt
(FILENAME != "input.txt") { exit }

BEGIN { PROCINFO["sorted_in"]="@ind_num_asc" }

function convert() {
    for (i=0; i<5; i++) {
        l[lc+i] = or (2 ^ board[5*i+1], 2 ^ board[5*i+2], 2 ^ board[5*i+3], 2 ^ board[5*i+4], 2 ^ board[5*i+5])
        l[lc+i+5] = or (2 ^ board[i+1], 2 ^ board[i+6], 2 ^ board[i+11], 2 ^ board[i+16], 2 ^ board[i+21])
    }
    lc+=10
    delete board
}

function finalize(pos,  x, y, sum) {
    for (y=0; y<5; y++)
        for (x=0; x<numboards; x++)
            if (and (2^x, l[bnum*10+y]) && !(x in drawna)) sum += x
    return sum * nums[pos]
}

(FNR == 1) { split($1,nums,",") }
(FNR > 1 && NF) { for (i=1; i<6; i++) board[length(board)+1] = $i; if (length(board) == 25) convert() }

END {
    numboards = length(l)/10
    for (i in nums) {
        drawna[nums[i]] = nums[i]
        drawn = or (drawn, 2 ^ nums[i])
        for (j in l) if (and(l[j], drawn) == l[j]) {
	    bnum = int(j / 10)
    	    if (!part1) {
    		print "Part 1: " finalize(i)
    		part1 = 1
    	    }
	    if (!(bnum in drawnb)) {
		drawnb[bnum] = length(drawnb)
		if (length(drawnb) == numboards)
	    	    print "Part 2: " finalize(i)
	    }
        }
    }
}
