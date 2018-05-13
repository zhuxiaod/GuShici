//
//  ZXDCycleData.h
//  GuShiCi
//
//  Created by zxd on 2018/4/4.
//  Copyright © 2018年 zxd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZXDCycleData : NSObject
///** 图片一 */
//@property (nonatomic, copy) NSString *image1;
//
///** 图片二 */
//@property (nonatomic, copy) NSString *image2;
//
///** 图片三 */
//@property (nonatomic, copy) NSString *image3;

@property (nonatomic, strong)NSArray *array;

@property (nonatomic, assign)NSInteger cellHeight;

+ (instancetype)cycleWithInit:(NSString *)image1 image2:(NSString *)image2 image3:(NSString *)image3 cellHeight:(NSInteger)height;

@end
