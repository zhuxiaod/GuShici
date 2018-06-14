//
//  ZXDMusic.h
//  GuShiCi
//
//  Created by zxd on 2018/4/9.
//  Copyright © 2018年 zxd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZXDMusic : NSObject

/** 图片url */
@property (nonatomic, copy) NSString *img_url;

/** 名字 */
@property (nonatomic, copy) NSString *story_name;

/** 大小 */
@property (nonatomic, copy) NSString *size;

/** 音乐url */
@property (nonatomic, copy) NSString *music_url;
@property (nonatomic, copy) NSString *filename;
@property (nonatomic, assign) NSInteger story_id;

//标题
@property (nonatomic, copy) NSString *music_name;
//id
@property (nonatomic, assign) NSInteger music_id;
//缩略图
@property (nonatomic, copy) NSString *music_image;
//背景图
@property (nonatomic, copy) NSString *music_bimag;
//音频
@property (nonatomic, copy) NSString *music_fl;

+(NSString *)initWithStr:(NSString *)rank name:(NSString *)musicName;

+(NSString *)chChangePin:(NSString *)str1;

-(BOOL) isFileExist:(NSString *)fileName;
@end
