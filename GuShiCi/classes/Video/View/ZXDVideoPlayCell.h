//
//  ZXDVideoPlayCell.h
//  GuShiCi
//
//  Created by zxd on 2018/4/25.
//  Copyright © 2018年 zxd. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ZXDVideoModel;

@interface ZXDVideoPlayCell : UITableViewCell
typedef void (^btnClickBlock) (ZXDVideoPlayCell *);

@property(nonatomic,strong)  ZXDVideoModel *video;

@property(nonatomic, copy) btnClickBlock btnClick;
@end
