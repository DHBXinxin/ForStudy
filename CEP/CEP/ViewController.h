//
//  ViewController.h
//  CEP
//
//  Created by DHSD on 2018/5/22.
//  Copyright © 2018年 DHSD. All rights reserved.
//

#import <UIKit/UIKit.h>
//category、extension、protocol
@interface ViewController : UIViewController
//category的特点
//1:不能定义实例变量～～实例变量是{内定义的变量}可以定义属性变量、因为属性变量相当于在类别中添加了两个getter、setter方法、而不是定义了一个单纯的变量
//2:方法名冲突、类别会完全取代原方法、类别具有更高的优先级

//extension扩展
//类能做的扩展都能做--扩展这个很常见、就是.m文件打头的那行

//protocol定义了需要在实现类必须或可选实现的方法


@end
@protocol TestProtocol <NSObject>

- (void)test1;//默认必须实现

@required
- (void)test2;//@required必须实现

@optional
- (void)test3;//可选实现

@end
//extension
@interface NSString()


@end

