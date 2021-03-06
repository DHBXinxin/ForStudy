//
//  ColorPicker.h
//  ForCGBitmapContext
//
//  Created by DHSD on 2019/6/3.
//  Copyright © 2019 DHSD. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
NS_ASSUME_NONNULL_BEGIN

@interface ColorPicker : NSObject

+ (UIColor *)getColor:(CGPoint)point withImage:(UIImage *)image;

@end

NS_ASSUME_NONNULL_END
