//
//  ZXDSetupView.h
//  GuShiCi
//
//  Created by zxd on 2018/5/10.
//  Copyright © 2018年 zxd. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ZXDSetupView;
@protocol ZXDSetupViewDelegate <NSObject>
@optional
-(void)ZXDSetupView1:(ZXDSetupView *)ZXDSetupView slider1:(UISlider *)slider;
-(void)ZXDSetupView2:(ZXDSetupView *)ZXDSetupView slider2:(UISlider *)slider2;
-(void)ZXDSetupView:(ZXDSetupView *)ZXDSetupView btn:(UIButton *)btn;

@end

@interface ZXDSetupView : UIView
@property (nonatomic, weak) id<ZXDSetupViewDelegate>delegate;

+(instancetype)ZXDSetupView;
@end
