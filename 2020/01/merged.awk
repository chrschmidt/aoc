#!/usr/bin/env -S awk -f ${_} -- input.txt
(FNR < NR) { exit }

{ entry[FNR] = $1 }

END {
    for (i=1; i<(NR-1); i++)
        for (j=i+1; j<NR; j++)
            if (entry[i] + entry[j] == 2020)
                print "Part 1: " entry[i]*entry[j]

    for (i=1; i<(NR-2); i++)
        for (j=i+1; j<(NR-1); j++)
            for (k=j+1; k<NR; k++)
                if (entry[i] + entry[j] + entry[k] == 2020)
                    print "Part 2: " entry[i]*entry[j]*entry[k]

}

