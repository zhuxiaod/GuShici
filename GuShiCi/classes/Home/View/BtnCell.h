//
//  BtnCell.h
//  GuShiCi
//
//  Created by zxd on 2018/4/30.
//  Copyright © 2018年 zxd. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ZXDRecommendButton;
@interface BtnCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UILabel *lable;

@property (nonatomic,strong)NSString *cellData;

@property (nonatomic)BOOL selected;
@end
