//
//  NetworkRequest.m
//  WisdomHall
//
//  Created by XTU-TI on 2017/6/29.
//  Copyright © 2017年 majinxing. All rights reserved.
//

#import "NetworkRequest.h"
#import "DYHeader.h"
#import "AFNetworking.h"
#import "AppDelegate.h"
#import <UIKit/UIKit.h>

@implementation NetworkRequest
+(instancetype)sharedInstance{
    static NetworkRequest *tools;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        // baseURL 的目的，就是让后续的网络访问直接使用 相对路径即可，baseURL 的路径一定要有 / 结尾
        NSURL *baseURL = [NSURL URLWithString:BaseURL];
        
        NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
        
        tools = [[self alloc] initWithBaseURL:baseURL sessionConfiguration:config];
        
        // 修改 解析数据格式 能够接受的内容类型 － 官方推荐的做法，民间做法：直接修改 AFN 的源代码
//        tools.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",
//                                                           @"text/json",
//                                                           @"text/javascript",
//                                                           @"text/html",
//                                                           @"application/xml",
//                                                           nil];
    });
    return tools;
}

-(void)afnetwroingPostWithUrl:(NSString *)url withDict:(NSDictionary *)dict{
    UserModel * user = [[Appsetting sharedInstance] getUsetInfo];
    NSString * baseUrl = user.host;

    NSString * str = [NSString stringWithFormat:@"%@/%@",baseUrl,url];
    
    AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
    
    [manager POST:str parameters:dict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                NSLog(@"success--%@--%@",[responseObject class],responseObject);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                NSLog(@"failure--%@",error);
    }];
}
/**
 *  封装AFN的POST请求
 *
 *  @param URLString 网络请求地址
 *  @param dict      参数(可以是字典或者nil)
 *  @param succeed   成功后执行success block
 *  @param failure   失败后执行failure block
 */
- (void)POST:(NSString *)URLString dict:(id)dict succeed:(void (^)(id data))succeed failure:(void (^)(NSError *error))failure
{
    //创建网络请求管理对象
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html",@"application/json", @"text/json", nil];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    [manager.requestSerializer setValue:@"application/json"forHTTPHeaderField:@"Content-Type"];
    //调出请求头
    
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    
    //将token封装入请求头
    
    UserModel * user = [[Appsetting sharedInstance] getUsetInfo];
    
    [manager.requestSerializer setValue:[NSString stringWithFormat:@"Bearer %@",user.token] forHTTPHeaderField:@"token"];

//    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
    //发送网络请求(请求方式为POST)
    NSString * baseUrl = user.host;

    URLString = [NSString stringWithFormat:@"%@/%@",baseUrl,URLString];
    
    [manager POST:URLString parameters:dict progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        succeed(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
    }];
    
}
/**
 *  封装AFN的GET请求
 *
 *  @param URLString 网络请求地址
 *  @param dict      参数(可以是字典或者nil)
 *  @param succeed   成功后执行success block
 *  @param failure   失败后执行failure block
 */
- (void)GET:(NSString *)URLString dict:(id)dict succeed:(void (^)(id data))succeed failure:(void (^)(NSError *error))failure
{
    //创建网络请求管理对象
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
//    //申明返回的结果是json类型
//    manager.responseSerializer = [AFJSONResponseSerializer serializer];
//    //申明请求的数据是json类型
//    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    //如果报接受类型不一致请替换一致text/html或别的
//    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html",nil];
    [ manager.requestSerializer setValue:@"application/json"forHTTPHeaderField:@"Content-Type"];
    //调出请求头
    
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    
    //将token封装入请求头
    
    UserModel * user = [[Appsetting sharedInstance] getUsetInfo];
    
    [manager.requestSerializer setValue:[NSString stringWithFormat:@"Bearer %@",user.token] forHTTPHeaderField:@"token"];
    
//    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
    //发送网络请求(请求方式为GET)
    NSString * baseUrl = user.host;

    URLString = [NSString stringWithFormat:@"%@/%@",baseUrl,URLString];

    [manager GET:URLString parameters:dict progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        succeed(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
    }];
}
/**
 *  封装AFN的POST请求
 *
 *  @param URLString 网络请求地址
 *  @param dict      参数(可以是字典或者nil)
 *  @param succeed   成功后执行success block
 *  @param failure   失败后执行failure block
 */
