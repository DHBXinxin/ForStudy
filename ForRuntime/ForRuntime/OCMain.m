//
//  OCMain.m
//  ForRuntime
//
//  Created by DHSD on 2018/6/28.
//  Copyright © 2018年 DHSD. All rights reserved.
//

#import <Foundation/Foundation.h>
@interface Base: NSObject
@end
@implementation Base
- (void)f {
    NSLog(@"Base f");
}
@end
@interface Derived: Base
@end
@implementation Derived
- (void)f {
    NSLog(@"Derived f");
}
@end
int main(int argc, char *argv[]) {
    printf("Hello");
    Derived *d = [[Derived alloc] init];
    Base *pb = d;
    Derived *pd = d;
    [pb f];     // 输出：Derived f
    [pd f];     // 输出：Derived f
    return 0;
}
//而OC没有添加关键字就完成了动态多态的实现、这都是runtime的功劳
