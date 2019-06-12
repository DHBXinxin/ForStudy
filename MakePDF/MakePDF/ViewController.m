//
//  ViewController.m
//  MakePDF
//
//  Created by DHSD on 2019/6/12.
//  Copyright © 2019 DHSD. All rights reserved.
//

#import "ViewController.h"
#import "PDFManager.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    NSString *path = @"/Users/dhsd/Downloads/界面/311539226763_.pic.jpg";
    NSData *data = [NSData dataWithContentsOfFile:path];
    NSString *pdfPath = @"/Users/dhsd/Downloads/界面/301539226762_.pic.pdf";
    //如果是多个图片把createPDF方法修改一下就可以了、标注第二页、看一眼就明白
    [PDFManager createPDFFileWith:data toFilePath:pdfPath withPassword:nil];
    
}


@end
