#!/usr/bin/env -S /bin/sh -c "exec awk -f ${_} -f ../../aoclib.awk input.txt"

{
    len=split($1,world[NR],"")
    if (!startx && (startx=index($1,"S")))
        starty=NR
}

function test(x,y,s,w) {
    if (x==0 || x>len || y==0 || y>NR || world[y][x]=="#" || x in w[y])
        return 0
    w[y][x]=s+1
    return 1
}

function step(s,w, x,y,sum) {
    for (y in w) {
        y=int(y)
        for (x in w[y]) {
            x=int(x)
            if (w[y][x]==s) {
                sum+=test(x-1,y,s,w)
                sum+=test(x+1,y,s,w)
                sum+=test(x,y-1,s,w)
                sum+=test(x,y+1,s,w)
            }
        }
    }
    return sum
}

function count(odd,w, x,y,sum) {
    for (y=1;y<=NR;y++)
        for (x=1;x<=len;x++)
            if (y in w && x in w[y] && typeof(w[y][x])=="number" && w[y][x]%2==odd)
                sum++
    return sum
}

function trace(odd,sx,sy,steps, w,i) {
    w[sy][sx]=0
    for (i=0;i<steps && step(i,w);i++) ;
    return count(odd,w)
}

END {
    print "Part 1: " trace(0,startx,starty,64)

    if (NR!=len) { print "Assertion \"input is square\" failed"; exit }
    if ((len%2)==0) { print "Assertion \"input square has odd length\" failed"; exit }
    if (startx!=starty || startx!=(len+1)/2) { print "Assertion \"Start is in the center of the world\" failed"; exit }
    # assertions for free space be here
    d=int((26501365-int(len/2))/len)                     # Number of blocks, excluding the center block
    r=(26501365-int(len/2))%len                          # Remaining steps in the final block (0 means at the end of the block)
    if (r!=0) { print "Assertion \"End lies in second half of final block\" failed"; exit }
#    if (r==0)                                           # Shift by one if the final block is complete
    d--                                                  # Which it always is (here)

    fullworlds=2*d*(d+1)+1                               # Number of complete blocks inside the resulting area
    clo=1+2*int(d/2)                                     # Odd blocks on the center line
    oddworlds=clo^2                                      # Number of odd block of the complete blocks
    oddsteps=trace(1,startx,starty,2*len)                # Number of odd ending point in a full block
    evenworlds=fullworlds-oddworlds                      # Number of even blocks of the complete blocks
    evensteps=trace(0,startx,starty,2*len)               # Number of even ending point in a full block
    outside=!(d%2)                                       # Outside world odd or even

    part2 =oddworlds * oddsteps + evenworlds * evensteps

    part2+=trace(outside,startx,len,len-1)               # Add the top element
    part2+=trace(outside,1,starty,len-1)                 # Add the rightmost element
    part2+=trace(outside,startx,1,len-1)                 # Add the bottom element
    part2+=trace(outside,len,starty,len-1)               # Add the leftmost element

    part2+=(d+1)*trace(outside,1,len,int(len/2)-1)       # Add the top-right small triangles
    part2+=(d+1)*trace(outside,len,len,int(len/2)-1)     # Add the top-left small triangles
    part2+=(d+1)*trace(outside,1,1,int(len/2)-1)         # Add the bottom-right small triangles
    part2+=(d+1)*trace(outside,len,1,int(len/2)-1)       # Add the bottom-left small triangles

    part2+=d*trace(!outside,1,len,int(len*3/2)-1)        # Add the top-right large triangles
    part2+=d*trace(!outside,len,len,int(len*3/2)-1)      # Add the top-left large triangles
    part2+=d*trace(!outside,1,1,int(len*3/2)-1)          # Add the bottom-right large triangles
    part2+=d*trace(!outside,len,1,int(len*3/2)-1)        # Add the bottom-left large triangles
    print "Part 2: " part2
}
