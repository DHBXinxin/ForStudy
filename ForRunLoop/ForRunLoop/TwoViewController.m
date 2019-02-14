//
//  TwoViewController.m
//  ForRunLoop
//
//  Created by DHSD on 2018/11/27.
//  Copyright © 2018 DHSD. All rights reserved.
//

#import "TwoViewController.h"
//测试第二种场景滚动中timer暂停
@interface TwoViewController ()

@property (assign, nonatomic) NSInteger count;

@property (weak, nonatomic) IBOutlet UITableView *mainTable;
@property (weak, nonatomic) IBOutlet UILabel *timeLable;

@end

@implementation TwoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    // 第一种写法
//    NSTimer *timer = [NSTimer timerWithTimeInterval:1.0 target:self selector:@selector(timerUpdate) userInfo:nil repeats:YES];
//    [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSDefaultRunLoopMode];
//    [timer fire];
    //第一种写法只是把timer加入了固定的NSDefaultRunLoopMode内、只要换成NSRunLoopCommonModes就可以了
    
/*--------------------------------------------------------------------*/
    //第一种写法修改之后
//    NSTimer *timer = [NSTimer timerWithTimeInterval:1.0 target:self selector:@selector(timerUpdate) userInfo:nil repeats:YES];
//    [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];//
//    [timer fire];

/*********************************************************************/
    // 第二种写法
//    [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timerUpdate) userInfo:nil repeats:YES];
//    [[NSRunLoop currentRunLoop] run];

    
    //第二种修改、添加了一个线程、让主线程可以正常运行、上面直接使用runloop会造成主线程阻塞
    //而第一种写法没有阻塞线程、就不是很明白了
//    [self creatThread];
    
}
- (void)creatThread {
    NSThread *thread = [[NSThread alloc]initWithTarget:self selector:@selector(testTimer) object:nil];
    [thread start];
}
- (void)ddd {
    [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timerUpdate) userInfo:nil repeats:YES];
}
- (void)testTimer {
    //再转回main相当于没有做任何修改、所以要用下面的方法
//    [self performSelectorOnMainThread:@selector(ddd) withObject:nil waitUntilDone:NO];

    @autoreleasepool {
//        NSRunLoop *runLoop = [NSRunLoop currentRunLoop];
//        NSLog(@"启动RunLoop前--%@",runLoop.currentMode);
//        NSLog(@"currentRunLoop:%@",[NSRunLoop currentRunLoop]);
        //注意这儿使用的是NSDefaultRunLoopMode
        NSTimer *timer = [NSTimer timerWithTimeInterval:1.0 target:self selector:@selector(timerUpdate) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSDefaultRunLoopMode];
        [timer fire];

        
//        [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timerUpdate) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop] run];
    }
}
- (void)timerUpdate {
    
    NSLog(@"当前线程：%@",[NSThread currentThread]);
    NSLog(@"启动RunLoop后--%@",[NSRunLoop currentRunLoop].currentMode);
    //    NSLog(@"currentRunLoop:%@",[NSRunLoop currentRunLoop]);
    dispatch_async(dispatch_get_main_queue(), ^{
        self.count ++;
        NSString *timerText = [NSString stringWithFormat:@"计时器:%ld",self.count];
        self.timeLable.text = timerText;
    });
    //Xcode9的新特性之Main Thread Checker
}


@end
