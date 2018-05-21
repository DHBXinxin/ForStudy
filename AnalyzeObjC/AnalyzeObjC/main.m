//
//  main.m
//  AnalyzeObjC
//
//  Created by DHSD on 2018/5/19.
//  Copyright © 2018年 DHSD. All rights reserved.
//

#import <Foundation/Foundation.h>

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        // insert code here...
        NSLog(@"Hello, World!");
    }
    return 0;
}
//isa 是指向元类的指针，不了解元类的可以看 Classes and Metaclasses
//super_class 指向当前类的父类
//cache 用于缓存指针和 vtable，加速方法的调用
//bits 就是存储类的方法、属性、遵循的协议等信息的地方
