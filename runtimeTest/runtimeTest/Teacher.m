//
//  Teacher.m
//  runtimeTest
//
//  Created by DHSD on 2018/9/25.
//  Copyright © 2018年 DHSD. All rights reserved.
//

#import "Teacher.h"
#import <objc/runtime.h>
#import <objc/message.h>
@implementation Teacher
- (void)encodeWithCoder:(nonnull NSCoder *)aCoder {
    unsigned int count = 0;
    Ivar *ivars = class_copyIvarList([self class], &count);
    for (NSUInteger i = 0; i < count; i ++) {
        Ivar ivar = ivars[i];
        const char *name = ivar_getName(ivar);
        NSString *key = [NSString stringWithUTF8String:name];
        id value = [self valueForKey:key];
        [aCoder encodeObject:value forKey:key];
    }
    free(ivars);
}

- (nullable instancetype)initWithCoder:(nonnull NSCoder *)aDecoder {
    self = [super init];
    if (self) {
        unsigned int count = 0;
        Ivar *ivars = class_copyIvarList([self class], &count);
        for (NSUInteger i = 0; i < count; i ++) {
            Ivar ivar = ivars[i];
            const char *name = ivar_getName(ivar);
            NSString *key = [NSString stringWithUTF8String:name];
            id value = [aDecoder decodeObjectForKey:key];
            [self setValue:value forKey:key];
        }
        free(ivars);
    }
    return self;
}

//普通的归档方法
//_idNum = [aDecoder decodeIntForKey:ID];
//_name = [aDecoder decodeObjectForKey:name];
//
//[aCoder encodeInt:_idNum forKey:IDNUM];
//[aCoder encodeObject:_name forKey:NAME];
@end
