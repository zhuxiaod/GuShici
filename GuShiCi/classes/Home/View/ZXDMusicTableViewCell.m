//
//  ZXDMusicTableViewCell.m
//  GuShiCi
//
//  Created by zxd on 2018/4/9.
//  Copyright © 2018年 zxd. All rights reserved.
//

#import "ZXDMusicTableViewCell.h"
#import "ZXDMusic.h"
#import <UIImageView+WebCache.h>
@interface ZXDMusicTableViewCell()

@property (weak, nonatomic) IBOutlet UIImageView *cellImage;

@property (weak, nonatomic) IBOutlet UILabel *musicName;

@property (weak, nonatomic) IBOutlet UILabel *musicSize;
@property (weak, nonatomic) IBOutlet UIImageView *playImage;

@end

@implementation ZXDMusicTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(void)setMusic:(ZXDMusic *)Music
{
    _Music = Music;
    self.cellImage.image = [UIImage imageNamed:Music.music_image];
//    [self.cellImage sd_setImageWithURL:[NSURL URLWithString:Music.music_bimag] placeholderImage:[UIImage imageNamed:@"f6783ab4fc5ec994ea7a83ed380db7f3"] options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize, NSURL * _Nullable targetURL) {
//    } completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
//    }];
//    self.musicSize.text = [NSString stringWithFormat:@"%@",Music.size];
    self.musicName.text = [NSString stringWithFormat:@"%ld. %@",(long)Music.music_id,Music.music_name];
    self.playImage.image = [UIImage imageNamed:@"Downloads"];
}


@end
