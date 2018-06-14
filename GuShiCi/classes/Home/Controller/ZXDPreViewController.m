//
//  ZXDPreViewController.m
//  GuShiCi
//
//  Created by zxd on 2018/5/12.
//  Copyright © 2018年 zxd. All rights reserved.
//

#import "ZXDPreViewController.h"
#import "ZXDHanZiCell.h"
#import "ZXDHanZi.h"
@interface ZXDPreViewController ()<UICollectionViewDataSource>

@end
static NSString *hanZiCell = @"hanZiCell";
@implementation ZXDPreViewController


-(NSArray *)dataArray
{
    if(!_dataArray)
    {
        _dataArray = [NSArray array];
    }
    return _dataArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    //流水布局
    UICollectionViewFlowLayout *layout = [self setupCollectionViewFlowLayout];
    
    //创建UICollectionView：黑色
    [self setupCollectionView:layout];

}

#pragma mark - 创建流水布局
-(UICollectionViewFlowLayout *)setupCollectionViewFlowLayout{
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
    layout.itemSize = CGSizeMake(75,75);
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    //行距
    layout.minimumLineSpacing = 0;
    return layout;
}
//上一个页面的内容传进来
//cell使用什么来显示
//布局问题
#pragma mark - 创建CollectionView
-(void)setupCollectionView:(UICollectionViewFlowLayout *)layout
{
    NSInteger height;
    //创建判断
    if(_dataArray.count < 5)
    {
        height = 1;
    }else{
        height = _dataArray.count/5;
    }
    //分割线
    UIView *view1 = [[UIView alloc] initWithFrame:CGRectMake(0, 63,ZXDScreenW,1 )];
    view1.backgroundColor = [UIColor grayColor];
    [self.view addSubview:view1];
    UIView *view2 = [[UIView alloc] initWithFrame:CGRectMake(0, height*100+70,ZXDScreenW,1 )];
    view2.backgroundColor = [UIColor grayColor];
    [self.view addSubview:view2];
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 64, ZXDScreenW, height * 100) collectionViewLayout:layout];
    collectionView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:collectionView];
    collectionView.dataSource = self;
    //注册
    [collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([ZXDHanZiCell class]) bundle:nil]  forCellWithReuseIdentifier:hanZiCell];
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    ZXDHanZiCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:hanZiCell forIndexPath:indexPath];
    ZXDHanZi *hanzi = self.dataArray[indexPath.row];
    cell.image = hanzi.image;
    return cell;
}

@end
