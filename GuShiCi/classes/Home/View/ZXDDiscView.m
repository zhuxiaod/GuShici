//
//  ZXDDiscView.m
//  GuShiCi
//
//  Created by zxd on 2018/4/9.
//  Copyright © 2018年 zxd. All rights reserved.
//

#import "ZXDDiscView.h"
#import "UIImageView+CornerRadius.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "JYAnimationManager.h"

@interface ZXDDiscView()<JYAnimationDelegate>

@property(nonatomic,strong)UIView *baseDiscView;
@property(nonatomic,strong)UIImageView *imgDiscView;

@property(nonatomic,strong)JYAnimationManager *jyAManager;

@end

@implementation ZXDDiscView

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self=[super initWithFrame:frame]) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(resetPlayStatus) name:@"CheckPlayStatus" object:nil];
        [self createDisc];
    }
    return self;
}

- (void)createDisc
{
    //创建Disc控件
    _baseDiscView=[[UIView alloc] initWithFrame:self.bounds];
    _baseDiscView.backgroundColor=[UIColor blackColor];
    _baseDiscView.layer.cornerRadius=self.bounds.size.width/2;
    _baseDiscView.alpha=0.2f;
    [self addSubview:_baseDiscView];
    
    _imgDiscView=[[UIImageView alloc] initWithFrame:CGRectMake(8, 8, self.bounds.size.width-16, self.bounds.size.height-16)];
    _imgDiscView.backgroundColor=[UIColor clearColor];
    [_imgDiscView zy_cornerRadiusRoundingRect];
    //    _imgDiscView.layer.cornerRadius = _imgDiscView.bounds.size.width/2;
    //    _imgDiscView.layer.masksToBounds = YES;
    [self addSubview:_imgDiscView];
}

#pragma mark - Public
//退出
-(void)takeOutDiscAnim;
{
    [self.jyAManager jy_addAnimationWithLayer:self.layer forKey:JYAnimationTypeScaleMove];
}
//进入
-(void)takeInDiscAnim
{
    [self.jyAManager jy_addAnimationWithLayer:self.layer forKey:JYAnimationTypeFade];
}

-(void)disc_setImageWithUrl:(NSURL *)url
{
    [_imgDiscView sd_setImageWithURL:url];
}

-(void)disc_setImageWithImage:(UIImage *)image;
{
    [_imgDiscView setImage:image];
}

#pragma mark - Private
-(JYAnimationManager *)jyAManager
{
    if (!_jyAManager) {
        _jyAManager=[JYAnimationManager manager];
        _jyAManager.delegate = self;
    }
    return _jyAManager;
}

//app进入后台后动画会被移除，重回前台后需要重新创建
-(void)resetPlayStatus
{
    [self checkPlayStatus];
}

-(void)checkPlayStatus
{
    if (_switchRotate) {
        if ([_imgDiscView.layer animationForKey:JYAnimationTypeRotaion]) {
            [self.jyAManager jy_resumeAnimationWithLayer:_imgDiscView.layer];
        }
        else{
            [self.jyAManager jy_addAnimationWithLayer:_imgDiscView.layer forKey:JYAnimationTypeRotaion];
        }
    }
    else{
        [self.jyAManager jy_pauseAnimationWithLayer:_imgDiscView.layer];
    }
}
//开关
-(void)setSwitchRotate:(BOOL)switchRotate
{
    if (_switchRotate!=switchRotate) {
        _switchRotate=switchRotate;
    }
    
    [self checkPlayStatus];
}

#pragma mark - JYAnimationDelegate

-(void)jy_animationDidStart:(CAAnimation *)anim
{
    if (anim == [self.layer animationForKey:JYAnimationTypeScaleMove]) {
        if ([_delegate respondsToSelector:@selector(changeDiscDidStart)]) {
            [_delegate changeDiscDidStart];
        }
        
    }
}

-(void)jy_animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    if (anim == [self.layer animationForKey:JYAnimationTypeScaleMove] && flag) {
        [self.jyAManager jy_removeAnimationFromLayer:_imgDiscView.layer forKey:JYAnimationTypeRotaion];
        [self.jyAManager jy_removeAnimationFromLayer:self.layer forKey:JYAnimationTypeScaleMove];
        
        if ([_delegate respondsToSelector:@selector(changeDiscDidFinish)]) {
            [_delegate changeDiscDidFinish];
        }
    }
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"CheckPlayStatus" object:nil];
}

@end
