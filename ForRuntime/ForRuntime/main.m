//
//  main.m
//  ForRuntime
//
//  Created by DHSD on 2018/6/28.
//  Copyright © 2018年 DHSD. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MyTestObject.h"
//https://www.jianshu.com/p/560d27e6cc81
//返回值表达方法、addMethod方法中用到
//https://developer.apple.com/library/archive/documentation/Cocoa/Conceptual/ObjCRuntimeGuide/Articles/ocrtTypeEncodings.html#//apple_ref/doc/uid/TP40008048-CH100-SW1
//比如int：（id self， SEL _cmd，NSString * name）这样一个方法的表达式为i@:@
//class_addMethod(newClass, @selector(testMetaClass), (IMP)TestMetaClass, "v@:"); 第四个参数：一个定义该函数返回值类型和参数类型的字符串 根据返回值和参数动态的确定---可以使用这个方法获取值@encode(void)当不知道某个参数怎么表示的时候
int main(int argc, const char * argv[]) {
    @autoreleasepool {
        // insert code here...
        NSLog(@"Hello, World!");
        
        id obj1 = [NSMutableArray alloc];
        id obj2 = [[NSMutableArray alloc] init];
        id obj3 = [NSArray alloc];
        id obj4 = [[NSArray alloc] initWithObjects:@"Hello",nil];
        
        NSLog(@"obj1 class is %@",NSStringFromClass([obj1 class]));
        NSLog(@"obj2 class is %@",NSStringFromClass([obj2 class]));
        NSLog(@"obj3 class is %@",NSStringFromClass([obj3 class]));
        NSLog(@"obj4 class is %@",NSStringFromClass([obj4 class]));
        
        id obj5 = [MyTestObject alloc];
        id obj6 = [[MyTestObject alloc] init];
        
        NSLog(@"obj5 class is %@",NSStringFromClass([obj5 class]));
        NSLog(@"obj6 class is %@",NSStringFromClass([obj6 class]));

        [obj6 printWords:@"说什么"];
    }
    return 0;
}
//使用图片huibian中的方法来查看汇编源码
//图片消息展示了msg的工作流程
