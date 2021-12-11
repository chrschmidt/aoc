#!/bin/bash

vals=($(merged.awk))
epsilon=$(echo ${vals[0]} | tr 01 10)

echo "Part 1: $(( 2#${vals[0]} * 2#$epsilon ))"
echo "Part 2: $(( 2#${vals[1]} * 2#${vals[2]} ))"
