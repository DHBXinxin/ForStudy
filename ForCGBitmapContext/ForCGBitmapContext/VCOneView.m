//
//  VCOneView.m
//  ForCGBitmapContext
//
//  Created by DHSD on 2019/5/31.
//  Copyright © 2019 DHSD. All rights reserved.
//

#import "VCOneView.h"
#define WIDTH self.view.frame.size.width
#define HEIGHT self.view.frame.size.height

@interface VCOneView ()

@property (strong, nonatomic) UIButton *resultView;

@property (strong, nonatomic) UIImageView *imgView;

@property (strong, nonatomic) UIView *pointView;

@end

@implementation VCOneView

- (UIButton *)resultView {
    if (_resultView) {
        return _resultView;
    }
    _resultView = [[UIButton alloc]initWithFrame:CGRectMake(0, HEIGHT-50, WIDTH, HEIGHT - 114)];
    
    return _resultView;
}
    
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor blueColor];
    
}



@end
