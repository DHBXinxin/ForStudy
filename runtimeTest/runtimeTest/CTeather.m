//
//  CTeather.m
//  runtimeTest
//
//  Created by DHSD on 2018/9/26.
//  Copyright © 2018年 DHSD. All rights reserved.
//

#import "CTeather.h"
#import <objc/runtime.h>
#import <objc/message.h>

@interface CTeather()

@end

@implementation CTeather

- (instancetype)initWithDictionary:(NSDictionary *)dictionary {
    self = [super init];
    if (self) {
        for (NSString *key in dictionary.allKeys) {
            id value = [dictionary objectForKey:key];
            SEL setter = [self propertySetterByKey:key];
            if (setter) {
                ((void (*)(id, SEL, id))objc_msgSend)(self, setter, value);
                //两个方法等价
//                Method m = class_getInstanceMethod([self class], setter);
//                ((void (*)(id, Method, id))method_invoke)(self, m, value);

                
            }
        }
    }
    return self;
}
- (NSDictionary *)covertToDictionary
{
    unsigned int count = 0;
    objc_property_t *properties = class_copyPropertyList([self class], &count);
    
    if (count != 0) {
        NSMutableDictionary *resultDict = [@{} mutableCopy];
        
        for (NSUInteger i = 0; i < count; i ++) {
            const void *propertyName = property_getName(properties[i]);
            NSString *name = [NSString stringWithUTF8String:propertyName];
            
            SEL getter = [self propertyGetterByKey:name];
            if (getter) {
                id value = ((id (*)(id, SEL))objc_msgSend)(self, getter);
                if (value) {
                    resultDict[name] = value;
                } else {
                    resultDict[name] = @"字典的key对应的value不能为nil哦！";
                }
                
            }
        }
        
        free(properties);
        
        return resultDict;
    }
    
    free(properties);
    
    return nil;
}

//setter方法
- (SEL)propertySetterByKey:(NSString *)key {
    NSString *propertySetterName = [NSString stringWithFormat:@"set%@:",key.capitalizedString];//首字母大写
    SEL setter = NSSelectorFromString(propertySetterName);
    if ([self respondsToSelector:setter]) {
        return setter;
    }
    return nil;
}
//getter方法
- (SEL)propertyGetterByKey:(NSString *)key {
    SEL getter = NSSelectorFromString(key);
    if ([self respondsToSelector:getter]) {
        return getter;
    }
    return nil;
}
@end
