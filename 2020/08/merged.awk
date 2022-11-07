#!/usr/bin/env -S awk -f ${_} -- input.txt
(FNR < NR) { exit }

{ code[FNR]=$1; arg[FNR]=$2 }

function exec(mode, pc,  acc, visited,  lvisited, result) {
    for (v in visited) lvisited[v] = 1
    while (!(pc in lvisited)) {
        if (pc == NR) return acc
        lvisited[pc]=1
        if (code[pc]=="acc") {
            acc+=arg[pc]
        } else if (code[pc]=="nop") {
            if (mode==2) result=exec(0,pc+arg[pc],acc,lvisited)
        }  else {
            if (mode==2) result=exec(0,pc+1,acc,lvisited)
            pc+=arg[pc]-1
        }
        pc++
        if (typeof(result)=="number") return result
    }
    if (mode==0) return
    else return acc
}

END {
    print "Part 1: " exec(1,1)
    print "Part 2: " exec(2,1)
}
