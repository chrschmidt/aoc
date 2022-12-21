#!/usr/bin/env -S /bin/sh -c "exec awk -f ${_} input.txt"

{
    for (i=2;i<=NF;i++)
        monkeys[substr($1,1,4)][i-2]=$i
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
