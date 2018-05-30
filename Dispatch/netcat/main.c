//
//  main.c
//  netcat
//
//  Created by DHSD on 2018/5/27.
//  Copyright © 2018年 DHSD. All rights reserved.
//

#include <stdio.h>
#include <Block.h>
#include <stdlib.h>
#include <unistd.h>
#include <err.h>
#include <syslog.h>
#include <sys/types.h>
#include <sys/socket.h>
#include <sys/fcntl.h>
#include <errno.h>
#include <netdb.h>
#include <stdbool.h>
#include <string.h>
#include <sys/param.h>
#include <sys/ioctl.h>
#include <mach/mach.h>
#include <pthread.h>

#if DEBUG
#define dlog(a) dispatch_debug(a, #a)
#else
#define dlog(a) do{ } while(0)
#endif

void usage(void);
void *run_block(void *);
void setup_fd_relay(int netfd /* bidirectional */,
                    int infd /* local input */,
                    int outfd /* local output */,
                    void (^finalizer_block)(void));
void doreadwrite(int fd1, int fd2, char *buffer, size_t len);


int main(int argc, const char * argv[]) {
    // insert code here...
    printf("Hello, World!\n");
    return 0;
}
