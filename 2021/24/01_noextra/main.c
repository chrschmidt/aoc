#include <inttypes.h>
#include <stdint.h>
#include <stdio.h>
typedef uint64_t u64;
#include <string.h>
#include <time.h>

#include <pthread.h>

#define ARRAY_SIZE(x) (sizeof(x) / sizeof(x[0]))

#ifndef numthreads
#define numthreads 32
#endif

#ifndef basecount
#define basecount 4
#endif

static pthread_mutex_t startlock;
static pthread_mutex_t resultlock;

#ifdef PART2
int startpos = 0;
#else
int startpos = 9*9*9*9-1;
#endif

void getstartvals (u64 * vals) {
    pthread_mutex_lock (&startlock);
    int div = 1;
    for (int i = basecount-1; i>=0; i--) {
        vals[i] = 1 + (startpos / div) % 9;
        div = div * 9;
    }
/*
    struct timespec tp;
    struct tm tm;
    char time[20];
    clock_gettime (CLOCK_REALTIME, &tp);
    localtime_r (&tp.tv_sec, &tm);
    strftime (time, sizeof(time), "%F %T", &tm);
    printf ("%s: ", time);
    for (int i=0; i<basecount; i++)
        printf ("%" PRIu64, vals[i]);
    printf ("\n");
*/
#ifdef PART2
    startpos++;
#else
    startpos--;
#endif
    pthread_mutex_unlock (&startlock);
}

int solved = 0;
u64 result[15];

void chkresult (u64 * vals) {
    pthread_mutex_lock (&resultlock);
    if (solved) {
        for (int i=1; i<ARRAY_SIZE(result); i++) {
#ifdef PART2
            if (vals[i] < result[i]) {
#else
            if (vals[i] > result[i]) {
#endif
                memcpy (result, vals, sizeof (result));
                break;
            }
        }
    } else {
        memcpy (result, vals, sizeof (result));
    }
    solved = 1;
    pthread_mutex_unlock (&resultlock);
}

#ifdef PART2
#include "part2.h"
#else
#include "part1.h"
#endif

int main() {
    pthread_t threads[numthreads];
    pthread_mutex_init (&startlock, NULL);
    pthread_mutex_init (&resultlock, NULL);

    for (int i=0; i<numthreads; i++)
        pthread_create (&threads[i], NULL, run, NULL);
    for (int i=0; i<numthreads; i++)
        pthread_join (threads[i], NULL);
#ifdef PART2
    printf ("Part 2: ");
#else
    printf ("Part 1: ");
#endif
    for (int i=1; i<15; i++)
        printf ("%" PRIu64, result[i]);
    printf ("\n");
    return 0;
}
