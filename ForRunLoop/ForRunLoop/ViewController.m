//
//  ViewController.m
//  ForRunLoop
//
//  Created by DHSD on 2018/11/15.
//  Copyright © 2018 DHSD. All rights reserved.
//

#import "ViewController.h"
#import "LThread.h"
#import "CommonObject.h"
///简单来说：runloop创建了一个循环--在线程里面表示这个线程一直在运行知道这个循环结束、但是这个循环按设计来说他是一直运行的直到app结束、所以线程在程序运行中是一直存在的不会被dealloc掉
@interface ViewController ()

@property (weak, nonatomic) LThread *subThread;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [self threadTest];
    [self deallocTest];
    
    [self test2];
}
- (void)test2 {
    LThread *subThread = [[LThread alloc] initWithTarget:self selector:@selector(subThreadEntryPoint) object:nil];
    [subThread setName:@"HLThread"];
    [subThread start];
    self.subThread = subThread;
}
- (void)subThreadEntryPoint {
    @autoreleasepool {
        NSRunLoop *runLoop = [NSRunLoop currentRunLoop];
        //如果注释了下面这一行，子线程中的任务并不能正常执行
        [runLoop addPort:[NSMachPort port] forMode:NSRunLoopCommonModes];
        NSLog(@"启动RunLoop前--%@",runLoop.currentMode);
        [runLoop run];
    }
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self performSelector:@selector(subThreadOpetion) onThread:self.subThread withObject:nil waitUntilDone:NO];
    
}
- (void)subThreadOpetion
{
    NSLog(@"启动RunLoop后--%@",[NSRunLoop currentRunLoop].currentMode);
    NSLog(@"%@----子线程任务开始",[NSThread currentThread]);
    [NSThread sleepForTimeInterval:3.0];
    NSLog(@"%@----子线程任务结束",[NSThread currentThread]);
}


#pragma mark ------------------------------

- (void)deallocTest {
    CommonObject *obj = [[CommonObject alloc]init];
    NSLog(@"----------%@",obj);
}//方法结束之后对象被销毁
- (void)threadTest {
    LThread *thread = [[LThread alloc]initWithTarget:self selector:@selector(threadOperate) object:nil];
    [thread start];
}

- (void)threadOperate {
    @autoreleasepool {
        NSLog(@"%@----子线程任务开始",[NSThread currentThread]);
        [NSThread sleepForTimeInterval:3.0];
        NSLog(@"%@----子线程任务结束",[NSThread currentThread]);
        //结束之后线程被销毁、同时对象才被销毁
    }
}

@end
