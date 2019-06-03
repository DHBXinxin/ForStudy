//
//  ColorPicker.m
//  ForCGBitmapContext
//
//  Created by DHSD on 2019/6/3.
//  Copyright © 2019 DHSD. All rights reserved.
//

#import "ColorPicker.h"

@implementation ColorPicker

- (UIColor *)getColor:(CGPoint)point withImage:(UIImage *)image {
    CGImageRef imgCGImage = [image CGImage];
    CGFloat imgWidth = CGImageGetWidth(imgCGImage);
    CGFloat imgHeight = CGImageGetHeight(imgCGImage);
    //位图大小 = 图片宽 * 图片高 * 包含的信息量(r、g、b、a这s4个)
    CGFloat bitmapByteCount = imgWidth * imgHeight * 4;
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    void *bitmapData = malloc(bitmapByteCount);
    CGContextRef context = CGBitmapContextCreate(bitmapData,
                                                 imgWidth,
                                                 imgHeight,
                                                 8,
                                                 imgWidth * 4,
                                                 colorSpace,
                                                 kCGImageAlphaPremultipliedLast | kCGBitmapByteOrderDefault);
    free(bitmapData);
    CGRect rect = CGRectMake(0, 0, imgWidth, imgHeight);
    CGContextDrawImage(context, rect, imgCGImage);
    void *data = CGBitmapContextGetData(context);
    
    unsigned char* pixelData = (unsigned char*)data;
    
    int offset = (int)point.y * imgWidth + (int)point.x * 4;
    
    CGFloat red   = (CGFloat)pixelData[offset];
    CGFloat green = (CGFloat)pixelData[offset + 1];
    CGFloat blue  = (CGFloat)pixelData[offset + 2];
    CGFloat alpha = (CGFloat)pixelData[offset + 3];
    
    return [UIColor colorWithRed:red green:green blue:blue alpha:alpha];

}
@end
