//
//  ZXDDiscView.h
//  GuShiCi
//
//  Created by zxd on 2018/4/9.
//  Copyright © 2018年 zxd. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol DiscViewDelegate <NSObject>

- (void)changeDiscDidStart;
- (void)changeDiscDidFinish;

@end

@interface ZXDDiscView : UIView

@property (nonatomic,assign) BOOL switchRotate;  //播放暂停状态开关
@property (nonatomic,weak) id <DiscViewDelegate> delegate;

- (void)takeOutDiscAnim;
- (void)takeInDiscAnim;
- (void)disc_setImageWithUrl:(NSURL *)url;
- (void)disc_setImageWithImage:(UIImage *)image;

@end
