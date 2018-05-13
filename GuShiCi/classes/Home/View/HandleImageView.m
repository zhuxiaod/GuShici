//
//  HandleImageView.m
//  drawDemo
//
//  Created by zxd on 2018/5/4.
//  Copyright © 2018年 zxd. All rights reserved.
//

#import "HandleImageView.h"

@interface HandleImageView()<UIGestureRecognizerDelegate>

@property(nonatomic,weak)UIImageView *imageV;

@end

@implementation HandleImageView

-(UIImageView *)imageV{
    
    if(_imageV == nil){
        UIImageView *imageV = [[UIImageView alloc] init];
        imageV.frame = self.bounds;
        imageV.userInteractionEnabled = YES;
        _imageV = imageV;
        [self addSubview:imageV];
        //添加手势
        [self addGes];
    }
    return _imageV;
}

-(void)setImage:(UIImage *)image{
    _image = image;
    self.imageV.image = image;
}

//添加手势
-(void)addGes{
    
    //拖拽手势
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(pan:)];
    [self.imageV addGestureRecognizer:pan];
    
    //捏合
    UIPinchGestureRecognizer *pinch = [[UIPinchGestureRecognizer alloc]initWithTarget:self action:@selector(pinch:)];
    pinch.delegate = self;
    [self.imageV addGestureRecognizer:pinch];
    
    //添加旋转
    UIRotationGestureRecognizer *rotation = [[UIRotationGestureRecognizer alloc] initWithTarget:self action:@selector(rotation:)];
    [self.imageV addGestureRecognizer:rotation];
    
    //长按手势
    UILongPressGestureRecognizer *longPree = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longPress:)];
    [self.imageV addGestureRecognizer:longPree];
}

//拖动的时候调用
-(void)pan:(UIPanGestureRecognizer *)pan{
    
    CGPoint transP = [pan translationInView:pan.view];
    pan.view.transform = CGAffineTransformTranslate(pan.view.transform, transP.x, transP.y);
    //复位
    [pan setTranslation:CGPointZero  inView:pan.view];
}

//捏合的时候调用
-(void)pinch:(UIPinchGestureRecognizer *)pinch{
    
    pinch.view.transform = CGAffineTransformScale(pinch.view.transform, pinch.scale, pinch.scale);
    //复位
    pinch.scale = 1;
}

//旋转的时候调用
-(void)rotation:(UIRotationGestureRecognizer *)rotation{
    //旋转图片
    rotation.view.transform = CGAffineTransformRotate(rotation.view.transform, rotation.rotation);
    
    //复位，只要相当于上一次旋转就复位
    rotation.rotation = 0;
}

//长按的时候调用
-(void)longPress:(UILongPressGestureRecognizer *)longPress{
    
    if(longPress.state == UIGestureRecognizerStateBegan){
        
        [UIView animateWithDuration:0.25 animations:^{
            //设置为透明
            self.imageV.alpha = 0;
        }completion:^(BOOL finished) {
            [UIView animateWithDuration:0.25 animations:^{
                self.imageV.alpha = 1;
                
                //把当前的view做一个截屏
                UIGraphicsBeginImageContextWithOptions(self.bounds.size, NO, 0);
                //获取上下文
                CGContextRef ctx = UIGraphicsGetCurrentContext();
                [self.layer renderInContext:ctx];
                UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
                //关闭上下文
                UIGraphicsEndImageContext();
                
                //调用代理方法
                if([self.delegate respondsToSelector:@selector(handleImageView:newImage:)]){
                    [self.delegate handleImageView:self newImage:newImage];
                    
                }
                
                //从父控件当中移除
                [self removeFromSuperview];
            }];
            }
        ];
    }
}


//能够同时支持多个手势
-(BOOL)gestureRecognizer:(nonnull UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(nonnull UIGestureRecognizer *)otherGestureRecognizer{
    
    return YES;
}






@end
