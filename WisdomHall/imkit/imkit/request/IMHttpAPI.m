/*                                                                            
  Copyright (c) 2014-2015, GoBelieve     
    All rights reserved.		    				     			
 
  This source code is licensed under the BSD-style license found in the
  LICENSE file in the root directory of this source tree. An additional grant
  of patent rights can be found in the PATENTS file in the same directory.
*/

#import "IMHttpAPI.h"
#import "TAHttpOperation.h"
#import "AFNetworking.h"
#define API_URL @"http://api.gobelieve.io"
@implementation IMHttpAPI


+(IMHttpAPI*)instance {
    static IMHttpAPI *im;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (!im) {
            im = [[IMHttpAPI alloc] init];
            im.apiURL = API_URL;
        }
    });
    return im;
}
//图片上传
+(NSOperation*)uploadImage:(UIImage*)image success:(void (^)(NSString *url))success fail:(void (^)())fail {
    [IMHttpAPI POSTImage:nil image:image dict:@{@"key":@"v"} succeed:^(id data) {
        NSDictionary * dict = [IMHttpAPI returnDictionaryWithDataPath:data];
        NSString * str =  [NSString stringWithFormat:@"http://192.168.1.100:8010/course-im/images/%@",[dict objectForKey:@"src"]];
        NSLog(@"2");
        
        success(str);
    } failure:^(NSError *error) {
        NSLog(@"2");
    } ];
    
//    NSData *data = UIImagePNGRepresentation(image);
    IMHttpOperation *request = [IMHttpOperation httpOperationWithTimeoutInterval:60];
//    request.targetURL = @"http://www.dayaokeji.com/imtest/upload.php";//[[IMHttpAPI instance].apiURL stringByAppendingString:@"/images"];
//    request.method = @"POST";
//    request.postBody = data;
//
//    NSMutableDictionary *headers = [NSMutableDictionary dictionaryWithObject:@"image/png" forKey:@"Content-Type"];
//    NSString *auth = [NSString stringWithFormat:@"Bearer %@", [IMHttpAPI instance].accessToken];
//    [headers setObject:auth forKey:@"Authorization"];
//    request.headers = headers;
//
//    request.successCB = ^(IMHttpOperation*commObj, NSURLResponse *response, NSData *data) {
//        NSInteger statusCode = [(NSHTTPURLResponse*)response statusCode];
//        if (statusCode != 200) {
//            NSLog(@"图片上传失败");
//            fail();
//        } else {
//            NSDictionary *resp = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
//            NSString *src_url = @"http://api.gobelieve.io/images/daae1c8cd3464d4b9c1cf19b4df947c4.png";//[resp objectForKey:@"src_url"];
//            success(src_url);
//        }
//    };
//    request.failCB = ^(IMHttpOperation*commObj, IMHttpOperationError error) {
//        fail();
//    };
//    [[NSOperationQueue mainQueue] addOperation:request];
//
//
//
//    NSString *requestUrl = request.targetURL;// [NSString stringWithFormat:@"%@%@", kBaseUrl, url];
//    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
//
//    NSMutableURLRequest *request1 = [[AFHTTPRequestSerializer serializer] requestWithMethod:@"POST" URLString:requestUrl parameters:nil error:nil];
//
//    request1.timeoutInterval= 60;
//
//    [request1 setAllHTTPHeaderFields:headers];
//
////    [request1 setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
//
////    /setAllHTTPHeaderFields
//
//    // 设置body
//    [request1 setHTTPBody:data];
//
//    AFHTTPResponseSerializer *responseSerializer = [AFHTTPResponseSerializer serializer];
//    responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",
//                                                 @"text/html",
//                                                 @"text/json",
//                                                 @"text/javascript",
//                                                 @"text/plain",
//                                                 nil];
//    manager.responseSerializer = responseSerializer;
//
////    [manager.requestSerializer setValue:[NSString stringWithFormat:@"Bearer %@",[IMHttpAPI instance].accessToken]] forHTTPHeaderField:@"token"];
//
//
//    [[manager dataTaskWithRequest:request1 completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
//
//        if (!error) {
//            NSLog(@"1");
////            if (show) {
////                [weakSelf dismissLoading];
////            }
////            success([weakSelf processResponse:responseObject]);
//
//        } else {
//            NSLog(@"2");
////            failure(error);
////            [weakSelf showErrorMessage];
////            ILog(@"request error = %@",error);
//        }
//    }] resume];
    return request;

}

/**
 *  封装AFN的POST请求
 *
 *  @param URLString 网络请求地址
 *  @param dict      参数(可以是字典或者nil)
 *  @param succeed   成功后执行success block
 *  @param failure   失败后执行failure block
 */
