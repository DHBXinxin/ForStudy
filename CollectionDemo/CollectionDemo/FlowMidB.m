//
//  FlowMidB.m
//  CollectionDemo
//
//  Created by 李欣欣 on 2021/4/26.
//

#import "FlowMidB.h"

@interface FlowMidB ()

@end
@implementation FlowMidB

- (void)prepareLayout {
    [super prepareLayout];
    self.scrollDirection = UICollectionViewScrollDirectionHorizontal;
}
- (NSArray<__kindof UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect {
    NSArray *array = [super layoutAttributesForElementsInRect:rect];
//    NSArray *array = [self deepCopyWithArray:[super layoutAttributesForElementsInRect:rect]];
    CGFloat contentOffsetX = self.collectionView.contentOffset.x;
    CGFloat collectionViewCenterX = self.collectionView.frame.size.width * 0.5;
    
    for (UICollectionViewLayoutAttributes *attr in array) {
        CGFloat scale = 1 - fabs(attr.center.x - contentOffsetX - collectionViewCenterX) / self.collectionView.bounds.size.width;
        NSLog(@"scale------>%f",scale);
        attr.transform = CGAffineTransformMakeScale(1, scale);
        attr.alpha = scale;
    }
    return array;
}
- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds {
    return YES;
}
- (CGPoint)targetContentOffsetForProposedContentOffset:(CGPoint)proposedContentOffset withScrollingVelocity:(CGPoint)velocity {
    CGRect rect;
    rect.origin.y = 0;
    rect.origin.x = proposedContentOffset.x;
    rect.size = self.collectionView.frame.size;
    
    NSArray *array = [super layoutAttributesForElementsInRect:rect];
    CGFloat contentOffsetX = self.collectionView.contentOffset.x;
    CGFloat collectionViewCenterX = self.collectionView.frame.size.width * 0.5;
    
    CGFloat minDistance = MAXFLOAT;
    for (UICollectionViewLayoutAttributes *attr in array) {
        CGFloat distance = attr.center.x - contentOffsetX - collectionViewCenterX;
        if (fabs(distance) < fabs(minDistance)) {
            minDistance = distance;
        }
    }
    proposedContentOffset.x += minDistance;
    return proposedContentOffset;

}
//  UICollectionViewFlowLayout has cached frame mismatch for index path这个警告来源主要是在使用layoutAttributesForElementsInRect：方法返回的数组时，没有使用该数组的拷贝对象，而是直接使用了该数组。解决办法对该数组进行拷贝，并且是深拷贝。

- (NSArray *)deepCopyWithArray:(NSArray *)arr {
    NSMutableArray *arrM = [NSMutableArray array];
    for (UICollectionViewLayoutAttributes *attr in arr) {
        [arrM addObject:[attr copy]];
    }
    return arrM;
}

@end
