//
//  ViewController.m
//  RuntimeAssociate
//
//  Created by DHSD on 2018/7/5.
//  Copyright © 2018年 DHSD. All rights reserved.
//

#import "ViewController.h"
#import "NSObject+AssociatedObject.h"
//#import "ViewController+AssociatedObject.h"
@interface ViewController ()

@end

__weak NSString *string_weak_assign = nil;
__weak NSString *string_weak_retain = nil;
__weak NSString *string_weak_copy   = nil;

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
//    NSLog(@"%@",self.associatedObject_assign);
    self.associatedObject_assign = [NSString stringWithFormat:@"leichunfeng1"];//不知道为什么只要稍微修改一下string它就不会崩溃、
    self.associatedObject_retain = [NSString stringWithFormat:@"234"];
    self.associatedObject_copy   = [NSString stringWithFormat:@"345"];

    string_weak_assign = self.associatedObject_assign;
    string_weak_retain = self.associatedObject_retain;
    string_weak_copy   = self.associatedObject_copy;
//    self.associatedObject_assign = [NSString stringWithFormat:@"leichunfeng1"];
//    self.associatedObject_retain = [NSString stringWithFormat:@"leichunfeng2"];
//    self.associatedObject_copy   = [NSString stringWithFormat:@"leichunfeng3"];
//
//    string_weak_assign = self.associatedObject_assign;
//    string_weak_retain = self.associatedObject_retain;
//    string_weak_copy   = self.associatedObject_copy;
//    logtotal([NSObject new], _cmd);
    
}
//OC会在方法后默认添加两个参数--self是当前的指针、_cmd表示当前方法
void logtotal(id self, SEL _cmd) {
    NSLog(@"%@----%s",self, _cmd);
}
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    NSLog(@"self.associatedObject_assign: %@", self.associatedObject_assign);//有选择的崩溃
    NSLog(@"self.associatedObject_retain: %@", self.associatedObject_retain);
    NSLog(@"self.associatedObject_copy:   %@", self.associatedObject_copy);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
/*
OBJC_ASSOCIATION_ASSIGN    @property (assign) or @property (unsafe_unretained)    弱引用关联对象
OBJC_ASSOCIATION_RETAIN_NONATOMIC    @property (strong, nonatomic)    强引用关联对象，且为非原子操作
OBJC_ASSOCIATION_COPY_NONATOMIC    @property (copy, nonatomic)    复制关联对象，且为非原子操作
OBJC_ASSOCIATION_RETAIN    @property (strong, atomic)    强引用关联对象，且为原子操作
OBJC_ASSOCIATION_COPY    @property (copy, atomic)    复制关联对象，且为原子操作
*/
