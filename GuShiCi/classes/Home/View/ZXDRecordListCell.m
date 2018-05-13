//
//  ZXDRecordListCell.m
//  GuShiCi
//
//  Created by zxd on 2018/4/29.
//  Copyright © 2018年 zxd. All rights reserved.
//

#import "ZXDRecordListCell.h"
#import "ZXDMusic.h"
@interface ZXDRecordListCell()
@property (weak, nonatomic) IBOutlet UIImageView *music_image;
@property (weak, nonatomic) IBOutlet UILabel *music_name;

@end
@implementation ZXDRecordListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(void)setMusic:(ZXDMusic *)Music
{
    _Music = Music;
    _music_image.image = [UIImage imageNamed:Music.music_image];
    _music_name.text = [NSString stringWithFormat:@"%ld. %@",(long)Music.music_id,Music.music_name];
}



@end
