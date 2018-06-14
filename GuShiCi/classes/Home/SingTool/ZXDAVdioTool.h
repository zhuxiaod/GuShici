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

//@property (nonatomic,strong)AVAudioPlayer *player;

@property (strong, nonatomic)AVAudioPlayer *play;

//+(AVAudioPlayer *)playingMusicWithMusicFileName:(NSString *)filename didComplete:(void(^)(void))complete;
+ (instancetype)sharedPlayManager;

- (void)playMusicWithFileName:(NSString *)fileName didComplete:(void(^)(void))complete;

+(void)pauseMusicWithMusicFileName:(NSString *)filename;

+(void)stopMusicWithMusicFileName:(NSString *)filename;

@end
