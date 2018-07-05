//
//  objcMain.m
//  ForRuntime
//
//  Created by DHSD on 2018/7/5.
//  Copyright © 2018年 DHSD. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <objc/objc-runtime.h>


@protocol AProtocol <NSObject>
- (void)aProtocolMethod;
@end
@interface B : NSObject
- (void)bTest;
@end
@implementation B
- (void)bTest {
    NSLog(@"bTest");
}
@end
@interface A : NSObject <AProtocol> {
    NSString *strA;
}
@property (nonatomic, assign) NSUInteger uintA;
- (void)test;
@end
@implementation A
- (void)test {
    NSLog(@"%lu", (unsigned long)_uintA);
}
@end
void aNewMethod() {
    NSLog(@"aNewMethod");
}


int main(int argc, char * argv[]) {
    // 获取类实例的大小
    size_t size = class_getInstanceSize([A class]);
    NSLog(@"%zu", size);
    // 动态创建一个实例
    A *a = class_createInstance([A class], size);
    a.uintA = 1;
    NSLog(@"%d", a.uintA);
    // 销毁一个实例，但是并没有回收内存
    objc_destructInstance(a);//不支持arc
    // 回收内存
    object_dispose(a);//不支持arc
    size_t allocSize = 2 * size;
    uintptr_t ptr = (uintptr_t)calloc(allocSize, 1);
    // 构造一个实例并将其存入ptr
    a = objc_constructInstance([A class], &ptr);//不支持arc
    // 创建一个对象的copy，肯定是深copy，会开辟新空间
    NSString *str = @"1";
    NSString *str1 = object_copy(str, size);//不支持arc
    NSLog(@"%@ %p %p", str1, str1, str);
    // 动态为实例的成员变量赋值
    NSString *b = @"111";
    object_setInstanceVariable(a, "strA", b);//不支持arc
    // 获取实例的某个成员变量的值
    NSString *b1 = nil;
    object_getInstanceVariable(a, "strA", (void **)&b1);//不支持arc
    NSLog(@"%@", b1);
    // 指向a中额外的空间，也就是多余的，没测试
    object_getIndexedIvars(a);//不支持arc
    //  获取实例的某个成员变量的值，比object_getInstanceVariable快
    unsigned int count;
    Ivar *intIvar = class_copyIvarList([A class], &count);
    id ivarValue =object_getIvar(a, intIvar[0]);
    NSLog(@"%@", ivarValue);
    // 动态为实例的成员变量赋值，比object_setInstanceVariable快
    object_setIvar(a, intIvar[0], @"222");
    NSLog(@"%@", ivarValue);
    // 获取实例的class名称
    const char *name = object_getClassName(a);
    NSLog(@"%s", name);
    // 获取实例的class
    object_getClass(a);
    // 将实例的isa指向一个新的class
    object_setClass(a, [B class]);
    
 
    // 获取ivar名称
//    unsigned int count;
    Ivar *ivars = class_copyIvarList([A class], &count);
    const char *ivarName = ivar_getName(ivars[0]);
    NSLog(@"%s", ivarName);
    // 获取ivar类型编码
    const char *encoding = ivar_getTypeEncoding(ivars[0]);
    NSLog(@"%s", encoding);
    // 获取某个成员变量的偏移量
    ptrdiff_t offset = ivar_getOffset(ivars[0]);
    NSLog(@"%td", offset);
    
    
    // 获取某个property的name
    const char *prpertyName = property_getName(class_getProperty([A class], "uintA"));
    NSLog(@"%s", prpertyName);
    // 获取property描述符，比如修饰词、类型、名字
    const char *propertyAttributes = property_getAttributes(class_getProperty([A class], "uintA"));
    NSLog(@"%s", propertyAttributes);
    // 获取property某个描述符的value
    const char *value = property_copyAttributeValue(class_getProperty([A class], "uintA"), "T");
    NSLog(@"%s", value);
    // 获取property描述符的列表
    unsigned int attriCount;
    objc_property_attribute_t *attrs = property_copyAttributeList(class_getProperty([A class], "uintA"), &attriCount);
    NSLog(@"%s", attrs[0]);
    
    
    // 绑定属性，不会添加到class的propertylist
    static void *kAssociatedObjectKey = &kAssociatedObjectKey;
    NSString *assStr = @"assStr";
    
//    unsigned int count;
    class_copyPropertyList([A class], &count);
    objc_setAssociatedObject([A class], kAssociatedObjectKey, assStr, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    class_copyPropertyList([A class], &count);
    // 获取之前绑定的属性
    objc_getAssociatedObject([A class], kAssociatedObjectKey);
    NSLog(@"%@", assStr);
    A *assA = [A new];
    assA.uintA = 10;
    // 移除所有绑定的属性，不会影响class自身的property
    objc_removeAssociatedObjects(assA);
    NSLog(@"%@ %d", objc_getAssociatedObject(assA, kAssociatedObjectKey), assA.uintA);
    
    // 获取sel的名称
    const char *selName = sel_getName(@selector(test));
    NSLog(@"%s", selName);
    // 生成一个新的sel
    SEL newSel = sel_registerName("newSel");
    NSLog(@"%s", newSel);
    // 同上。生成一个新的sel
    SEL newSel1 = sel_getUid("newSel1");
    NSLog(@"%s", newSel1);
    // 判断两个sel是否相同
    if(sel_isEqual(newSel, newSel1)) {
        NSLog(@"相同sel");
    } else {
        NSLog(@"不相同sel");
    }
    

    // 调用一个object的method
    // method_invoke_stret(testMethod, method); 参照void method_invoke_stret(void *stretAddr, id theReceiver, SEL theSelector, ....) stretAddr为返回的数据结构
    // 若报错，project里面设定Enable Strict Checking of objc_msgSend Calls为NO
    A *testMethod = [A new];
    testMethod.uintA = 100;
    unsigned int outCount;
    Method *methods = class_copyMethodList([A class], &outCount);
    Method method = methods[0];
    
    method_invoke(testMethod, method);
    // 将某个method指向一个新的IMP
    method_setImplementation(method, (IMP)aNewMethod);
    method_invoke(testMethod, method);
    // 获取method的SEL
    SEL methodSel = method_getName(method);
    NSLog(@"%s", methodSel);
    // 获取method的IMP
    // 随意传两个参数，无所谓的
    IMP methodImp = method_getImplementation(method);
    methodImp(0,0);
    // 获取method的类型编码，包含返回值和参数
    const char *methodEncoding = method_getTypeEncoding(method);
    NSLog(@"%s", methodEncoding);
    // 获取method的返回值类型
    const char *returnType = method_copyReturnType(method);
    NSLog(@"%s", returnType);
    // 获取method的某个参数类型
    const char *oneArgumentType = method_copyArgumentType(method, 0);
    NSLog(@"%s", oneArgumentType);
    // 获取method的返回值类型
    char dst[256];
    method_getReturnType(method, dst, 256);
    NSLog(@"%s", dst);
    // 获取method的参数个数
    unsigned int numOfArgu = method_getNumberOfArguments(method);
    NSLog(@"%d" ,numOfArgu);
    // 获取method的某个参数的类型
    method_getArgumentType(method, 0, dst, 256);
    NSLog(@"%s", dst);
    // 获取method的描述
    struct objc_method_description des = *method_getDescription(method);
    NSLog(@"%s", des);
    // 更换method method_exchangeImplementations
    method_exchangeImplementations(methods[0], methods[1]);
    method_invoke(testMethod, methods[1]);  // l
    
    
    // 根据char *获取Protocol
    Protocol *protocol = objc_getProtocol("AProtocol");
    NSLog(@"%s", protocol_getName(protocol));
    // 获取项目所有的protocol列表
    unsigned int protocolCount;
    Protocol * __unsafe_unretained *protocols = objc_copyProtocolList(&protocolCount);
    NSLog(@"%d", protocolCount);
    // 动态创建一个protocol
    Protocol *bProtocol = objc_allocateProtocol("BProtocol");
    // 动态为protocol添加一个实例方法
    protocol_addMethodDescription(bProtocol, NSSelectorFromString(@"bProtocolMethod"), "v@:", NO, YES);
    // 动态为protocol添加property
    // 添加属性必须两个参数都是YES，因为属性的方法必须是实例和requried
    objc_property_attribute_t attributes[] = { { "T", "@\"NSString\"" }, { "&", "N" }, { "V", "" } };
    protocol_addProperty(bProtocol, "bProtocolProperty", attributes, 3, YES, YES);
    // 为protocol添加其需要遵循的protocol
    protocol_addProtocol(bProtocol, @protocol(NSObject));
    // 注册这个protocol
    objc_registerProtocol(bProtocol);
    // 获取protocol的所有可选的实例方法
    class_addProtocol([A class], bProtocol);
    class_addMethod([A class], NSSelectorFromString(@"bProtocolMethod"), (IMP)aNewMethod, "v@:");
    unsigned int protocolOutCount;
    protocol_copyMethodDescriptionList(bProtocol, NO, YES, &protocolOutCount);
    NSLog(@"%d", protocolOutCount);
    // 获取protocol中某个方法的描述
    struct objc_method_description desc = protocol_getMethodDescription(bProtocol, NSSelectorFromString(@"bProtocolMethod"), NO, YES);
    NSLog(@"%s", desc);
    // 获取protocol的属性列表
    protocol_copyPropertyList(bProtocol, &protocolOutCount);
    NSLog(@"%d", protocolOutCount);
    // 获取protocol中某个属性
    objc_property_t proNewPro = protocol_getProperty(bProtocol, "bProtocolProperty", YES, YES);
    NSLog(@"%s", proNewPro);
    // 获取protocol遵循的protocol列表
    protocol_copyProtocolList(bProtocol, &protocolOutCount);
    NSLog(@"%d", protocolOutCount);
    // 判断某个protocol是否遵循另一个protocol
    if (protocol_conformsToProtocol(bProtocol, @protocol(NSObject))) {
        NSLog(@"bProtocol遵循NSObject");
    }
    // 判断两个protocol是否相同
    if(!protocol_isEqual(bProtocol, @protocol(AProtocol))) {
        NSLog(@"bProtocol和Aprotocol不同");
    }
    
    // objc_msgSend返回id类型
    // objc_msgSend_fpret返回double类型
    // void objc_msgSend_stret(id self, SEL op, ...) 为返回一个结构体，参照void objc_msgSend_stret(void *stretAddr, id theReceiver, SEL theSelector, ....)
    objc_msgSend([B new], @selector(bTest));
    objc_msgSend_fpret([B new], @selector(bTest));
    // objc_msgSendSuper，向superClass发消息，返回id
    // OBJC_EXPORT void objc_msgSendSuper_stret(struct objc_super *super, SEL op, ...) 为返回一个结构体，参照void objc_msgSendSuper_stret(void *stretAddr, id theReceiver, SEL theSelector, ....)
    struct objc_super superClass = {(id)[B new], [B superclass]};
//    objc_msgSendSuper(&superClass, @selector(bTest)); //崩溃
    
  
    // 获取工程中所有的frameworks和dynamic libraries名称
//    unsigned int count;
    const char **arr = objc_copyImageNames(&count);
    NSLog(@"%s", arr[0]);
    // 获取某个class所在的库名称
    const char *frameworkName = class_getImageName([NSArray class]);
    NSLog(@"%s", frameworkName);
    // 根据某个库名，获取该库所有的class
    const char **classArr = objc_copyClassNamesForImage(arr[0], &count);
    NSLog(@"%s", classArr[0]);
    
    // A、
    // void objc_enumerationMutation(id obj)
    // void objc_setEnumerationMutationHandler(void (*handler)(id))
    // 两个方法是用来在快速遍历的时候捕获一些突发性的问题的。(没测试过)
    // B、
    // IMP imp_implementationWithBlock(id block)
    // id imp_getBlock(IMP anImp)
    // BOOL imp_removeBlock(IMP anImp)
    // 三个方法是用来 绑定/获取/解绑 block到某个方法的。
    // C、
    // id objc_loadWeak(id *location)
    // id objc_storeWeak(id *location, id obj)
    // objc_storeWeak即为正常的weak类型赋值的时候需要调用的方法。objc_loadWeak为在某个方法中使用weak类型对象的话，先retain并加入autoreleasepool，pop autoreleasepool的时候release。
    
  
    return 0;
}
