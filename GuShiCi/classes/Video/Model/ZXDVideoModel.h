//
//  ZXDVideoModel.h
//  GuShiCi
//
//  Created by zxd on 2018/4/24.
//  Copyright © 2018年 zxd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZXDVideoModel : NSObject

/** <#digest#> */
@property (nonatomic, copy) NSString *ID;

/** <#digest#> */
@property (nonatomic, strong) NSURL *image;

/** <#digest#> */
@property (nonatomic, copy) NSString *name;

/** <#digest#> */
@property (nonatomic, strong) NSURL *url;
@end
