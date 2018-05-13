//
//  ZXDConsoleView.m
//  GuShiCi
//
//  Created by zxd on 2018/4/9.
//  Copyright © 2018年 zxd. All rights reserved.
//

#import "ZXDConsoleView.h"

@interface ZXDConsoleView ()

@property(nonatomic,weak) id target;
@property(nonatomic,assign) SEL action;

@end


@implementation ZXDConsoleView

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self=[super initWithFrame:frame]) {
        [self createButtons];
    }
    
    return self;
}

-(void)setConsoleBtnEnabled:(BOOL)consoleBtnEnabled
{
    if (_consoleBtnEnabled != consoleBtnEnabled) {
        _consoleBtnEnabled = consoleBtnEnabled;
    }
    
    _lastBtn.enabled=_consoleBtnEnabled;
    _playBtn.enabled=_consoleBtnEnabled;
    _nextBtn.enabled=_consoleBtnEnabled;
}

-(void)createButtons
{
    CGSize cSize=self.bounds.size;

    _lastBtn=[[ZXDConsoleBtn alloc] initWithFrame:CGRectMake(10, (cSize.height-smallBtnWidth)/2, smallBtnWidth, smallBtnWidth) ConsoleType:ZXDConsoleBtnTypeLast];
    [_lastBtn addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_lastBtn];
    
    _playBtn=[[ZXDConsoleBtn alloc] initWithFrame:CGRectMake((cSize.width-bigBtnWidth)/2, (cSize.height-bigBtnWidth)/2, bigBtnWidth, bigBtnWidth) ConsoleType:ZXDConsoleBtnTypePlay];
    [_playBtn addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_playBtn];
    
    _nextBtn=[[ZXDConsoleBtn alloc] initWithFrame:CGRectMake(cSize.width-10-smallBtnWidth, (cSize.height-smallBtnWidth)/2, smallBtnWidth, smallBtnWidth) ConsoleType:ZXDConsoleBtnTypeNext];
    [_nextBtn addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_nextBtn];
}

-(void)btnClicked:(UIButton *)sender
{
    [self.target performSelector:self.action withObject:sender afterDelay:0];
}

-(void)addTarget:(id)target action:(SEL)action
{
    self.target = target;
    self.action = action;
}
@end
