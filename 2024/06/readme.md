## merged.awk
Stupid brute-force approach, blindly testing all empty fields.

Runtime: 2m27.602s
## mergedb.awk
Less stupid brute-force, only testing empty fields that are actually traversed during phase 1.

Runtime: 0m40.588s
## mergedc.awk
Same less stupid approach, but folding the solver into a single function, reducing the number of calls.

Runtime: 0m32.966s
## mergedd.awk
Intertwined phase 1 and phase 2, where the phase 2 tests immediately follow a single step of phase1. Tests are run on copies of the map.

Runtime: 0m18.726s
## mergede.awk
Same intertwined approach, but backtracking is used instead of array copies which awk does not like.

Runtime: 0m5.795s
