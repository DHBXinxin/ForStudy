//
//  People+Associated.m
//  runtimeTest
//
//  Created by DHSD on 2018/9/25.
//  Copyright © 2018年 DHSD. All rights reserved.
//

#import "People+Associated.h"
#import <objc/runtime.h>
#import <objc/message.h>

@implementation People (Associated)

- (void)setAssociatedBust:(NSNumber *)bust {
    // 设置关联对象
    objc_setAssociatedObject(self, @selector(associatedBust), bust, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (NSNumber *)associatedBust {
    // 得到关联对象
    NSLog(@"--------------------------------------");
    NSLog(@"@selector:%s",@selector(associatedBust));
    return objc_getAssociatedObject(self, @selector(associatedBust));
}
- (void)setAssociatedCallBack:(CodingCallBack)callback {
    objc_setAssociatedObject(self, @selector(associatedCallBack), callback, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (CodingCallBack)associatedCallBack {
    return objc_getAssociatedObject(self, @selector(associatedCallBack));
}
@end
