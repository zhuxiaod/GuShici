//
//  ZXDAVdioTool.h
//  GuShiCi
//
//  Created by zxd on 2018/4/16.
//  Copyright © 2018年 zxd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

@interface ZXDAVdioTool : NSObject

@property (nonatomic,strong)AVAudioPlayer *player;

+(AVAudioPlayer *)playingMusicWithMusicFileName:(NSString *)filename;

+(void)pauseMusicWithMusicFileName:(NSString *)filename;

+(void)stopMusicWithMusicFileName:(NSString *)filename;

@end
