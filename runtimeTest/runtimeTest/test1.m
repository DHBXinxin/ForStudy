//
//  test1.m
//  runtimeTest
//
//  Created by DHSD on 2018/9/12.
//  Copyright © 2018年 DHSD. All rights reserved.
//

#import <Foundation/Foundation.h>
//#import <objc/objc-runtime.h>//在iOSapi中没有这个文件
//对应的是这两个文件
#import <objc/runtime.h>
#import <objc/message.h>

void sayFunction(id self, SEL _cmd, id some) {
    NSLog(@"%@岁的%@说：%@", object_getIvar(self, class_getInstanceVariable([self class], "_age")),[self valueForKey:@"name"],some);
}
//在类中上方法就是下面的方法、类中会自动提添加id和SEL参数、表示类方法和方法的SEL可以理解成是方法的ID通过ID来寻方法、而IMP是函数指针
//- (void)sayFunction:(id)some {
//
//}
int main(int argc, const char * argv[]) {
    @autoreleasepool {
        // insert code here...
        NSLog(@"Hello, World!");
        //动态创建对象 创建一个Person 继承自 NSObject类
        Class People = objc_allocateClassPair([NSObject class], "Person", 0);
        //添加成员变量、类型为string
        class_addIvar(People, "_name", sizeof(NSString *), log2(sizeof(NSString *)), @encode(NSString *));
        class_addIvar(People, "_age", sizeof(int), sizeof(int), @encode(int));
        //网上说_Alignof更标准
//        class_addIvar(People, "someIvar", sizeof(int), log2(_Alignof(int)), @encode(int));
        
//        class_addIvar(<#Class  _Nullable __unsafe_unretained cls#>, <#const char * _Nonnull name#>, <#size_t size#>, <#uint8_t alignment#>, <#const char * _Nullable types#>)
        //log2表示2为底数的对数、log表示以e为底的对数、log10表示以10为底的对数、log是logarithm的缩写
        
        //注册方法、注册之后才可以使用
        SEL s = sel_registerName("say:");
        class_addMethod(People, s, (IMP)sayFunction, "v@:@");
        //注册类
        objc_registerClassPair(People);
        
        id pInstance = [[People alloc]init];
        //kvc改动值、name为实例变量
        [pInstance setValue:@"苍老师" forKey:@"name"];
        //_age为成员变量、返回本类的变量和属性、不包含父类变量和属性
        Ivar ageInstance = class_getInstanceVariable(People, "_age");
        //获取不到、一般认为oc不支持类变量
        Ivar ageClass = class_getClassVariable(People, "_age");
        object_setIvar(pInstance, ageInstance, @18);
        object_setIvar(pInstance, ageClass, @16);
        //Build Setting–> Apple LLVM 7.0 – Preprocessing–> Enable Strict Checking of objc_msgSend Calls 改为 NO
        //objc_msgSend(pInstance, s, @"大家好!");
        ((void (*)(id, SEL, id))objc_msgSend)(pInstance, s, @"大家好");
        pInstance = nil;//当People或则其子类存在实例、不能调用销毁方法
        //销毁类
        objc_disposeClassPair(People);
        
    }
    return 0;
}
/*
- (void)addStrPropertyForTargetClass:(Class)targetClass Name:(NSString *)propertyName{
    objc_property_attribute_t type = { "T", [[NSString stringWithFormat:@"@\"%@\"",NSStringFromClass([NSString class])] UTF8String] }; //type
    objc_property_attribute_t ownership0 = { "C", "" }; // C = copy
    objc_property_attribute_t ownership = { "N", "" }; //N = nonatomic
    //对应值的文档
    //https://developer.apple.com/library/archive/documentation/Cocoa/Conceptual/ObjCRuntimeGuide/Articles/ocrtPropertyIntrospection.html#//apple_ref/doc/uid/TP40008048-CH101-SW6
    
//    常用attribute         name    value
//    nonatomic              "N"    ""
//    strong/retain          "&"    ""
//    weak                   "W"    ""
//    属性的类型type           "T"    "@TypeName", eg"@\"NSString\""
//    属性对应的实例变量Ivar    "V"    "Ivar_name", eg "_name"
//    readonly               "R"    ""
//    getter                 "G"    "GetterName", eg"isRight"
//    setter                 "S"    "SetterName", eg"setName"
//    copy                   "C"    ""
//    assign/atomic    默认即为assign和retain

    objc_property_attribute_t backingivar  = { "V", [[NSString stringWithFormat:@"_%@", propertyName] UTF8String] };  //变量名
    objc_property_attribute_t attrs[] = { type, ownership0, ownership, backingivar };
    if (class_addProperty(targetClass, [propertyName UTF8String], attrs, 4)) {
        //添加get和set方法
        [targetClass addObjectProperty:propertyName];
        DDLogDebug(@"创建属性Property成功");
    }
}
 */
