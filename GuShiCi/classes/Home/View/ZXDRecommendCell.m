//
//  ZXDRecommendCell.m
//  GuShiCi
//
//  Created by zxd on 2018/4/6.
//  Copyright © 2018年 zxd. All rights reserved.
//

#import "ZXDRecommendCell.h"
#import "HomeButton.h"
#import "ZXDRecommendButton.h"
#import "ZXDMusic.h"
#import "ZXDRecommendView.h"

@interface ZXDRecommendCell ()
@property(nonatomic,strong)ZXDRecommendView *recommendView;


@end

@implementation ZXDRecommendCell

- (NSMutableArray *)btns
{
    if (!_btns) {
        _btns = [NSMutableArray array];
    }
    return _btns;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        //推荐歌单
        _recommendView = [[[NSBundle mainBundle]loadNibNamed:@"ZXDRecommendView" owner:self options:nil]lastObject];
        [self addSubview:_recommendView];
        //创建6个button
        for (NSInteger i = 0; i < 6; i ++) {
            
            HomeButton * button1 = [HomeButton buttonWithType:UIButtonTypeCustom];
            //设置button的样式
            button1.imageView.layer.cornerRadius = 10;
            button1.imageView.layer.masksToBounds = YES;
            button1.imageView.layer.borderWidth = 1;
            button1.imageView.layer.borderColor = [UIColor redColor].CGColor;
            button1.titleLabel.font = [UIFont systemFontOfSize:13];
            NSInteger index = i;
            button1.tag = index;
            [button1 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            //给一个button增加一个事件  [对象 接收器];
            //内部实现
            self.buttom = button1;
            [self.contentView addSubview:button1];
            [self.btns addObject:button1];
        }
    }
    return self;
}
//设置button的位置
-(void)layoutSubviews
{
    [super layoutSubviews];
    //下面是九宫格的设计
    //给button定位置
    //给每个button设置位置
    _recommendView.frame = CGRectMake(20, 10, 100, 30);
    for (NSInteger i = 0; i < 6; i ++) {
        HomeButton *button = [self.btns objectAtIndex:i];
        NSInteger l = i % 3;
        NSInteger h = i / 3;
        
        NSInteger space = 20;
        // 300 - 2 * 20 =260 /3 = 90
        CGFloat width = (self.frame.size.width - 4 * space) / 3;
        CGFloat height = 120;
        button.frame = CGRectMake(20+(space + width) * l,50 + (space + height) * h, width, height);
    }
}

-(void)setIndexTag:(NSInteger)indexTag
{
    _indexTag = indexTag;
}


//传递数据
-(void)setZxdMusic:(ZXDMusic *)zxdMusic
{
    //为什么会显示最后一个？
    _zxdMusic = zxdMusic;
        HomeButton *button = [self.btns objectAtIndex:_indexTag];
        [button setImage:[UIImage imageNamed:zxdMusic.music_image] forState:UIControlStateNormal];
        [button setTitle:zxdMusic.music_name forState:UIControlStateNormal];
}

#pragma mark - handleButton
- (void)handleButton:(UIButton *)sender{
    if (self.handler) {
        self.handler(sender);
    }
}

-(void)checkAction:(UIButton *)sender
{
    if ([_delegate respondsToSelector:@selector(choseTerm:)]) {
        sender.tag = self.tag;
        [_delegate choseTerm:sender];
    }
}

@end
