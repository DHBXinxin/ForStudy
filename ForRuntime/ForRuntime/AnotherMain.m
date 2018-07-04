//
//  AnotherMain.m
//  ForRuntime
//
//  Created by DHSD on 2018/6/29.
//  Copyright © 2018年 DHSD. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <objc/runtime.h>
@interface B : NSObject
- (void)b;
@end
@implementation B
- (void)b {
    NSLog(@"bbbbbbbbbbbbbbbbb");
}
- (void)doesNotRecognizeSelector:(SEL)aSelector {
    [super doesNotRecognizeSelector:aSelector];
}
@end

//动态绑定、
@interface A : NSObject {
    NSInteger _a;
}
@property (nonatomic, assign) NSInteger a;
@end
@implementation A
@dynamic a;

int a(id self, SEL _cmd) {
    return 1;
}
void setA(int aA, SEL _cmd) {
//    _a = aA;//不能在c方法中使用oc中的_a
    NSLog(@"1");
}
//- (void)setA:(NSInteger)a {
//    NSLog(@"oc1");
//    _a = a;
//}//先检查有没有setA：再从resolveInstanceMethod方法中检查setA、如果再没有就使用forwardInvocation（消息转发）来检查有没有实现、
+ (BOOL)resolveInstanceMethod:(SEL)sel {
    class_addMethod([self class], @selector(a), (IMP)a, "i@:");
    class_addMethod([self class], @selector(setA:), (IMP)setA, "vi:");

    return YES;
}
//类方法
void c(id obj, SEL _cmd) {
    NSLog(@"b");
}
+ (BOOL)resolveClassMethod:(SEL)sel {
    if (sel == @selector(b)) {
        Class aMeta = objc_getMetaClass(class_getName([self class]));
        class_addMethod([aMeta class], @selector(b), (IMP)c, "v@:");
        return YES;
    }
    if (sel == @selector(nowCanDo:)) {
        class_addMethod(object_getClass(self), sel, class_getMethodImplementation(object_getClass(self), @selector(myClassMethod:)), "v@:");
        return YES;
    }
    return [class_getSuperclass(self) resolveClassMethod:sel];
}
+ (void)myClassMethod:(NSString *)string {
    NSLog(@"myClassMethod = %@", string);
}
- (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector {
    NSMethodSignature* signature = [super methodSignatureForSelector:aSelector];
    if (!signature) {
        B *bObject = [[B alloc] init];
        signature = [bObject methodSignatureForSelector:aSelector];
    }
    return signature;
}

- (void)forwardInvocation:(NSInvocation *)anInvocation {
    B *bObject = [[B alloc] init];
    [anInvocation invokeWithTarget:bObject];
}

- (void)doesNotRecognizeSelector:(SEL)aSelector {
    [super doesNotRecognizeSelector:aSelector];
}

@end

@interface Student : NSObject
+ (void)learnClass:(NSString *) string;
- (void)goToSchool:(NSString *) name;
@end

@implementation Student
+ (BOOL)resolveClassMethod:(SEL)sel {
    if (sel == @selector(learnClass:)) {
        class_addMethod(object_getClass(self), sel, class_getMethodImplementation(object_getClass(self), @selector(myClassMethod:)), "v@:");
        return YES;
    }
    if (sel == @selector(speakSome:)) {
        Class aMeta = objc_getMetaClass(class_getName([self class]));
        class_addMethod([aMeta class], sel, (IMP)speak, "v@:");
        return YES;
    }
    if (sel == @selector(nowCanDo:)) {
        class_addMethod(object_getClass(self), sel, class_getMethodImplementation(object_getClass(self), @selector(myClassMethod:)), "v@:");
        return YES;
    }
    return [class_getSuperclass(self) resolveClassMethod:sel];
}


+ (BOOL)resolveInstanceMethod:(SEL)aSEL
{
    if (aSEL == @selector(goToSchool:)) {
        class_addMethod([self class], aSEL, class_getMethodImplementation([self class], @selector(myInstanceMethod:)), "v@:");
        return YES;
    }
   
    return [super resolveInstanceMethod:aSEL];
}
void speak(id obj, SEL _cmd) {
    NSLog(@"speak");
}
+ (void)myClassMethod:(NSString *)string {
    NSLog(@"myClassMethod = %@", string);
}

- (void)myInstanceMethod:(NSString *)string {
    NSLog(@"myInstanceMethod = %@", string);
}
@end
int main(int argc, char * argv[]) {
    A *aObject = [[A alloc] init];
    NSLog(@"%ld", aObject.a);   //@dynamic需要实现 不然会崩于此行
    aObject.a = 1;
    [A performSelector:@selector(nowCanDo:) withObject:@"a cando"];
    
    [[A class] performSelector:@selector(b)];
    
    Student *s = [[Student alloc]init];
    [s goToSchool:@"goto"];
    [Student learnClass:@"learn"];
    [Student performSelector:@selector(learnClass:) withObject:@"class"];
    [[Student class] performSelector:@selector(speakSome:) withObject:@"speak"];
    [[Student class] performSelector:@selector(nowCanDo:) withObject:@"speak"];
    [Student performSelector:@selector(nowCanDo:) withObject:@"class"];//在实例方法中找不到会自动转去找类方法、才造成与上面的那个一样

    Class cl = object_getClass(s);
    Class cls = objc_getClass("Student");
    NSLog(@"%@-----%@",cl, cls);
    
    //object_getClass(<#id  _Nullable obj#>)
    //以id获取class
    //objc_getClass(<#const char * _Nonnull name#>)
    //以字符串获取class
    return 0;
}
