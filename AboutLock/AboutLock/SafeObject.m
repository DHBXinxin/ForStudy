//
//  SafeObject.m
//  AboutLock
//
//  Created by DHSD on 2019/8/12.
//  Copyright © 2019 DHSD. All rights reserved.
//

#import "SafeObject.h"

@interface SafeObject ()
{
    NSMutableArray *_mulData;
}
@end
@implementation SafeObject
- (instancetype)init {
    self = [super init];
    if (self) {
        
    }
    return self;
}
- (void)addElement:(id)element {
    @synchronized (self) {
        
    }
    @synchronized (_mulData) {
        
    }//这两个锁效果一样、一个把锁添加给self、一个添加给mulData而把下面这一句添加到锁的代码块、造成的效果是一样的
    [_mulData addObject:element];
}
@end
