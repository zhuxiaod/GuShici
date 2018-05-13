//
//  ZXDMusicDataBaseTool.h
//  GuShiCi
//
//  Created by zxd on 2018/4/29.
//  Copyright © 2018年 zxd. All rights reserved.
//

#import <Foundation/Foundation.h>
@class ZXDMusic;
@interface ZXDMusicDataBaseTool : NSObject

//添加音乐
+ (BOOL)addMusic:(ZXDMusic *)music;
//获取所有的学生
+ (NSArray *)musics;

@end
