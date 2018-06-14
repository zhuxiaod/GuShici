//
//  ZXDHelpViewController.m
//  GuShiCi
//
//  Created by zxd on 2018/5/17.
//  Copyright © 2018年 zxd. All rights reserved.
//

#import "ZXDHelpViewController.h"

@interface ZXDHelpViewController ()

@end

@implementation ZXDHelpViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    UITextView *textView = [[UITextView alloc] initWithFrame:CGRectMake(10, 10, ZXDScreenW - 20, ZXDScreenH - 60)];
    [self.view addSubview:textView];
    NSString *str1 = @"此功能尚未开启...\n";
    NSMutableAttributedString *mutableAttriteStr = [[NSMutableAttributedString alloc]init];
    NSAttributedString *attributeStr1 = [[NSAttributedString alloc] initWithString:str1 attributes:@{NSFontAttributeName :[UIFont fontWithName:@"futura" size:20],NSForegroundColorAttributeName : [UIColor blackColor]}];
    [mutableAttriteStr appendAttributedString:attributeStr1];
    textView.attributedText = mutableAttriteStr;
}


@end
