#!/bin/bash

gamma=$(part1.awk)
epsilon=$(echo $gamma | tr 01 10)

echo "$(( 2#$gamma * 2#$epsilon ))"