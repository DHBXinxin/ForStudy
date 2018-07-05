//
//  NSObject+Test.m
//  ForRuntime
//
//  Created by DHSD on 2018/7/5.
//  Copyright © 2018年 DHSD. All rights reserved.
//

#import "NSObject+Test.h"
#import <objc/runtime.h>

@implementation NSObject (Test)
- (void)setTest:(NSString *)test {
    objc_setAssociatedObject(self, @selector(test), test, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (NSString *)test {
    return objc_getAssociatedObject(self, @selector(test));
}

@end
