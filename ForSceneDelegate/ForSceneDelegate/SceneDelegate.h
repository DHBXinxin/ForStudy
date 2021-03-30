//
//  SceneDelegate.h
//  ForSceneDelegate
//
//  Created by DHSD on 2020/6/11.
//  Copyright © 2020 DHSD. All rights reserved.
//

#import <UIKit/UIKit.h>

//实在不想用分屏把多余的删掉
//1:删除info里面的Application Scene Manifest
//2:删掉SceneDelegate
//3:把原来的AppDelegate内方法补齐并删除多余的方法
//4:把项目general中的main interface删掉
@interface SceneDelegate : UIResponder <UIWindowSceneDelegate>

@property (strong, nonatomic) UIWindow * window;

@end

