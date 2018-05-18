//
//  ViewController.m
//  AllocInit
//
//  Created by DHSD on 2018/5/17.
//  Copyright © 2018年 DHSD. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    NSString *string = [[NSString alloc]init];
    //alloc的作用
    //    将该新对象的引用计数 (Retain Count) 设置成 1。
    //    将该新对象的 isa 成员变量指向它的类对象。
    //    将该新对象的所有其它成员变量的值设置成零。（根据成员变量类型，零有可能是指 nil 或 Nil 或 0.0）
    //对于isa的理解看本程序的图更能明显的理解
    //init的作用
    //为对象属性赋值
    //alloc的作用
//    内存管理的事情，设置 Retain Count。
//    运行时自省的功能，设置 isa 变量。
//    非逻辑性的初使化功能，设置所有成员变量为零。
    //new只是alloc+init
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
