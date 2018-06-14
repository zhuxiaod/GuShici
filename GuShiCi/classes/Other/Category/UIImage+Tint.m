//
//  UIImage+Tint.m
//  GuShiCi
//
//  Created by zxd on 2018/5/17.
//  Copyright © 2018年 zxd. All rights reserved.
//

#import "UIImage+Tint.h"

@implementation UIImage (Tint)
- (UIImage *)imageWithTintColor:(UIColor *)tintColor {
    UIGraphicsBeginImageContextWithOptions(self.size, NO, self.scale);
    CGRect drawRect = CGRectMake(0, 0, self.size.width, self.size.height);
    [self drawInRect:drawRect];
    [tintColor set];
    UIRectFillUsingBlendMode(drawRect, kCGBlendModeSourceAtop);
    UIImage *tintedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return tintedImage;
}
@end
