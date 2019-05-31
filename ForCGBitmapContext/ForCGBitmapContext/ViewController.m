//
//  ViewController.m
//  ForCGBitmapContext
//
//  Created by DHSD on 2019/5/31.
//  Copyright © 2019 DHSD. All rights reserved.
//

#import "ViewController.h"
#import "VCOneView.h"
#import "VCTwoView.h"

@interface ViewController () <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) UITableView *mainTable;

@end

@implementation ViewController

- (UITableView *)mainTable {
    if (_mainTable) {
        return _mainTable;
    }
    _mainTable = [[UITableView alloc]initWithFrame:self.view.frame style:UITableViewStylePlain];
    _mainTable.delegate = self;
    _mainTable.dataSource = self;
    return _mainTable;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.view addSubview:self.mainTable];
    
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 2;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    if (indexPath.row == 0) {
        cell.textLabel.text = @"取色器";
    }
    if (indexPath.row == 1) {
        cell.textLabel.text = @"图片拉伸";
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UIViewController *viewController = nil;
    if (indexPath.row == 0) {
        
        viewController = [[VCOneView alloc]init];
        
    }
    if (indexPath.row == 1) {
        
        viewController = [[VCTwoView alloc]init];
        
    }
    if (viewController) {
        [self.navigationController pushViewController:viewController animated:YES];
    }
}

@end
