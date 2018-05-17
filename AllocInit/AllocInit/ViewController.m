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
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
