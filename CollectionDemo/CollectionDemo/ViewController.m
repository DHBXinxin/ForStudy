//
//  ViewController.m
//  CollectionDemo
//
//  Created by 李欣欣 on 2021/4/26.
//

#import "ViewController.h"
#import "FlowMidB.h"

@interface ViewController ()<UICollectionViewDelegate,UICollectionViewDataSource>

@property (strong, nonatomic) UICollectionView *collectionView;
@property (strong, nonatomic) FlowMidB *layout;
@end

@implementation ViewController

- (UICollectionView *)collectionView {
    if (_collectionView) {
        return _collectionView;
    }
    _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 150, 375, 300) collectionViewLayout:self.layout];
    [_collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    return _collectionView;
}
- (FlowMidB *)layout {
    if (!_layout) {
        _layout = [[FlowMidB alloc]init];
        _layout.itemSize = CGSizeMake(350, 240);
    }
    return _layout;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.view addSubview:self.collectionView];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 20;
}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    cell.backgroundColor = [UIColor redColor];
    return cell;;
}


@end
