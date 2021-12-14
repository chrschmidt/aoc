#!/bin/bash

vals=($(part2.awk))
echo "$(( 2#${vals[0]} * 2#${vals[1]} ))"