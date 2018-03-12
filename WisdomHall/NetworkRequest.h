//
//  NetworkRequest.h
//  WisdomHall
//
//  Created by XTU-TI on 2017/6/29.
//  Copyright © 2017年 majinxing. All rights reserved.
//

#import "AFHTTPSessionManager.h"

#import "AFNetworking/AFNetworking.h"

@interface NetworkRequest : AFHTTPSessionManager
+ (instancetype)sharedInstance;
- (void)POST:(NSString *)URLString dict:(id)dict succeed:(void (^)(id data))succeed failure:(void (^)(NSError *error))failure;
- (void)GET:(NSString *)URLString dict:(id)dict succeed:(void (^)(id data))succeed failure:(void (^)(NSError *error))failure;
//上传图片 file 类型
- (void)POSTImage:(NSString *)URLString image:(UIImage *)uploadImage dict:(id)dict succeed:(void (^)(id data))succeed failure:(void (^)(NSError *error))failure;
/**
 *  封装AFN的POST请求
 *
 *  @param URLString 网络请求地址
 *  @param dict      参数(可以是字典或者nil)
 *  @param succeed   成功后执行success block
 *  @param failure   失败后执行failure block
 */
- (void)POSTImage:(NSString *)URLString filePath:(NSString *)filePath dict:(id)dict succeed:(void (^)(id data))succeed failure:(void (^)(NSError *error))failure;
@end
