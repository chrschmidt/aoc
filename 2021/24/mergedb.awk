#!/usr/bin/env -S awk -f ${_} -- input.txt

(FNR < NR) { exit }

function indent(text) {
    for (i=0; i<depth; i++)
	text = text "    "
    return text
}

function dprint(text) {
    print indent() text > "part1.awk"
    print indent() text > "part2.awk"
}

BEGIN {
    regname["w"]; regname["x"]; regname["y"]; regname["z"]
    for (r in regname) reg[r] = 0
    dprint("BEGIN { exit }\n\nEND {")
    depth = 1
}

function printreg(r,  val) {
    val = (reg[r] ~ /\//) ? "int(" reg[r] ")" : reg[r]
    dprint(r depth-1 " = " val)
    if (reg[r] != 0)
        reg[r] = r  depth - 1
}

function wrap(a, b, op,  wa, wb) {
    if (a ~ / /) wa = "(" a ")"; else wa = a
    if (b ~ / /) wb = "(" b ")"; else wb = b
    return wa " " op " " wb
}

function resolve(x) {
    if (x ~ /^-?[[:digit:]]+$/)
        return int(x)
    else if (reg[x] ~ /^-?[[:digit:]]+$/)
        return int(reg[x])
# Special AoC optimization
    else if (reg[x] ~ /!=/) {
        dprint("if (" reg[x] ") continue")
        reg[x] = 0
        return 0
    } else
        return reg[x]
}

/add/ {
    r3 = resolve($3)
    if (reg[$2] == 0) reg[$2] = r3
    else if (r3 != 0) {
        if (typeof(r3) == "number" && r3<0) reg[$2] = wrap(reg[$2], -r3, "-")
        else                                reg[$2] = wrap(reg[$2], r3, "+")
    }
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
    if (depth > 1)
	printreg("z")
    print indent() "for (" $2 depth "=9; " $2 depth ">=1; " $2 depth "--) {" > "part1.awk"
    print indent() "for (" $2 depth "=1; " $2 depth "<=9; " $2 depth "++) {" > "part2.awk"
    depth++
    iter[depth] = $2
    iprint = iprint " " $2 depth - 1
    for (r in regname)
        if (depth == 2) reg[r] = 0
        else reg[r] = r depth - 2
    reg[$2] = $2 depth - 1
}

END {
    printreg("z")
    dprint("if (z14 == 0) {")
    depth++
    print indent() "print \"part 1: \"" iprint > "part1.awk"
    print indent() "print \"part 2: \"" iprint > "part2.awk"
    dprint("exit")
    depth--
    for (; depth>=0; depth--)
        dprint("}")
    system("gawk -f part1.awk")
    system("gawk -f part2.awk")
}
