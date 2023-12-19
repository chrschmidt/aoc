#!/usr/bin/env -S /bin/sh -c "exec awk -f ${_} -f ../../aoclib.awk input.txt"

/^[a-z]+{.*}$/ {
    split($1,a,/[{}]/)
    rules[a[1]]=a[2]
    split(a[2],b,",")
    for (r=1;r<=length(b);r++) {
        split(b[r],c,/[<>:]/,d)
        workflows[a[1]][r][0]=c[1]
        workflows[a[1]][r][1]=d[1]
        workflows[a[1]][r][2]=c[2]
        workflows[a[1]][r][3]=c[3]
    }
}

function process(vars,wf, i,v,rule,sum) {
    if (wf=="R") return 0
    else if (wf=="A") { for (i in vars) sum+=vars[i]; return sum }
    for (rule=1;rule<=length(workflows[wf]);rule++) {
        if ((v=workflows[wf][rule][0]) in vars) {
            if ((workflows[wf][rule][1]==">" && vars[v]>workflows[wf][rule][2]) ||
                (workflows[wf][rule][1]=="<" && vars[v]<workflows[wf][rule][2]))
                return process(vars,workflows[wf][rule][3])
        } else {
            return process(vars,workflows[wf][rule][0])
        }
    }
}

/^{.*}$/ {
    split($1,a,/[{}]/)
    split(a[2],b,/[=,]/)
    for (p=1;p<=length(b);p+=2)
        vars[b[p]]=b[p+1]
    part1+=process(vars,"in")
}

function process2(vars,wf, i,v,rule,tmpvars,mult) {
    if (wf=="R") return
    else if (wf=="A") { mult=1; for (i in vars) mult*=vars[i][1]-vars[i][0]+1; part2+=mult; return }
    for (rule=1;rule<=length(workflows[wf]);rule++) {
        for (i in vars) { tmpvars[i][0]=vars[i][0]; tmpvars[i][1]=vars[i][1] }
        if ((v=workflows[wf][rule][0]) in vars) {
            if (workflows[wf][rule][1]==">") {
                if (vars[v][1]<=workflows[wf][rule][2]) continue
                if (vars[v][0]>workflows[wf][rule][2]) return process2(vars,workflows[wf][rule][3])
                vars[v][1]=workflows[wf][rule][2]
                tmpvars[v][0]=workflows[wf][rule][2]+1
                process2(tmpvars,workflows[wf][rule][3])
            } else {
                if (vars[v][0]>=workflows[wf][rule][2]) continue
                if (vars[v][1]<workflows[wf][rule][2]) return process2(vars,workflows[wf][rule][3])
                tmpvars[v][1]=workflows[wf][rule][2]-1
                vars[v][0]=workflows[wf][rule][2]
                process2(tmpvars,workflows[wf][rule][3])
            }
        } else {
            return process2(vars,workflows[wf][rule][0])
        }
    }
}

END {
    print "Part 1: " part1
    delete vars
    vars["x"][0]=1; vars["x"][1]=4000
    vars["m"][0]=1; vars["m"][1]=4000
    vars["a"][0]=1; vars["a"][1]=4000
    vars["s"][0]=1; vars["s"][1]=4000
    process2(vars,"in",1)
    print "Part 2: " part2
}
