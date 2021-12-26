The solution path implemented here uses volume subpartitioning into overlapping regions until no more overlaps are found. For each subvolume, the last input line that affects it is tracked for final evaluation.

The original part 2 solution calculates all overlaps between all input lines at once, making this pretty slow, as recursively checking for overlaps is employed, leading to an n²/2 algorithm for this brute force approach. For each overlapping region ("parent"), the total size of its "children" (areas in which another parent overlaps it) is deducted to find the number of reactor cores this volume uniquely affects.

To find the number of total active cores in the end, all volumes in which the last activity was "on" are added.

The merged version contains an optimization that shrinks the number of comparions for the n²/2 core. Instead of evaluating all input lines at once with all their overlapping regions, each input region is added individually. The same recursive algorithm as before is used to find the number of already active reactor cores in the currently processed region (given by an input line). This number is then removed from the current total, which equals turning them off, and in case it is an "on" operation, the total size of the processed region is added again.
