//
//  main.c
//  timers
//
//  Created by DHSD on 2018/6/20.
//  Copyright © 2018年 DHSD. All rights reserved.
//


#include <assert.h>
#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <sys/errno.h>
#include <mach/clock_types.h>

#include <dispatch/dispatch.h>

int main(int argc, const char * argv[]) {
    // insert code here...
    dispatch_source_t theTimer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, dispatch_queue_create("timer queue",NULL));
    
    __block int i = 0;
    
    printf("Starting to count by seconds\n");
    
    dispatch_source_set_event_handler(theTimer, ^{
        printf("%d\n", ++i);
        if (i >= 6) {
            printf("i>6\n");
            dispatch_source_cancel(theTimer);
        }
        if (i == 3) {
            printf("switching to half seconds\n");
            dispatch_source_set_timer(theTimer, DISPATCH_TIME_NOW, NSEC_PER_SEC / 2, 0);
        }
    });
    
    dispatch_source_set_cancel_handler(theTimer, ^{
        printf("dispatch source canceled OK\n");
        dispatch_release(theTimer);
        exit(0);
    });
    
    dispatch_source_set_timer(theTimer, dispatch_time(DISPATCH_TIME_NOW,NSEC_PER_SEC) , NSEC_PER_SEC, 0);
    
    dispatch_resume(theTimer);
    dispatch_main();
    return 0;
}
