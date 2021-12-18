Array accesses in awk are slow.

mergedb.awk implements a two-level hierarchy for candidates. This nets a nearly factor 8 speedup over the first solution, at the expense of nearly 20 extra loc.

for merged.awk:

    real	0m14.520s
    user	0m14.508s
    sys 	0m0.012s

for mergedb.awk:

    real	0m1.871s
    user	0m1.835s
    sys 	0m0.036s
