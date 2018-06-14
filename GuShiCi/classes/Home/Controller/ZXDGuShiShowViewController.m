//
//  ZXDGuShiShowViewController.m
//  GuShiCi
//
//  Created by zxd on 2018/5/13.
//  Copyright © 2018年 zxd. All rights reserved.
//

#import "ZXDGuShiShowViewController.h"
#import "ZXDMusic.h"
@interface ZXDGuShiShowViewController ()

@end

@implementation ZXDGuShiShowViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = _music.music_name;
    //设置背景view
    [self setupImageView];
    
    //设置textview
    [self setupTextView];
}

-(void)setupImageView{
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, ZXDScreenW, ZXDScreenH)];
    imageView.image = [UIImage imageNamed:_music.music_bimag];
    imageView.alpha = 0.3;
    [self.view addSubview:imageView];
}
-(void)setupTextView{
    NSError *error;
    UITextView *textView = [[UITextView alloc] initWithFrame:CGRectMake(0, 0, ZXDScreenW, ZXDScreenH)];
    textView.backgroundColor = [UIColor clearColor];
    NSString *txt = [NSString stringWithContentsOfFile:[[NSBundle mainBundle] pathForResource:_music.music_image ofType:@"txt"] encoding:NSUTF8StringEncoding error:&error];
    textView.textColor = [UIColor blackColor];
    textView.text = txt;
    textView.editable = NO;
    textView.selectable = NO;
    textView.textContainerInset = UIEdgeInsetsMake(20, 20, 20, 20);
    textView.font = [UIFont systemFontOfSize:20];
    
    [self.view addSubview:textView];
}
@end
