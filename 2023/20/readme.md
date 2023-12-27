Another day where human analysis of the data sets restrictions on the generalized input, in a victory of sanity.

This solution currently sets the following demands:

### 1. There is exactly one element that feeds into rx

This could easily be relaxed to multiple calculations and a second level of detection, and using the minimum of these results.

### 2. This element is a conjunction.

This is more or less a direct result of making things countable. If it was a flipflop, the calculation would have to search for the second low pulse over all inputs.

As it stands, the solution searches for the for the first time all of these inputs generate a high pulse.

### 3. Any number of elements feeds into the conjunction from (2), but all of these are conjunctions themselves.

This is (mainly) due to the tracking. For flipflops the priod changes, as the first highpulse would be followed by a lowpulse at the same conditions in front of the flipflop, generating a period of 2x and an offset of 1x the number of button presses after the first high pulse was recorded.

### 4. The output of these elements is periodic.

With all high-pulse outputs being periodic, the lowest common multiple can be used to determine the overlap of all periods.


