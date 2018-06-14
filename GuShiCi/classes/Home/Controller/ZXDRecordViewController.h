//
//  ZXDRecordViewController.h
//  GuShiCi
//
//  Created by zxd on 2018/4/25.
//  Copyright © 2018年 zxd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@class ZXDMusic;

@interface ZXDRecordViewController : UIViewController

@property(nonatomic,strong)ZXDMusic *currentmusic;

@property(nonatomic,strong)NSMutableArray *array;

@end
