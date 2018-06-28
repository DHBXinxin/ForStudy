//
//  ViewController.m
//  CEP
//
//  Created by DHSD on 2018/5/22.
//  Copyright © 2018年 DHSD. All rights reserved.
//

#import "ViewController.h"

//extension
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self.view forwardingTargetForSelector:@selector(addObject:)];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
