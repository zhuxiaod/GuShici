//
//  ZXDFlowLayout.m
//  GuShiCi
//
//  Created by zxd on 2018/5/1.
//  Copyright © 2018年 zxd. All rights reserved.
//

#import "ZXDFlowLayout.h"
/*
    根据demo去了解父类中的方法
 
 */
@implementation ZXDFlowLayout

//重写它的方法,扩展方法
//什么时候调用：collectionView第一次布局，collectionView刷新的时候也会调用
//作用：计算cell的布局,条件：cell的位置是固定不变
//很少使用
- (void)prepareLayout
{
    [super prepareLayout];
    // 每个cell的尺寸
    self.itemSize = CGSizeMake(160,160);
}

/*
 UICollectionViewLayoutAttributes:确定cell的尺寸
 一个UICollectionViewLayoutAttributes对象对应一个cell
 拿到UICollectionViewLayoutAttributes相当于拿到cell
 */

//作用：返回很多cell的尺寸
//可以一次性返回所有cell尺寸,也可以每隔一个距离返回cell
- (nullable NSArray<__kindof UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect
{
//    //获取当前显示cell的布局
    NSArray *attrs = [super layoutAttributesForElementsInRect:self.collectionView.bounds];
//
//    for (UICollectionViewLayoutAttributes *attr in attrs){
//        //2.计算中心点距离
//        CGFloat delta = fabs((attr.center.x - self.collectionView.contentOffset.x) - self.collectionView.bounds.size.width * 0.5);
//
//        //3.计算比例
//        CGFloat scale = 1 - delta / (self.collectionView.bounds.size.width * 0.5) * 0.25;
//
//        attr.transform = CGAffineTransformMakeScale(scale, scale);
//    }
    return attrs;
}

//在滚动的时候是否允许刷新布局
- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds
{
    return YES;
}

//什么时候调用：用户手指一松开就会调用
//作用：确定最终偏移量
- (CGPoint)targetContentOffsetForProposedContentOffset:(CGPoint)proposedContentOffset withScrollingVelocity:(CGPoint)velocity
{
//    CGFloat collectionW = self.collectionView.bounds.size.width;
//
//    //最终偏移量
    CGPoint targetP = [super targetContentOffsetForProposedContentOffset:proposedContentOffset withScrollingVelocity:velocity];
//
//    //0.获取最终显示的区域
//    CGRect targetRect = CGRectMake(targetP.x, 0, collectionW, MAXFLOAT);
//
//    //1.获取最终显示的cell
//    NSArray *attrs = [super layoutAttributesForElementsInRect:targetRect];
//
//    CGFloat minDelta = MAXFLOAT;
//    for (UICollectionViewLayoutAttributes *attr in attrs){
//        //2.计算中心点距离
//        CGFloat delta = fabs((attr.center.x - self.collectionView.contentOffset.x) - self.collectionView.bounds.size.width * 0.5);
//
//        if (fabs(delta) < fabs(minDelta) ) {
//            minDelta = delta;
//        }
//    }
//
//    targetP.x += minDelta;
//
//    NSLog(@"%f",targetP.x);
//    if (targetP.x < 0) {
//        targetP.x = 0;
//    }
//
    return targetP;
}

//计算collectionView滚动范围
- (CGSize)collectionViewContentSize{
    return [super collectionViewContentSize];
}
@end
