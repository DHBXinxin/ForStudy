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
