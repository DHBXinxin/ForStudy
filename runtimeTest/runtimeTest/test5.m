//
//  test5.m
//  runtimeTest
//
//  Created by DHSD on 2018/9/28.
//  Copyright © 2018年 DHSD. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CTeather.h"
int main(int argc, const char * argv[]) {
    @autoreleasepool {
        // insert code here...
        NSLog(@"Hello, World!");
        
        NSDictionary *dict = @{
                               @"name" : @"苍井空",
                               @"age"  : @18,
                               @"occupation" : @"老师",
                               @"nationality" : @"日本"
                               };
        
        // 字典转模型
        CTeather *cangTeacher = [[CTeather alloc] initWithDictionary:dict];
        NSLog(@"热烈欢迎，从%@远道而来的%@岁的%@%@",cangTeacher.nationality,cangTeacher.age,cangTeacher.name,cangTeacher.occupation);
        
        // 模型转字典
        NSDictionary *covertedDict = [cangTeacher covertToDictionary];
        NSLog(@"%@",covertedDict);
    }
    return 0;
}
