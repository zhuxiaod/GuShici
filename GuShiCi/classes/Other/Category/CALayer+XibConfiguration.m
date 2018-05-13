//
//  CALayer+XibConfiguration.m
//  GuShiCi
//
//  Created by zxd on 2018/5/5.
//  Copyright © 2018年 zxd. All rights reserved.
//

#import "CALayer+XibConfiguration.h"

@implementation CALayer (XibConfiguration)

-(void)setBorderUIColor:(UIColor*)color

{
    
    self.borderColor = color.CGColor;
    
}

-(UIColor*)borderUIColor

{
    
    return [UIColor colorWithCGColor:self.borderColor];
    
}



@end

