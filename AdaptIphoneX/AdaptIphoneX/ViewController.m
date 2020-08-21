//
//  ViewController.m
//  AdaptIphoneX
//
//  Created by DHSD on 2019/6/4.
//  Copyright © 2019 DHSD. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@property (strong, nonatomic) UIScrollView *scrol;

@end

@implementation ViewController
//https://developer.apple.com/library/archive/qa/qa1686/_index.html
//项目中icon和default图片的命名规则、当然也可以直接使用Assets就不需要在意这些

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
  
    if (#available(iOS 11.0, *)) {
        NSLog(@"ssss");
    }
    //scrollview设置自动为nav留位置
    if (@available(iOS 11.0, *)) {
        [_scrol setContentInsetAdjustmentBehavior:UIScrollViewContentInsetAdjustmentAlways];
    } else {
        // Fallback on earlier versions
        self.automaticallyAdjustsScrollViewInsets = YES;
    }
    
}


@end
