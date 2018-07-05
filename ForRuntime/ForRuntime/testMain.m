//
//  testMain.m
//  ForRuntime
//
//  Created by DHSD on 2018/7/5.
//  Copyright © 2018年 DHSD. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <objc/objc-runtime.h>

@protocol AProtocol <NSObject>
- (void)aProtocolMethod;
@end
@interface B : NSObject
- (void)bTest;
@end
@implementation B
- (void)bTest {
    NSLog(@"bTest");
}
@end
@interface A : NSObject <AProtocol> {
    NSString *strA;
}
@property (nonatomic, assign) NSUInteger uintA;
- (void)test;
@end
@implementation A
- (void)test {
    NSLog(@"%lu", (unsigned long)_uintA);
}
@end
void aNewMethod() {
    NSLog(@"aNewMethod");
}


int main() {
    
    // 调用一个object的method
    // method_invoke_stret(testMethod, method); 参照void method_invoke_stret(void *stretAddr, id theReceiver, SEL theSelector, ....) stretAddr为返回的数据结构
    // 若报错，project里面设定Enable Strict Checking of objc_msgSend Calls为NO
    A *testMethod = [A new];
    testMethod.uintA = 100;
    unsigned int outCount;
    Method *methods = class_copyMethodList([A class], &outCount);
    Method method = methods[0];
    method_invoke(testMethod, method);  // a
    // 将某个method指向一个新的IMP
    method_setImplementation(method, (IMP)aNewMethod);
    method_invoke(testMethod, method);  // b
    // 获取method的SEL
    SEL methodSel = method_getName(method);
    NSLog(@"%s", methodSel);    // c
    // 获取method的IMP
    // 随意传两个参数，无所谓的
    IMP methodImp = method_getImplementation(method);
    methodImp(0,0); // d
    // 获取method的类型编码，包含返回值和参数
    const char *methodEncoding = method_getTypeEncoding(method);
    NSLog(@"%s", methodEncoding);   // e
    // 获取method的返回值类型
    const char *returnType = method_copyReturnType(method);
    NSLog(@"%s", returnType);   // f
    // 获取method的某个参数类型
    const char *oneArgumentType = method_copyArgumentType(method, 0);
    NSLog(@"%s", oneArgumentType);  // g
    // 获取method的返回值类型
    char dst[256];
    method_getReturnType(method, dst, 256);
    NSLog(@"%s", dst);  // h
    // 获取method的参数个数
    unsigned int numOfArgu = method_getNumberOfArguments(method);
    NSLog(@"%d" ,numOfArgu);    // i
    // 获取method的某个参数的类型
    method_getArgumentType(method, 0, dst, 256);
    NSLog(@"%s", dst);  // j
    // 获取method的描述
    objc_method_description des = *method_getDescription(method);
    NSLog(@"%s", des);  // k
    // 更换method method_exchangeImplementations
    method_exchangeImplementations(methods[0], methods[1]);
    method_invoke(testMethod, methods[1]);  // l
    
    
    return 0;
}
