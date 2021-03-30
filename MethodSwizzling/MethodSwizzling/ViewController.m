//
//  ViewController.m
//  MethodSwizzling
//
//  Created by DHSD on 2018/9/10.
//  Copyright © 2018年 DHSD. All rights reserved.
//

#import "ViewController.h"
#import <objc/NSObjCRuntime.h>
@interface ViewController ()<UITableViewDataSource, UITableViewDelegate>
- (IBAction)changeLaunge:(id)sender;

@property (strong, nonatomic) UITableView *mainTable;

@property (strong, nonatomic) NSMutableArray *mainData;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.view.backgroundColor = [UIColor redColor];
    
    _mainData = [NSMutableArray array];
    [_mainData addObjectsFromArray:@[@"kk", @"jj"]];
    _mainTable = [[UITableView alloc]initWithFrame:self.view.bounds];
    _mainTable.delegate = self;
    _mainTable.dataSource = self;
    [self.view addSubview:_mainTable];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapTable:)];
    [_mainTable addGestureRecognizer:tap];
}

- (void)tapTable:(UITapGestureRecognizer *)tap {
    [_mainData replaceObjectAtIndex:0 withObject:@"aaaa"];
    [_mainTable reloadData];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    cell.textLabel.text = [_mainData objectAtIndex:indexPath.row];
    return cell;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)changeLaunge:(id)sender {
}
@end
