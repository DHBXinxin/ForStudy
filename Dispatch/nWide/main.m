//
//  main.m
//  nWide
//
//  Created by DHSD on 2018/6/20.
//  Copyright © 2018年 DHSD. All rights reserved.
//

#import <Foundation/Foundation.h>

#include <stdio.h>
#include <unistd.h>
#include <stdlib.h>
#include <sys/errno.h>
#include <assert.h>
#include <dispatch/dispatch.h>
#include <mach/mach_time.h>
#import <libkern/OSAtomic.h>
#include <string.h>

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        // insert code here...
        dispatch_group_t    mg = dispatch_group_create();
        dispatch_semaphore_t ds;
        __block int numRunning = 0;
        int    qWidth = 5;
        int numWorkBlocks = 100;
        
        if (argc >= 2) {
            qWidth = atoi(argv[1]);    // use the command 1st line parameter as the queue width
            if (qWidth==0) qWidth=1; // protect against bad values
        }
        
        if (argc >=3) {
            numWorkBlocks = atoi(argv[2]);    // use the 2nd command line parameter as the queue width
            if (numWorkBlocks==0) numWorkBlocks=1; // protect against bad values
        }
        
        printf("Starting dispatch semaphore test to simulate a %d wide dispatch queue\n", qWidth );
        ds = dispatch_semaphore_create(qWidth);
        
        int i;
        for (i=0; i<numWorkBlocks; i++) {
            // synchronize the whole shebang every 25 work units...
            if (i % 25 == 24) {
                dispatch_group_async(mg,dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,0), ^{
                    // wait for all pending work units to finish up...
                    for (int x=0; x<qWidth; x++) dispatch_semaphore_wait(ds, DISPATCH_TIME_FOREVER);
                    // do the thing that is critical here
                    printf("doing something critical...while %d work units are running \n",numRunning);
                    // and let work continue unimpeeded
                    for (int x=0; x<qWidth; x++) dispatch_semaphore_signal(ds);
                });
            } else {
                // schedule the next block waiting when there are qWidth blocks running
                dispatch_semaphore_wait(ds, DISPATCH_TIME_FOREVER);
                dispatch_group_async(mg,dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,0), ^{
                    OSAtomicIncrement32( &numRunning );
                    usleep(random() % 10000);    // simulate some random amount of work
                    printf("Value of i is %d  Number of blocks in flight %d\n",i, numRunning);
                    // tell the loop it's time to schedule the next block if there is one
                    OSAtomicDecrement32( &numRunning );
                    dispatch_semaphore_signal(ds);
                });
            }
        }
        
        dispatch_group_notify(mg, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            printf("And we are done!\n");
//            dispatch_release(mg);
//            dispatch_release(ds);
            exit(0);
        });
        
        dispatch_main();
        
    }
    return 0;
}
