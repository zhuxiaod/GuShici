//
//  BtnCell.m
//  GuShiCi
//
//  Created by zxd on 2018/4/30.
//  Copyright © 2018年 zxd. All rights reserved.
//

#import "BtnCell.h"
#import "ZXDRecommendButton.h"
@interface BtnCell()

@property (weak, nonatomic) IBOutlet UILabel *ZXDlabel;


@end
@implementation BtnCell

- (void)awakeFromNib {
    [super awakeFromNib];
    //设置cell的圆角
    //2.0是圆角的弧度，根据需求自己更改
    self.layer.cornerRadius = 5.0;
}
-(void)setSelected:(BOOL)selected
{
    [super setSelected:selected];
    if (selected == YES) {
        [self addBorderProperty];
    }else{
        [self deleteBorderProperty];
    }
    
}
-(void)addBorderProperty
{
    self.layer.borderColor = [UIColor whiteColor].CGColor;
    self.layer.borderWidth = 2;
}
-(void)deleteBorderProperty
{
    self.layer.borderColor = nil;
    self.layer.borderWidth = 0;
}
@end
