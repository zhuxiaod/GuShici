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
    //视频地址
    //视频的图片
    //名字
//    http://bsyvideo.boosj.com/v/2016-06/03/2016-0603CVNC123013461111718243.mp4?start=0&t=jRBZq6YWmizIYzanhVKw-w&m=1526718257&c=m
//    NSString *str = @"http://120.25.226.186:32812/";
    NSString *str2 = [video.image absoluteString];
//    NSString *Str3 = [str stringByAppendingString:str2];
    self.name.text = video.name;
    [self.image sd_setImageWithURL:[NSURL URLWithString:str2]];
}

- (IBAction)addBtnClick:(UIButton *)sender {
    if (self.btnClick) {
        self.btnClick(self);
    }
}

@end
