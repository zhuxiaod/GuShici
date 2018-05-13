//
//  ZXDTitleView.h
//  GuShiCi
//
//  Created by zxd on 2018/4/9.
//  Copyright © 2018年 zxd. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ZXDMusic;
@interface ZXDTitleView : UIView

@property(nonatomic,copy)NSDictionary *titleDict;

@property(nonatomic,strong)ZXDMusic *singModel;
@end
