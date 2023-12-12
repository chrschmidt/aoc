#!/usr/bin/env -S awk -f ${_} -- input.txt

(FNR < NR) { exit }

BEGIN {
    if (!OUTFILE) OUTFILE = "-"
    if (!BASECOUNT) BASECOUNT=4
    regname["w"]; regname["x"]; regname["y"]; regname["z"]
    for (r in regname) { reg[r] = 0; needsprint[r] = 0; deps[r][0]; delete deps[r][0] }
    print "void * run (void * param) {" > OUTFILE
    print "    u64 w[15] = {0}, x[15] = {0}, y[15] = {0}, z[15] = {0}, inval[" BASECOUNT "];" >> OUTFILE
    print "    while (!solved) {" >> OUTFILE
    print "    getstartvals (inval);" >> OUTFILE
}

function indent (i) {
    for (i=0; i<=depth; i++)
        printf ("    ") >> OUTFILE
}

function _printreg(r, val, reset) {
    if (!needsprint[r])
        return
    indent()
    print r "[" depth "] = " val ";" >> OUTFILE
    if (reset)
        reg[r] = r "[" depth "]"
    needsprint[r] = 0
}

function printreg(r,  d) {
    _printreg(r, reg[r], 1)
    for (d in deps[r]) {
        printreg(d)
        delete deps[d][r]
    }
}

function chkdep(r, val,  d) {
    needsprint[r] = 1
    if (length(deps[r]) == 0)
        return
    for (d in deps)
        if (r in deps[d]) {
            _printreg(d, reg[d], 1)
            delete deps[d][r]
        }
    _printreg(r, val, 0)
    for (d in deps[r]) {
        printreg(d)
        delete deps[r][d]
    }
}

function _flush(r,  d) {
    for (d in deps)
        if (r in deps[d])
            printreg(d)
    printreg(r)
}

function flush(r, d) {
    if (depth == 0) return
    _flush("z")
    for (r in regname)
        for (d in deps[r])
            delete deps[r][d]
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
    else if (x == iter[depth] || reg[x] == x "[" depth-1 "]")
        return reg[x]
    else {
        if (x != $2)
            deps[x][$2] = 1
        return x "[" depth "]"
    }
}

/add/ {
    start = reg[$2]
    r3 = resolve($3)
    if (reg[$2] == 0) reg[$2] = r3
    else if (r3 != 0) {
        if (typeof(r3) == "number" && r3<0) reg[$2] = wrap(reg[$2], -r3, "-")
        else                                reg[$2] = wrap(reg[$2], r3, "+")
    }
    if (match(reg[$2], /^(-?[[:digit:]]+) \+ (-?[[:digit:]]+)$/, val))
        reg[$2] = val[1] + val[2]
    if (start != reg[$2])
        chkdep($2, start)
}

/mul/ {
    start = reg[$2]
    r3 = resolve($3)
    if (r3 == 0) reg[$2] = 0
    else if (r3 == 1) ;
    else if (reg[$2] == 0) reg[$2] = 0
    else reg[$2] = wrap(reg[$2], resolve($3), "*")
    if (start != reg[$2])
        chkdep($2, start)
}

/div/ {
    start = reg[$2]
    if ($3 != 1)
        reg[$2] = wrap(reg[$2], resolve($3), "/")
    if (start != reg[$2])
        chkdep($2, start)
}

/mod/ {
    start = reg[$2]
    reg[$2] = wrap(reg[$2], resolve($3), "%")
    if (start != reg[$2])
        chkdep($2, start)
}

/eql/ {
    start = reg[$2]
    if (reg[$2] ~ / /) {
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
    if (start != reg[$2])
        chkdep($2, start)
}

/inp/ {
    flush()
    indent()
    depth++
    if (depth > BASECOUNT) {
        if (GENERATE == "up")
            print "for (" $2 "[" depth "]=1; " $2 "[" depth "]<=9; " $2 "[" depth "]++) {" >> OUTFILE
        else
            print "for (" $2 "[" depth "]=9; " $2 "[" depth "]>=1; " $2 "[" depth "]--) {" >> OUTFILE
    } else {
        print $2 "[" depth "] = inval[" depth-1 "];" >> OUTFILE
    }
    iter[depth] = $2
    for (r in regname)
        reg[r] = r "[" depth-1 "]"
    needsprint[$2] = 0
    reg[$2] = $2 "[" depth "]"
}

END {
    flush()
    indent(); print "if (z[14] == 0) {" >> OUTFILE
    depth++
    indent(); print "chkresult (w);" >> OUTFILE
    indent(); print "return NULL;" >> OUTFILE
    depth--
    for (; depth>=BASECOUNT; depth--) { indent(); print "}" >> OUTFILE }
    print "    }" >> OUTFILE
    print "    return NULL;" >> OUTFILE
    print "}" >> OUTFILE
}
