//
//  ZXDConsoleBtn.m
//  GuShiCi
//
//  Created by zxd on 2018/4/9.
//  Copyright © 2018年 zxd. All rights reserved.
//

#import "ZXDConsoleBtn.h"

#define BUTTON_COLOR   [UIColor colorWithRed:0.27 green:0.73 blue:0.36 alpha:1]
#define DISABLE_COLOR  [UIColor colorWithRed:0.5 green:0.5 blue:0.5 alpha:1]

@interface ZXDConsoleBtn ()

@property(nonatomic,strong)UIColor *btnColor;

@end

@implementation ZXDConsoleBtn

-(instancetype)initWithFrame:(CGRect)frame
{
    return [self initWithFrame:frame ConsoleType:ZXDConsoleBtnTypePlay];
}

-(instancetype)initWithFrame:(CGRect)frame ConsoleType:(ZXDConsoleBtnType)type
{
    if (self=[super initWithFrame:frame]) {
        
        //        for (int i=0; i<4; i++) {
        //            _zColor[i]=enableColor[i];
        //        }
        _btnColor = BUTTON_COLOR;
        
        self.consoleType = type;
        [self cunstomBtnStyle];
    }
    
    return self;
}

-(void)setConsoleType:(ZXDConsoleBtnType)consoleType
{
    if (_consoleType!=consoleType) {
        _consoleType=consoleType;
    }
    
    [self setNeedsDisplay];
}

-(void)cunstomBtnStyle
{
    self.layer.cornerRadius = self.frame.size.width/2;
    self.layer.borderColor = BUTTON_COLOR.CGColor;
    self.layer.borderWidth = 2.0f;
}

#pragma mark - OverRide
-(void)setEnabled:(BOOL)enabled
{
    [super setEnabled:enabled];
    if (self.consoleType == ZXDConsoleBtnTypeLast || self.consoleType == ZXDConsoleBtnTypeNext) {
        [self enabledBtnColor:enabled];
    }
}

-(void)enabledBtnColor:(BOOL)enabled
{
    //    for (int i=0; i<4; i++) {
    //        _zColor[i]=enabled?enableColor[i]:disableColor[i];
    //    }
    _btnColor = enabled ? BUTTON_COLOR : DISABLE_COLOR;
        
    self.layer.borderColor=enabled?BUTTON_COLOR.CGColor:DISABLE_COLOR.CGColor;
    [self setNeedsDisplay];
}
        
#pragma mark - DrawRect
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.

- (void)drawRect:(CGRect)rect { [super drawRect:rect]; CGContextRef context = UIGraphicsGetCurrentContext();
    //获得图形上下文
    // CGContextSetStrokeColor(context, _zColor);
    // CGContextSetFillColor(context, _zColor);
    [_btnColor set];
    //设置颜色
    CGContextSetLineWidth(context, 1.0);
    //设置线宽
    switch (_consoleType) {
        case ZXDConsoleBtnTypePlay:
        [self drawPlayBtnwithContext:context rect:rect];
        break;
        case ZXDConsoleBtnTypeLast:
        [self drawLastBtnwithContext:context rect:rect];
        break;
        case ZXDConsoleBtnTypeNext:
        [self drawNextBtnwithContext:context rect:rect];
        break;
        case ZXDConsoleBtnTypePause:
        [self drawPauseBtnwithContext:context rect:rect];
        break;
        default:
        break;
    }
}

//画一个播放按钮
- (void)drawPlayBtnwithContext:(CGContextRef)context rect:(CGRect)rect
{
    CGPoint sPoints[3];//坐标点
    sPoints[0] =CGPointMake(rect.size.width*0.3+2, rect.size.height*0.3);//坐标1
    sPoints[1] =CGPointMake(rect.size.width*0.3+2, rect.size.height*0.7);//坐标2
    sPoints[2] =CGPointMake(rect.size.width*0.7+2, rect.size.height*0.5);//坐标3
    CGContextAddLines(context, sPoints, 3);//添加线
    CGContextClosePath(context);//封起来
    CGContextDrawPath(context, kCGPathFillStroke); //根据坐标绘制路径
}

//画一个上一首按钮
- (void)drawLastBtnwithContext:(CGContextRef)context rect:(CGRect)rect
{
    CGPoint sPoints[3];//坐标点
    sPoints[0] =CGPointMake(rect.size.width*0.65, rect.size.height*0.65);//坐标1
    sPoints[1] =CGPointMake(rect.size.width*0.65, rect.size.height*0.35);//坐标2
    sPoints[2] =CGPointMake(rect.size.width*0.35, rect.size.height*0.5);//坐标3
    CGContextAddLines(context, sPoints, 3);//添加线
    CGContextClosePath(context);//封起来
    CGContextDrawPath(context, kCGPathFillStroke); //根据坐标绘制路径
    
    CGContextFillRect(context, CGRectMake(rect.size.width*0.35-1, rect.size.height*0.35, 2, rect.size.height*0.3));
}

//画一个下一首按钮
- (void)drawNextBtnwithContext:(CGContextRef)context rect:(CGRect)rect
{
    CGPoint sPoints[3];//坐标点
    sPoints[0] =CGPointMake(rect.size.width*0.35, rect.size.height*0.35);//坐标1
    sPoints[1] =CGPointMake(rect.size.width*0.35, rect.size.height*0.65);//坐标2
    sPoints[2] =CGPointMake(rect.size.width*0.65, rect.size.height*0.5);//坐标3
    CGContextAddLines(context, sPoints, 3);//添加线
    CGContextClosePath(context);//封起来
    CGContextDrawPath(context, kCGPathFillStroke); //根据坐标绘制路径
    
    CGContextFillRect(context, CGRectMake(rect.size.width*0.65-1, rect.size.height*0.35, 2, rect.size.height*0.3));
}
//画一个暂停按钮（两条竖线）
- (void)drawPauseBtnwithContext:(CGContextRef)context rect:(CGRect)rect
{
    CGContextFillRect(context, CGRectMake(rect.size.width*0.3+2, rect.size.height*0.3, 5, rect.size.height*0.4));
    CGContextFillRect(context, CGRectMake(rect.size.width*0.7-7, rect.size.height*0.3, 5, rect.size.height*0.4));
}
@end
