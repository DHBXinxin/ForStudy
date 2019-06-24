//
//  HeightCalculator.h
//  KnowAutolayout
//
//  Created by DHSD on 2019/6/24.
//  Copyright © 2019 DHSD. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ChatModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface HeightCalculator : NSObject

//系统计算高度后缓存进cache
- (void)setHeight:(CGFloat)height withCalculateheightModel:(ChatModel *)model;

//根据model hash 获取cache中的高度,如过无则返回－1
- (CGFloat)heightForCalculateheightModel:(ChatModel *)model;

//清空cache
- (void)clearCaches;

@end

NS_ASSUME_NONNULL_END
