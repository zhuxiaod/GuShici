//
//  ZXDSingTool.m
//  GuShiCi
//
//  Created by zxd on 2018/4/16.
//  Copyright © 2018年 zxd. All rights reserved.
//

#import "ZXDSingTool.h"
#import "ZXDMusic.h"
#import "MJExtension.h"
@implementation ZXDSingTool


static NSMutableArray *_musics;
static ZXDMusic *_playingMusic;

// 类加载的时候初始化音乐列表和播放音乐
//数据源
+(void)initializeWithArray:(NSMutableArray *)Array;
{
    if (_musics == nil) {
        _musics = Array;
    }
    if (_playingMusic == nil) {
        //默认音乐
        _playingMusic = _musics[4];
    }
}

// 获取所有音乐
+(NSMutableArray *)Musics
{
    return _musics;
}

// 当前正在播放的音乐
+(ZXDMusic *)playingMusic
{
    return _playingMusic;
}

// 设置默认播放的音乐
+(void)setUpPlayingMusic:(ZXDMusic *)playingMusic
{
    _playingMusic = playingMusic;
}

// 返回上一首音乐
+ (ZXDMusic *)previousMusic
{
    NSInteger index = [_musics indexOfObject:_playingMusic];
    
    //    index -= 1;
    //    if (index < 0) {
    //        index = _musics.count - 1;
    //    }
    //    CLMusicModel *previousMusic = _musics[index];
    
    if (index == 0) {
        index = _musics.count -1;
    }else{
        index = index -1;
    }
    ZXDMusic *previousMusic = _musics[index];
    return previousMusic;
}

// 返回下一首音乐
+ (ZXDMusic *)nextMusic
{
    NSInteger index = [_musics indexOfObject:_playingMusic];
    if (index == _musics.count - 1) {
        index = 0;
    }else{
        index = index +1;
    }
    ZXDMusic *previousMusic = _musics[index];
    return previousMusic;
}

@end
