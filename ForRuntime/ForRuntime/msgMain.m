//
//  msgMain.m
//  ForRuntime
//
//  Created by DHSD on 2018/7/2.
//  Copyright © 2018年 DHSD. All rights reserved.
//

#import <Foundation/Foundation.h>


//消息转发
#import <objc/runtime.h>

@interface B : NSObject
- (void)b;
@end
@implementation B
- (void)b {
    NSLog(@"b");
}

- (void)doesNotRecognizeSelector:(SEL)aSelector {
    [super doesNotRecognizeSelector:aSelector];
}

+ (void)b {
    NSLog(@"bbbbbbb");
}
+ (void)doesNotRecognizeSelector:(SEL)aSelector {
    [super doesNotRecognizeSelector:aSelector];
}
+ (void)c {
    NSLog(@"cccccccc");
}
@end
@interface A : NSObject
@end
@implementation A

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

+ (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector {
    NSMethodSignature* signature = [super methodSignatureForSelector:aSelector];
    if (!signature) {
        Class bMeta = objc_getMetaClass(class_getName([B class]));
        signature = [[bMeta class] instanceMethodSignatureForSelector:aSelector];
    }
    return signature;
}

+ (void)forwardInvocation:(NSInvocation *)anInvocation {
    [anInvocation invokeWithTarget:[B class]];
}

+ (void)doesNotRecognizeSelector:(SEL)aSelector {
    [super doesNotRecognizeSelector:aSelector];
}
+ (id)forwardingTargetForSelector:(SEL)aSelector {
    if (aSelector == @selector(c)) {
        return [B class];
    }
    return [super forwardingTargetForSelector:aSelector];
}

@end
int main(int argc, char * argv[]) {
    A *aObject = [[A alloc] init];
    [aObject performSelector:@selector(b)];
    [[A class] performSelector:@selector(b)];
    [[A class] performSelector:@selector(c)];
    //respondsToSelector:和isKindOfClass:只会作用于继承链、不会出发消息msgsend
    return 0;
}


