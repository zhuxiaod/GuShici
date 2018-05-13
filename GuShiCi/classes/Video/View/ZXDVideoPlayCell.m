//
//  ZXDVideoPlayCell.m
//  GuShiCi
//
//  Created by zxd on 2018/4/25.
//  Copyright © 2018年 zxd. All rights reserved.
//

#import "ZXDVideoPlayCell.h"
#import "ZXDVideoModel.h"

@interface ZXDVideoPlayCell()
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UIImageView *image;
@property (weak, nonatomic) IBOutlet UIButton *btn;

@end

@implementation ZXDVideoPlayCell

-(void)setVideo:(ZXDVideoModel *)video
{
    _video = video;
    NSString *str = @"http://120.25.226.186:32812/";
    NSString *str2 = [video.image absoluteString];
    NSString *Str3 = [str stringByAppendingString:str2];
    self.name.text = video.name;
    [self.image sd_setImageWithURL:[NSURL URLWithString:Str3]];
}

- (IBAction)addBtnClick:(UIButton *)sender {
    if (self.btnClick) {
        self.btnClick(self);
    }
}

@end
