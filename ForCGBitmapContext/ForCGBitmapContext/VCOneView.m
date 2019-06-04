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
    _resultView = [[UIButton alloc]initWithFrame:CGRectMake(0, HEIGHT-50, WIDTH, 50)];
    _resultView.backgroundColor = [UIColor whiteColor];
    [_resultView setTitle:@"当前颜色" forState:UIControlStateNormal];
    [_resultView setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [_resultView setTitleEdgeInsets:UIEdgeInsetsMake(20, 0, 0, 0)];
    _resultView.layer.bounds = _resultView.bounds;
    _resultView.layer.borderWidth = 3;
    _resultView.layer.borderColor = [UIColor cyanColor].CGColor;
    _resultView.titleLabel.font = [UIFont systemFontOfSize:15];
    return _resultView;
}

- (UIImageView *)imgView {
    if (_imgView) {
        return _imgView;
    }
    UIImage *image = [UIImage imageNamed:@"cat.jpeg"];
    _imgView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 164, WIDTH, HEIGHT - 214 )];
    _imgView.image = image;
    [_imgView addSubview:self.pointView];
    return _imgView;
}
- (UIView *)pointView {
    if (_pointView) {
        return _pointView;
    }
    CAShapeLayer *shape = [[CAShapeLayer alloc]init];
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, 20, 20) cornerRadius:10];
    shape.path = path.CGPath;
    shape.fillColor = [UIColor clearColor].CGColor;
    shape.strokeColor = [UIColor blueColor].CGColor;
    _pointView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 20, 20)];
    [_pointView.layer addSublayer:shape];
//    _pointView.backgroundColor = [UIColor redColor];
    return _pointView;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    NSString *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
    NSLog(@"%@",path);
    
    CGPoint point = CGPointMake(0, 0);
    [self.view addSubview:self.imgView];
    [self.view addSubview:self.resultView];
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self.view];
    NSLog(@"%f,%f",point.x, point.y);
}
- (void)tourchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {

}



@end
