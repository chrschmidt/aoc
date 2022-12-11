#!/usr/bin/env -S /bin/sh -c "exec awk -v scm=1 -f ${_} input.txt"

/Monkey/ { id=int($2) }
/Starting items/ { monkey[id]["items"][0]; items+=patsplit($0,monkey[id]["items"],"[0-9]+") }
/Operation/ { monkey[id]["op"]=$5; if ($6!="old") monkey[id]["arg"]=$6 }
/Test/ { monkey[id]["test"]=$4; scm*=$4 }
/If/ { monkey[id]["new"][$2=="true:"]=$6 }

END {
    for (i=0;i<10000;i++) {
        for (id in monkey) {
            for (item in monkey[id]["items"]) {
                inspect[id]++
                level=monkey[id]["items"][item]
                delete monkey[id]["items"][item]
                arg=monkey[id]["arg"]?monkey[id]["arg"]:level
                level=(monkey[id]["op"]=="+"?level+arg:level*arg)%scm
                monkey[monkey[id]["new"][!(level%monkey[id]["test"])]]["items"][++items]=level
            }
        }
    }
    asort(inspect,inspect,"@val_num_desc")
    print "Part 2: " inspect[1]*inspect[2]
}
