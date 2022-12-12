# Day 12

This starts with an easy to implement brute force algorithm that gets the job done, but takes roughly two minutes to complete (on my laptop) in merged.awk.

There is a number of improvements possible:
1. Abort the wave when it hits the end, not only when it can't expand any more. Nearly negligible. (mergedb.awk, -2% time, +6 chars)
2. Mark valleys with no exit to not contain valid starting points. Decent result. (mergedc.awk, -20% time, +3 loc)
3. Separate the full wave from its front. Key optimization. (mergedd.awk, -90%, +1 loc due to some savings somewhere else)
