//
//  HeightCalculator.m
//  KnowAutolayout
//
//  Created by DHSD on 2019/6/24.
//  Copyright © 2019 DHSD. All rights reserved.
//

#import "HeightCalculator.h"

@interface HeightCalculator ()

@property (strong, nonatomic) NSCache *cache;

@end

@implementation HeightCalculator

- (instancetype)init {
    if (self = [super init]) {
        [self defaulfConfigure];
    }
    return self;
}
- (void)defaulfConfigure {
    _cache = [[NSCache alloc]init];
    _cache.name = @"my.cache";
    _cache.countLimit = 100;
    
}
//系统计算高度后缓存进cache
- (void)setHeight:(CGFloat)height withCalculateheightModel:(ChatModel *)model {
    NSAssert(model != nil, @"Cell Model can't  nil");
    if (height >= 0) {
        [self.cache setObject:[NSNumber numberWithFloat:height] forKey:@(model.hash)];
    }
}

//根据model hash 获取cache中的高度,如过无则返回－1
- (CGFloat)heightForCalculateheightModel:(ChatModel *)model {
    NSNumber *cellHeightNumber = [self.cache objectForKey:@(model.hash)];
    if (cellHeightNumber) {
        return [cellHeightNumber floatValue];
    } else {
        return -1;
    }
}

//清空cache
- (void)clearCaches {
    [self.cache removeAllObjects];
}

@end
