//
//  UITableView+Swizzing.m
//  MethodSwizzling
//
//  Created by DHSD on 2018/9/10.
//  Copyright © 2018年 DHSD. All rights reserved.
//

#import "UITableView+Swizzing.h"
#import <objc/runtime.h>

@implementation UITableView (Swizzing)
+ (void)load {
    method_exchangeImplementations(class_getInstanceMethod(self, @selector(reloadData)),
                                   class_getInstanceMethod(self, @selector(my_reloadData)));
    //交换两个方法实现
    
    //下面的方法实现在reloadData方法
    //而my_reloadData方法实现了reloadData的方法
}
- (void)my_reloadData
{
    [self my_reloadData];
    
    [self myPrint];
}

- (void)myPrint
{
    NSLog(@"TableView reloadData");
}
//+ (void)load {
//    Class class = [self class];
//    //取得函数名称
//    SEL originSEL = @selector(viewDidAppear:);
//    SEL swizzleSEL = @selector(swizzleViewDidAppear:);
//    //根据函数名，从class的method list中取得对应的method结构体，如果是实例方法用class_getInstanceMethod，类方法用class_getClassMethod()。会从当前的Class中寻找对应方法名的实现，若没有则向上遍历父类中查找。若父类中也没有，则返回NULL。
//    Method originMethod = class_getInstanceMethod(class, originSEL);
//    Method swizzleMethod = class_getInstanceMethod(class, swizzleSEL);
//    //class_addMethod向class中添加对应方法名和方法实现。如果该class（不包含父类）已含有该方法名，则返回NO。
//    BOOL didAddMethod = class_addMethod(class, originSEL,
//                                        method_getImplementation(swizzleMethod), method_getTypeEncoding(swizzleMethod));
//    if (didAddMethod) {
//        //因为已向class中添加了swizzledMethod实现对应的方法名，只需要替换swizzledSelector的实现为originalMethod。
//        class_replaceMethod(class,
//                            swizzleSEL,
//                            method_getImplementation(originMethod),
//                            method_getTypeEncoding(originMethod));
//    } else {
//        //class中本来就含有originSEL的method，只需要交换originalMethod和swizzledMethod的实现。
//        method_exchangeImplementations(originMethod,
//                                       swizzleMethod);
//    }
//}
//// 我们自己实现的方法，也就是和self的swizzleViewDidAppear方法进行交换的方法。
//- (void)swizzleViewDidAppear:(BOOL)animated {
//    [self swizzleViewDidAppear:animated];//表示load原本的方法
//}

@end
