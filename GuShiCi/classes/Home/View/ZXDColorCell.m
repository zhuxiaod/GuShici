//
//  ZXDColorCell.m
//  GuShiCi
//
//  Created by zxd on 2018/5/9.
//  Copyright © 2018年 zxd. All rights reserved.
//

#import "ZXDColorCell.h"
#import "ZXDBallColorModel.h"

@interface ZXDColorCell ()
@property (nonatomic,weak)UIImageView *imageView;
@end
@implementation ZXDColorCell
-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self){
        //设置图像
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0,  CGRectGetWidth(self.frame), CGRectGetWidth(self.frame))];
        self.imageView = imageView;
        [self addSubview:self.imageView];
    }
    return self;
}
@end
