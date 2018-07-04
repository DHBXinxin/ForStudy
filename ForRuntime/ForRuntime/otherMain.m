//
//  otherMain.m
//  ForRuntime
//
//  Created by DHSD on 2018/6/28.
//  Copyright © 2018年 DHSD. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <objc/runtime.h>


@interface A : NSObject
@property (nonatomic, assign) NSInteger a;
- (void)b;
+ (void)c;
- (void)d:(NSString *)ddd;
- (void)f;
@end
@implementation A
- (void)b {
    NSLog(@"b");
}
+ (void)c {
    NSLog(@"c");
    SEL b = @selector(b);
    NSLog(@"%s",b);
}
- (void)d:(NSString *)ddd {
    NSLog(@"%@",ddd);
}
void fooMethod(id obj, SEL _cmd)
{
    NSLog(@"Doing Foo");
    NSLog(@"%@",obj);
}
- (void)f {
    class_addMethod([self class], @selector(fooMethod:), (IMP)fooMethod, "v@:");
    
    objc_msgSend(self,@selector(fooMethod:),@"Hello World!", @selector(f));

}
@end

void printWords(NSString *words) {
    NSLog(@"%@",words);
    NSLog(@"printWords");
}
int main(int argc, char * argv[]) {
    class_addMethod([A class], @selector(printWords:), (IMP)printWords, "v@");//"v@"，即为返回值为void类型，参数为一个对象
    //对照表https://developer.apple.com/library/archive/documentation/Cocoa/Conceptual/ObjCRuntimeGuide/Articles/ocrtTypeEncodings.html
    A *aObject = [[A alloc] init];
    // 实例方法调用
    [aObject b];
    // 类方法调用
    [A c];
    
    objc_msgSend(aObject,@selector(printWords:),@"Hello World!");
    ((void (*) (id, SEL, NSString *)) (void *)objc_msgSend)(aObject, sel_registerName("printWords:"),@"Hello World!");
    ((void (*) (id, SEL, NSString *)) (void *)objc_msgSend)(aObject, sel_registerName("d:"),@"Hello World!");
//    [aObject performSelector:@selector(printWords:)];
    
    [aObject f];
    
    
    // 在A对应的objc_class结构体的继承链中找到实例方法b
    IMP bIMP = class_getMethodImplementation([A class], @selector(b));
    // 执行IMP
    void (*func)(void) = (void*)bIMP;//实例方法
    func();
    // 获取A类对应的metaClass
    Class aMeta = objc_getMetaClass(class_getName([A class]));
    // 在metaClass中找类方法d
    IMP cIMP = class_getMethodImplementation(aMeta, @selector(c));
    void (*func2)(void) = (void*)cIMP;//类方法
    func2();
    objc_msgSend(objc_getClass("A"), sel_registerName("c"));
    objc_msgSend([A class], sel_registerName("c"));

    void (*funcp)(void);    /* 函数指针 */
//    类型说明符 (*函数名)(参数)
//
//    int (*f) (int x);
    char *funcq(void);     /* 指针函数 */
//    类型标识符    *函数名(参数表)
//
//    int *f(x，y);
    void *FileFunc(void), EditFunc(void);
//    funcp = FileFunc();
    
}
struct objc_method {
    SEL method_name                                          OBJC2_UNAVAILABLE;
    char *method_types                                       OBJC2_UNAVAILABLE;
    IMP method_imp                                           OBJC2_UNAVAILABLE;
}                                                            OBJC2_UNAVAILABLE;
//SEL : 类成员方法的指针，但不同于C语言中的函数指针，函数指针直接保存了方法的地址，但SEL只是方法编号。
//IMP:一个函数指针,保存了方法的地址

