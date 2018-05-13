//
//  ZXDCycleData.m
//  GuShiCi
//
//  Created by zxd on 2018/4/4.
//  Copyright © 2018年 zxd. All rights reserved.
//

#import "ZXDCycleData.h"

@implementation ZXDCycleData
+(instancetype)cycleWithInit:(NSString *)image1 image2:(NSString *)image2 image3:(NSString *)image3 cellHeight:(NSInteger)height
{
    ZXDCycleData *data = [[self alloc] init];
    data.array = [NSArray arrayWithObjects:image1,image2,image3, nil];
    data.cellHeight = height;
    return data;
}

@end
