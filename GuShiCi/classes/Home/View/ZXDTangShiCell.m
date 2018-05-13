//
//  ZXDTangShiCell.m
//  GuShiCi
//
//  Created by zxd on 2018/5/6.
//  Copyright © 2018年 zxd. All rights reserved.
//

#import "ZXDTangShiCell.h"
#import "ZXDTangShi.h"
@interface ZXDTangShiCell()
@property (weak, nonatomic) IBOutlet UILabel *ZXDlabel;


@end

@implementation ZXDTangShiCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(void)setTangShi:(NSDictionary *)tangShi
{
    _tangShi = tangShi;
    NSString *str = [tangShi objectForKey:@"title"];
    _ZXDlabel.text = str;
}
@end
