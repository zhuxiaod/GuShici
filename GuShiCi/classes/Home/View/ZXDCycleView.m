//
//  ZXDCycleView.m
//  GuShiCi
//
//  Created by zxd on 2018/4/4.
//  Copyright © 2018年 zxd. All rights reserved.
//

#import "ZXDCycleView.h"
#import "MYCycleView.h"
#import <SystemConfiguration/CaptiveNetwork.h>
#import <NetworkExtension/NetworkExtension.h>

@interface ZXDCycleView ()

@property (strong, nonatomic) IBOutlet MYCycleView *cycleView;


@end

@implementation ZXDCycleView

//设置子控件的数据
//启动轮播
-(void)setCycleData:(ZXDCycleData *)CycleData
{
    _CycleData = CycleData;
    [self initWithCycleView:_CycleData.cellHeight cycleViewSecond:3 cycImageArray:_CycleData.array];

    //启动正常 没有问题   调用2次
    //停止
}

//关闭轮播
-(void)setCycleViewSecond:(NSTimeInterval)cycleViewSecond
{
    [self initWithCycleView:_CycleData.cellHeight cycleViewSecond:0 cycImageArray:_CycleData.array];
}

//获取mac的地址
- (NSString *)macAddress {
    NSArray *ifs = CFBridgingRelease(CNCopySupportedInterfaces());
    id info = nil;
    for (NSString *ifnames in ifs) {
        info = (__bridge_transfer id)CNCopyCurrentNetworkInfo((CFStringRef)ifnames);
        if (info && [info count]) {
            break;
        }
    }
    NSDictionary *dict = (NSDictionary *)info;
    NSString *ssid = [[dict objectForKey:@"SSID"] lowercaseString];
    NSString *bssid = [dict objectForKey:@"BSSID"];
//    NSLog(@"%@--%@",ssid,bssid);
    return bssid;
}

//轮播实现
-(void)initWithCycleView:(CGFloat)cycCellHeight cycleViewSecond:(NSTimeInterval)cycleViewSecond cycImageArray:(NSArray *)imageArray
{
    if (!_cycleView) {
//        NSLog(@"我来了");
        self.cycleView = [[MYCycleView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width,cycCellHeight)];
        _cycleView.second = cycleViewSecond;
        _cycleView.imageArray = imageArray;
        //应该暴露在外面 给控制器使用
        _cycleView.bannerClick = ^(NSInteger index) {
            NSLog(@"点击了%zd",index);
            
        };
        [self addSubview:self.cycleView];
    }
    else{
        _cycleView.second = cycleViewSecond;
    }
}
@end
