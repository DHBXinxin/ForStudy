//
//  NSObject+AssociatedObject.m
//  RuntimeAssociate
//
//  Created by DHSD on 2018/7/10.
//  Copyright © 2018年 DHSD. All rights reserved.
//

#import "NSObject+AssociatedObject.h"

@implementation NSObject (AssociatedObject)

#pragma mark - Object Associated Objects

- (NSString *)associatedObject_assign {
//    objc_getAssociatedObject(self, _cmd);
//    objc_getAssociatedObject(<#id  _Nonnull object#>, <#const void * _Nonnull key#>)
//    objc_setAssociatedObject(<#id  _Nonnull object#>, <#const void * _Nonnull key#>, <#id  _Nullable value#>, <#objc_AssociationPolicy policy#>)
//    NSLog(@"%@---%s",objc_getAssociatedObject(self, _cmd), _cmd);
    struct objc_selector *ss;
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setAssociatedObject_assign:(NSString *)associatedObject_assign {
    SEL sel = @selector(associatedObject_assign);
    NSLog(@"%p----%s",sel, sel);
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

#pragma mark - Class Associated Objects

+ (NSString *)associatedObject {
    return objc_getAssociatedObject([self class], _cmd);
}

+ (void)setAssociatedObject:(NSString *)associatedObject {
    objc_setAssociatedObject([self class], @selector(associatedObject), associatedObject, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
@end
