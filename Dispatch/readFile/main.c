//
//  main.c
//  readFile
//
//  Created by DHSD on 2018/6/20.
//  Copyright © 2018年 DHSD. All rights reserved.
//

#include <assert.h>
#include <fcntl.h>
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <string.h>
#include <sys/errno.h>

#include <dispatch/dispatch.h>

int main(int argc, const char * argv[]) {
    // insert code here...
    int infd;
    dispatch_source_t fileSource;
    
    if (argc != 2) {
        fprintf(stderr, "usage: %s file ...\n", argv[0]);
        exit(1);
    }
    
    
    infd = open(argv[1], O_RDONLY);
    if (infd == -1) {
        perror(argv[1]);
        exit(1);
    }
    
    if (fcntl(infd, F_SETFL, O_NONBLOCK) != 0) {
        perror(argv[1]);
        exit(1);
    }
    
    fileSource = dispatch_source_create(DISPATCH_SOURCE_TYPE_READ, infd, 0, dispatch_queue_create("read source queue",NULL));
    
    dispatch_source_set_event_handler( fileSource, ^{
        char buffer[10];
        size_t estimated = dispatch_source_get_data(fileSource);
        printf("Estimated bytes available: %ld\n", estimated);
        ssize_t actual = read(infd, buffer, sizeof(buffer));
        if (actual == -1) {
            if (errno != EAGAIN) {
                perror("read");
                exit(-1);
            }
        } else {
            if  (estimated>actual) {
                printf("  bytes read: %ld\n", actual);
            } else {
                // end of file has been reached.
                printf("  last bytes read: %ld\n", actual);
                dispatch_source_cancel(fileSource);
            }
        }
    });
    
    dispatch_source_set_cancel_handler( fileSource, ^{
        // release all our associated dispatch data structures
        dispatch_release(fileSource);
        dispatch_release(dispatch_get_current_queue());
        // close the file descriptor because we are done reading it
        close(infd);
        // and since we have nothing left to do, exit the tool
        exit(0);
        
    });
    
    dispatch_resume(fileSource);
    
    dispatch_main();
    
    return 0;
}
