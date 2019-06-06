//
//  ColorPicker.m
//  ForCGBitmapContext
//
//  Created by DHSD on 2019/6/3.
//  Copyright © 2019 DHSD. All rights reserved.
//

#import "ColorPicker.h"

@implementation ColorPicker
//这个方法不知道为什么取到的值不对、奇怪的是一样的代码、swift就可以顺利的运行、获取不一样但是我咩有发现不一样的地方
//+ (UIColor *)getColor:(CGPoint)point withImage:(UIImage *)image {
//    CGImageRef imgCGImage = [image CGImage];
//    NSInteger imgWidth = CGImageGetWidth(imgCGImage);
//    NSInteger imgHeight = CGImageGetHeight(imgCGImage);
//    //位图大小 = 图片宽 * 图片高 * 包含的信息量(r、g、b、a这s4个)
//    NSInteger bitmapByteCount = imgWidth * imgHeight * 4;
//    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
//    void *bitmapData = malloc(bitmapByteCount);
//    CGContextRef context = CGBitmapContextCreate(bitmapData,
//                                                 imgWidth,
//                                                 imgHeight,
//                                                 8,
//                                                 imgWidth * 4,
//                                                 colorSpace,
//                                                 kCGImageAlphaPremultipliedFirst);
//    free(bitmapData);
//    CGRect rect = CGRectMake(0, 0, imgWidth, imgHeight);
//    CGContextDrawImage(context, rect, imgCGImage);
//    unsigned char* pixelData = CGBitmapContextGetData(context);
//
////    unsigned char* pixelData = (unsigned char*)data;
//
//     long int offset = (int)point.y * imgWidth + (int)point.x * 4;
//
//    CGFloat alpha   = (CGFloat)pixelData[offset];
//    CGFloat red = (CGFloat)pixelData[offset + 1];
//    CGFloat green  = (CGFloat)pixelData[offset + 2];
//    CGFloat blue = (CGFloat)pixelData[offset + 3];
//
//    return [UIColor colorWithRed:red / 255.0 green:green / 255.0  blue:blue / 255.0  alpha:alpha / 255.0 ];
//
//}
//----------------------------swift获取了正确的数据--------------下面的方法也获取了正确的数据
//class func getColor(point:CGPoint, image:UIImage) -> UIColor{
//
//    // 获取图片信息
//    let imgCGImage = image.cgImage
//    let imgWidth = imgCGImage!.width// CGImageGetWidth(imgCGImage!)
//    let imgHeight = imgCGImage!.height//CGImageGetHeight(imgCGImage!)
//
//    // 位图的大小 ＝ 图片宽 ＊ 图片高 ＊ 图片中每点包含的信息量
//    let bitmapByteCount = imgWidth * imgHeight * 4
//
//    // 使用系统的颜色空间
//    let colorSpace = CGColorSpaceCreateDeviceRGB()
//
//    // 根据位图大小，申请内存空间
//    let bitmapData = malloc(bitmapByteCount)
//    defer {free(bitmapData)}
//
//    // 创建一个位图
//    let context = CGContext.init(data: bitmapData,
//                                 width: imgWidth,
//                                 height: imgHeight,
//                                 bitsPerComponent: 8,
//                                 bytesPerRow: imgWidth * 4,
//                                 space: colorSpace,
//                                 bitmapInfo: CGImageAlphaInfo.premultipliedFirst.rawValue)
//
//    // 图片的rect
//    let rect = CGRect.init(x: 0, y: 0, width: CGFloat(imgWidth), height: CGFloat(imgHeight))// CGRectMake(0, 0, CGFloat(imgWidth), CGFloat(imgHeight))
//
//    // 将图片画到位图中
//    context?.draw(imgCGImage!, in: rect)
//    //        CGContextDrawImage(context, rect, imgCGImage)
//
//    // 获取位图数据
//    let data = context?.data//CGBitmapContextGetData(context!)
//
//    /**
//     强转指针类型
//     参考:http://www.csdn.net/article/2015-01-20/2823635-swift-pointer
//     http://c.biancheng.net/cpp/html/2282.html
//     */
//    let charData = unsafeBitCast(data, to: UnsafePointer<CUnsignedChar>.self)
//
//    // 根据当前所选择的点计算出对应位图数据的index
//    let offset = (Int(point.y) * imgWidth + Int(point.x)) * 4
//
//    // 获取4种信息
//    let alpha = charData[offset]//(charData+offset).memory
//    let red   = charData[offset + 1] //(charData+offset+1).memory
//    let green = charData[offset + 2]//(charData+offset+2).memory
//    let blue  = charData[offset + 3]//(charData+offset+3).memory
//
//    // 得到颜色
//    let color = UIColor(red: CGFloat(red)/255.0, green: CGFloat(green)/255.0, blue: CGFloat(blue)/255.0, alpha: CGFloat(alpha)/255.0)
//
//    return color
//}


+ (UIColor *)getColor:(CGPoint)point withImage:(UIImage *)image {
    NSInteger pointX = trunc(point.x);
    NSInteger pointY = trunc(point.y);
    CGImageRef cgImage = image.CGImage;
    NSUInteger width = image.size.width;
    NSUInteger height = image.size.height;
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    int bytesPerPixel = 4;
    int bytesPerRow = bytesPerPixel * 1;
    NSUInteger bitsPerComponent = 8;
    unsigned char pixelData[4] = { 0, 0, 0, 0 };
    CGContextRef context = CGBitmapContextCreate(pixelData,
                                                 1,
                                                 1,
                                                 bitsPerComponent,
                                                 bytesPerRow,
                                                 colorSpace,
                                                 kCGImageAlphaPremultipliedLast |     kCGBitmapByteOrder32Big);
    CGColorSpaceRelease(colorSpace);
    //按point做位移把point点画到画板上---与手机像素的的（0，0）点不一样、他是正常的坐标点儿、以左下角为（0，0）点
    CGContextTranslateCTM(context, -pointX, pointY-(CGFloat)height);
    CGContextDrawImage(context, CGRectMake(0.0f, 0.0f, (CGFloat)width, (CGFloat)height), cgImage);
    CGContextRelease(context);
    
    CGFloat red   = (CGFloat)pixelData[0] / 255.0f;
    CGFloat green = (CGFloat)pixelData[1] / 255.0f;
    CGFloat blue  = (CGFloat)pixelData[2] / 255.0f;
    CGFloat alpha = (CGFloat)pixelData[3] / 255.0f;
    
    return [UIColor colorWithRed:red green:green blue:blue alpha:alpha];
    
}
 
@end
