//
//  ZXDHanZiCell.m
//  GuShiCi
//
//  Created by zxd on 2018/5/12.
//  Copyright © 2018年 zxd. All rights reserved.
//

#import "ZXDHanZiCell.h"
@interface ZXDHanZiCell()
@property (weak, nonatomic) IBOutlet UIImageView *cellImage;

@end

@implementation ZXDHanZiCell

-(void)setImage:(UIImage *)image
{
    _image = image;
    _cellImage.image = image;
}
@end
