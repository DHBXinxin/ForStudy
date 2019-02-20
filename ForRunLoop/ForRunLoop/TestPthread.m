//
//  TestPthread.m
//  ForRunLoop
//
//  Created by DHSD on 2019/2/19.
//  Copyright © 2019 DHSD. All rights reserved.
//

#import "TestPthread.h"
#import <pthread/pthread.h>

void *demo(void *param){
    NSLog(@"%@  %@",[NSThread currentThread],param);
    return NULL;
}

@implementation TestPthread

- (void)test1 {
    NSString *str = @"hello JG";
    pthread_t threadID;
    int result = pthread_create(&threadID, NULL, &demo, (__bridge void *)(str));
    if (result) {
        NSLog(@"OK");
    }else{
        NSLog(@"error %d",result);
    }
    
    /**
     pthread是属于POSIX 多线程开发框架
     参数：
     1.指向一个线程代号的指针
     2.线程的属性
     3.指向函数的指针
     4.传递该函数的参数
     返回值：
     如果是0，表示正确
     如果是非0，表示正确
     */
}
@end