- (void)POSTImage:(NSString *)URLString image:(UIImage *)uploadImage dict:(id)dict succeed:(void (^)(id data))succeed failure:(void (^)(NSError *error))failure{
    //创建网络请求管理对象
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html",@"application/json", @"text/json", nil];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    [manager.requestSerializer setValue:@"application/json"forHTTPHeaderField:@"Content-Type"];
    //调出请求头
    
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    
    //将token封装入请求头
    
    UserModel * user = [[Appsetting sharedInstance] getUsetInfo];
    
    [manager.requestSerializer setValue:[NSString stringWithFormat:@"Bearer %@",user.token] forHTTPHeaderField:@"token"];
    NSString * baseUrl = user.host;

    //发送网络请求(请求方式为POST)
    URLString = [NSString stringWithFormat:@"%@/%@",baseUrl,URLString];
    
    [manager POST:URLString parameters:dict constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
        NSData *imageData = UIImageJPEGRepresentation(uploadImage,0.5);
        
        UserModel * user = [[Appsetting sharedInstance] getUsetInfo];
        
        NSString *str = [NSString stringWithFormat:@"%@-%@-%@",user.userName,user.studentId,[UIUtils getTime]];
        
        NSString *fileName = [NSString stringWithFormat:@"%@.jpg",str];
        
        [formData appendPartWithFileData:imageData name:@"myfiles"  fileName:fileName mimeType:@"image/jpg"];       // 上传图片的参数key
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        succeed(responseObject);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
        
    }];
    
}
/**
 *  封装AFN的POST请求
 *
 *  @param URLString 网络请求地址
 *  @param dict      参数(可以是字典或者nil)
 *  @param succeed   成功后执行success block
 *  @param failure   失败后执行failure block
 */
- (void)POSTImage:(NSString *)URLString filePath:(NSString *)filePath dict:(id)dict succeed:(void (^)(id data))succeed failure:(void (^)(NSError *error))failure{
    //创建网络请求管理对象
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html",@"application/json", @"text/json", nil];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    [manager.requestSerializer setValue:@"application/json"forHTTPHeaderField:@"Content-Type"];
    //调出请求头
    
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    
    //将token封装入请求头
    
    UserModel * user = [[Appsetting sharedInstance] getUsetInfo];
    
    [manager.requestSerializer setValue:[NSString stringWithFormat:@"Bearer %@",user.token] forHTTPHeaderField:@"token"];
    NSString * baseUrl = user.host;

    //发送网络请求(请求方式为POST)
    URLString = [NSString stringWithFormat:@"%@/%@",baseUrl,URLString];
    
    [manager POST:URLString parameters:dict constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
//        NSData *fileData = [NSData dataWithContentsOfFile:filePath];
        NSData *imageData = [NSData dataWithContentsOfFile:filePath];
        
        UserModel * user = [[Appsetting sharedInstance] getUsetInfo];
        
//        NSString *str = [NSString stringWithFormat:@"%@-%@-%@",user.userName,user.studentId,[UIUtils getTime]];
        
        NSString *fileName = [filePath lastPathComponent];
        
        [formData appendPartWithFileData:imageData name:@"myfiles"  fileName:fileName mimeType:@"image/jpg"];       // 上传图片的参数key
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        succeed(responseObject);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
        
    }];
}
/**
 *  封装AFN的GET请求
 *
 *  @param URLString 网络请求地址
 *  @param dict      参数(可以是字典或者nil)
 *  @param succeed   成功后执行success block
 *  @param failure   失败后执行failure block
 */
- (void)GETSchool:(NSString *)URLString dict:(id)dict succeed:(void (^)(id data))succeed failure:(void (^)(NSError *error))failure
{
    //创建网络请求管理对象
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    //    //申明返回的结果是json类型
    //    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    //    //申明请求的数据是json类型
    //    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    //如果报接受类型不一致请替换一致text/html或别的
    //    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html",nil];
    [ manager.requestSerializer setValue:@"application/json"forHTTPHeaderField:@"Content-Type"];
    //调出请求头
    
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    
    //将token封装入请求头
    
    UserModel * user = [[Appsetting sharedInstance] getUsetInfo];
    
    [manager.requestSerializer setValue:[NSString stringWithFormat:@"Bearer %@",user.token] forHTTPHeaderField:@"token"];
    
    //    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
    //发送网络请求(请求方式为GET)
    URLString = [NSString stringWithFormat:@"%@",URLString];
    
    [manager GET:URLString parameters:dict progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        succeed(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
    }];
}
@end
