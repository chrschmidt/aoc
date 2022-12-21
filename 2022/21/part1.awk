#!/usr/bin/env -S /bin/sh -c "exec awk -f ${_} input.txt"

{
    monkeys[mshort=substr($1,1,4)][0]=$2
    for (i=3;i<=NF;i++)
        monkeys[mshort][i-2]=$i
}

function getval(monkey) {
    if (1 in monkeys[monkey]) {
        if ((op=monkeys[monkey][1])=="+") return getval(monkeys[monkey][0]) + getval(monkeys[monkey][2])
        else if (op=="-") return getval(monkeys[monkey][0]) - getval(monkeys[monkey][2])
        else if (op=="*") return getval(monkeys[monkey][0]) * getval(monkeys[monkey][2])
        else if (op=="/") return int(getval(monkeys[monkey][0]) / getval(monkeys[monkey][2]))
    } else return monkeys[monkey][0] 
}

END {
    print "Part 1: " getval("root")
}