+ (void)POSTImage:(NSString *)URLString image:(UIImage *)uploadImage dict:(id)dict succeed:(void (^)(id data))succeed failure:(void (^)(NSError *error))failure
{
    //创建网络请求管理对象
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html",@"application/json", @"text/json", nil];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    [manager.requestSerializer setValue:@"application/json"forHTTPHeaderField:@"Content-Type"];
    //调出请求头
    
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    //将token封装入请求头
    
//    UserModel * user = [[Appsetting sharedInstance] getUsetInfo];
    NSString *auth = [NSString stringWithFormat:@"Basic Nzo0NDk3NjBiMTIwNjEwYWMwYjNhYmRiZDk1NTI1NGVlMA=="];

    
    [manager.requestSerializer setValue:auth forHTTPHeaderField:@"Authorization"];
    
    NSString * baseUrl = @"http://192.168.1.100:8010/course-im/images";//@"http://www.dayaokeji.com/imtest/upload.php";// user.host;
    //发送网络请求(请求方式为POST)
    URLString = [NSString stringWithFormat:@"%@",baseUrl];
    
    [manager POST:URLString parameters:dict constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
        NSData *imageData = UIImageJPEGRepresentation(uploadImage,0.1);
        
        NSString *str = @"2018-6-21";// [NSString stringWithFormat:@"%@-%@-%@",user.userName,user.studentId,[UIUtils getTime]];
        
        NSString *fileName = [NSString stringWithFormat:@"%@.jpg",str];
        
        [formData appendPartWithFileData:imageData name:@"file"  fileName:fileName mimeType:@"image/jpg"];       // 上传图片的参数key
        
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
+ (void)POSTfile:(NSString *)URLString image:(NSData *)uploadImage dict:(id)dict succeed:(void (^)(id data))succeed failure:(void (^)(NSError *error))failure
{
    //创建网络请求管理对象
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html",@"application/json", @"text/json", nil];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    [manager.requestSerializer setValue:@"application/json"forHTTPHeaderField:@"Content-Type"];
    //调出请求头
    
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    //将token封装入请求头
    
    //    UserModel * user = [[Appsetting sharedInstance] getUsetInfo];
    //
    //    [manager.requestSerializer setValue:[NSString stringWithFormat:@"Bearer %@",user.token] forHTTPHeaderField:@"token"];
    NSString *auth = [NSString stringWithFormat:@"Basic Nzo0NDk3NjBiMTIwNjEwYWMwYjNhYmRiZDk1NTI1NGVlMA=="];
    
    
    [manager.requestSerializer setValue:auth forHTTPHeaderField:@"Authorization"];
    NSString * baseUrl = @"http://192.168.1.100:8010/course-im/audios";//@"http://www.dayaokeji.com/imtest/upload.php";// user.host;
    //发送网络请求(请求方式为POST)
    URLString = [NSString stringWithFormat:@"%@",baseUrl];
    
    [manager POST:URLString parameters:dict constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
        NSData *imageData=uploadImage;//= UIImageJPEGRepresentation(uploadImage,0.1);
        
        NSString *str = @"2018-6-21";// [NSString stringWithFormat:@"%@-%@-%@",user.userName,user.studentId,[UIUtils getTime]];
        
        NSString *fileName = [NSString stringWithFormat:@"%@/amrRecord.amr",str];
        
        [formData appendPartWithFileData:imageData name:@"file"  fileName:fileName mimeType:@"audio/ogg"];       // 上传图片的参数key
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        succeed(responseObject);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
        
    }];
    
    
}
//NSData 转字典:
 // NSData转dictonary
+(NSDictionary*)returnDictionaryWithDataPath:(NSData*)data
 {
    
     NSDictionary *dictionary =[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
       return dictionary;
    }
//语音上传
+(NSOperation*)uploadAudio:(NSData*)data success:(void (^)(NSString *url))success fail:(void (^)())fail {
    [IMHttpAPI POSTfile:nil image:data dict:@{@"key":@"v"} succeed:^(id data) {
        NSDictionary * dict = [IMHttpAPI returnDictionaryWithDataPath:data];
        NSString * str =  [NSString stringWithFormat:@"http://192.168.1.100:8010/course-im/audios/%@",[dict objectForKey:@"src"]];
        NSLog(@"2");
        success(str);
    } failure:^(NSError *error) {
        NSLog(@"2");
    }];
    
    IMHttpOperation *request = [IMHttpOperation httpOperationWithTimeoutInterval:60];
//    request.targetURL = [[IMHttpAPI instance].apiURL stringByAppendingString:@"/audios"];
//    request.method = @"POST";
//    request.postBody = data;
//
//    NSMutableDictionary *headers = [NSMutableDictionary dictionaryWithObject:@"application/plain" forKey:@"Content-Type"];
//    NSString *auth = [NSString stringWithFormat:@"Bearer %@", [IMHttpAPI instance].accessToken];
//    [headers setObject:auth forKey:@"Authorization"];
//    request.headers = headers;
//
//    request.successCB = ^(IMHttpOperation*commObj, NSURLResponse *response, NSData *data) {
//        NSInteger statusCode = [(NSHTTPURLResponse*)response statusCode];
//        if (statusCode != 200) {
//            NSLog(@"录音上传失败");
//            fail();
//        } else {
//            NSDictionary *resp = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
//            NSString *src_url = [resp objectForKey:@"src_url"];
//            success(src_url);
//        }
//    };
//    request.failCB = ^(IMHttpOperation*commObj, IMHttpOperationError error) {
//        fail();
//    };
//    [[NSOperationQueue mainQueue] addOperation:request];
    return request;
}

+(NSOperation*)bindDeviceToken:(NSString*)deviceToken success:(void (^)())success fail:(void (^)())fail {
    IMHttpOperation *request = [IMHttpOperation httpOperationWithTimeoutInterval:60];
    request.targetURL = [[IMHttpAPI instance].apiURL stringByAppendingString:@"/device/bind"];
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:deviceToken forKey:@"apns_device_token"];
    NSMutableDictionary *headers = [NSMutableDictionary dictionaryWithObject:@"application/json" forKey:@"Content-Type"];
//    NSString *auth = [NSString stringWithFormat:@"Bearer %@", [IMHttpAPI instance].accessToken];
    NSString * auth = [NSString stringWithFormat:@"Basic Nzo0NDk3NjBiMTIwNjEwYWMwYjNhYmRiZDk1NTI1NGVlMA=="];
    [headers setObject:auth forKey:@"Authorization"];
    
    request.headers = headers;
    NSData *data = [NSJSONSerialization dataWithJSONObject:dict options:0 error:nil];
    request.postBody = data;
    request.method = @"POST";
    request.successCB = ^(IMHttpOperation*commObj, NSURLResponse *response, NSData *data) {
        NSInteger statusCode = [(NSHTTPURLResponse*)response statusCode];
        if (statusCode != 200) {
            NSLog(@"bind device token fail");
            fail();
            return;
        }
        success();
    };
    request.failCB = ^(IMHttpOperation*commObj, IMHttpOperationError error) {
        NSLog(@"bind device token fail");
        fail();
    };
    [[NSOperationQueue mainQueue] addOperation:request];
    return request;
}

+(NSOperation*)unbindDeviceToken:(NSString*)deviceToken success:(void (^)())success fail:(void (^)())fail {
    IMHttpOperation *request = [IMHttpOperation httpOperationWithTimeoutInterval:60];
    request.targetURL = [[IMHttpAPI instance].apiURL stringByAppendingString:@"/device/unbind"];
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:deviceToken forKey:@"apns_device_token"];
    NSMutableDictionary *headers = [NSMutableDictionary dictionaryWithObject:@"application/json" forKey:@"Content-Type"];
    
//    NSString *auth = [NSString stringWithFormat:@"Bearer %@", [IMHttpAPI instance].accessToken];
    NSString * auth = [NSString stringWithFormat:@"Basic Nzo0NDk3NjBiMTIwNjEwYWMwYjNhYmRiZDk1NTI1NGVlMA=="];
    [headers setObject:auth forKey:@"Authorization"];
    
    request.headers = headers;
    NSData *data = [NSJSONSerialization dataWithJSONObject:dict options:0 error:nil];
    request.postBody = data;
    request.method = @"POST";
    request.successCB = ^(IMHttpOperation*commObj, NSURLResponse *response, NSData *data) {
        NSInteger statusCode = [(NSHTTPURLResponse*)response statusCode];
        if (statusCode != 200) {
            NSLog(@"unbind device token fail");
            fail();
            return;
        }
        success();
    };
    request.failCB = ^(IMHttpOperation*commObj, IMHttpOperationError error) {
        NSLog(@"unbind device token fail");
        fail();
    };
    [[NSOperationQueue mainQueue] addOperation:request];
    return request;
}

