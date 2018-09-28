//
//  Test6.m
//  runtimeTest
//
//  Created by DHSD on 2018/9/28.
//  Copyright © 2018年 DHSD. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <objc/runtime.h>
#import <objc/message.h>
#import "CangTeacher.h"
#import "Bird.h"
#import "DanceCang.h"

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        
        CangTeacher *cangTeacher = [[CangTeacher alloc] init];
        cangTeacher.name = @"苍老师";
        [cangTeacher sing];
        
        Bird *bird = [[Bird alloc] init];
        bird.name = @"小小鸟";
        
        ((void (*)(id, SEL))objc_msgSend)((id)bird, @selector(sing));
        
        DanceCang *cang = [[DanceCang alloc] init];
        
        ((void(*)(id, SEL)) objc_msgSend)((id)cang, @selector(sing));
        
    }
    return 0;
}
