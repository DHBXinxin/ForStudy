//
//  PDFManager.h
//  MakePDF
//
//  Created by DHSD on 2019/6/12.
//  Copyright © 2019 DHSD. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface PDFManager : NSObject
/**
 创建pdf文件
 */
+ (void)createPDFFileWith:(NSData *)imgData
               toFilePath:(NSString *)filePath
             withPassword:(NSString * __nullable)pw;
@end

NS_ASSUME_NONNULL_END
