//
//  ShapeImageView.h
//  ForCGBitmapContext
//
//  Created by DHSD on 2019/6/5.
//  Copyright © 2019 DHSD. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ShapeImageView : UIImageView

@property (strong, nonatomic) UIImage *basicImage;

- (void)changeShape:(NSArray<NSValue *> *)points;
@end

NS_ASSUME_NONNULL_END
