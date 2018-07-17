//
//  ViewController+AssociatedObject.h
//  RuntimeAssociate
//
//  Created by DHSD on 2018/7/11.
//  Copyright © 2018年 DHSD. All rights reserved.
//

#import "ViewController.h"
#import <objc/runtime.h>
@interface ViewController (AssociatedObject)
@property (assign, nonatomic) NSString *associatedObject_assign;
@property (strong, nonatomic) NSString *associatedObject_retain;
@property (copy,   nonatomic) NSString *associatedObject_copy;

+ (NSString *)associatedObject;
+ (void)setAssociatedObject:(NSString *)associatedObject;
@end
