//
//  DrawView.h
//  drawDemo
//
//  Created by zxd on 2018/5/3.
//  Copyright © 2018年 zxd. All rights reserved.
//

#import <UIKit/UIKit.h>
@class DrawView;
@protocol DrawViewDelegate <NSObject>
@optional
-(void)DrawView:(DrawView *)DrawView allpath:(NSMutableArray *)allpath;
@end
@interface DrawView : UIView
//设置线的颜色
@property(nonatomic,strong)UIColor *zxdcolor;
@property (nonatomic,strong)UIImage *image;
@property (nonatomic,strong)NSMutableArray *ZXDNewAllPath;
@property (nonatomic,weak) id<DrawViewDelegate> delegate;

//清屏
-(void)clear;
//撤销
-(void)undo;
//橡皮擦
-(void)erase;
//设置线的宽度
-(void)setLineWidth:(CGFloat)lineWidth;
//设置线的颜色
-(void)setLineColor:(UIColor *)color;
//绘制
-(void)reDraw;

@end
