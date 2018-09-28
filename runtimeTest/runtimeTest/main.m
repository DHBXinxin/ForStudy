//
//  main.m
//  runtimeTest
//
//  Created by DHSD on 2018/9/12.
//  Copyright © 2018年 DHSD. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <objc/runtime.h>
#import <objc/objc-runtime.h>
#import "ForInvocation.h"

//copy别人的代码
int main(int argc, const char * argv[]) {
    @autoreleasepool {
        // insert code here...
        NSLog(@"Hello, World!");
        
        ForInvocation *test = [ForInvocation new];
        [test test1];
        [test test2];
        [test test3];
        [test test4];
    }
    return 0;
}
