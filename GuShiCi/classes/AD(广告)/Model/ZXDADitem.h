//
//  ZXDADitem.h
//  GuShiCi
//
//  Created by zxd on 2018/3/28.
//  Copyright © 2018年 zxd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
//w_picurl,ori_curl,w,h
@interface ZXDADitem : NSObject
//广告图片的地址
@property(nonatomic,strong)NSString *w_picurl;
//跳转广告的地址
@property(nonatomic,strong)NSString *ori_curl;
//width
@property(nonatomic,assign) CGFloat w;
//height
@property(nonatomic,assign) CGFloat h;

@end
