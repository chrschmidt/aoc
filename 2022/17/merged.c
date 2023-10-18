#include <errno.h>
#include <inttypes.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/stat.h>
#include <time.h>

typedef uint64_t u64;
typedef uint32_t u32;
typedef uint8_t u8;
typedef u8 mapline;

static const u32 rocks[5][3] = {
    {1,3,15},
    {3,4,132866},
    {3,4,263175},
    {4,6,16843009},
    {2,5,771}
};

char * cjet;
u8 * jet;
int jetpos;
int jetlen;
mapline * map;

static inline int max(int a, int b) {
    return a>b?a:b;
}

void dump (int maplen) {
    printf ("Height: %d\n", maplen);
    for (int i=maplen-1; i>=0; i--) {
        for (int j=0;j<7;j++)
            printf ("%c", (map[i] & (1<<j)) ? '#':'.');
        printf ("\n");
    }
}

int spos[5][16];
int * jet4;

int load (const char * fname) {
    struct stat sb;
    int result;
    FILE * file;

    result = stat (fname, &sb);
    if (result) {
        printf ("Failed stat(%s): %s\n", fname, strerror (errno));
        return 1;
    }
    cjet = malloc (sb.st_size+1);
    file = fopen (fname, "r");
    if (!file) {
        printf ("Failed to fopen(%s): %s\n", fname, strerror (errno));
        return 1;
    }
    if (fgets (cjet, sb.st_size+1, file) == NULL) {
        printf ("Failed to fread(%s): %s\n", fname, strerror (errno));
        return 1;
    }
    fclose (file);
    jetlen = strlen (cjet);
    while (cjet[jetlen-1] == '\r' || cjet[jetlen-1] == '\n') {
        cjet[jetlen-1] = 0;
        jetlen--;
    }
    printf ("read %d characters\n", jetlen);
    return 0;
}

void init() {
    jet = malloc (2*jetlen);
    memcpy (jet, cjet, jetlen);
    memcpy (jet+jetlen, cjet, jetlen);
    for (int rock=0; rock<5; rock++)
        for (int j=0; j<16; j++) {
            spos[rock][j]=2;
            for (int i=0; i<4; i++)
                if (j&(1<<i)) {
                    if (spos[rock][j] < rocks[rock][1]) spos[rock][j]++;
                } else {
                    if (spos[rock][j]) spos[rock][j]--;
                }
        }
    jet4 = calloc (sizeof(int), 2*jetlen);
    for (int i=0; i<2*jetlen; i++)
        for (int j=0; j<4; j++)
            jet4[i] |= jet[(i+j)%(2*jetlen)]=='>'?1<<j:0;
}

int insert (int rock, int maplen) {
    int shift = spos[rock][jet4[jetpos]];
    u32 crock = rocks[rock][2];

    jetpos += 4;
    u8* mapwin = &map[maplen-1];
    while (!(*(u32*)mapwin & (crock << shift))) {
        if (jet[jetpos++] == '>') {
            if (shift < rocks[rock][1])
                if (!(*(u32*)mapwin & (crock << (shift+1))))
                    shift++;
        } else {
            if (shift)
                if (!(*(u32*)mapwin & (crock << (shift-1))))
                    shift--;
        }
        mapwin--;
    }
    *(u32*)++mapwin |= (crock << shift);
    return max(maplen, mapwin-map+rocks[rock][0]);
}

static const int mapsize = 50000;

u64 deleted;

int compress (int maplen) {
#ifdef debug
    printf ("Compressing %d->", maplen);
#endif
    mapline * newmap = calloc (mapsize, sizeof(mapline));
    int sum=0;
    int i;
    for (i=maplen-1; i && (sum != 127); i--)
        sum |= map[i];
    for (int j=0; j<maplen-i; j++)
        newmap[j] = map[i+j];
    free (map);
    map = newmap;
    deleted += i;
#ifdef debug
    printf ("  %d\n", maplen-i);
#endif
    return maplen-i;
}

int main () {
    struct timespec start, end;
    load ("input.txt");
    init();

    int maplen = 1;
    jetpos = 0;
    deleted = 0;
    map = calloc (mapsize, sizeof(mapline));
    map[0] = 127;
    for (int i=0; i<2022; i++) {
        maplen = insert (i%5, maplen);
        if (maplen > (mapsize-5))
            maplen = compress (maplen);
    }
    printf ("Part 1: %" PRIu64 "\n", deleted+maplen-1);
    free (map);

    maplen = 1;
    jetpos = 0;
    deleted = 0;
    map = calloc (mapsize, sizeof(mapline));
    map[0] = 127;
    if (clock_gettime (CLOCK_MONOTONIC, &start)) {
        printf ("error getting time %s\n", strerror (errno));
        return 1;
    }
    for (int k=0; k<10000; k++) {
        for (int i=0;i<20000000;i++) {
            for (int j=0;j<5;j++)
                maplen = insert(j, maplen);
            if (maplen > (mapsize-25))
                maplen = compress (maplen);
            if (jetpos > jetlen)
                jetpos -= jetlen;
        }
        clock_gettime (CLOCK_MONOTONIC, &end);
        u64 diff = 1000000000llu*end.tv_sec + end.tv_nsec -
            1000000000llu*start.tv_sec - start.tv_nsec;
        diff /= 1000000;
        printf ("loop %5d in %6" PRIu64 ".%03" PRIu64 "s, %" PRIu64 "\n",
                k, diff/1000, diff % 1000, deleted+maplen-1);
    }
    printf ("Part 2: %" PRIu64 "\n", deleted+maplen-1);
    return 0;
}
