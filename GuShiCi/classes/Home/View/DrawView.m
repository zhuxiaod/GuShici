//
//  DrawView.m
//  drawDemo
//
//  Created by zxd on 2018/5/3.
//  Copyright © 2018年 zxd. All rights reserved.
//

#import "DrawView.h"
#import "MyBezierPath.h"
// 最小/大宽度
#define kWIDTH_MIN 5
#define kWIDTH_MAX 13

@interface DrawView ()

@property(nonatomic,strong)UIBezierPath *path;

@property(nonatomic,strong)NSMutableArray *allPathArray;

//设置线的宽度
@property(nonatomic,assign)CGFloat width;

// 上一次图片
@property (nonatomic, strong) UIImage *lastImage;
// 设置调试
@property (nonatomic, assign) BOOL debug;
@end

@implementation DrawView

-(NSMutableArray *)allPathArray
{
    if(_allPathArray == nil){
        _allPathArray = [NSMutableArray array];
    }
    return _allPathArray;
}

-(void)awakeFromNib{
    //添加手势
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(pan:)];
    [self addGestureRecognizer:pan];
    
    self.width = 10;
    self.zxdcolor = [UIColor blackColor];
}

//清屏
-(void)clear{
    //情况所有的路径
    [self.allPathArray removeAllObjects];
    //重绘
    [self setNeedsDisplay];
}
////撤销
-(void)undo{
    //删除最后一个路径
    [self.allPathArray removeLastObject];
    //重绘
    [self setNeedsDisplay];
}
//绘制
-(void)reDraw{
    self.allPathArray = nil;
    [self setNeedsDisplay];
}
//有线。然后画了上去
-(void)setZXDNewAllPath:(NSMutableArray *)ZXDNewAllPath
{
    self.allPathArray = ZXDNewAllPath;
    //重绘
    [self setNeedsDisplay];
}
////橡皮擦
-(void)erase{
    [self setLineColor:[UIColor whiteColor]];
}
////设置线的宽度
-(void)setLineWidth:(CGFloat)lineWidth{
    self.width = lineWidth;
}
////设置线的颜色
-(void)setLineColor:(UIColor *)color{
    self.zxdcolor = color;
}

-(void)setImage:(UIImage *)image{
    _image = image;
    //添加图片到数组当中
    [self.allPathArray addObject:image];
    //重绘
    [self setNeedsDisplay];
}
//可以划线了并记录划线
-(void)pan:(UIPanGestureRecognizer *)pan
{
    //获取的当前手指的点
    CGPoint curP = [pan locationInView:self];
    //判断手势的状态
    if(pan.state == UIGestureRecognizerStateBegan){
        //创建路径
        MyBezierPath *path = [MyBezierPath bezierPath];
        self.path = path;
        //设置起点
        [path moveToPoint:curP];
        //设置线的宽度
        [path setLineWidth:self.width];
        //设置线的颜色
        path.color = self.zxdcolor;
        [self.allPathArray addObject:path];
    }else if (pan.state == UIGestureRecognizerStateChanged){
        //绘制一根线到当前手指所在的点
        [self.path addLineToPoint:curP];
        //重绘
        [self setNeedsDisplay];
    }
    if([self.delegate respondsToSelector:@selector(DrawView:allpath:)])
    {
        [self.delegate DrawView:self allpath:self.allPathArray];
    }
}

-(void)drawRect:(CGRect)rect{
    //绘制当前的路径
    for (MyBezierPath *path in self.allPathArray) {
        //判断取出的路径真实类型
        if([path isKindOfClass:[UIImage class]]){
            UIImage *image = (UIImage *)path;
            [image drawInRect:rect];
        }else{
            [path.color set];
            [path stroke];
        }
    }
}


@end
