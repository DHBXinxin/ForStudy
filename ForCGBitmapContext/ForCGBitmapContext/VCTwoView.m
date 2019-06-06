//
//  VCTwoView.m
//  ForCGBitmapContext
//
//  Created by DHSD on 2019/5/31.
//  Copyright © 2019 DHSD. All rights reserved.
//

#import "VCTwoView.h"
#import "ShapeImageView.h"


@interface VCTwoView ()

@property (strong, nonatomic) ShapeImageView *shapeImageView;

@property (strong, nonatomic) NSArray<UIView *> *views;

@property (weak, nonatomic) UIView *selectedView;

@end

@implementation VCTwoView

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
    // 设置图片view
    UIImage *img = [UIImage imageNamed:@"cat"];
    _shapeImageView = [[ShapeImageView alloc]init];
    _shapeImageView.frame = CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height-64);
    _shapeImageView.basicImage = img;
    [self.view addSubview:_shapeImageView];
    
    // 设置可拖动的按钮
    UIView *v0 = [[UIView alloc]initWithFrame:CGRectMake(50, 150, 20, 20)];
    UIView *v1 = [[UIView alloc]initWithFrame:CGRectMake(200, 150, 20, 20)];
    UIView *v2 = [[UIView alloc]initWithFrame:CGRectMake(200, 400, 20, 20)];
    UIView *v3 = [[UIView alloc]initWithFrame:CGRectMake(50, 400, 20, 20)];
    _views = @[v0,v1,v2,v3];
    
    for (UIView *v in _views) {
        v.backgroundColor = [UIColor blueColor];
        [self.view addSubview:v];
    }
    
    NSArray *arr = @[[NSValue valueWithCGPoint:_views[0].center],
                     [NSValue valueWithCGPoint:_views[1].center],
                     [NSValue valueWithCGPoint:_views[2].center],
                     [NSValue valueWithCGPoint:_views[3].center]];
    [_shapeImageView changeShape:arr];
    
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self.view];
    for (UIView *view in _views) {
        if (CGRectContainsPoint(view.frame, point)) {
            _selectedView = view;
        }
    }
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    UITouch *touch = touches.anyObject;
    CGPoint point = [touch locationInView:self.view];
    _selectedView.center = point;
    NSArray *arr = @[[NSValue valueWithCGPoint:_views[0].center],
                     [NSValue valueWithCGPoint:_views[1].center],
                     [NSValue valueWithCGPoint:_views[2].center],
                     [NSValue valueWithCGPoint:_views[3].center]];
    [_shapeImageView changeShape:arr];
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    _selectedView = nil;
}

@end
