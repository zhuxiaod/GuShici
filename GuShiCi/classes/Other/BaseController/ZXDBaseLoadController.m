//
//  ZXDBaseLoadController.m
//  GuShiCi
//
//  Created by zxd on 2018/4/24.
//  Copyright © 2018年 zxd. All rights reserved.
//

#import "ZXDBaseLoadController.h"

@interface ZXDBaseLoadController ()

@end

@implementation ZXDBaseLoadController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

#pragma mark - 加载框
- (void)showLoading
{
    [MBProgressHUD showProgressToView:self.view Text:@"加载中..."];
}

- (void)dismissLoading
{
    [MBProgressHUD hideHUDForView:self.view];
}

@end
