//
//  ZXDPutInTextViewController.h
//  GuShiCi
//
//  Created by zxd on 2018/5/6.
//  Copyright © 2018年 zxd. All rights reserved.
//

#import <UIKit/UIKit.h>
//block
typedef void(^ReturnDicBlock)(NSDictionary *dic);

@interface ZXDPutInTextViewController : UITableViewController
@property(nonatomic,copy)ReturnDicBlock returnDicBlock;


@end

