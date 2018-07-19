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

#define API_URL IMAPIURL//@"http://192.168.1.100:8010/course-im"

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
    //    NSString * str = @"http://192.168.1.109:8010/course-im";
    
    [IMHttpAPI POSTImage:[NSString stringWithFormat:@"%@/%@",IMAPIURL,IMImages] image:image dict:@{@"key":@"v"} succeed:^(id data) {
        NSDictionary * dict = [IMHttpAPI returnDictionaryWithDataPath:data];
        NSString * str =  [NSString stringWithFormat:@"%@/%@/%@",IMAPIURL,IMImages,[dict objectForKey:@"src"]];
        NSLog(@"2");
        
        success(str);
    } failure:^(NSError *error) {
        NSLog(@"2");
    } ];
    
    //    NSData *data = UIImagePNGRepresentation(image);
    IMHttpOperation *request = [IMHttpOperation httpOperationWithTimeoutInterval:60];
    
    return request;
    
}

+ (NSString *)postRequestWithURL: (NSString *)url // IN
                      postParems: (NSMutableDictionary *)postParems // IN
                     picFilePath: (NSString *)picFilePath // IN上传图片路径
                     picFileName: (NSString *)picFileName // IN
{
    NSString *TWITTERFON_FORM_BOUNDARY = @"0xKhTmLbOuNdArY";
    //根据url初始化request
    NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url] cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:10];
    //分界线 --AaB03x
    NSString *MPboundary=[[NSString alloc]initWithFormat:@"--%@",TWITTERFON_FORM_BOUNDARY];
    //结束符 AaB03x--
    NSString *endMPboundary=[[NSString alloc]initWithFormat:@"%@--",MPboundary];
    //得到图片的data
    NSData* data; if(picFilePath){
        UIImage *image=[UIImage imageWithContentsOfFile:picFilePath];
        //判断图片是不是png格式的文件
        if (UIImagePNGRepresentation(image)) {
            //返回为png图像。
            data = UIImagePNGRepresentation(image);
            
        }else {
            //返回为JPEG图像。
            data = UIImageJPEGRepresentation(image, 1.0); }
        
    } //http body的字符串
    NSMutableString *body=[[NSMutableString alloc]init];
    //参数的集合的所有key的集合
    NSArray *keys= [postParems allKeys];
    //遍历keys
    for(int i=0;i<[keys count];i++) {
        //得到当前key
        NSString *key=[keys objectAtIndex:i];
        //添加分界线，换行
        [body appendFormat:@"%@\r\n",MPboundary];
        //添加字段名称，换2行
        [body appendFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n",key];
        //添加字段的值
        [body appendFormat:@"%@\r\n",[postParems objectForKey:key]];
        NSLog(@"添加字段的值==%@",[postParems objectForKey:key]);
        
    }
    if(picFilePath){
        ////添加分界线，换行
        [body appendFormat:@"%@\r\n",MPboundary];
        //声明pic字段，文件名为boris.png
        //        [body appendFormat:@"Content-Disposition: form-data; name=\"%@\"; filename=\"%@\"\r\n",FORM_FLE_INPUT,picFileName];
        //声明上传文件的格式
        [body appendFormat:@"Content-Type: image/jpge,image/gif, image/jpeg, image/pjpeg, image/pjpeg\r\n\r\n"];
        NSLog(@"body = %@",body);
        
    } //声明结束符：--AaB03x--
    NSString *end=[[NSString alloc]initWithFormat:@"\r\n%@",endMPboundary];
    //声明myRequestData，用来放入http body
    NSMutableData*myRequestData=[NSMutableData data];
    //将body字符串转化为UTF8格式的二进制
    [myRequestData appendData:[body dataUsingEncoding:NSUTF8StringEncoding]]; if(picFilePath){
        //将image的data加入
        [myRequestData appendData:data];
        
    } //加入结束符--AaB03x--
    [myRequestData appendData:[end dataUsingEncoding:NSUTF8StringEncoding]];
    //设置HTTPHeader中Content-Type的值
    NSString *content=[[NSString alloc]initWithFormat:@"multipart/form-data; boundary=%@",TWITTERFON_FORM_BOUNDARY];
    //设置HTTPHeader
    [request setValue:content forHTTPHeaderField:@"Content-Type"];
    //设置Content-Length
    [request setValue:[NSString stringWithFormat:@"%lu", (unsigned long)[myRequestData length]] forHTTPHeaderField:@"Content-Length"];
    //设置http body
    [request setHTTPBody:myRequestData]; //http method
    [request setHTTPMethod:@"POST"];
    NSHTTPURLResponse *urlResponese = nil;
    NSError *error = [[NSError alloc]init];
    NSData* resultData = [NSURLConnection sendSynchronousRequest:request returningResponse:&urlResponese error:&error];
    NSString* result= [[NSString alloc] initWithData:resultData encoding:NSUTF8StringEncoding];
    if([urlResponese statusCode] >=200&&[urlResponese statusCode]<300){
        
        NSLog(@"返回结果=====%@",result);
        
        return result;
        
    }
    return nil;
    
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
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/plain", @"multipart/form-data", @"application/json", @"text/html", @"image/jpeg", @"image/png", @"application/octet-stream", @"text/json", nil];
    
    [manager.requestSerializer setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    //调出请求头
    
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    //将token封装入请求头
    
    //    UserModel * user = [[Appsetting sharedInstance] getUsetInfo];
    NSString *auth = [NSString stringWithFormat:@"Basic aaaaaaNzo0NDk3NjBiMTIwNjEwYWMwYjNhYmRiZDk1NTI1NGVlMA=="];
    
    
    [manager.requestSerializer setValue:auth forHTTPHeaderField:@"Authorization"];
    
    NSString * baseUrl = URLString;//@"http://192.168.1.100:8010/course-im/images";//@"http://www.dayaokeji.com/imtest/upload.php";// user.host;
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
        
        NSString *str = @"2018-6-22";// [NSString stringWithFormat:@"%@-%@-%@",user.userName,user.studentId,[UIUtils getTime]];
        
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
    [IMHttpAPI POSTfile:[NSString stringWithFormat:@"%@/%@",IMAPIURL,IMAudios] image:data dict:@{@"key":@"v"} succeed:^(id data) {
        
        NSDictionary * dict = [IMHttpAPI returnDictionaryWithDataPath:data];
        if ([UIUtils isBlankString:[dict objectForKey:@"src"]]) {
            fail();
        }else{
            NSString * str =  [NSString stringWithFormat:@"%@/%@/%@",IMAPIURL,IMAudios,[dict objectForKey:@"src"]];
            NSLog(@"2");
            success(str);
        }
        
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

