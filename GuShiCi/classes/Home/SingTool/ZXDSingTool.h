//
//  ZXDSingTool.h
//  GuShiCi
//
//  Created by zxd on 2018/4/16.
//  Copyright © 2018年 zxd. All rights reserved.
//

#import <Foundation/Foundation.h>
@class ZXDMusic;
@interface ZXDSingTool : NSObject
//初始化
+(void)initializeWithArray:(NSMutableArray *)Array;

// 获取所有音乐
+(NSMutableArray *)Musics;

// 当前正在播放的音乐
+(ZXDMusic *)playingMusic;

// 设置默认播放的音乐
+(void)setUpPlayingMusic:(ZXDMusic *)playingMusic;

// 返回上一首音乐
+ (ZXDMusic *)previousMusic;

// 返回下一首音乐
+ (ZXDMusic *)nextMusic;
@end
