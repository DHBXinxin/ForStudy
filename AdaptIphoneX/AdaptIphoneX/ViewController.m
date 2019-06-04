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

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
  
    //scrollview设置自动为nav留位置
    if (@available(iOS 11.0, *)) {
        [_scrol setContentInsetAdjustmentBehavior:UIScrollViewContentInsetAdjustmentAlways];
    } else {
        // Fallback on earlier versions
        self.automaticallyAdjustsScrollViewInsets = YES;
    }
    
}


@end
