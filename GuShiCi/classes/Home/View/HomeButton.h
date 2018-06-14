//
//  HomeButton.h
//  GuShiCi
//
//  Created by zxd on 2018/4/5.
//  Copyright © 2018年 zxd. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^tapHandler)(UIButton *sender);
@interface HomeButton : UIButton

@property (nonatomic,strong)tapHandler handler;
@property (nonatomic,assign)int value;



@property (nonatomic, copy) NSString *tittle;

@property (nonatomic, strong) UIColor *titleColor;

@property (nonatomic, assign) CGFloat titleFont;

@property (nonatomic) NSTextAlignment *textAlignment;

@property (nonatomic, strong) UIImage *btnImage;

@property (nonatomic, assign) UIViewContentMode *imageViewContentMode;

+ (instancetype)buttonWithType:(UIButtonType)buttonType frame:(CGRect)frame title:(NSString *)title titleColor:(UIColor *)titleColor titleFont:(CGFloat)font textAlignment:(NSTextAlignment)textAlignment image:(UIImage *)image imageViewContentMode:(UIViewContentMode)imageViewContentMode handler:(tapHandler)handler;

@end
