//
//  ZXDAVdioTool.m
//  GuShiCi
//
//  Created by zxd on 2018/4/16.
//  Copyright © 2018年 zxd. All rights reserved.
//

#import "ZXDAVdioTool.h"
#import <AVFoundation/AVFoundation.h>
@interface ZXDAVdioTool ()
@end

@implementation ZXDAVdioTool

static NSMutableDictionary *_players;

//初始化播放器
+(void)initialize
{
    _players = [NSMutableDictionary dictionary];
}

//根据参数文件名找到文件路径并根据文件路径创建播放器player
+(AVAudioPlayer *)playingMusicWithMusicFileName:(NSString *)filename
{
    AVAudioPlayer *player = nil;
//    self.avplayers = player;
    //players为nil
    player = _players[filename];
    if (player == nil) {
        // 文件路径转化为url
        NSString *pathDocuments = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)objectAtIndex:0];
        NSString *createPath = [NSString stringWithFormat:@"%@/musicFile/%@",pathDocuments,filename];
        NSLog(@"createPath:%@",createPath);
        NSURL *url = [NSURL URLWithString:createPath];
        if (url == nil) {
            NSLog(@"url为空");
            return nil;
        }
        NSError *error;
        // 创建player
        player = [[AVAudioPlayer alloc]initWithContentsOfURL:url error:&error];
        NSLog(@"error:%@",error);
        // 准备播放
        [player prepareToPlay];
        // 将播放器存储到字典中
        [_players setObject:player forKey:filename];
    }
    // 开始播放
    [player play];
    return player;
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
@end

