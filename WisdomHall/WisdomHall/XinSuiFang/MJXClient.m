//
//  MJXClient.m
//  XinSuiFang
//
//  Created by majinxing on 16/8/25.
//  Copyright © 2016年 majinxing. All rights reserved.
//

#import "MJXClient.h"
#import "AppDelegate.h"
#import "MJXAppsettings.h"
#import "WTKeychain.h"
#import "TTUtil.h"
#import "AFNetworking.h"


@interface MJXClient ()
@property (nonatomic, strong)NSString* deviceToken;
@property (nonatomic, strong)NSString* userToken;
@end
@implementation MJXClient
+ (instancetype)sharedInstance {
    static MJXClient *_sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedInstance = [[MJXClient alloc] initWithBaseURL:[NSURL URLWithString:MJXBaseURL]];
        _sharedInstance.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
    });
    
    return _sharedInstance;
}

+(AFHTTPRequestOperationManager *)setAFHTTPRequestOperationManagerSomeQuality{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html",@"application/json", @"text/json", nil];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    [manager.requestSerializer setValue:@"application/json"forHTTPHeaderField:@"Content-Type"];
    
    return manager;
    
}
- (NSURLSessionDataTask*)POST:(NSString *)URLString
                   parameters:(id)parameters
                      success:(void (^)(NSURLSessionDataTask *, id))success
                      failure:(void (^)(NSURLSessionDataTask *, NSError *))failure
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html",@"application/json", @"text/json", nil];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    [ manager.requestSerializer setValue:@"application/json"forHTTPHeaderField:@"Content-Type"];
    NSString *str=[NSString stringWithFormat:@"%@%@",MJXBaseURL,URLString];
    [manager POST:str parameters:parameters  success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"chenggong %@",responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"失败 %@",error);
    }];

    return nil;
    
    
    
    NSString *urlStr = @"http://*****/**/api/account/token";
    AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
    [manager.responseSerializer setAcceptableContentTypes:[NSSet setWithObject:@"text/html"]];
    NSString * cerPath = [[NSBundle mainBundle] pathForResource:@"server" ofType:@"cer"];
    NSData * cerData = [NSData dataWithContentsOfFile:cerPath];
    manager.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeCertificate withPinnedCertificates:[[NSArray alloc] initWithObjects:cerData, nil]];
    manager.securityPolicy.allowInvalidCertificates = YES;
    [manager.securityPolicy setValidatesDomainName:NO];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    NSDictionary * parameter = @{@"userName":@"12345678907", @"password":@"W0.w123456",@"grant_type":@"password"};
    
    [manager POST:urlStr parameters:parameter success:^(NSURLSessionDataTask * task, id responseObject) {
        NSLog(@"success--- %@", responseObject);
    }
          failure:^(NSURLSessionDataTask * task, NSError * error) {
              NSLog(@"token failure*** %@", error);
}

@end
