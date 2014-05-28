# The Benchmarks Game benchmarks language compilers. For this they use the -O3
# optimization flag and some other uncommon optimization flags like
# -funroll-loops. As I'm trying to mimic common programs's behavior with this
# benchmark, I've removed some of the flags.
#
CFLAGS=-pipe -Wall -O3 -fomit-frame-pointer -march=native

SSE2_FLAGS=-mfpmath=sse -msse2
SSE3_FLAGS=-mfpmath=sse -msse3

# Disable SSE2 and SSE3
SSE2_FLAGS=
SSE3_FLAGS=

CC=gcc

# One version of each algorithm
ONE_OF_EACH=nbody \
			fannkuchredux \
			meteor \
			fasta \
			fastaredux-2 \
			spectralnorm \
			revcomp \
			mandelbrot \
			knucleotide-4 \
			regexdna \
			pidigits \
			chameosredux-2 \
			threadring \
			binarytrees

# A custom set of programs you may be willing to build
CUSTOM_SET=nbody \
		   fannkuchredux \
		   meteor \
		   fasta \
		   fastaredux-2 \
		   spectralnorm \
		   revcomp \
		   knucleotide-4 \
		   chameosredux-2 \
		   threadring \
		   binarytrees

build-one-of-each: $(ONE_OF_EACH)

build-custom-set: $(CUSTOM_SET)

clean:
	rm -f $(ONE_OF_EACH)

nbody: nbody.c
	$(CC) $(CFLAGS) $(SSE3_FLAGS) $< -o $@ -lm
	#./$@ 50000000

fannkuchredux: fannkuchredux.c
	$(CC) $(CFLAGS) -pthread -falign-labels=8 $< -o $@
	#./$@ 12

meteor: meteor.c
	$(CC) $(CFLAGS) $< -o $@
	#./$@ 2098

fasta: fasta.c
	$(CC) $(CFLAGS) -std=c99 $(SSE3_FLAGS) $< -o $@
	#./$@ 25000000

fastaredux-2: fastaredux-2.c
	$(CC) $(CFLAGS) -std=c99 $(SSE3_FLAGS) $< -o $@
	#./$@ 25000000

spectralnorm: spectralnorm.c
	$(CC) $(CFLAGS) -fopenmp $(SSE2_FLAGS) $< -o $@ -lm
	#./$@ 5500

revcomp: revcomp.c
	$(CC) $(CFLAGS) -std=c99 -pthread $< -o $@ # -std=c100
	#$@ 0 < data/revcomp-input.txt

mandelbrot: mandelbrot.c
	$(CC) $(CFLAGS) -std=c99 -D_GNU_SOURCE $(SSE2_FLAGS) -fopenmp $< -o $@
	#./$@ 16000

knucleotide-4: knucleotide-4.c
	$(CC) $(CFLAGS) -std=c99 -include simple_hash3.h -pthread $< -o $@
	#./$@ 0 < data/knucleotide-input.txt

regexdna: regexdna.c
	$(CC) $(CFLAGS) -pthread \
		-I/usr/include/tcl8.6 \
		`pkg-config --cflags --libs glib-2.0` \
		$< -o$@ -ltcl8.6
	#./$@ 0 < data/regexdna-input.txt

pidigits: pidigits.c
	$(CC) $(CFLAGS) $< -o $@ -lgmp
	#./$@ 10000

chameosredux-2: chameneosredux-2.c
	$(CC) $(CFLAGS) -pthread $< -o $@ 
	#./$@ 6000000

threadring: threadring.c
	$(CC) $(CFLAGS) -pthread $< -o $@
	#./$@ 50000000

binarytrees: binarytrees.c
	# removed -funroll-loops 
	$(CC) $(O) -fomit-frame-pointer -static $< -lm -o $@
	#./$@ 20

.PHONY: build-one-of-each build-custom-set clean
