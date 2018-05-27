//
//  main.c
//  apply
//
//  Created by DHSD on 2018/5/27.
//  Copyright © 2018年 DHSD. All rights reserved.
//

#include <stdio.h>
#include <unistd.h>
#include <stdlib.h>
#include <sys/errno.h>
#include <assert.h>
#include <dispatch/dispatch.h>
#include <mach/mach_time.h>

#define kIT    10

uint64_t        elapsed_time;

void    timer_start() {
    elapsed_time = mach_absolute_time();
}

double    timer_milePost() {
    static dispatch_once_t        justOnce;
    static double        scale;
    
    dispatch_once(&justOnce, ^{
        mach_timebase_info_data_t    tbi;
        mach_timebase_info(&tbi);
        scale = tbi.numer;
        scale = scale/tbi.denom;
        printf("Scale is %10.4f  Just computed once courtesy of dispatch_once()\n", scale);
    });
    
    uint64_t    now = mach_absolute_time()-elapsed_time;
    double    fTotalT = now;
    fTotalT = fTotalT * scale;            // convert this to nanoseconds...
    fTotalT = fTotalT / 1000000000.0;
    return fTotalT;
}

int main(int argc, const char * argv[]) {
    dispatch_queue_t myQueue = dispatch_queue_create("myQueue", NULL);
    dispatch_group_t myGroup = dispatch_group_create();
    
    // dispatch_apply on a serial queue finishes each block in order so the following code will take a little more than a second
    timer_start();
    dispatch_apply(kIT, myQueue, ^(size_t current){
        printf("Block #%ld of %d is being run\n",
               current+1, // adjusting the zero based current iteration we get passed in
               kIT);
        usleep(USEC_PER_SEC/10);
    });
    printf("and dispatch_apply( serial queue ) returned after %10.4lf seconds\n",timer_milePost());
    
    // dispatch_apply on a concurrent queue returns after all blocks are finished, however it can execute them concurrently with each other
    // so this will take quite a bit less time
    timer_start();
    dispatch_apply(kIT, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(size_t current){
        printf("Block #%ld of %d is being run\n",current+1, kIT);
        usleep(USEC_PER_SEC/10);
    });
    printf("and dispatch_apply( concurrent queue) returned after %10.4lf seconds\n",timer_milePost());
    
    // To execute all blocks in a dispatch_apply asynchonously, you will need to perform the dispatch_apply
    // asynchonously, like this (NOTE the nested dispatch_apply inside of the async block.)
    // Also note the use of the dispatch_group so that we can ultimatly know when the work is
    // all completed
    
    timer_start();
    dispatch_group_async(myGroup, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        dispatch_apply(kIT, myQueue, ^(size_t current){
            printf("Block #%ld of %d is being run\n",current+1, kIT);
            usleep(USEC_PER_SEC/10);
        });
    });
    
    printf("and dispatch_group_async( dispatch_apply( )) returned after %10.4lf seconds\n",timer_milePost());
    printf("Now to wait for the dispatch group to finish...\n");
    dispatch_group_wait(myGroup, UINT64_MAX);
    printf("and we are done with dispatch_group_async( dispatch_apply( )) after %10.4lf seconds\n",timer_milePost());
    return 0;
}
