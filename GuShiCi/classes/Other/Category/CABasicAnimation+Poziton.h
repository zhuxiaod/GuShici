//
//  CABasicAnimation+Poziton.h
//  GuShiCi
//
//  Created by zxd on 2018/5/12.
//  Copyright © 2018年 zxd. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

@interface CABasicAnimation (Poziton)

-(void)createWYAnimation:(CGPoint)from toValue:(CGPoint)toValue duration:(NSTimeInterval)duration objc:(id)objc;
@end
