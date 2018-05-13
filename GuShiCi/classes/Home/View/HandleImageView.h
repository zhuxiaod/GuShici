//
//  HandleImageView.h
//  drawDemo
//
//  Created by zxd on 2018/5/4.
//  Copyright © 2018年 zxd. All rights reserved.
//

#import <UIKit/UIKit.h>
@class HandleImageView;
@protocol handleImageViewDelegate <NSObject>

-(void)handleImageView:(HandleImageView *)handleImageView newImage:(UIImage *)newImage;

@end
@interface HandleImageView : UIView

@property (nonatomic,strong)UIImage *image;

@property (nonatomic, weak) id<handleImageViewDelegate> delegate;
@end
