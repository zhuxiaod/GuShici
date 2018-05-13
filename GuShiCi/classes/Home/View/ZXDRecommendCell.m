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

@interface ZXDRecommendCell ()



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

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
//
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        //创建6个button
        for (NSInteger i = 0; i < 6; i ++) {
            
            HomeButton * button1 = [HomeButton buttonWithType:UIButtonTypeCustom];
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
    for (NSInteger i = 0; i < 6; i ++) {
        HomeButton *button = [self.btns objectAtIndex:i];
        NSInteger l = i % 3;
        NSInteger h = i / 3;
        
        NSInteger space = 20;
        // 300 - 2 * 20 =260 /3 = 90
        CGFloat width = (self.frame.size.width - 2 * space) / 3;
        CGFloat height = 150;
        button.frame = CGRectMake((space + width) * l,20 + (space + height) * h, width, height);
    }
}

-(void)setIndexTag:(NSInteger)indexTag
{
    _indexTag = indexTag;
}


//传递数据
-(void)setRecommendButton:(ZXDRecommendButton *)recommendButton
{
    //为什么会显示最后一个？
    _recommendButton = recommendButton;

        HomeButton *button = [self.btns objectAtIndex:_indexTag];
//         NSLog(@"内存地址1：%p", button);
        NSLog(@"%p------%@",button,recommendButton.btnTittle);
        //地址不同。说明数据有问题
        //数据也不同 这是为什么？
        //数据被覆盖了
//        if (recommendButton.btnImage == nil && recommendButton.btnTittle == nil) {
            [button setImage:[UIImage imageNamed:recommendButton.btnImage] forState:UIControlStateNormal];
            [button setTitle:recommendButton.btnTittle forState:UIControlStateNormal];
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
