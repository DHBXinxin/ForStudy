//
//  PDFManager.m
//  MakePDF
//
//  Created by DHSD on 2019/6/12.
//  Copyright © 2019 DHSD. All rights reserved.
//

#import "PDFManager.h"

@implementation PDFManager
+ (void)createPDFFileWith:(NSData *)imgData
               toFilePath:(NSString *)filePath
             withPassword:(NSString * __nullable)pw {
//    NSString *filePath = [self pdfSavePath:fileName];
    const char *path = [filePath UTF8String];
    CFDataRef data = (__bridge CFDataRef)(imgData);
    UIImage *image = [UIImage imageWithData:imgData];
    CGRect rect = CGRectMake(0, 0, image.size.width, image.size.height);
    CFStringRef password = (__bridge CFStringRef)pw;
    createPDF(data, rect, path, password);
}
void createPDF(CFDataRef data,
                 CGRect rect,
                 const char *filePath,
                 CFStringRef pw) {
    
    CGContextRef pdfContext;
    CFStringRef path;
    CFURLRef url;
    CFDataRef boxData = NULL;
    CFMutableDictionaryRef myDictionary = NULL;
    CFMutableDictionaryRef pageDictionary = NULL;
    
    path = CFStringCreateWithCString(NULL, filePath, kCFStringEncodingUTF8);
    url = CFURLCreateWithFileSystemPath(NULL, path, kCFURLPOSIXPathStyle, 0);
    CFRelease(path);
    //设置pdf文件的标题、作者等、、、
    myDictionary = CFDictionaryCreateMutable(NULL, 0, &kCFTypeDictionaryKeyCallBacks, &kCFTypeDictionaryValueCallBacks);
    CFDictionarySetValue(myDictionary, kCGPDFContextTitle, CFSTR("照片"));
    CFDictionarySetValue(myDictionary, kCGPDFContextCreator, CFSTR("作者"));
    if (pw) {
        CFDictionarySetValue(myDictionary, kCGPDFContextUserPassword, pw);
        CFDictionarySetValue(myDictionary, kCGPDFContextOwnerPassword, pw);
    }
    //创建pdf
    pdfContext = CGPDFContextCreateWithURL(url, &rect, myDictionary);
    CFRelease(myDictionary);
    CFRelease(url);
    pageDictionary = CFDictionaryCreateMutable(NULL, 0, &kCFTypeDictionaryKeyCallBacks, &kCFTypeDictionaryValueCallBacks);
    boxData = CFDataCreate(NULL, (const UInt8 *)&rect, sizeof(CGRect));
    CFDictionarySetValue(pageDictionary, kCGPDFContextMediaBox, boxData);
    CGPDFContextBeginPage(pdfContext, pageDictionary);
    drawContent(pdfContext, data, rect);
    CGPDFContextEndPage(pdfContext);
    
    //pageDictionary不重要、直接传空也可以正常运行、所以boxData也没有什么用、在创建context的时候已经把rect确定了下来
    //第二页
    CGPDFContextBeginPage(pdfContext, nil);
    drawContent(pdfContext, data, rect);
    CGPDFContextEndPage(pdfContext);
    
    CGContextRelease(pdfContext);
    CFRelease(pageDictionary);
    CFRelease(boxData);
}
void drawContent(CGContextRef myContext,
                   CFDataRef data,
                   CGRect rect)
{
    CGDataProviderRef dataProvider = CGDataProviderCreateWithCFData(data);
    CGImageRef image = CGImageCreateWithJPEGDataProvider(dataProvider, NULL, NO, kCGRenderingIntentDefault);
    CGContextDrawImage(myContext, rect, image);
    CGDataProviderRelease(dataProvider);
    CGImageRelease(image);
}
@end
