//
//  CangTeacher.m
//  runtimeTest
//
//  Created by DHSD on 2018/9/28.
//  Copyright © 2018年 DHSD. All rights reserved.
//

#import "CangTeacher.h"
#import <objc/runtime.h>
#import <objc/message.h>


@implementation CangTeacher

+ (BOOL)resolveInstanceMethod:(SEL)sel
{
    // 我们没有给People类声明sing方法，我们这里动态添加方法
    if ([NSStringFromSelector(sel) isEqualToString:@"sing"]) {
        class_addMethod(self, sel, (IMP)otherSing, "v@:");
        return YES;
    }
    return [super resolveInstanceMethod:sel];
}

void otherSing(id self, SEL cmd)
{
    NSLog(@"%@ 唱歌啦！",((CangTeacher *)self).name);
}
@end
