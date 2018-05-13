//
//  ZXDMakeOutViewController.m
//  GuShiCi
//
//  Created by zxd on 2018/4/30.
//  Copyright © 2018年 zxd. All rights reserved.
//

#import "ZXDMakeOutViewController.h"
#import "BtnCell.h"
#import "ZXDFlowLayout.h"
#import "ZXDRecommendButton.h"
@interface ZXDMakeOutViewController ()<UICollectionViewDataSource>
//写字的数据源
@property (nonatomic, strong) NSArray *dataArr;
@property (weak, nonatomic) IBOutlet UIView *topView;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@end
static NSString *collectionID = @"collectionID";
@implementation ZXDMakeOutViewController

- (NSArray *)dataArr
{
    if(!_dataArr){
        _dataArr = [ZXDRecommendButton mj_objectArrayWithFilename:@"buttons.plist"];
    }
    return _dataArr;
}

- (void)viewDidLoad {
    [super viewDidLoad];
//    self.automaticallyAdjustsScrollViewInsets=YES;
    self.view.backgroundColor = [UIColor whiteColor];
    
    //创建一个view 装btn
    [self setupTopView];
   
    //流水布局
    UICollectionViewFlowLayout *layout = [self setupCollectionViewFlowLayout];

    //创建UICollectionView：黑色
    [self setupCollectionView:layout];
    
    //创建btn
    [self setupButton];
    
    //加入写字板1
    
}

#pragma mark - 创建topView
-(void)setupTopView
{
//    UIView *topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ZXDScreenW, 230)];
    UIView *topView = [[UIView alloc]init];
    _topView = topView;
    topView.backgroundColor = [UIColor brownColor];
    [self.view addSubview:topView];
}
#pragma mark - 创建流水布局
-(UICollectionViewFlowLayout *)setupCollectionViewFlowLayout{
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
    layout.itemSize = CGSizeMake(80,80);
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    //demo
//    CGFloat margin = (ZXDScreenW - 160) * 0.5;
//    layout.sectionInset = UIEdgeInsetsMake(0, margin, 0, margin);
    //行距
    layout.minimumLineSpacing = 10;
    return layout;
}

#pragma mark - 创建CollectionView
-(void)setupCollectionView:(UICollectionViewFlowLayout *)layout
{
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 64, self.view.bounds.size.width, 100) collectionViewLayout:layout];
    collectionView.backgroundColor = [UIColor clearColor];
    [_topView addSubview:collectionView];
    _collectionView = collectionView;
    collectionView.dataSource = self;
    
    //demo
//    collectionView.showsVerticalScrollIndicator = NO;
//    collectionView.center = self.view.center;
    //注册
//    [collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([BtnCell class]) bundle:nil]  forCellWithReuseIdentifier:collectionID];
}

#pragma mark - 创建textButton
-(void)setupButton
{
    CGFloat buttonW = 150;
    CGFloat buttonH = 30;
    UIButton *text = [[UIButton alloc] initWithFrame:CGRectMake((ZXDScreenW - buttonW)/2, 180, buttonW, buttonH)];
    text.backgroundColor = [UIColor blueColor];
    [text setTitle:@"输入文字" forState:UIControlStateNormal];
    text.titleLabel.textColor = [UIColor whiteColor];
    [text addTarget:self action:@selector(textTarget) forControlEvents:UIControlEventTouchUpInside];
    [_topView addSubview:text];
}

-(void)textTarget
{
    
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.dataArr.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{

    BtnCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:collectionID forIndexPath:indexPath];
    cell.cellData = self.dataArr[indexPath.row];
    return cell;
}


@end
