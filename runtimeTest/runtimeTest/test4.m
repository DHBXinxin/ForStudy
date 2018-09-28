//
//  test4.m
//  runtimeTest
//
//  Created by DHSD on 2018/9/25.
//  Copyright © 2018年 DHSD. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <objc/runtime.h>
#import <objc/message.h>
#import "Teacher.h"

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        // insert code here...
        NSLog(@"Hello, World!");
        Teacher *cangTeacher = [[Teacher alloc] init];
        cangTeacher.name = @"苍井空";
        cangTeacher.age = @18;
        cangTeacher.occupation = @"老师";
        cangTeacher.nationality = @"日本";
        
        NSString *path = NSHomeDirectory();
        path = [NSString stringWithFormat:@"%@/cangTeacher",path];
        // 归档
        [NSKeyedArchiver archiveRootObject:cangTeacher toFile:path];
        // 解归档
        Teacher *teacher = [NSKeyedUnarchiver unarchiveObjectWithFile:path];
        NSLog(@"热烈欢迎，从%@远道而来的%@岁的%@%@",teacher.nationality,teacher.age,teacher.name,teacher.occupation);
    }
    return 0;
}
