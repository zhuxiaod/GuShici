//
//  ZXDConsoleView.h
//  GuShiCi
//
//  Created by zxd on 2018/4/9.
//  Copyright © 2018年 zxd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZXDConsoleBtn.h"

@class ZXDConsoleBtn;

@interface ZXDConsoleView : UIView

@property(nonatomic,strong)ZXDConsoleBtn *lastBtn;
@property(nonatomic,strong)ZXDConsoleBtn *playBtn;
@property(nonatomic,strong)ZXDConsoleBtn *nextBtn;

@property(nonatomic) BOOL consoleBtnEnabled;

//传递button事件
-(void)addTarget:(id)target action:(SEL)action;

@end
