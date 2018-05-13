//
//  ZXDSetupView.m
//  GuShiCi
//
//  Created by zxd on 2018/5/10.
//  Copyright © 2018年 zxd. All rights reserved.
//

#import "ZXDSetupView.h"
@interface ZXDSetupView()
@property (weak, nonatomic) IBOutlet UISlider *thickness;
@property (weak, nonatomic) IBOutlet UISlider *labelSize;
@property (weak, nonatomic) IBOutlet UIButton *tureBtn;

@end
@implementation ZXDSetupView
//初始化
- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    self = [[[NSBundle mainBundle] loadNibNamed:@"ZXDSetupView" owner:self options:nil] lastObject];
    if (self) {
        
        self.frame = frame;
    }
    UISlider *thickness = [[UISlider alloc] init];
    self.thickness = thickness;
    
    [_thickness addTarget:self action:@selector(sliderAction1:) forControlEvents:UIControlEventValueChanged];
    UISlider *labelSize = [[UISlider alloc] init];
    self.labelSize = labelSize;
    [_labelSize addTarget:self action:@selector(sliderAction2:) forControlEvents:UIControlEventValueChanged];
    UIButton *tureBtn = [[UIButton alloc] init];
    self.tureBtn = tureBtn;
    self.tureBtn.layer.borderColor = [UIColor whiteColor].CGColor;
    self.tureBtn.layer.borderWidth = 2;
    [_tureBtn addTarget:self action:@selector(end:) forControlEvents:UIControlEventTouchUpInside];
    return self;
}
-(void)awakeFromNib
{
    [super awakeFromNib];
    
}

- (IBAction)sliderAction1:(UISlider *)sender {
    if([self.delegate respondsToSelector:@selector(ZXDSetupView1:slider1:)]){
        [self.delegate ZXDSetupView1:self slider1:sender];
    }
}
- (IBAction)sliderAction2:(UISlider *)sender {
    if([self.delegate respondsToSelector:@selector(ZXDSetupView2:slider2:)]){
        [self.delegate ZXDSetupView2:self slider2:sender];
    }
}
+(instancetype)ZXDSetupView
{
    return [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil]lastObject];
    
}
- (IBAction)end:(id)sender {
    if([self.delegate respondsToSelector:@selector(ZXDSetupView:btn:)]){
        [self.delegate ZXDSetupView:self btn:sender];
    }
}

@end
