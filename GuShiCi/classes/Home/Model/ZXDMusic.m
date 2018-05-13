//
//  ZXDMusic.m
//  GuShiCi
//
//  Created by zxd on 2018/4/9.
//  Copyright © 2018年 zxd. All rights reserved.
//

#import "ZXDMusic.h"

@implementation ZXDMusic

+(NSString *)initWithStr:(NSString *)rank name:(NSString *)musicName
{
    NSString *url = [[NSString alloc] initWithFormat:@"http://7xsool.com2.z0.glb.qiniucdn.com/%@-%@.mp3",rank,musicName];
    return url;
}

+(NSString *)chChangePin:(NSString *)str1;
{
    //  把汉字转换成拼音第一种方法
    NSString *str = [[NSString alloc]initWithFormat:@"%@", str1];
    // NSString 转换成 CFStringRef 型
    CFStringRef string1 = (CFStringRef)CFBridgingRetain(str);
//    NSLog(@"%@", str);
    //  汉字转换成拼音
    CFMutableStringRef string = CFStringCreateMutableCopy(NULL, 0, string1);
    //  拼音（带声调的）
    CFStringTransform(string, NULL, kCFStringTransformMandarinLatin, NO);
//    NSLog(@"%@", string);
    //  去掉声调符号
    CFStringTransform(string, NULL, kCFStringTransformStripDiacritics, NO);
//    NSLog(@"%@", string);
    //  CFStringRef 转换成 NSString
    NSString *strings = (NSString *)CFBridgingRelease(string);
    //  去掉空格
    NSString *cityString = [strings stringByReplacingOccurrencesOfString:@" " withString:@""];
//    NSLog(@"%@", cityString);
    return cityString;
}

//判断文件是否已经在沙盒中已经存在？
-(BOOL) isFileExist:(NSString *)fileName
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *path = [NSString stringWithFormat:@"%@/musicFile",documentsDirectory];

    NSString *filePath = [path stringByAppendingPathComponent:fileName];
        NSLog(@"path:%@",filePath);
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL result = [fileManager fileExistsAtPath:filePath];
    NSLog(@"这个文件已经存在：%@",result?@"是的":@"不存在");
    return result;
}
@end
