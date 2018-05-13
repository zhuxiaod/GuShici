//
//  ZXDRecommendCell.h
//  GuShiCi
//
//  Created by zxd on 2018/4/6.
//  Copyright © 2018年 zxd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HomeButton.h"

//添加代理
@protocol ZXDRecommendCellDelegate <NSObject>

-(void)choseTerm:(UIButton *)button;

@end

typedef void(^tapHandler)(UIButton *sender);

@class ZXDRecommendButton;

@interface ZXDRecommendCell : UITableViewCell

@property(nonatomic, strong)HomeButton *buttom;

@property (nonatomic,strong)tapHandler handler;

@property (nonatomic,assign)NSInteger indexTag;

@property (nonatomic,strong)ZXDRecommendButton *recommendButton;
//声明代理
@property (assign,nonatomic)id<ZXDRecommendCellDelegate>delegate;
//按钮组
@property (nonatomic,strong)NSMutableArray * btns;


-(void)didClickButtonCallBlock:(void(^)(UIButton *btn,UITableView *cell))buttonCallBlock;
-(void)checkAction:(UIButton *)sender;

@end
