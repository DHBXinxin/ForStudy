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
        
    }
//self和mulData是标识符
    [_mulData addObject:element];
}
@end
