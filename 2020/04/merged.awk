#!/usr/bin/env -S awk -f ${_} -- input.txt
(FNR < NR) { exit }

BEGIN { ec["amb"]=1; ec["blu"]=1; ec["brn"]=1; ec["gry"]=1; ec["grn"]=1; ec["hzl"]=1; ec["oth"]=1 }

function cint(val, min, max) { return val > min-1 && val < max+1 }
function ccint(val, min, max) { if (val ~ /^[0-9]+$/) return cint(val,min,max); else return 0 }

function validate(hgt) {
    if (length(passport)==8 || (length(passport)==7 && !("cid" in passport))) {
        valid1++
        if (!ccint(passport["byr"],1920,2002)) return
        if (!ccint(passport["iyr"],2010,2020)) return
        if (!ccint(passport["eyr"],2020,2030)) return
        hgt = passport["hgt"]
        if (hgt ~ /^[0-9]+in$/) { if (!cint(hgt,59,76)) return }
        else if (hgt ~ /^[0-9]+cm$/) { if (!cint(hgt,150,193)) return }
        else return
        if (!(passport["hcl"] ~ /^#[0-9a-f]{6}$/)) return
        if (!(passport["ecl"] in ec)) return
        if (!(passport["pid"] ~ /^[0-9]{9}$/)) return
        valid2++
    }
}

(NF == 0) {
    validate()
    delete passport
}

(NF > 0) {
    for (i=1; i<=NF; i++) {
        split($i,kv,":")
        passport[kv[1]]=kv[2]
    }
}

END {
    if (isarray(passport)) validate()
    print "Part 1: " valid1
    print "Part 2: " valid2
}
