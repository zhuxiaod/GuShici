//
//  ZXDColorSelectedView.h
//  GuShiCi
//
//  Created by zxd on 2018/5/9.
//  Copyright © 2018年 zxd. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ZXDColorSelectedView;
@protocol ZXDColorSelectedViewDelegate<NSObject>
@optional
-(void)ZXDColorSelectedView:(ZXDColorSelectedView *)ZXDColorSelectedView selectColor:(UIColor *)selectColor;
@end

@interface ZXDColorSelectedView : UIView

@property (nonatomic, weak) id<ZXDColorSelectedViewDelegate>delegate;

@end
