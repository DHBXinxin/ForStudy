//
//  TestLock.m
//  AboutLock
//
//  Created by DHSD on 2019/6/27.
//  Copyright © 2019 DHSD. All rights reserved.
//

#import "TestLock.h"

@implementation TestLock

- (void)method1 {
    NSLog(@"%@",NSStringFromSelector(_cmd));
}

- (void)method2 {
    NSLog(@"%@",NSStringFromSelector(_cmd));
}

@end
