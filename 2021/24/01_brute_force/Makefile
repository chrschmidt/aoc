BASECOUNT = 4
THREADS   = 32

.PHONY: clean

all: part1 part2

part1: main.c part1.h
	gcc -D basecount=$(BASECOUNT) -D numthreads=$(THREADS) -Wall -march=native -O3 -lpthread $< -o $@

part2: main.c part2.h
	gcc -D PART2 -D basecount=$(BASECOUNT) -D numthreads=$(THREADS) -Wall -march=native -O3 -lpthread $< -o $@

part1.h: generate.awk | input.txt
	awk -f $< -v BASECOUNT=$(BASECOUNT) -v OUTFILE=$@ -v GENERATE=down -- $|

part2.h: generate.awk | input.txt
	awk -f $< -v BASECOUNT=$(BASECOUNT) -v OUTFILE=$@ -v GENERATE=up -- $|

clean:
	rm -f part1.h part2.h part1 part2
