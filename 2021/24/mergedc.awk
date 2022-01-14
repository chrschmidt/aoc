#!/usr/bin/env -S awk -f ${_} -- input.txt

(FNR < NR) { exit }

BEGIN {
    regname["w"]; regname["x"]; regname["y"]; regname["z"]
    depth = 1
}

function wrap(a, b, op,  wa, wb) {
    if (a ~ / /) wa = "(" a ")"; else wa = a
    if (b ~ / /) wb = "(" b ")"; else wb = b
    return wa " " op " " wb
}

function link(val,  num, tmp) {
    num = asorti(stack, tmp, "@ind_num_asc")
    links[tmp[num]] = depth - 1 "," stack[tmp[num]] + val
    delete stack[tmp[num]]
}

function resolve(x,  val) {
    if (x ~ /^-?[[:digit:]]+$/)
        return int(x)
    else if (reg[x] ~ /^-?[[:digit:]]+$/)
        return int(reg[x])
# Special AoC optimization
    else if (match(reg[x], /(-?[[:digit:]]+)\) !=/, val)) {
        link(val[1])
        reg[x] = 0
        return 0
    } else
        return reg[x]
}

/add/ {
    r3 = resolve($3)
    if (reg[$2] == 0) reg[$2] = r3
    else if (r3 != 0) reg[$2] = wrap(reg[$2], r3, "+")
    if (match(reg[$2], /^(-?[[:digit:]]+) \+ (-?[[:digit:]]+)$/, val))
        reg[$2] = int(val[1]) + int(val[2])
}

/mul/ {
    r3 = resolve($3)
    if (reg[$2] == 0) ;
    else if (r3 == 0) reg[$2] = 0
    else if (r3 == 1) ;
    else reg[$2] = wrap(reg[$2], r3, "*")
}

/div/ {
    r3 = resolve($3)
    if (r3 != 1)
        reg[$2] = wrap(reg[$2], r3, "/")
}

/mod/ {
    reg[$2] = wrap(reg[$2], resolve($3), "%")
}

/eql/ {
    if (reg[$2] == 0 && $3 == "0")
        reg[$2] = 1
    else if (reg[$2] ~ / /) {
        arg = reg[$2]
        len = split(arg, parts)
        if (parts[len-1] == "==") {
            reg[$2] = parts[1]
            for (i=2; i<len-1; i++) reg[$2] = reg[$2] " " parts[i]
            reg[$2] = reg[$2] " != " parts[len]
        } else if (parts[len-1] == "!=") {
            reg[$2] = parts[1]
            for (i=2; i<len-1; i++) reg[$2] = reg[$2] " " parts[i]
            reg[$2] = reg[$2] " == " parts[len]
        } else reg[$2] = wrap(reg[$2], resolve($3), "==")
    } else reg[$2] = wrap(reg[$2], resolve($3), "==")
# Special AoC optimization
    if (match(reg[$2], /+ ([[:digit:]]+)\) ==/, val) && val[1] > 9)
        reg[$2] = 0
}

/inp/ {
# Special AoC optimization
    if (match(reg["z"], /+ (-?[[:digit:]]+)/, val))
	stack[depth-1] = val[1]
    depth++
    iter[depth] = $2
    for (r in regname)
        if (depth == 2) reg[r] = 0
        else reg[r] = r depth - 2
    reg[$2] = $2 depth - 1
}

END {
    for (digit in links) {
	split(links[digit], linkval, /,/)
        for (v=9; v>0; v--)
    	    if (v + linkval[2] >= 1 && v + linkval[2] <= 9) {
		max[digit] = v
		max[linkval[1]] = v + linkval[2]
		break
	    }
        for (v=1; v<10; v++)
    	    if (v + linkval[2] >= 1 && v + linkval[2] <= 9) {
		min[digit] = v
		min[linkval[1]] = v + linkval[2]
		break
	    }
    }
    printf ("Part 1: ")
    for (digit in max)
        printf ("%d", max[digit])
    printf ("\n")
    printf ("Part 2: ")
    for (digit in max)
        printf ("%d", min[digit])
    printf ("\n")
}
