//
//  ZXDRequestManager.h
//  GuShiCi
//
//  Created by zxd on 2018/4/24.
//  Copyright © 2018年 zxd. All rights reserved.
//

#import "AFHTTPSessionManager.h"
#import <Foundation/Foundation.h>
#import "LMJBaseResponse.h"
#import <AFNetworking.h>

typedef NSString ZXDDataName;

typedef enum : NSInteger {
    // 自定义错误码
    ZXDRequestManagerStatusCodeCustomDemo = -10000,
} ZXDRequestManagerStatusCode;

typedef LMJBaseResponse *(^ResponseFormat)(LMJBaseResponse *response);

@interface ZXDRequestManager : AFHTTPSessionManager

+ (instancetype)sharedManager;

//本地数据模式
@property (assign, nonatomic) BOOL isLocal;

//预处理返回的数据
@property (copy, nonatomic) ResponseFormat responseFormat;

// https 验证
@property (nonatomic, copy) NSString *cerFilePath;

- (void)POST:(NSString *)urlString parameters:(id)parameters completion:(void (^)(LMJBaseResponse *response))completion;

- (void)GET:(NSString *)urlString parameters:(id)parameters completion:(void (^)(LMJBaseResponse *response))completion;

/*
 上传
 data 数据对应的二进制数据
 LMJDataName data对应的参数
 */
- (void)upload:(NSString *)urlString parameters:(id)parameters formDataBlock:(NSDictionary<NSData *, ZXDDataName *> *(^)(id<AFMultipartFormData> formData, NSMutableDictionary<NSData *, ZXDDataName *> *needFillDataDict))formDataBlock progress:(void (^)(NSProgress *progress))progress completion:(void (^)(LMJBaseResponse *response))completion;

@end
