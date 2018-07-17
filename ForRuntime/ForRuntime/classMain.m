//
//  classMain.m
//  ForRuntime
//
//  Created by DHSD on 2018/7/4.
//  Copyright © 2018年 DHSD. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <objc/runtime.h>
//runtime数据结构
//runtime中的相关代码
//而图objc-method-after-realize-class中的结构可以在objc4-723中看到、在objc-runtime-new.h、可解下面的包看
//可以得到runtime与objc-runtime.h是不同的、runtime表示iOS、Mac等开发的root、runtime、而objc-runtime表示OC的runtime他们所表示是objc_class是两个不同的概念

//objc_class
/*
struct objc_class {
    // 指向元类的的指针，如果本身是元类，则指向rootMeta
    Class isa  OBJC_ISA_AVAILABILITY;
#if !__OBJC2__
    // 指向父类
    Class super_class                                        OBJC2_UNAVAILABLE;
    // 类名
    const char *name                                         OBJC2_UNAVAILABLE;
    // 版本号，可以用runtime方法set，get
    long version                                             OBJC2_UNAVAILABLE;
    long info                                                OBJC2_UNAVAILABLE;
    long instance_size                                       OBJC2_UNAVAILABLE;
    // 成员变量列表，存储成员变量
    struct objc_ivar_list *ivars                             OBJC2_UNAVAILABLE;
    // 方法列表
    struct objc_method_list **methodLists                    OBJC2_UNAVAILABLE;
    // 方法cache，msgSend遍历继承链的时候需要辅助使用
    struct objc_cache *cache                                 OBJC2_UNAVAILABLE;
    // 协议列表
    struct objc_protocol_list *protocols                     OBJC2_UNAVAILABLE;
#endif
} OBJC2_UNAVAILABLE;
*/


//objc_method
/*
 // 存在objc_method_list里面
 struct objc_method {
 // 方法名
 SEL method_name                                          OBJC2_UNAVAILABLE;
 // 参数，返回值编码
 char *method_types                                       OBJC2_UNAVAILABLE;
 // 方法地址指针
 IMP method_imp                                           OBJC2_UNAVAILABLE;
 }
*/

//objc_method_description
/*
 // 方法描述
 struct objc_method_description {
 // 方法名
 SEL name;
 // 参数，返回值编码
 char *types;
 };
 */

//objc_protocol_list
/*
 struct objc_protocol_list {
 // 指向下一个objc_protocol_list的指针
 struct objc_protocol_list *next;
 long count;
 // 协议结构
 Protocol *list[1];
 };
 
*/

//objc_ivar
/*
 struct objc_ivar {
 // 成员变量名
 char *ivar_name                                          OBJC2_UNAVAILABLE;
 // 成员变量的类型，比如@"NSString" 代表NSString
 char *ivar_type                                          OBJC2_UNAVAILABLE;
 int ivar_offset                                          OBJC2_UNAVAILABLE;
 #ifdef __LP64__
 int space                                                OBJC2_UNAVAILABLE;
 #endif
 }
 
 */

//objc_category
/*
 struct objc_category {
 // 分类名称
 char *category_name                                      OBJC2_UNAVAILABLE;
 // 绑定的类名
 char *class_name                                         OBJC2_UNAVAILABLE;
 // 分类中的实例方法
 struct objc_method_list *instance_methods                OBJC2_UNAVAILABLE;
 // 分类中的类方法
 struct objc_method_list *class_methods                   OBJC2_UNAVAILABLE;
 // 分类实现的协议
 struct objc_protocol_list *protocols                     OBJC2_UNAVAILABLE;
 }
 */

//objc_property_t
/*
 // 属性对应的结构体objc_property，至于具体结构，一般看不着
 typedef struct objc_property *objc_property_t;
 
 // 在objc-runtime-old.h中的结构体作为参考吧
 struct old_property {
 // 属性名
 const char *name;
 // objc_property_attribute_t的char*表示
 const char *attributes;
 };
 
 */

//objc_property_attribute_t
/*
 // 这是用来修饰表示属性的一些修饰词，比如nonatomic、copy等等
 typedef struct {
 const char *name;
 const char *value;
 } objc_property_attribute_t;
 */
