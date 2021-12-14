#!/usr/bin/env -S gawk --bignum -f ${_} -- input.txt
(FNR < NR) { exit }

BEGIN { PROCINFO["sorted_in"]="@ind_num_asc" }

function convert() {
    for (i=0; i<5; i++) {
        l[lc+i] = or (2 ^ board[5*i+1], 2 ^ board[5*i+2], 2 ^ board[5*i+3], 2 ^ board[5*i+4], 2 ^ board[5*i+5])
        l[lc+i+5] = or (2 ^ board[i+1], 2 ^ board[i+6], 2 ^ board[i+11], 2 ^ board[i+16], 2 ^ board[i+21])
    }
    lc+=10
    delete board
}

function finalize(pos, drawn) {
    bnum = int(pos/10)
    for (y=0; y<5; y++)
        for (x=0; x<100; x++)
            if (and (2^x, l[bnum*10+y]) && !(x in drawna)) sum += x
    print "result: " sum * nums[drawn];
    exit
}

(FNR == 1) { split($1,nums,",") }
(FNR > 1 && NF) { for (i=1; i<6; i++) board[length(board)+1] = $i; if (length(board)==25) convert() }

END {
    for (i in nums) {
        drawna[nums[i]] = nums[i];
        drawn = or (drawn, 2 ^ nums[i])
        for (j in l) if (and (l[j], drawn) == l[j]) finalize(j, i);
    }
    print "not found...";
}
