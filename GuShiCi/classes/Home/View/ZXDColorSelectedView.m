//
//  ZXDColorSelectedView.m
//  GuShiCi
//
//  Created by zxd on 2018/5/9.
//  Copyright © 2018年 zxd. All rights reserved.
//

#import "ZXDColorSelectedView.h"
#import "ZXDColorCell.h"
#import "ZXDBallColorModel.h"
#import "UIColor+help.h"
#import "DrawView.h"

@interface ZXDColorSelectedView ()<UICollectionViewDelegate,UICollectionViewDataSource>
@property (weak, nonatomic) UICollectionView *collectionView;

@property (nonatomic,strong) NSArray *colorSelectModels;

@property (nonatomic,strong) NSArray *colors;
@property (nonatomic,strong) DrawView *drawView;

@end
@implementation ZXDColorSelectedView

static NSString *colorCellID = @"colorCell";
NSIndexPath *_lastIndexPath;

-(instancetype)initWithFrame:(CGRect)frame
{
    if(self = [super initWithFrame:frame]){
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init]; [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
        //设置CollectionView的属性
         UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
        self.collectionView = collectionView;
        self.collectionView.backgroundColor = [UIColor whiteColor];
        self.collectionView.delegate = self;
        self.collectionView.dataSource = self;
        self.collectionView.scrollEnabled = YES;
        [self addSubview:self.collectionView];
        //注册Cell
        [self.collectionView registerClass:[ZXDColorCell class] forCellWithReuseIdentifier:colorCellID];
    }
    return self;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    self.collectionView.frame = CGRectMake(1, 1, self.frame.size.width-2, self.frame.size.height-2);
}
#pragma mark - lazy
- (NSArray *)colorSelectModels
{
    /*
     ed4040 237 64 64
     f5973c 245 151 60
     efe82e 239 232 46
     7ce331 124 227 49
     48dcde 72 220 222
     2877e3 40 119 227
     9b33e4 155 51 228
     */
    if (!_colorSelectModels) {
        //        isBallColor
        NSDictionary *dic1 = [NSDictionary dictionaryWithObjectsAndKeys:@(0),@"ballColor", nil];
        NSDictionary *dic2 = [NSDictionary dictionaryWithObjectsAndKeys:@(1),@"ballColor", nil];
        NSDictionary *dic3 = [NSDictionary dictionaryWithObjectsAndKeys:@(2),@"ballColor", nil];
        NSDictionary *dic4 = [NSDictionary dictionaryWithObjectsAndKeys:@(3),@"ballColor", nil];
        NSDictionary *dic5 = [NSDictionary dictionaryWithObjectsAndKeys:@(4),@"ballColor", nil];
        NSDictionary *dic6 = [NSDictionary dictionaryWithObjectsAndKeys:@(5),@"ballColor", nil];
        NSDictionary *dic7 = [NSDictionary dictionaryWithObjectsAndKeys:@(6),@"ballColor", nil];
        NSDictionary *dic8 = [NSDictionary dictionaryWithObjectsAndKeys:@(7),@"ballColor", nil];

        NSDictionary *dic9 = [NSDictionary dictionaryWithObjectsAndKeys:@(8),@"ballColor", nil];

        NSDictionary *dic10 = [NSDictionary dictionaryWithObjectsAndKeys:@(9),@"ballColor", nil];

        NSDictionary *dic11 = [NSDictionary dictionaryWithObjectsAndKeys:@(10),@"ballColor", nil];

        NSDictionary *dic12 = [NSDictionary dictionaryWithObjectsAndKeys:@(11),@"ballColor", nil];

        NSDictionary *dic13 = [NSDictionary dictionaryWithObjectsAndKeys:@(12),@"ballColor", nil];
         NSDictionary *dic14 = [NSDictionary dictionaryWithObjectsAndKeys:@(13),@"ballColor", nil];
         NSDictionary *dic15 = [NSDictionary dictionaryWithObjectsAndKeys:@(14),@"ballColor", nil];


        NSArray *array = [NSArray arrayWithObjects:dic1,
                          dic2,
                          dic3,
                          dic4,
                          dic5,
                          dic6,
                          dic7,
                          dic8,
                          dic9,
                          dic10,
                          dic11,
                          dic12,
                          dic13,
                          dic14,
                          dic15,
                          nil];
        _colorSelectModels = [ZXDBallColorModel mj_objectArrayWithKeyValuesArray:array];
    }
    return _colorSelectModels;
}
- (NSArray *)colors
{
    if (!_colors) {
        _colors = [NSArray arrayWithObjects:@"#ed4040",
                   @"#f5973c",
                   @"#efe82e",
                   @"#7ce331",
                   @"#48dcde",
                   @"#2877e3",
                   @"#9b33e4",
                   @"#000000",
                   @"#4f4f2f",
                   @"#856363",
                   @"#5c3317",
                   @"#00ff7f",
                   @"#2f4f4f",
                   @"#545454",
                   @"#ff7f00",
                   nil];
    }
    return _colors;
}

#pragma mark - 设置CollectionViewDataSourse
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.colors.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:colorCellID forIndexPath:indexPath];
    //设置颜色背景图案
    ZXDBallColorModel *model = self.colorSelectModels[indexPath.item];
    cell.backgroundColor = [UIColor colorWithHexString:self.colors[[model.ballColor integerValue]]];
    cell.layer.cornerRadius = 3;
    //选中效果
    if (model.isBallColor) {
        cell.layer.borderWidth = 3;
        cell.layer.borderColor = [UIColor purpleColor].CGColor;
    }else{
        cell.layer.borderWidth = 0;
    }
    cell.layer.masksToBounds = YES;
    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (_lastIndexPath) {
        HBBallColorModel *lastModel = self.colorSelectModels[_lastIndexPath.item];
        lastModel.isBallColor = NO;
        [self.collectionView reloadItemsAtIndexPaths:@[_lastIndexPath]];
    }
    _lastIndexPath = indexPath;
    
    HBBallColorModel *model = self.colorSelectModels[indexPath.item];
    UIColor *color = [UIColor colorWithHexString:self.colors[[model.ballColor integerValue]]];
    if([self.delegate respondsToSelector:@selector(ZXDColorSelectedView:selectColor:)]){
        [self.delegate ZXDColorSelectedView:self selectColor:color];
    }
    
    model.isBallColor = YES;
    [self.collectionView reloadItemsAtIndexPaths:@[indexPath]];
    //从父控件当中移除
    [self removeFromSuperview];
}

@end
