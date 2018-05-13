//
//  HomeButton.m
//  GuShiCi
//
//  Created by zxd on 2018/4/5.
//  Copyright © 2018年 zxd. All rights reserved.
//

#import "HomeButton.h"

#define kTitleRatio 0.28

@implementation HomeButton

+ (instancetype)buttonWithType:(UIButtonType)buttonType frame: (CGRect)frame title:(NSString *)title titleColor:(UIColor *)titleColor titleFont:(CGFloat)font textAlignment:(NSTextAlignment)textAlignment image:(UIImage *)image imageViewContentMode:(UIViewContentMode)imageViewContentMode handler:(tapHandler)handler
{
    //button的类型
    HomeButton *button = [super buttonWithType:buttonType];
    //button的frame
    button.frame = frame;
    //文字居中
    button.titleLabel.textAlignment = textAlignment;
    //文字大小
    button.titleLabel.font = [UIFont systemFontOfSize:font];
    //文字颜色
    [button setTitleColor:titleColor forState:UIControlStateNormal];
    //图片填充的内容模式
    button.imageView.contentMode = imageViewContentMode;
    //button的title
    [button setTitle:title forState:UIControlStateNormal];
    //button的image
    [button setImage:image forState:UIControlStateNormal];
    //button的点击事件
    button.handler = handler;
    [button addTarget:button action:@selector(handleButton:) forControlEvents:UIControlEventTouchUpInside];
    return button;
    
    
}
    
#pragma mark - handleButton
- (void)handleButton:(UIButton *)sender{
    if (self.handler) {
        self.handler(sender);
    }
}

#pragma mark - 调整内部ImageView的frame --
- (CGRect)imageRectForContentRect:(CGRect)contentRect{
    CGFloat imageX = 0;
    CGFloat imageY = 0;
    CGFloat imageWidth = contentRect.size.width;
    //110 * x = 80
    CGFloat imageHeight = contentRect.size.height * (1 - kTitleRatio);
//    NSLog(@"%f",contentRect.size.height);
    return CGRectMake(imageX, imageY, imageWidth, imageHeight);
}
#pragma mark - 调整内部UIlable的frame
- (CGRect)titleRectForContentRect:(CGRect)contentRect{
    CGFloat titleX = 0;
    CGFloat titleHeight = contentRect.size.height - contentRect.size.height * (1 - kTitleRatio);
    //减与图片相近
    CGFloat titleY = contentRect.size.height - titleHeight;
    CGFloat titleWidth = contentRect.size.width;
    return CGRectMake(titleX, titleY, titleWidth, titleHeight);
}



@end
