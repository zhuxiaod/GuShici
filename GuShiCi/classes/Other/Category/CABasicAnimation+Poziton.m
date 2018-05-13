//
//  CABasicAnimation+Poziton.m
//  GuShiCi
//
//  Created by zxd on 2018/5/12.
//  Copyright © 2018年 zxd. All rights reserved.
//

#import "CABasicAnimation+Poziton.h"

@implementation CABasicAnimation (Poziton)
-(void)createWYAnimation:(CGPoint)from toValue:(CGPoint)toValue duration:(NSTimeInterval)duration objc:(id)objc{
     CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"position"];
    animation.fromValue = [NSValue valueWithCGPoint:CGPointMake(ZXDScreenW/2, ZXDScreenH)];
    animation.toValue = [NSValue valueWithCGPoint:CGPointMake(ZXDScreenW/2, ZXDScreenH/2)];
    animation.duration = 0.3f;
    [objc addAnimation:animation forKey:@"positionAnimation"];
}
@end
