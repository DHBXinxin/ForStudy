//
//  NSObject+Common.h
//  CEP
//
//  Created by DHSD on 2018/5/22.
//  Copyright © 2018年 DHSD. All rights reserved.
//

#import <Foundation/Foundation.h>
//category
@interface NSObject (Common)
{
    //不可以定义成员变量（实例变量）
//    NSString *_string;
//    int age;
}
//可以定义属性和方法|但是不能正常的实现set、get方法
@property (copy, nonatomic) NSString *name;

- (void)objLog;

@end
