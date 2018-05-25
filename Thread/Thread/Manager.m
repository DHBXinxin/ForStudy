//
//  Manager.m
//  Thread
//
//  Created by DHSD on 2018/5/23.
//  Copyright © 2018年 DHSD. All rights reserved.
//

#import "Manager.h"

@implementation Manager
//dispatch_once_t保证单例只运行一次
+ (instancetype)shareManager {
    static Manager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[Manager alloc]init];
    });
    return manager;
}
@end
