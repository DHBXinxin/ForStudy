//
//  ThirdViewController.m
//  ForRunLoop
//
//  Created by DHSD on 2019/2/19.
//  Copyright © 2019 DHSD. All rights reserved.
//

#import "ThirdViewController.h"
#import "CatchCrash.h"
#import <pthread/pthread.h>
//不知道以前怎么样、现在的话、有一样的c方法会报错、不能运行
@interface ThirdViewController ()

@end

@implementation ThirdViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [CatchCrash shareInstance];
    
    
    NSLog(@"app已经启动、进入界面");
    
    
   
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    NSArray *array = [NSArray array];
    
    NSLog(@"%@",[array objectAtIndex:1]);
}


@end
