//
//  ShapeImageView.m
//  ForCGBitmapContext
//
//  Created by DHSD on 2019/6/5.
//  Copyright © 2019 DHSD. All rights reserved.
//

#import "ShapeImageView.h"

@interface ShapeImageView ()


@end

@implementation ShapeImageView

- (void)changeShape:(NSArray<NSValue *> *)points {
    CGPoint p0 = [points objectAtIndex:0].CGPointValue;
    CGPoint p1 = [points objectAtIndex:1].CGPointValue;
    CGPoint p2 = [points objectAtIndex:2].CGPointValue;
    CGPoint p3 = [points objectAtIndex:3].CGPointValue;
    
    CGFloat minLeft = MIN(MIN(p0.x, p1.x), MIN(p2.x, p3.x));
    CGFloat minTop = MIN(MIN(p0.y, p1.y), MIN(p2.y, p3.y));
    NSInteger shapeWidth = (NSInteger)(MAX(MAX(p0.x, p1.x), MAX(p2.x, p3.x))-MIN(MIN(p0.x, p1.x), MIN(p2.x, p3.x)));
    NSInteger shapeHeight = (NSInteger)(MAX(MAX(p0.y, p1.y), MAX(p2.y, p3.y))-MIN(MIN(p0.y, p1.y), MIN(p2.y, p3.y)));
    p0.x = p0.x - minLeft;
    p1.x = p1.x - minLeft;
    p2.x = p2.x - minLeft;
    p3.x = p3.x - minLeft;
    p0.y = p0.y - minTop;
    p1.y = p1.y - minTop;
    p2.y = p2.y - minTop;
    p3.y = p3.y - minTop;
    
    CGImageRef imgCGImage = self.basicImage.CGImage;
    NSInteger imgWidth = CGImageGetWidth(imgCGImage);
    NSInteger imgHeight = CGImageGetHeight(imgCGImage);
    
    size_t imgByteCount = imgWidth * imgHeight * 4;
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    
    unsigned char* imgData = malloc(imgByteCount);
    
    CGContextRef imgContext = CGBitmapContextCreate(imgData,
                                                 imgWidth,
                                                 imgHeight,
                                                 8,
                                                 imgWidth * 4,
                                                 colorSpace,
                                                 kCGImageAlphaPremultipliedLast);
    CGRect imgRect = CGRectMake(0, 0, imgWidth, imgHeight);
    CGContextDrawImage(imgContext, imgRect, imgCGImage);
    
    void* data = CGBitmapContextGetData(imgContext);
    unsigned char *newImgData = data;
    
    size_t shapeByteCount = shapeWidth * shapeHeight * 4;
    
    void *shapeVoideData = malloc(shapeByteCount);
    unsigned char *shapeData = shapeVoideData;
    for (int i=0; i<(int)shapeHeight; i++) {
        for (int j=0; j<(int)shapeWidth; j++) {
            NSInteger offset = (i*shapeWidth + j)*4;
            shapeData[offset] = 0;
            shapeData[offset + 1] = 0;
            shapeData[offset + 2] = 0;
            shapeData[offset + 3] = 0;
        }
    }
    
    for (int i=0; i<(int)imgHeight-1; i++) {
        for (int j=0; j<(int)imgWidth-1; j++) {
            // 在原图中的位置
            NSInteger offset = (i*imgWidth + j)*4;
            
            // 计算原图每个点在新图中的位置
            CGFloat xFactor = j/(CGFloat)imgWidth;
            CGFloat yFactor = i/(CGFloat)imgHeight;
            
            CGFloat delX = (p1.x-p0.x)*xFactor;
            CGFloat delY = (p1.y-p0.y)*xFactor;
            CGPoint top = CGPointMake(p0.x+delX, p0.y+delY);
            
            delX = (p2.x-p3.x)*xFactor;
            delY = (p2.y-p3.y)*xFactor;
            CGPoint bottom = CGPointMake(p3.x+delX, p3.y+delY);
            
            delX = (bottom.x-top.x)*yFactor;
            delY = (bottom.y-top.y)*yFactor;
            CGPoint newPoint = CGPointMake(top.x+delX, top.y+delY);
            
            NSInteger newIndex = ((int)newPoint.y*(int)shapeWidth+(int)newPoint.x)*4;
            
            // 修改值
            shapeData[newIndex] = newImgData[offset];
            shapeData[newIndex + 1] = newImgData[offset + 1];
            shapeData[newIndex + 2] = newImgData[offset + 2];
            shapeData[newIndex + 3] = newImgData[offset + 3];
            
        }
    }
    
    CGContextRef shapeContext = CGBitmapContextCreate(shapeData,
                                                      shapeWidth,
                                                      shapeHeight,
                                                      8,
                                                      shapeWidth * 4,
                                                      colorSpace,
                                                      kCGImageAlphaPremultipliedLast);
    
    CGImageRef outImage = CGBitmapContextCreateImage(shapeContext);
    UIImage *image = [UIImage imageWithCGImage:outImage];
    self.frame = CGRectMake(minLeft, minTop, shapeWidth, shapeHeight);
    
    self.image = image;
    
    free(imgData);
    free(shapeVoideData);
}
@end
