//
//  ViewController.m
//  HowMainWork
//
//  Created by DHSD on 2018/5/17.
//  Copyright © 2018年 DHSD. All rights reserved.
//

#import "ViewController.h"

//http://blog.sunnyxx.com/2014/08/30/objc-pre-main/
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSLog(@"%@",paths);
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
//cd /Users/DHSD/Library/Developer/Xcode/DerivedData/ForStudy-fwmvohepyntzzbbficxdsqejapyl/Build/Products/Debug-iphonesimulator/HowMainWork.app
//$ otool -L HowMainWork
//HowMainWork:
///System/Library/Frameworks/CFNetwork.framework/CFNetwork (compatibility version 1.0.0, current version 897.15.0)
///System/Library/Frameworks/Accounts.framework/Accounts (compatibility version 1.0.0, current version 1.0.0)
///System/Library/Frameworks/Foundation.framework/Foundation (compatibility version 300.0.0, current version 1452.23.0)
///usr/lib/libobjc.A.dylib (compatibility version 1.0.0, current version 228.0.0)
///usr/lib/libSystem.dylib (compatibility version 1.0.0, current version 1252.50.4)
///System/Library/Frameworks/CoreFoundation.framework/CoreFoundation (compatibility version 150.0.0, current version 1452.23.0)
///System/Library/Frameworks/UIKit.framework/UIKit (compatibility version 1.0.0, current version 3698.52.10)
