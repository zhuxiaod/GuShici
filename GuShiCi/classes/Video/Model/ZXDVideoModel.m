//
//  ZXDVideoModel.m
//  GuShiCi
//
//  Created by zxd on 2018/4/24.
//  Copyright © 2018年 zxd. All rights reserved.
//

#import "ZXDVideoModel.h"

@implementation ZXDVideoModel
+ (instancetype)videoGroupWithDict:(NSDictionary *)dict
{
    ZXDVideoModel *group = [[self alloc] init];
    //    [group setValuesForKeysWithDictionary:dict];
    group.ID = dict[@"id"];
    group.url = dict[@"url"];
    group.name = dict[@"name"]; 
    return group;
}
@end
