//
//  ViewController.m
//  KnowAutolayout
//
//  Created by DHSD on 2019/6/24.
//  Copyright © 2019 DHSD. All rights reserved.
//

#import "ViewController.h"
#import "ChatCell.h"
#import "HeightCalculator.h"

@interface ViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) ChatCell *prototypeCell;
@property (strong, nonatomic) UITableView *mainTable;

@property (strong, nonatomic) NSArray *dataArray;
@property (strong, nonatomic) HeightCalculator *heightCalculator;

@end

@implementation ViewController

- (UITableView *)mainTable {
    if (_mainTable) {
        return _mainTable;
    }
    _mainTable = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
    _mainTable.delegate = self;
    _mainTable.dataSource = self;
    _mainTable.translatesAutoresizingMaskIntoConstraints = NO;
    return _mainTable;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.view addSubview:self.mainTable];
    NSArray *lay1 = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[_mainTable]-0-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_mainTable)];
    NSArray *lay2 = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[_mainTable]-0-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_mainTable)];
    [self.view addConstraints:lay1];
    [self.view addConstraints:lay2];
    
    _heightCalculator = [[HeightCalculator alloc] init];
    self.mainTable.estimatedRowHeight = 100;
    self.prototypeCell = [[ChatCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    [self initialData];
    
    UIButton *bt = [[UIButton alloc]init];
    bt.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:bt];
    bt.backgroundColor = [UIColor redColor];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:bt attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeft multiplier:1 constant:60]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:bt attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1 constant:60]];
    
    //左上的toItem值不能为nil
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:bt attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:60]];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:bt attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:60]];
}
- (void)initialData
{
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"data" ofType:@"json"];
    NSData *data = [[NSData alloc] initWithContentsOfFile:filePath];
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
    NSArray *array = [dic objectForKey:@"feed"];
    NSMutableArray *muArray = [NSMutableArray array];
    for (NSDictionary *dic in array) {
        ChatModel *model = [[ChatModel alloc] initWithDictionary:dic];
        [muArray addObject:model];
    }
    _dataArray = [NSArray arrayWithArray:muArray];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ChatModel *model = model = [_dataArray objectAtIndex:indexPath.row];
    
    CGFloat height = [_heightCalculator heightForCalculateheightModel:model];
    if (height > 0) {
        NSLog(@"cache height");
        return height;
    } else {
        NSLog(@"calculate height");
    }
    ChatCell *cell = self.prototypeCell;
    cell.contentView.translatesAutoresizingMaskIntoConstraints = NO;
    [self configureCell:cell atIndexPath:indexPath]; //必须先对Cell中的数据进行配置使动态计算时能够知道根据Cell内容计算出合适的高度
    
    /*------------------------------重点这里必须加上contentView的宽度约束不然计算出来的高度不准确-------------------------------------*/
    CGFloat contentViewWidth = CGRectGetWidth(self.mainTable.bounds);
    NSLayoutConstraint *widthFenceConstraint = [NSLayoutConstraint constraintWithItem:cell.contentView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:contentViewWidth];
    [cell.contentView addConstraint:widthFenceConstraint];
    // Auto layout engine does its math
    CGFloat fittingHeight = [cell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;
    [cell.contentView removeConstraint:widthFenceConstraint];
    /*-------------------------------End------------------------------------*/
    
    CGFloat cellHeight = fittingHeight + 2 * 1 / [UIScreen mainScreen].scale; //必须加上上下分割线的高度
    [_heightCalculator setHeight:cellHeight withCalculateheightModel:model];
    return cellHeight;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ChatCell *cell = [[ChatCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    [self configureCell:cell atIndexPath:indexPath];
    return cell;
}
//去除分割线
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Remove seperator inset
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    
    // Prevent the cell from inheriting the Table View's margin settings
    if ([cell respondsToSelector:@selector(setPreservesSuperviewLayoutMargins:)]) {
        [cell setPreservesSuperviewLayoutMargins:NO];
    }
    
    // Explictly set your cell's layout margins
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}

- (void)configureCell:(ChatCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    cell.model = [_dataArray objectAtIndex:indexPath.row];
}

@end
