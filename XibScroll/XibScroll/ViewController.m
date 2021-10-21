//
//  ViewController.m
//  XibScroll
//
//  Created by 李欣欣 on 2021/5/8.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
/*
 Xcode 11之后添加scroll
 1.添加scroll 上下左右设置成0
 2.添加view设置相对Content Layout guide上下左右为0
 3.设置view的宽度和高度----比如上下滚动设置view相对Frame Layout Guide的宽度相当、然后设置他的高度就可以了
 4.使用的时候最后把view的高度约束删除
 */
/*
 Xcode 11之前添加scroll
 1.添加scroll
 2.勾选的Content Layout guide的勾划掉，就成了之前那个那种没有Content Layout guide和Frame Layout Guide的那种样子了
 3.添加view设置上下左右为0
 4.设置view的宽度和高度----比如上下滚动就设置相对scroll Horizontally in Container垂直居中然后设置高度
 5.如果要设置成左右滚动-----可以设置view水平居中然后设置宽度、如果要上下左右都可以滚动、就单设置view的宽高就可以了
 6.最后要使用的时候把view的宽或者高给删掉、让view内的控件来决定view的宽或者高度
 */
//把view改成Contentview容易识别
@end
