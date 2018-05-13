//
//  ZXDMeViewController.m
//  GuShiCi
//
//  Created by zxd on 2018/3/25.
//  Copyright © 2018年 zxd. All rights reserved.
//

#import "ZXDMeViewController.h"

@interface ZXDMeViewController ()

@end

@implementation ZXDMeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blueColor];
    [self setupNavBar];

}

-(void)setupNavBar
{
    self.navigationItem.title = @"我";
    
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
