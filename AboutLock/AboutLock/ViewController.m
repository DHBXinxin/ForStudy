//
//  ViewController.m
//  AboutLock
//
//  Created by DHSD on 2019/6/27.
//  Copyright © 2019 DHSD. All rights reserved.
//

#import "ViewController.h"
#import "TestLock.h"
#import <pthread/pthread.h>

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    __block NSInteger i = 0;
    [NSTimer scheduledTimerWithTimeInterval:1 repeats:YES block:^(NSTimer * _Nonnull timer) {
        i++;
        NSLog(@"%li",(long)i);
    }];
//    [self test1];
//    [self test2];
//    [self test3];
//    [self test4];
//    [self checkSemaphore];
    
}
- (void)checkSemaphore {
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSLog(@"任务1");
        dispatch_semaphore_signal(semaphore);//+1
    });
    dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
//    DISPATCH_TIME_FOREVER会一直等待知道信号量为正数
//    DISPATCH_TIME_NOW超时时间为0表示忽略信号量，直接向下运行
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSLog(@"任务2");
        dispatch_semaphore_signal(semaphore);//信号量+1
    });
    dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSLog(@"任务3");
    });
}
- (void)test4 {
    TestLock *obj = [[TestLock alloc]init];
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(1);//信号量为0的时候会一直等待
//    dispatch_semaphore_wait会对信号量做减1操作
//    dispatch_semaphore_signal会对信号量做加1操作
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);//阻塞
        [obj method1];
        sleep(10);
        dispatch_semaphore_signal(semaphore);
    });
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
        sleep(1);
        [obj method2];
        dispatch_semaphore_signal(semaphore);
    });
    
}
- (void)test3 {
    TestLock *obj = [[TestLock alloc]init];
    __block pthread_mutex_t mutex;
    pthread_mutex_init(&mutex, NULL);
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        pthread_mutex_lock(&mutex);
        [obj method1];
        sleep(10);
        pthread_mutex_unlock(&mutex);
    });
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        pthread_mutex_lock(&mutex);
        sleep(1);
        [obj method2];
        pthread_mutex_unlock(&mutex);
    });
}
- (void)test2 {
    TestLock *obj = [[TestLock alloc]init];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        @synchronized (obj) {
            [obj method1];
            sleep(10);
        }
    });
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        sleep(1);//不包含在锁里面的在执行block的时候就开始运行了
        @synchronized (obj) {
            [obj method2];
        }
    });
}
- (void)test1 {
    TestLock *obj = [[TestLock alloc]init];
    NSLock *lock = [[NSLock alloc]init];;
    
    NSLog(@"1111------------------");
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [lock lock];
        [obj method1];
        sleep(100);
        [lock unlock];
    });
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [lock lock];//打开锁之后102秒之后执行、没有锁的情况下2秒之后执行
        NSLog(@"2222----------------------");
        sleep(2);
        [obj method2];
        [lock unlock];
    });
    
}

@end
