//
//  XXObject.m
//  AnalyzeObjC
//
//  Created by DHSD on 2018/5/19.
//  Copyright © 2018年 DHSD. All rights reserved.
//

#import "XXObject.h"

#define FAST_IS_SWIFT           (1UL<<0)
#define FAST_HAS_DEFAULT_RR     (1UL<<1)
#define FAST_REQUIRES_RAW_ISA   (1UL<<2)
#define FAST_DATA_MASK          0x00007ffffffffff8UL

@implementation XXObject

- (void)userSwift {
    
    ClassA *a = [[ClassA alloc]init];
    [a classLog];
}
@end

