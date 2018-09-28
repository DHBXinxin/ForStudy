//
//  People.m
//  runtimeTest
//
//  Created by DHSD on 2018/9/20.
//  Copyright © 2018年 DHSD. All rights reserved.
//

#import "People.h"
#import <objc/runtime.h>
#import <objc/message.h>

@implementation People

- (NSDictionary *)allIvars {
    unsigned int count = 0;
    
    NSMutableDictionary *resultDictionary = [NSMutableDictionary dictionary];
    //获取类的成员变量、没有count为l0
    Ivar * ivars = class_copyIvarList([self class], &count);
    for (NSInteger i = 0 ; i < count; i++) {
        const char *varName = ivar_getName(ivars[i]);
        NSString *name = [NSString stringWithUTF8String:varName];
        id varValue = [self valueForKey:name];
        if (varValue) {
            [resultDictionary setObject:varValue forKey:name];
        } else {
            resultDictionary[name] = @"字典的key对应的value不能为nil哦！";
        }
    }
    free(ivars);
    return resultDictionary;
}
- (NSDictionary *)allMethods {
    unsigned int count = 0;
    NSMutableDictionary *resultDictionary = [NSMutableDictionary dictionary];
    Method *methods = class_copyMethodList([self class], &count);
    for (NSInteger i = 0; i < count; i++) {
        SEL methodSEL = method_getName(methods[i]);
        const char *methodName = sel_getName(methodSEL);
        NSString *name = [NSString stringWithUTF8String:methodName];
        int arguments = method_getNumberOfArguments(methods[i]);
        [resultDictionary setObject:@(arguments - 2) forKey:name];//减去默认的两个参数self和_cmd
    }
    free(methods);
    return resultDictionary;
}
- (NSDictionary *)allProperties {
    unsigned int count = 0;
    
    // 获取类的所有属性，如果没有属性count就为0
    objc_property_t *properties = class_copyPropertyList([self class], &count);
    NSMutableDictionary *resultDict = [@{} mutableCopy];
    
    for (NSUInteger i = 0; i < count; i ++) {
        
        // 获取属性的名称和值
        const char *propertyName = property_getName(properties[i]);
        NSString *name = [NSString stringWithUTF8String:propertyName];
        id propertyValue = [self valueForKey:name];
        
        if (propertyValue) {
            resultDict[name] = propertyValue;
        } else {
            resultDict[name] = @"字典的key对应的value不能为nil哦！";
        }
    }
    
    // 这里properties是一个数组指针，我们需要使用free函数来释放内存。
    free(properties);
    
    return resultDict;
}
@end
