//
//  People+Associated.h
//  runtimeTest
//
//  Created by DHSD on 2018/9/25.
//  Copyright © 2018年 DHSD. All rights reserved.
//

#import "People.h"

NS_ASSUME_NONNULL_BEGIN
typedef void (^CodingCallBack)();

@interface People (Associated)
@property (nonatomic, strong) NSNumber *associatedBust; // 胸围
@property (nonatomic, copy) CodingCallBack associatedCallBack; // 写代码
@end

NS_ASSUME_NONNULL_END
