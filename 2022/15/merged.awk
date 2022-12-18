#!/usr/bin/env -S /bin/sh -c "exec awk -f ${_} input.txt"

function abs(a) { return a<0?-a:a }
function min(a,b) { return a<b?a:b }
function max(a,b) { return a>b?a:b }
function inrange(min,max,val) { return val>=min && val<=max}
function dist(x1,y1,x2,y2) { return abs(x1-x2)+abs(y1-y2) }

function merge(l1,l2,merged) {
    for (l1 in ranges) {
        for (l2 in ranges) {
            if (l1!=l2 && l1 in ranges && l2 in ranges) {
                if (inrange(ranges[l1][0],ranges[l1][1],ranges[l2][0]) ||
                    inrange(ranges[l1][0],ranges[l1][1],ranges[l2][1])) {
                    ranges[l1][0]=min(ranges[l1][0],ranges[l2][0])
                    ranges[l1][1]=max(ranges[l1][1],ranges[l2][1])
                    delete ranges[l2]
                    merged=1
                }
            }
        }
    }
    if (merged)
        merge()
}

{
    patsplit($0,a,"-?[0-9]+")
    x=sensors[NR][0]=a[1]
    y=sensors[NR][1]=a[2]
    beacons[a[3],a[4]][0]=a[3]
    beacons[a[3],a[4]][1]=a[4]
    md[NR]=dist(a[1],a[2],a[3],a[4])
}

function addrange(start,end) {
    l=length(ranges)
    ranges[l][0]=start
    ranges[l][1]=end
}

function calcline(line) {
    delete ranges
    for (s in sensors)
        if (inrange(sensors[s][1]-md[s],sensors[s][1]+md[s],line)) {
            d=abs(line-sensors[s][1])
            addrange(sensors[s][0]-md[s]+d, sensors[s][0]+md[s]-d)
        }
    merge()
}

END {
    calcline(2000000)
    for (i in ranges)
        sum+=ranges[i][1]-ranges[i][0]+1
    for (b in beacons)
        if (beacons[b][1]==2000000)
            sum--
    print "Part 1: " sum
    for (y=0;y<=4000000;y++) {
#        if (!(y%250000)) print y "..."
        calcline(y)
        sum=0
        for (i in ranges) {
            if (ranges[i][0]<4000000 && ranges[i][1]>0) {
                if (ranges[i][0]<0) ranges[i][0]=0
                if (ranges[i][1]>4000000) ranges[i][1]=4000000
                sum+=ranges[i][1]-ranges[i][0]+1
            }
        }
        if (sum!=4000001) {
            l=asort(ranges)
            if (l==1) {
                if (ranges[1][0]==0) x=4000000
                else x=0
            } else x=ranges[1][1]+1
            print "Part 2: " 4000000*x+y
            break
        }
    }
}
