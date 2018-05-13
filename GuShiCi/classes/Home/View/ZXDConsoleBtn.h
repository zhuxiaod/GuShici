//
//  ZXDConsoleBtn.h
//  GuShiCi
//
//  Created by zxd on 2018/4/9.
//  Copyright © 2018年 zxd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZXDConsoleBtn.h"

typedef NS_ENUM(NSInteger,ZXDConsoleBtnType) {
    ZXDConsoleBtnTypePlay,
    ZXDConsoleBtnTypeLast,
    ZXDConsoleBtnTypeNext,
    ZXDConsoleBtnTypePause
};

static CGFloat bigBtnWidth = 60;
static CGFloat smallBtnWidth = 40;

@interface ZXDConsoleBtn : UIButton

@property (nonatomic)ZXDConsoleBtnType consoleType;

-(instancetype)initWithFrame:(CGRect)frame ConsoleType:(ZXDConsoleBtnType)type;
@end
