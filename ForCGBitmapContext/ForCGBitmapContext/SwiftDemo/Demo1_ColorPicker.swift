//
//  Demo1_ColorPicker.swift
//  AFBitMap
//
//  Created by DHSD on 2019/6/4.
//  Copyright © 2019 DHSD. All rights reserved.
//

import UIKit

class Demo1_ColorPicker: NSObject {
    class func getColor(point:CGPoint, image:UIImage) -> UIColor{
        
        // 获取图片信息
        let imgCGImage = image.cgImage
        let imgWidth = imgCGImage!.width// CGImageGetWidth(imgCGImage!)
        let imgHeight = imgCGImage!.height//CGImageGetHeight(imgCGImage!)
        
        // 位图的大小 ＝ 图片宽 ＊ 图片高 ＊ 图片中每点包含的信息量
        let bitmapByteCount = imgWidth * imgHeight * 4
        
        // 使用系统的颜色空间
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        
        // 根据位图大小，申请内存空间
        let bitmapData = malloc(bitmapByteCount)
        defer {free(bitmapData)}
        
        // 创建一个位图
        let context = CGContext.init(data: bitmapData,
                                     width: imgWidth,
                                     height: imgHeight,
                                     bitsPerComponent: 8,
                                     bytesPerRow: imgWidth * 4,
                                     space: colorSpace,
                                     bitmapInfo: CGImageAlphaInfo.premultipliedFirst.rawValue)
        
        // 图片的rect
        let rect = CGRect.init(x: 0, y: 0, width: CGFloat(imgWidth), height: CGFloat(imgHeight))// CGRectMake(0, 0, CGFloat(imgWidth), CGFloat(imgHeight))
        
        // 将图片画到位图中
        context?.draw(imgCGImage!, in: rect)
//        CGContextDrawImage(context, rect, imgCGImage)
        
        // 获取位图数据
        let data = context?.data//CGBitmapContextGetData(context!)
        
        /**
         强转指针类型
         参考:http://www.csdn.net/article/2015-01-20/2823635-swift-pointer
         http://c.biancheng.net/cpp/html/2282.html
         */
        let charData = unsafeBitCast(data, to: UnsafePointer<CUnsignedChar>.self)
        
        // 根据当前所选择的点计算出对应位图数据的index
        let offset = (Int(point.y) * imgWidth + Int(point.x)) * 4
        
        // 获取4种信息
        let alpha = charData[offset]//(charData+offset).memory
        let red   = charData[offset + 1] //(charData+offset+1).memory
        let green = charData[offset + 2]//(charData+offset+2).memory
        let blue  = charData[offset + 3]//(charData+offset+3).memory
        
        // 得到颜色
        let color = UIColor(red: CGFloat(red)/255.0, green: CGFloat(green)/255.0, blue: CGFloat(blue)/255.0, alpha: CGFloat(alpha)/255.0)
        
        return color
    }
}
