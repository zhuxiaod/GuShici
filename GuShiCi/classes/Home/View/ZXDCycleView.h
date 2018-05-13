//
//  ZXDCycleView.h
//  GuShiCi
//
//  Created by zxd on 2018/4/4.
//  Copyright © 2018年 zxd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZXDCycleData.h"

@interface ZXDCycleView : UITableViewCell

/** 轮播模型 */
@property (nonatomic, strong) ZXDCycleData *CycleData;

@property (nonatomic, assign) NSTimeInterval cycleViewSecond;

@end
