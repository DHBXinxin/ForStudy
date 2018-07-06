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
