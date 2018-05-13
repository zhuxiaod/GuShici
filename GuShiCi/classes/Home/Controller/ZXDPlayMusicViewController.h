//
//  ZXDPlayMusicViewController.h
//  GuShiCi
//
//  Created by zxd on 2018/4/9.
//  Copyright © 2018年 zxd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZXDMusic.h"
@interface ZXDPlayMusicViewController : UIViewController

@property(nonatomic,strong)ZXDMusic *currentmusic;

@property (nonatomic, strong) NSMutableArray *dataArr;

@end
