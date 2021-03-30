//
//  NSBundle+Language.m
//  iOSLocal
//
//  Created by 李欣欣 on 2021/3/30.
//

#import "NSBundle+Language.h"
#import <objc/runtime.h>
static const char _bundle = 0;

//static const NSString *_bundlekey = @"_bundlekey";//也可以使用这个关键字来保存获取bundle、类型不重要
@interface BundleExtension : NSBundle

@end

@implementation BundleExtension

- (NSString *)localizedStringForKey:(NSString *)key value:(NSString *)value table:(NSString *)tableName {
    NSBundle *bundle = objc_getAssociatedObject(self, &_bundle);
    return bundle ? [bundle localizedStringForKey:key value:value table:tableName] : [super localizedStringForKey:key value:value table:tableName];
}

@end

@implementation NSBundle (Language)

+ (void)setLanguage:(NSString *)language {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        object_setClass([NSBundle mainBundle], [BundleExtension class]);
    });
    objc_setAssociatedObject([NSBundle mainBundle], &_bundle, language ? [NSBundle bundleWithPath:[[NSBundle mainBundle] pathForResource:language ofType:@"lproj"]] : nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    //给mainbundle赋值
}
@end
