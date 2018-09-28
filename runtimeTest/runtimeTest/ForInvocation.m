//
//  ForInvocation.m
//  runtimeTest
//
//  Created by DHSD on 2018/9/26.
//  Copyright © 2018年 DHSD. All rights reserved.
//

#import "ForInvocation.h"
@interface ForInvocation()
//如果没有这个声明、[[self class] methodSignatureForSelector:method];会返回空
//- (void)run;
//- (void)run:(NSString *)sport name:(NSString *)who friends:(NSArray *)friends;
//- (NSString *)getName:(NSString *)name;
@end
@implementation ForInvocation

- (void)test1 {
    SEL method = @selector(run);
    NSMethodSignature *sig = [[self class] instanceMethodSignatureForSelector:method];//注意test2使用的方法是另一个
    NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:sig];
    [invocation setSelector:method];
    invocation.target = self;
    [invocation invoke];//执行
}

- (void)test2 {
    SEL method = @selector(run:name:friends:);
    SEL methodTest = @selector(run);//用这个人测试下面的几个参数
    NSMethodSignature *sig = [self methodSignatureForSelector:method];
//    NSMethodSignature *sig = [[self class] methodSignatureForSelector:methodTest];
    
    NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:sig];
    [invocation setSelector:method];
    [invocation setTarget:self];
    NSString *sport = @"跑步";
    NSString *name = @"我";
    NSArray *friends = @[@"张三", @"李四"];
    [invocation setArgument:&sport atIndex:2];
    [invocation setArgument:&name atIndex:3];
    [invocation setArgument:&friends atIndex:4];
    [invocation invoke];
}
- (void)test3 {
    //补全参数
    SEL method = @selector(run:name:friends:);
    NSMethodSignature *sig = [self methodSignatureForSelector:method];
    
    NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:sig];
//    [invocation setSelector:method];
//    [invocation setTarget:self];
    __weak typeof(self) weakSelf = self;
    NSString *sport = @"跑步";
    NSString *name = @"我";
    NSArray *friends = @[@"张三", @"李四"];
    [invocation setArgument:(__bridge void * _Nonnull)(weakSelf) atIndex:0];
    [invocation setArgument:&method atIndex:1];
    [invocation setArgument:&sport atIndex:2];
    [invocation setArgument:&name atIndex:3];
    [invocation setArgument:&friends atIndex:4];
    NSLog(@"%d", invocation.argumentsRetained);
//    NSLog(@"%@",invocation.target);//崩溃到这儿
    NSLog(@"%@",NSStringFromSelector(invocation.selector));
    [invocation invokeWithTarget:self];
    NSLog(@"%@",invocation.target);
    [invocation retainArguments];
    [invocation invoke];
}
- (void)test4 {
    SEL method = @selector(getName:);
    NSMethodSignature *sig = [self methodSignatureForSelector:method];
    
    NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:sig];
    NSString *name = @"我";
    __weak typeof(self) weakSelf = self;
    [invocation setArgument:(__bridge void * _Nonnull)(weakSelf) atIndex:0];
    [invocation setArgument:&method atIndex:1];
    [invocation setArgument:&name atIndex:2];
    [invocation retainArguments];
    NSString *abc = @"abc";
    [invocation setReturnValue:&abc];

    NSString *bcd = @"bcd";
    [invocation getReturnValue:&bcd];
    NSLog(@"%@---%@",abc, bcd);
//    [invocation invoke];//崩溃到这儿

}
- (void)run {
    NSLog(@"无参数无返回值");
}
- (void)run:(NSString *)sport name:(NSString *)who friends:(NSArray *)friends {
    NSLog(@"%@和%@在%@",who, friends, sport);
}
- (NSString *)getName:(NSString *)name {
    return @"10";
}
@end
