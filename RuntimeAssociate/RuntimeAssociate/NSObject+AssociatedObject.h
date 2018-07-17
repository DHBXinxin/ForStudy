//
//  NSObject+AssociatedObject.h
//  RuntimeAssociate
//
//  Created by DHSD on 2018/7/10.
//  Copyright © 2018年 DHSD. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <objc/runtime.h>
@interface NSObject (AssociatedObject)

@property (assign, nonatomic) NSString *associatedObject_assign;
@property (strong, nonatomic) NSString *associatedObject_retain;
@property (copy,   nonatomic) NSString *associatedObject_copy;

+ (NSString *)associatedObject;
+ (void)setAssociatedObject:(NSString *)associatedObject;

@end
