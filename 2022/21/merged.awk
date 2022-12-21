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
        else return int(getval(monkeys[monkey][0]) / getval(monkeys[monkey][2]))
    } else return monkeys[monkey][0]
}

function hashumn(monkey) {
    if (monkey=="humn") return 1
    if (1 in monkeys[monkey]) return hashumn(monkeys[monkey][0]) + hashumn(monkeys[monkey][2])
    else return 0
}

function precalc(monkey) {
    if (!(1 in monkeys[monkey])) return
    if (hashumn(monkeys[monkey][0])) precalc(monkeys[monkey][0])
    else monkeys[monkey][0]=getval(monkeys[monkey][0])
    if (hashumn(monkeys[monkey][2])) precalc(monkeys[monkey][2])
    else monkeys[monkey][2]=getval(monkeys[monkey][2])
}

function left(monkey) { return monkeys[monkey][0]~/[0-9]+/ }
function v(monkey) { return left(monkey)?monkeys[monkey][0]:monkeys[monkey][2] }
function m(monkey) { return left(monkey)?monkeys[monkey][2]:monkeys[monkey][0] }

function part2(monkey,value) {
    if (monkey=="humn") return value
    if ((op=monkeys[monkey][1])=="+") return part2(m(monkey),value-v(monkey))
    else if (op=="-") return part2(m(monkey),left(monkey)?v(monkey)-value:value+v(monkey))
    else if (op=="*") return part2(m(monkey),value/v(monkey))
    else return part2(m(monkey),left(monkey)?int(v(monkey)/value):value*v(monkey))
}

END {
    print "Part 1: " getval("root")
    precalc("root")
    print "Part 2: " part2(m("root"),v("root"))
}
