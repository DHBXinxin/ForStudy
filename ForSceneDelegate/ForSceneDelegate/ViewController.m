//
//  ViewController.m
//  ForSceneDelegate
//
//  Created by DHSD on 2020/6/11.
//  Copyright © 2020 DHSD. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UIButton *bt = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 40, 40)];
        bt.backgroundColor = [UIColor redColor];
        [self.view addSubview:bt];
        [bt addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
        bt.center = self.view.center;
   
}

   
- (void)click:(UIButton *)sender {
    UIViewController *view = [[UIViewController alloc]init];
              
    view.view.backgroundColor = [UIColor redColor];
             
    if (@available(iOS 13.0, *)) {
        view.modalPresentationStyle = UIModalPresentationFullScreen;
        //13之后present方法会变成顶部预留、需要修改默认模式
    }
    [self presentViewController:view animated:YES completion:nil];
              
         
}


@end
