#!/usr/bin/env -S /bin/sh -c "exec awk -f ${_} -f ../../aoclib.awk input.txt"

function enq(dst,src,state) {
#    print "Enqueued " src " -> " dst ": " state
    queue[queueend][0]=dst
    queue[queueend][1]=src
    queue[queueend++][2]=state
}

{
    gsub(/,/,"")
    name=substr($1,2)
    if (substr($1,1,1)=="%") modules[name]["type"]="ff"
    else if (substr($1,1,1)=="&") modules[name]["type"]="con"
    else name=$1
    modules[name]["state"]=0
    for (i=3;i<=NF;i++) {
        modules[name]["out"][i]=$i
        modules[$i]["in"][name]=0
    }
}

function dump(i, j) {
    for (i in modules) {
        printf "%s: %d, in:", i, modules[i]["state"]
        for (j in modules[i]["in"])
            printf " %s=%d", j, modules[i]["in"][j]
        printf "\n"
    }
}

function button(state, i,name,src,out) {
    queueend=queuestart=0
    enq("broadcaster","button",state)
    while (queueend!=queuestart) {
        name=queue[queuestart][0]
        src=queue[queuestart][1]
        state=queue[queuestart++][2]
#        print src " -" (state?"high":"low") "-> " name
        pulses[state]++
        modules[name]["in"][src]=state
        if (modules[name]["type"]=="ff") {
            if (state==0)
                state=modules[name]["state"]=!modules[name]["state"]
            else
                continue
        } else if (modules[name]["type"]=="con") {
            for (i in modules[name]["in"])
                state=and(state,modules[name]["in"][i])
            state=!state
            if (state && name in triggers) {
                delete triggers[name]
#                print name " triggered at " part2
                results[name]=part2
            }
        }
        for (i in modules[name]["out"])
            enq(modules[name]["out"][i],name,state)
    }
}

function inputs(level,module, i) {
    if (level==6) return
    for (i=1;i<level;i++) printf "  "
    if (module in printed)
        print level " " module "[R]"
    else {
        print level " " module
        printed[module]
        for (i in modules[module]["in"])
            inputs(level+1,i)
        delete printed[module]
    }
}

function part2_prep(final) {
    for (i in modules) {
        modules[i]["state"]=0
        for (j in modules[i]["in"])
            modules[i]["in"][j]=0
    }

    if (length(modules["rx"]["in"])!=1) {
        print "ERROR: rx has more than one input, situation not handled"
        exit
    }
    for (final in modules["rx"]["in"]) ;
    if (modules[final]["type"]!="con") {
        print "ERROR: " final " feeds into rx but is not a conjunction, situation not handled"
        exit
    }
    for (gate in modules[final]["in"]) {
        if (modules[gate]["type"]!="con") {
            print "ERROR: " gate " feeds into " final " but is not a conjunction, situation not handled"
            exit
        }
        triggers[gate]
    }
}

END {
    for (i=0;i<1000;i++)
        button(0)
    print "Part 1: " pulses[0]*pulses[1]

    part2_prep()
    for (part2=1;length(triggers);part2++)
        button(0)
    part2=1
    for (i in results)
        part2=lcm(part2,results[i])
#    inputs(1,"rx")
    print "Part 2: " part2
}
