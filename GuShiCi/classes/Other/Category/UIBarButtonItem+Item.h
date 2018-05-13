//
//  UIBarButtonItem+Item.h
//  GuShiCi
//
//  Created by zxd on 2018/3/27.
//  Copyright © 2018年 zxd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIBarButtonItem (Item)


+(UIBarButtonItem *)itemWithImage:(UIImage *)image highImage:(UIImage *)highImage target:(id)target action:(SEL)action;

+(UIBarButtonItem *)backItemWithImage:(UIImage *)image highImage:(UIImage *)highImage target:(id)target action:(SEL)action title:(NSString *)title;

+(UIBarButtonItem *)itemWithTitle:(NSString *)title target:(id)target action:(SEL)action;

@end
