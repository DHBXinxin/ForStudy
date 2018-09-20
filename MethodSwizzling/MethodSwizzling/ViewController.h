//
//  ViewController.h
//  MethodSwizzling
//
//  Created by DHSD on 2018/9/10.
//  Copyright © 2018年 DHSD. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController
{
    NSString *aString;
    int aNumber;
    UIButton *aButton;
}//1～3成员变量、3实例变量

@property (strong, nonatomic) UIButton *aButton;//属性变量

@end

