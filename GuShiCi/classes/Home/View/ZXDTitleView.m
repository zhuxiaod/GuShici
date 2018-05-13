//
//  ZXDTitleView.m
//  GuShiCi
//
//  Created by zxd on 2018/4/9.
//  Copyright © 2018年 zxd. All rights reserved.
//

#import "ZXDTitleView.h"
#import "ZXDSingModel.h"
#import "ZXDMusic.h"
@interface ZXDTitleView ()

@property(nonatomic,strong)UILabel *titleLabel;

@property(nonatomic,strong)UILabel *artistLabel;

@end

@implementation ZXDTitleView

-(instancetype)initWithFrame:(CGRect)frame
{
    if(self = [super initWithFrame:frame]){
        [self createLabels];
    }
    return self;
}

-(void)createLabels
{
    _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height/2)];
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    _titleLabel.textColor = [UIColor whiteColor];
    _titleLabel.font = [UIFont systemFontOfSize:25];
    [self addSubview:_titleLabel];

    _artistLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, self.bounds.size.height / 2, self.bounds.size.width, self.bounds.size.height / 2)];
    _artistLabel.textAlignment = NSTextAlignmentCenter;
    _artistLabel.textColor = [UIColor whiteColor];
    _artistLabel.font = [UIFont systemFontOfSize:16];
    [self addSubview:_artistLabel];

}

-(void)setSingModel:(ZXDMusic *)singModel
{
    _singModel = singModel;
    self.titleLabel.text = singModel.story_name;
//    self.artistLabel.text = singModel.singer;
}
@end