// 为获取class的protocol准备
@protocol AProtocol <NSObject>
- (void)aProtocolMethod;
@end
// 为获取class的相关信息
@interface A : NSObject {
    NSString *strA;
}
@property (nonatomic, assign) NSUInteger uintA;
@end
@implementation A
@end
// 为为class添加方法准备
void aNewMethod() {
    NSLog(@"aNewMethod");
}
void aReplaceMethod() {
    NSLog(@"aReplaceMethod");
}

int main(int argc, char * argv[]) {
    // 代码
    // 获取类名
    const char *a = class_getName([A class]);
    NSLog(@"%s", a);
    // 获取父类
    Class aSuper = class_getSuperclass([A class]);
    NSLog(@"%s", class_getName(aSuper));
    // 判断是否是元类
    BOOL aIfMeta = class_isMetaClass([A class]);
    BOOL aMetaIfMeta = class_isMetaClass(objc_getMetaClass("A"));
    NSLog(@"%i  %i", aIfMeta, aMetaIfMeta);
    // 类大小
    size_t aSize = class_getInstanceSize([A class]);
    NSLog(@"%zu", aSize);
    // 获取和设置类版本号
    class_setVersion([A class], 1);
    NSLog(@"%d", class_getVersion([A class]));
    // 获取工程中所有的class，包括系统class
    unsigned int count3;
    int classNum = objc_getClassList(NULL, count3);
    NSLog(@"%d", classNum);
    // 获取工程中所有的class的数量
    objc_copyClassList(&count3);
    NSLog(@"%d", classNum);
    Class aClass;
    // 获取name为"A"的class
    aClass = objc_getClass("A");
    NSLog(@"%s", class_getName(aClass));
    // 获取name为"A"的class，比getClass少了一次检查
    aClass = objc_lookUpClass("A");
    NSLog(@"%s", class_getName(aClass));
    // 获取name为"A"的class，找不到会crash
    aClass = objc_getRequiredClass("A");
    NSLog(@"%s", class_getName(aClass));
    // 获取name为"A"的class元类
    Class aMetaClass = objc_getMetaClass("A");
    NSLog(@"%d", class_isMetaClass(aMetaClass));
    
    
    // 获取类实例成员变量，只能取到本类的，父类的访问不到
    Ivar aInstanceIvar = class_getInstanceVariable([A class], "strA");
    NSLog(@"%s", ivar_getName(aInstanceIvar));
    // 获取类成员变量，相当于class_getInstanceVariable(cls->isa, name)，感觉除非给metaClass添加成员，否则不会获取到东西
    Ivar aClassIvar = class_getClassVariable([A class], "strA");
    NSLog(@"%s", ivar_getName(aClassIvar));
    // 往A类添加成员变量不会成功的。因为class_addIvar不能给现有的类添加成员变量，也不能给metaClass添加成员变量，那怎么添加，且往后看
    if (class_addIvar([A class], "intA", sizeof(int), log2(sizeof(int)), @encode(int))) {
        NSLog(@"绑定成员变量成功");
    }
    // 获取类中的ivar列表，count为ivar总数
    unsigned int count;
    Ivar *ivars = class_copyIvarList([A class], &count);
    NSLog(@"%i", count);
    // 获取某个名为"uIntA"的属性
    objc_property_t aPro = class_getProperty([A class], "uintA");
    NSLog(@"%s", property_getName(aPro));
    // 获取类的全部属性
    class_copyPropertyList([A class], &count);
    NSLog(@"%i", count);
    // 创建objc_property_attribute_t，然后动态添加属性
    objc_property_attribute_t type = { "T", [[NSString stringWithFormat:@"@\"%@\"",NSStringFromClass([NSString class])] UTF8String] }; //type
    objc_property_attribute_t ownership0 = { "C", "" }; // C = copy
    objc_property_attribute_t ownership = { "N", "" }; //N = nonatomic
    objc_property_attribute_t backingivar  = { "V", [[NSString stringWithFormat:@"_%@", @"aNewProperty"] UTF8String] };  //variable name
    objc_property_attribute_t attrs[] = { type, ownership0, ownership, backingivar };
    if(class_addProperty([A class], "aNewProperty", attrs, 4)) {
        // 只会增加属性，不会自动生成set，get方法
        NSLog(@"绑定属性成功");
    }
    // 创建objc_property_attribute_t，然后替换属性
    objc_property_attribute_t typeNew = { "T", [[NSString stringWithFormat:@"@\"%@\"",NSStringFromClass([NSString class])] UTF8String] }; //type
    objc_property_attribute_t ownership0New = { "C", "" }; // C = copy
    objc_property_attribute_t ownershipNew = { "N", "" }; //N = nonatomic
    objc_property_attribute_t backingivarNew  = { "V", [[NSString stringWithFormat:@"_%@", @"uintA"] UTF8String] };  //variable name
    objc_property_attribute_t attrsNew[] = { typeNew, ownership0New, ownershipNew, backingivarNew };
    class_replaceProperty([A class], "uintA", attrsNew, 4);
    // 这有个很大的坑。替换属性指的是替换objc_property_attribute_t，而不是替换name。如果替换的属性class里面不存在，则会动态添加这个属性
    objc_property_t pro = class_getProperty([A class], "uintA");
    NSLog(@"123456   %s", property_getAttributes(pro));
    // class_getIvarLayout、class_setIvarLayout、class_getWeakIvarLayout、class_setWeakIvarLayout用来设定和获取成员变量的weak、strong。参见http://blog.sunnyxx.com/2015/09/13/class-ivar-layout/
   
    // 动态添加方法
    class_addMethod([A class], @selector(aNewMethod), (IMP)aNewMethod, "v");
    // 向元类动态添加类方法
    class_addMethod(objc_getMetaClass("A"), @selector(aNewMethod), (IMP)aNewMethod, "v");
    // 获取类实例方法
    Method aMethod = class_getInstanceMethod([A class], @selector(aNewMethod));
    // 获取元类中类方法
    Method aClassMethod = class_getClassMethod([A class], @selector(aNewMethod));
    NSLog(@"%s", method_getName(aMethod));
    NSLog(@"%s", method_getName(aClassMethod));
    // 获取类中的method列表
    unsigned int count1;
    Method *method = class_copyMethodList([A class], &count1);
    // 多了一个方法，打印看出.cxx_destruct，只在arc下有，析构函数
    NSLog(@"%i", count1);
    NSLog(@"%s", method_getName(method[2]));
    // 替换方法，其实是替换IMP
    class_replaceMethod([A class], @selector(aNewMethod), (IMP)aReplaceMethod, "v");
    // 调用aNewMethod，其实是调用了aReplaceMethod
    [[A new] performSelector:@selector(aNewMethod)];    // aReplaceMethod会输出
    // 获取类中某个SEL的IMP
    IMP aNewMethodIMP = class_getMethodImplementation([A class], @selector(aNewMethod));
//    aNewMethodIMP();    // 会调用aReplaceMethod的输出
    void (*func)(void) = (void*)aNewMethodIMP;//上面的会报错
    func();
    // 获取类中某个SEL的IMP
    IMP aNewMethodIMP_stret = class_getMethodImplementation_stret([A class], @selector(aNewMethod));
//    aNewMethodIMP_stret();    // 会调用aReplaceMethod的输出
    func = (void *)aNewMethodIMP_stret;
    func();
    // 判断A类中有没有一个SEL
    if(class_respondsToSelector([A class], @selector(aNewMethod))) {
        NSLog(@"存在这个方法");
    }
    

    // 动态创建一个类和其元类
    Class aNewClass = objc_allocateClassPair([NSObject class], "aNewClass", 0);
    // 添加成员变量
    if (class_addIvar(aNewClass, "intA", sizeof(int), log2(sizeof(int)), @encode(int))) {
        NSLog(@"绑定成员变量成功");
    }
    // 注册这个类，之后才能用
    objc_registerClassPair(aNewClass);
    // 销毁这个类和元类
    objc_disposeClassPair(aNewClass);
    
    // 添加protocol到class
    if(class_addProtocol([A class], @protocol(AProtocol))) {
        NSLog(@"绑定Protocol成功");    
    }
    // 查看类是不是遵循protocol
    if(class_conformsToProtocol([A class], @protocol(AProtocol))) {
        NSLog(@"A遵循AProtocol");
    }
    // 获取类中的protocol
    unsigned int count2;
    Protocol *__unsafe_unretained  *aProtocol = class_copyProtocolList([A class], &count2);
    NSLog(@"%s", protocol_getName(aProtocol[0]));
    
    
    
    return 0;

}

