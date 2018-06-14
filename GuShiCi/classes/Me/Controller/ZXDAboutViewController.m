//
//  ZXDAboutViewController.m
//  GuShiCi
//
//  Created by zxd on 2018/5/17.
//  Copyright © 2018年 zxd. All rights reserved.
//

#import "ZXDAboutViewController.h"

@interface ZXDAboutViewController ()

@end

@implementation ZXDAboutViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    UITextView *textView = [[UITextView alloc] initWithFrame:CGRectMake(10, 10, ZXDScreenW - 20, ZXDScreenH - 60)];
    [self.view addSubview:textView];
    NSString *str1 = @"免责声明\n";
    NSString *str2 = @"本应用自身不提供任何视频内容,所有内容均系搜索引擎技术从第三方站点搜索所得,请勿用于商业用途\n\n";
    NSString *str3 = @"关于本应用\n";
    NSString *str4 = @"本应用为用户提供快速的学习通道,通过本应用,用户可以方便的把各大学习网站的优质资源一网打尽。本应用为用户提供了轻松便捷的观看入口,打造了优质流畅的观影体验。\n\n";
    NSString *str5 = @"版权问题\n";
    NSString *str6 = @"如果您发现本应用有侵犯你权益的内容,请及时发送邮件到zhuxiaod_183202114@qq.com进行反馈！我们会及时进行处理。\n\n";
    NSString *str7 = @"反馈\n";
    NSString *str8 = @"如果您对本应用有任何的意见或建议,诚恳的希望您能通过邮件的方式告诉我们。我们会认真对待每一个反馈并及时改正我们的不足。\n\n";
    NSMutableAttributedString *mutableAttriteStr = [[NSMutableAttributedString alloc]init];
    NSAttributedString *attributeStr1 = [[NSAttributedString alloc] initWithString:str1 attributes:@{NSFontAttributeName :[UIFont fontWithName:@"futura" size:20],NSForegroundColorAttributeName : [UIColor blackColor]}];
    NSAttributedString *attributeStr2 = [[NSAttributedString alloc] initWithString:str2 attributes:@{NSFontAttributeName :[UIFont fontWithName:@"futura" size:15],NSForegroundColorAttributeName : [UIColor blackColor]}];
    NSAttributedString *attributeStr3 = [[NSAttributedString alloc] initWithString:str3 attributes:@{NSFontAttributeName :[UIFont fontWithName:@"futura" size:20],NSForegroundColorAttributeName : [UIColor blackColor]}];
    NSAttributedString *attributeStr4 = [[NSAttributedString alloc] initWithString:str4 attributes:@{NSFontAttributeName :[UIFont fontWithName:@"futura" size:15],NSForegroundColorAttributeName : [UIColor blackColor]}];
    NSAttributedString *attributeStr5 = [[NSAttributedString alloc] initWithString:str5 attributes:@{NSFontAttributeName :[UIFont fontWithName:@"futura" size:20],NSForegroundColorAttributeName : [UIColor blackColor]}];
    NSAttributedString *attributeStr6 = [[NSAttributedString alloc] initWithString:str6 attributes:@{NSFontAttributeName :[UIFont fontWithName:@"futura" size:15],NSForegroundColorAttributeName : [UIColor blackColor]}];
    NSAttributedString *attributeStr7 = [[NSAttributedString alloc] initWithString:str7 attributes:@{NSFontAttributeName :[UIFont fontWithName:@"futura" size:20],NSForegroundColorAttributeName : [UIColor blackColor]}];
    NSAttributedString *attributeStr8 = [[NSAttributedString alloc] initWithString:str8 attributes:@{NSFontAttributeName :[UIFont fontWithName:@"futura" size:15],NSForegroundColorAttributeName : [UIColor blackColor]}];

    [mutableAttriteStr appendAttributedString:attributeStr1];
    [mutableAttriteStr appendAttributedString:attributeStr2];
    [mutableAttriteStr appendAttributedString:attributeStr3];
    [mutableAttriteStr appendAttributedString:attributeStr4];
    [mutableAttriteStr appendAttributedString:attributeStr5];
    [mutableAttriteStr appendAttributedString:attributeStr6];
    [mutableAttriteStr appendAttributedString:attributeStr7];
    [mutableAttriteStr appendAttributedString:attributeStr8];
    textView.attributedText = mutableAttriteStr;
}

@end
