//
//  ZXDHanZi.h
//  GuShiCi
//
//  Created by zxd on 2018/5/9.
//  Copyright © 2018年 zxd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZXDHanZi : NSObject
//存什么字
@property (nonatomic,copy)NSString *ZXDhanZi;
//存上下文
@property (nonatomic,strong)NSMutableArray *allPath;
@property (nonatomic,strong)UIImage *image;

@end
