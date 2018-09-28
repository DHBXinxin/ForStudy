//
//  test3.m
//  runtimeTest
//
//  Created by DHSD on 2018/9/25.
//  Copyright © 2018年 DHSD. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <objc/runtime.h>
#import <objc/message.h>
#import "People.h"
#import "People+Associated.h"

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        // insert code here...
        NSLog(@"Hello, World!");
        
        People *cangTeacher = [[People alloc] init];
        cangTeacher.name = @"苍井空";
        cangTeacher.age = 18;
        [cangTeacher setValue:@"老师" forKey:@"occupation"];
        cangTeacher.associatedBust = @(90);
        cangTeacher.associatedCallBack = ^(){
            
            NSLog(@"苍老师要写代码了！");
            
        };
        cangTeacher.associatedCallBack();
        
        NSDictionary *propertyResultDic = [cangTeacher allProperties];
        for (NSString *propertyName in propertyResultDic.allKeys) {
            NSLog(@"propertyName:%@, propertyValue:%@",propertyName, propertyResultDic[propertyName]);
        }
        
        NSDictionary *methodResultDic = [cangTeacher allMethods];
        for (NSString *methodName in methodResultDic.allKeys) {
            NSLog(@"methodName:%@, argumentsCount:%@", methodName, methodResultDic[methodName]);
        }
        
    }
    return 0;
}
