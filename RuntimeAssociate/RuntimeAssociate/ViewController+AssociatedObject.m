//
//  ViewController+AssociatedObject.m
//  RuntimeAssociate
//
//  Created by DHSD on 2018/7/11.
//  Copyright © 2018年 DHSD. All rights reserved.
//

#import "ViewController+AssociatedObject.h"

@implementation ViewController (AssociatedObject)

#pragma mark - ViewController Object Associated Objects

- (NSString *)associatedObject_assign {
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setAssociatedObject_assign:(NSString *)associatedObject_assign {
    objc_setAssociatedObject(self, @selector(associatedObject_assign), associatedObject_assign, OBJC_ASSOCIATION_ASSIGN);
}

- (NSString *)associatedObject_retain {
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setAssociatedObject_retain:(NSString *)associatedObject_retain {
    objc_setAssociatedObject(self, @selector(associatedObject_retain), associatedObject_retain, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSString *)associatedObject_copy {
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setAssociatedObject_copy:(NSString *)associatedObject_copy {
    objc_setAssociatedObject(self, @selector(associatedObject_copy), associatedObject_copy, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

#pragma mark - ViewController Class Associated Objects

+ (NSString *)associatedObject {
    return objc_getAssociatedObject([self class], _cmd);
}

+ (void)setAssociatedObject:(NSString *)associatedObject {
    objc_setAssociatedObject([self class], @selector(associatedObject), associatedObject, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end
