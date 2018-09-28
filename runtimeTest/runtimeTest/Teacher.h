//
//  Teacher.h
//  runtimeTest
//
//  Created by DHSD on 2018/9/25.
//  Copyright © 2018年 DHSD. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Teacher : NSObject<NSCoding>

@property (nonatomic, copy) NSString *name; // 姓名
@property (nonatomic, strong) NSNumber *age; // 年龄
@property (nonatomic, copy) NSString *occupation; // 职业
@property (nonatomic, copy) NSString *nationality; // 国籍

@end

NS_ASSUME_NONNULL_END
