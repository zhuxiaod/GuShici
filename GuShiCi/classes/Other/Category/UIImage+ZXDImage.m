//
//  UIImage+ZXDImage.m
//  GuShiCi
//
//  Created by zxd on 2018/3/26.
//  Copyright © 2018年 zxd. All rights reserved.
//

#import "UIImage+ZXDImage.h"

@implementation UIImage (ZXDImage)
+(UIImage *)imageOriginalWithName:(NSString *)imageName
{
    UIImage *image = [UIImage imageNamed:imageName];
    return  [image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
}
@end
