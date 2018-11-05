//
//  main.m
//  MemorryManage
//
//  Created by DHSD on 2018/10/16.
//  Copyright © 2018年 DHSD. All rights reserved.
//

#import <Foundation/Foundation.h>
//内存管理
//不需甚解
int main(int argc, const char * argv[]) {
    @autoreleasepool {
        // insert code here...
        NSLog(@"Hello, World!");
        
    }
    
    
    id obj = [[NSObject alloc]init];
    NSLog(@"%i",[obj retainCount]);
    
    id array = [NSArray array];//非自己生成的对象，且该对象存在，但自己不持有
    NSLog(@"%i",[array retainCount]);
    [array release];
    
    id __weak objc=[[NSObject alloc]init];
    
    NSLog(@"弱引用自身地址:%p",&objc);
    
    NSLog(@"弱引用指向地址:%p",objc);
    
    id __strong obj0=[[NSObject alloc]init];
    
    id __weak obj1=obj0;
    
    NSLog(@"强引用自身地址:%p",&obj0);
    
    NSLog(@"弱引用自身地址:%p",&obj1);
    
    NSLog(@"强引用指向地址:%p",obj0);
    
    NSLog(@"弱引用指向地址:%p",obj1);
    
    obj1=nil;
    
//    obj0=nil;
    
    NSLog(@"弱引用销毁时强类型变量指向地址:%p",obj0);
    
    NSLog(@"弱引用销毁时弱类型变量指向地址:%p",obj1);
    
    return 0;
}
