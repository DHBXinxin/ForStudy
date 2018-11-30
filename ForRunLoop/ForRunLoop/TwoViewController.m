//
//  TwoViewController.m
//  ForRunLoop
//
//  Created by DHSD on 2018/11/27.
//  Copyright © 2018 DHSD. All rights reserved.
//

#import "TwoViewController.h"
//测试第二种滚动中timer暂停
@interface TwoViewController ()

@property (assign, nonatomic) NSInteger count;

@property (weak, nonatomic) IBOutlet UILabel *timeLable;
@end

@implementation TwoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    // 第一种写法
    NSTimer *timer = [NSTimer timerWithTimeInterval:1.0 target:self selector:@selector(timerUpdate) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSDefaultRunLoopMode];
    [timer fire];
    
    // 第二种写法
//    [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timerUpdate) userInfo:nil repeats:YES];
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
}

@end
