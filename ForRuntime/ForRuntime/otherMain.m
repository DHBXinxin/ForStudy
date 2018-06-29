//
//  otherMain.m
//  ForRuntime
//
//  Created by DHSD on 2018/6/28.
//  Copyright © 2018年 DHSD. All rights reserved.
//

#import <Foundation/Foundation.h>
@interface A : NSObject
@property (nonatomic, assign) NSInteger a;
- (void)b;
+ (void)c;
@end
@implementation A
- (void)b {
    NSLog(@"b");
}
+ (void)c {
    NSLog(@"c");
}
@end

int main(int argc, char * argv[]) {
    A *aObject = [[A alloc] init];
    // 实例方法调用
    [aObject b];
    // 类方法调用
    [A c];
}

