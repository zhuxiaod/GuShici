//
//  ZXDAVdioTool.m
//  GuShiCi
//
//  Created by zxd on 2018/4/16.
//  Copyright © 2018年 zxd. All rights reserved.
//

#import "ZXDAVdioTool.h"
#import <AVFoundation/AVFoundation.h>
@interface ZXDAVdioTool ()<AVAudioPlayerDelegate>

@property(copy,nonatomic) NSString *fileName;

@property (nonatomic, copy) void(^complete)(void);

@end

@implementation ZXDAVdioTool

static NSMutableDictionary *_players;
+ (instancetype)sharedPlayManager{
    
    static ZXDAVdioTool *_playManager;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        _playManager = [[self alloc]init];
    });
    return _playManager;
}

- (void)playMusicWithFileName:(NSString *)fileName didComplete:(void(^)(void))complete
{
    if (![_fileName isEqualToString:fileName]) {
        // 1.加载资源文件
        NSURL *url = [[NSBundle mainBundle] URLForResource:fileName withExtension:nil];
        // 2.创建播放器
        _play = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:NULL];
        // 3.准备播放
        [_play prepareToPlay];
        
        _play.delegate = self;
        // 赋值
        _fileName = fileName;
        
        _complete = complete;
    }
    
    // 4.播放
    [_play play];
}

+(void)pauseMusicWithMusicFileName:(NSString *)filename
{
    AVAudioPlayer *player = _players[filename];
    if (player) {
        [player pause];
    }
}

+(void)stopMusicWithMusicFileName:(NSString *)filename
{
    AVAudioPlayer *player = _players[filename];
    if (player) {
        [player stop];
        [_players removeObjectForKey:filename];
        player = nil;
    }
}
#pragma mark 代理方法
/// 当歌曲播放完毕时调用
- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag
{
    //  在这里回调block
    self.complete();
}
@end

