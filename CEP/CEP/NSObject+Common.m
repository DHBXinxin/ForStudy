//
//  NSObject+Common.m
//  CEP
//
//  Created by DHSD on 2018/5/22.
//  Copyright © 2018年 DHSD. All rights reserved.
//

#import "NSObject+Common.h"

@implementation NSObject (Common)
//@synthesize name;
@dynamic name;

- (void)setName:(NSString *)name {
    self.name = name;//此句会导致无限循环
}
- (void)objLog {
    NSLog(@"objLog");
}
@end
//clang -rewrite-objc NSObject+Common.m生成cpp文件对于学习runtime有帮助