+(NSOperation*)openGroupNotification:(int64_t)group_id success:(void (^)())success fail:(void (^)())fail {
    IMHttpOperation *request = [IMHttpOperation httpOperationWithTimeoutInterval:60];
    
    request.targetURL = [NSString stringWithFormat:@"%@/notification/groups/%lld", [IMHttpAPI instance].apiURL, group_id];
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:[NSNumber numberWithInt:0] forKey:@"quiet"];
    NSMutableDictionary *headers = [NSMutableDictionary dictionaryWithObject:@"application/json" forKey:@"Content-Type"];
//    NSString *auth = [NSString stringWithFormat:@"Bearer %@", [IMHttpAPI instance].accessToken];
    NSString * auth = [NSString stringWithFormat:@"Basic Nzo0NDk3NjBiMTIwNjEwYWMwYjNhYmRiZDk1NTI1NGVlMA=="];
    [headers setObject:auth forKey:@"Authorization"];
    
    request.headers = headers;
    NSData *data = [NSJSONSerialization dataWithJSONObject:dict options:0 error:nil];
    request.postBody = data;
    request.method = @"POST";
    request.successCB = ^(IMHttpOperation*commObj, NSURLResponse *response, NSData *data) {
        NSInteger statusCode = [(NSHTTPURLResponse*)response statusCode];
        if (statusCode != 200) {
            fail();
            return;
        }
        success();
    };
    request.failCB = ^(IMHttpOperation*commObj, IMHttpOperationError error) {
        fail();
    };
    [[NSOperationQueue mainQueue] addOperation:request];
    return request;
}

