//
//  MyTestObject.m
//  ForRuntime
//
//  Created by DHSD on 2018/6/28.
//  Copyright © 2018年 DHSD. All rights reserved.
//

#import "MyTestObject.h"

void dynamicMethodIMP(id self, SEL _cmd)
{
    
}

@implementation MyTestObject


+ (BOOL)resolveInstanceMethod:(SEL)sel {
    
    if (sel == @selector(resolveThisMethodDynamically))
    {
        class_addMethod([self class], sel, (IMP) dynamicMethodIMP, "v@:");
        return YES;
    }
    return [super resolveInstanceMethod:sel];
}
- (void)printWords:(NSString *)words {
    [self printMessage:words];
    
    ((void (*) (id, SEL)) (void *)objc_msgSend)(self, sel_registerName("say"));
   id obj = objc_msgSend(self,@selector(printMessage:),@"Hello World!");
    NSLog(@"%p",obj);
}
//objc_msgSend报错解决
//在项目配置文件 -> Build Settings -> Enable Strict Checking of objc_msgSend Calls 这个字段设置为 NO
- (void)say {
    NSLog(@"saynonon");
}
- (void)printMessage:(NSString *)words {
    NSLog(@"printMessage:%@",words);
}
/*
// 首先看一下objc_msgSend的方法实现的伪代码
id objc_msgSend(id self, SEL op, ...) {
    if (!self) return nil;
    // 关键代码（a）
    IMP imp = class_getMethodImplementation(self->isa, SEL op);
    imp(self, op, ...); // 调用这个函数，伪代码...
}
// 查找IMP
IMP class_getMethodImplementation(Class cls, SEL sel) {
    if (!cls || !sel) return nil;
    IMP imp = lookUpImpOrNil(cls, sel);
    if (!imp) {
        ... // 执行动态绑定
    }
    IMP imp = lookUpImpOrNil(cls, sel);
    if (!imp) return _objc_msgForward; // 这个是用于消息转发的
    return imp;
}
// 遍历继承链，查找IMP
IMP lookUpImpOrNil(Class cls, SEL sel) {
    if (!cls->initialize()) {
        _class_initialize(cls);
    }
    Class curClass = cls;
    IMP imp = nil;
    do { // 先查缓存,缓存没有时重建,仍旧没有则向父类查询
        if (!curClass) break;
        if (!curClass->cache) fill_cache(cls, curClass);
        imp = cache_getImp(curClass, sel);
        if (imp) break;
    } while (curClass = curClass->superclass); // 关键代码（b）
    return imp;
}
*/
@end
