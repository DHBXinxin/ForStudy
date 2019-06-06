//
//  Demo2_ShapeImageView.swift
//  AFBitMap
//
//  Created by DHSD on 2019/6/4.
//  Copyright © 2019 DHSD. All rights reserved.
//

import UIKit

class Demo2_ShapeImageView: UIImageView {

    var basicImage:UIImage?
    
    func changeShape(points:[CGPoint]){
        
        var p0 = points[0]
        var p1 = points[1]
        var p2 = points[2]
        var p3 = points[3]
        
        // 当前view距父View左上角的相对距离，和理论大小
        let minLeft = min(min(p0.x, p1.x), min(p2.x, p3.x));
        let minTop = min(min(p0.y, p1.y), min(p2.y, p3.y));
        let shapeWidth = Int(max(max(p0.x, p1.x), max(p2.x, p3.x))-min(min(p0.x, p1.x), min(p2.x, p3.x)))
        let shapeHeight = Int(max(max(p0.y, p1.y), max(p2.y, p3.y))-min(min(p0.y, p1.y), min(p2.y, p3.y)))
        
        // 修正点的位置为相对自身
        p0.x = p0.x - minLeft;
        p1.x = p1.x - minLeft;
        p2.x = p2.x - minLeft;
        p3.x = p3.x - minLeft;
        p0.y = p0.y - minTop;
        p1.y = p1.y - minTop;
        p2.y = p2.y - minTop;
        p3.y = p3.y - minTop;
        
        // 获取图片信息
        let imgCGImage = basicImage!.cgImage
        let imgWidth = imgCGImage!.width//CGImageGetWidth(imgCGImage)
        let imgHeight = imgCGImage!.height//CGImageGetHeight(imgCGImage)
        
        // 位图的大小 ＝ 图片宽 ＊ 图片高 ＊ 图片中每点包含的信息量
        let imgByteCount = imgWidth * imgHeight * 4
        
        // 使用系统的颜色空间
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        
        // 根据位图大小，申请内存空间
        let imgData = malloc(imgByteCount)
        defer {free(imgData)}
        
        // 创建一个位图
        let imgContext = CGContext.init(data: imgData,
                                        width: imgWidth,
                                        height: imgHeight,
                                        bitsPerComponent: 8,
                                        bytesPerRow: imgWidth * 4,
                                        space: colorSpace,
                                        bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue)
        
//        let imgContext = CGBitmapContextCreate(imgData,
//                                               imgWidth,
//                                               imgHeight,
//                                               8,
//                                               imgWidth * 4,
//                                               colorSpace,
//                                               CGImageAlphaInfo.PremultipliedFirst.rawValue)
        
        // 图片的rect
        let imgRect = CGRect.init(x: 0, y: 0, width: CGFloat(imgWidth), height: CGFloat(imgHeight))//CGRectMake(0, 0, CGFloat(imgWidth), CGFloat(imgHeight))
        
        // 将图片画到位图中
        imgContext!.draw(imgCGImage!, in: imgRect)
//        CGContextDrawImage(imgContext, imgRect, imgCGImage)
        
        // 获取位图数据
        /**
         强转指针类型
         参考:http://www.csdn.net/article/2015-01-20/2823635-swift-pointer
         http://c.biancheng.net/cpp/html/2282.html
         */
        let data = imgContext!.data;
        //.self表示他的类型|.self用在实例变量后表示实例本身
        let newImgData = unsafeBitCast(data, to: UnsafeMutablePointer<CUnsignedChar>.self)
//        let newImgData = unsafeBitCast(CGBitmapContextGetData(imgContext), UnsafeMutablePointer<CUnsignedChar>.self)
        
        // 计算总大小,申请内存空间
        let shapeByteCount = shapeWidth * shapeHeight * 4
        let shapeVoideData = malloc(shapeByteCount)
        defer {free(shapeVoideData)}
        let shapeData = unsafeBitCast(shapeVoideData, to: UnsafeMutablePointer<CUnsignedChar>.self)
//        let shapeData = unsafeBitCast(shapeVoideData, UnsafeMutablePointer<CUnsignedChar>.self)
        
        // swift4之后的for循环
//        for i in 0...10 {
//            //0...10表示包含头尾的0到10之间所有的整数
//            //0..<10表示包含头不包含尾的0到9之间所有的整数
//            //0...10这种条件区间内不能出现任何的空格
//        }
//        //如果不关心循环本身的索引，可以直接用下划线如下
//        for _ in 0...10 {
//        }
//        //在遍历数组的时候，Swift还提供了一种特别方便的方式（利用元祖）
//        for (index,value) in array.enumerated() {
//            //index是下标，value是值
//            //这样使得遍历数组能写的更加简洁优雅
//        }
        for i in 0..<Int(shapeHeight) {
            for j in 0..<Int(shapeWidth) {
                let offset = Int(i * shapeWidth + j) * 4
                shapeData[offset] = 0
                shapeData[offset + 1] = 0
                shapeData[offset + 2] = 0
                shapeData[offset + 3] = 0
            }
        }
//        for (var i=0; i<Int(shapeHeight); i++) {
//            for (var j=0; j<shapeWidth; j++) {
//                let offset = (i*shapeWidth + j)*4
//                (shapeData+offset).memory = 0
//                (shapeData+offset+1).memory = 0
//                (shapeData+offset+2).memory = 0
//                (shapeData+offset+3).memory = 0
//            }
//        }
        
        // 数据处理
        for i in 0..<Int(imgHeight) - 1 {
            for j in 0..<Int(imgWidth) - 1 {
                let offset = Int(i * imgWidth + j) * 4
                let xFactor = CGFloat(j)/CGFloat(imgWidth)
                let yFactor = CGFloat(i)/CGFloat(imgHeight)
                
                var delX = (p1.x-p0.x)*xFactor
                var delY = (p1.y-p0.y)*xFactor
                let top = CGPoint.init(x: p0.x + delX, y: p0.y + delY)//CGPointMake(p0.x+delX, p0.y+delY)
                
                delX = (p2.x-p3.x)*xFactor
                delY = (p2.y-p3.y)*xFactor
                let bottom = CGPoint.init(x: p3.x + delX, y: p3.y + delY)//CGPointMake(p3.x+delX, p3.y+delY)
                
                delX = (bottom.x-top.x)*yFactor
                delY = (bottom.y-top.y)*yFactor
                let newPoint = CGPoint.init(x: top.x + delX, y: top.y + delY)//CGPointMake(top.x+delX, top.y+delY)
                
                let newIndex = (Int(newPoint.y)*shapeWidth+Int(newPoint.x))*4
                shapeData[newIndex] = newImgData[offset]
                shapeData[newIndex + 1] = newImgData[offset + 1]
                shapeData[newIndex + 2] = newImgData[offset + 2]
                shapeData[newIndex + 3] = newImgData[offset + 3]
                
            }
        }
//        for (var i=0; i<imgHeight-1; i++) {
//            for (var j=0; j<imgWidth-1; j++) {
//                // 在原图中的位置
//                let offset = (i*imgWidth + j)*4
//
//                // 计算原图每个点在新图中的位置
//                let xFactor = CGFloat(j)/CGFloat(imgWidth)
//                let yFactor = CGFloat(i)/CGFloat(imgHeight)
//
//                var delX = (p1.x-p0.x)*xFactor
//                var delY = (p1.y-p0.y)*xFactor
//                let top = CGPointMake(p0.x+delX, p0.y+delY)
//
//                delX = (p2.x-p3.x)*xFactor
//                delY = (p2.y-p3.y)*xFactor
//                let bottom = CGPointMake(p3.x+delX, p3.y+delY)
//
//                delX = (bottom.x-top.x)*yFactor
//                delY = (bottom.y-top.y)*yFactor
//                let newPoint = CGPointMake(top.x+delX, top.y+delY)
//
//                let newIndex = (Int(newPoint.y)*shapeWidth+Int(newPoint.x))*4
//
//                // 修改值
//                (shapeData+newIndex).memory = (newImgData+offset).memory
//                (shapeData+newIndex+1).memory = (newImgData+offset+1).memory
//                (shapeData+newIndex+2).memory = (newImgData+offset+2).memory
//                (shapeData+newIndex+3).memory = (newImgData+offset+3).memory
//
//            }
//        }
        
        // 创建新图的上下文
        let shapeContext = CGContext.init(data: shapeData,
                                          width: shapeWidth,
                                          height: shapeHeight,
                                          bitsPerComponent: 8,
                                          bytesPerRow: shapeWidth * 4,
                                          space: colorSpace,
                                          bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue)
//        let shapeContext = CGBitmapContextCreate(shapeData,
//                                                 shapeWidth,
//                                                 shapeHeight,
//                                                 8,      // bits per component
//            shapeWidth*4,
//            colorSpace,
//            CGImageAlphaInfo.PremultipliedFirst.rawValue)
        
        
        let outImage = shapeContext!.makeImage()//CGBitmapContextCreateImage(shapeContext!)
        
        // 根据图形上下文绘图
        let img = UIImage.init(cgImage: outImage!)//UIImage(CGImage: outImage!)
        
        // 配置新图片
        self.frame = CGRect.init(x: minLeft, y: minTop, width: CGFloat(shapeWidth), height: CGFloat(shapeHeight))//CGRectMake(minLeft, minTop, CGFloat(shapeWidth), CGFloat(shapeHeight))
        self.image = img
    }
}