+(NSOperation*)closeGroupNotification:(int64_t)group_id success:(void (^)())success fail:(void (^)())fail {
    IMHttpOperation *request = [IMHttpOperation httpOperationWithTimeoutInterval:60];
    
    request.targetURL = [NSString stringWithFormat:@"%@/notification/groups/%lld", [IMHttpAPI instance].apiURL, group_id];
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:[NSNumber numberWithInt:1] forKey:@"quiet"];
    NSMutableDictionary *headers = [NSMutableDictionary dictionaryWithObject:@"application/json" forKey:@"Content-Type"];
//    NSString *auth = [NSString stringWithFormat:@"Bearer %@", [IMHttpAPI instance].accessToken];
    NSString * auth = [NSString stringWithFormat:@"Basic Nzo0NDk3NjBiMTIwNjEwYWMwYjNhYmRiZDk1NTI1NGVlMA=="];
    [headers setObject:auth forKey:@"Authorization"];
    
    request.headers = headers;
    NSData *data = [NSJSONSerialization dataWithJSONObject:dict options:0 error:nil];
    request.postBody = data;
    request.method = @"POST";
    request.successCB = ^(IMHttpOperation*commObj, NSURLResponse *response, NSData *data) {
        NSInteger statusCode = [(NSHTTPURLResponse*)response statusCode];
        if (statusCode != 200) {
            NSLog(@"open group notification fail");
            fail();
            return;
        }
        success();
    };
    request.failCB = ^(IMHttpOperation*commObj, IMHttpOperationError error) {
        NSLog(@"open group notification fail");
        fail();
    };
    [[NSOperationQueue mainQueue] addOperation:request];
    return request;
}

+(NSOperation*)createGroup:(NSString*)groupName master:(int64_t)master members:(NSArray*)members success:(void (^)(NSDictionary * groupId))success fail:(void (^)(NSString * error))fail {
    IMHttpOperation *request = [IMHttpOperation httpOperationWithTimeoutInterval:60];
    request.targetURL = [[IMHttpAPI instance].apiURL stringByAppendingString:@"/groups/create"];//接口
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];

    [dict setObject:[NSNumber numberWithLongLong:master] forKey:@"master"];
    [dict setObject:groupName forKey:@"name"];
    [dict setObject:members forKey:@"members"];
    
    NSMutableDictionary *headers = [NSMutableDictionary dictionaryWithObject:@"application/json" forKey:@"Content-Type"];
//    NSString *auth = [NSString stringWithFormat:@"Bearer %@", [IMHttpAPI instance].accessToken];
    NSString * auth = [NSString stringWithFormat:@"Basic Nzo0NDk3NjBiMTIwNjEwYWMwYjNhYmRiZDk1NTI1NGVlMA=="];
    [headers setObject:auth forKey:@"Authorization"];

    request.headers = headers;
    NSData *data = [NSJSONSerialization dataWithJSONObject:dict options:0 error:nil];
    request.postBody = data;
    request.method = @"POST";
    request.successCB = ^(IMHttpOperation*commObj, NSURLResponse *response, NSData *data) {
        NSInteger statusCode = [(NSHTTPURLResponse*)response statusCode];
        if (statusCode != 200) {
            NSDictionary *resp = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
            NSLog(@"create group fail:%@", resp);
            fail(@"create group fail");
            return;
        }
        
        NSDictionary *resp = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
//        int64_t groupID = [[[resp objectForKey:@"data"] objectForKey:@"group_id"] longLongValue];
        success(resp);
    };
    request.failCB = ^(IMHttpOperation*commObj, IMHttpOperationError error) {
        NSLog(@"create group fail");
        fail(@"create group fail");
    };
    [[NSOperationQueue mainQueue] addOperation:request];
    return request;
}

@end
