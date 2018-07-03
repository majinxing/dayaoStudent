//
//  IMTool.m
//  WisdomHall
//
//  Created by XTU-TI on 2018/6/29.
//  Copyright © 2018年 majinxing. All rights reserved.
//

#import "IMTool.h"

//#import <gobelieve/IMService.h>
#import "IMService.h"
//#import <gobelieve/TextMessageViewController.h>
#import "TextMessageViewController.h"
//#import <gobelieve/MessageViewController.h>
#import "MessageViewController.h"
//#import <gobelieve/IMHttpAPI.h>
#import "IMHttpAPI.h"
//#import <gobelieve/PeerMessageViewController.h>
#import "PeerMessageViewController.h"
//#import <gobelieve/PeerMessageDB.h>
#import "PeerMessageDB.h"
//#import <gobelieve/GroupMessageDB.h>
#import "GroupMessageDB.h"
//#import <gobelieve/CustomerMessageDB.h>
#import "CustomerMessageDB.h"
//#import <gobelieve/SyncKeyHandler.h>
#import "SyncKeyHandler.h"
//#import <gobelieve/PeerMessageHandler.h>
#import "PeerMessageHandler.h"
//#import <gobelieve/GroupMessageHandler.h>
#import "GroupMessageHandler.h"
//#import <gobelieve/CustomerMessageHandler.h>
#import "CustomerMessageHandler.h"

#import "MessageListViewController.h"
#import "Conversation.h"
//#import <FMDB/FMDB.h>
#import "FMDB.h"
#import <sqlite3.h>

@implementation IMTool
+(void)IMLogin:(NSString *)UId{
//    tfSender.text = @"1";
    
//    if (!tfSender.text.length) {
//        NSLog(@"invalid input");
//        return;
//    }
//    [self.view endEditing:YES];
    
//    self.chatButton.userInteractionEnabled = NO;
    
    long long sender = [UId longLongValue];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSString *token = [self login:sender];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
//            self.chatButton.userInteractionEnabled = YES;
            
            if (token.length == 0) {
                NSLog(@"login fail");
                return;
            }
            
            NSLog(@"login success");
            
            
            
#ifdef FILE_ENGINE_DB
            NSString *path = [self getDocumentPath];
            
            NSString *dbPath = [NSString stringWithFormat:@"%@/%lld", path, [UId longLongValue]];
            [self mkdir:dbPath];
            
#elif defined SQL_ENGINE_DB
            NSString *path = [self getDocumentPath];
            NSString *dbPath = [NSString stringWithFormat:@"%@/gobelieve_%lld.db", path, [UId longLongValue]];
            
            //检查数据库文件是否已经存在
            NSFileManager *fileManager = [NSFileManager defaultManager];
            if (![fileManager fileExistsAtPath:dbPath]) {
                NSString *p = [[NSBundle mainBundle] pathForResource:@"gobelieve" ofType:@"db"];
                [fileManager copyItemAtPath:p toPath:dbPath error:nil];
            }
            FMDatabase *db = [[FMDatabase alloc] initWithPath:dbPath];
            BOOL r = [db openWithFlags:SQLITE_OPEN_READWRITE|SQLITE_OPEN_WAL vfs:nil];
            if (!r) {
                NSLog(@"open database error:%@", [db lastError]);
                db = nil;
                NSAssert(NO, @"");
            }
#else
#error dd
#endif
            
            
            
#ifdef FILE_ENGINE_DB
            [PeerMessageDB instance].dbPath = [NSString stringWithFormat:@"%@/peer", dbPath];
            [GroupMessageDB instance].dbPath = [NSString stringWithFormat:@"%@/group", dbPath];
            [CustomerMessageDB instance].dbPath = [NSString stringWithFormat:@"%@/customer", dbPath];
#elif defined SQL_ENGINE_DB
            [PeerMessageDB instance].db = db;
            [GroupMessageDB instance].db = db;
            [CustomerMessageDB instance].db = db;
#else
            
#endif
            
            [PeerMessageHandler instance].uid = [UId longLongValue];
            [GroupMessageHandler instance].uid = [UId longLongValue];
            [CustomerMessageHandler instance].uid = [UId longLongValue];
            
            [IMHttpAPI instance].accessToken = token;
            [IMService instance].token = token;
            
            
            path = [self getDocumentPath];
            dbPath = [NSString stringWithFormat:@"%@/%lld", path, [UId longLongValue]];
            [self mkdir:dbPath];
            
            NSString *fileName = [NSString stringWithFormat:@"%@/synckey", dbPath];
            SyncKeyHandler *handler = [[SyncKeyHandler alloc] initWithFileName:fileName];
            [IMService instance].syncKeyHandler = handler;
            
            [IMService instance].syncKey = [handler syncKey];
            NSLog(@"sync key:%lld", [handler syncKey]);
            
            [[IMService instance] clearSuperGroupSyncKey];
            NSDictionary *groups = [handler superGroupSyncKeys];
            for (NSNumber *k in groups) {
                NSNumber *v = [groups objectForKey:k];
                NSLog(@"group id:%@ sync key:%@", k, v);
                [[IMService instance] addSuperGroupSyncKey:[v longLongValue] gid:[k longLongValue]];
            }
            
            [[IMService instance] start];
            
//            if (self.deviceToken.length > 0) {
//
//                [IMHttpAPI bindDeviceToken:self.deviceToken
//                                   success:^{
//                                       NSLog(@"bind device token success");
//                                   }
//                                      fail:^{
//                                          NSLog(@"bind device token fail");
//                                      }];
//            }
            
//            if (tfReceiver.text.length > 0) {
//                PeerMessageViewController *msgController = [[PeerMessageViewController alloc] init];
//                msgController.currentUID = [UId longLongValue];
//                msgController.peerUID = [tfReceiver.text longLongValue];
//                msgController.peerName = @"测试";
//                msgController.userDelegate = self;
//                self.navigationController.navigationBarHidden = NO;
//                [self.navigationController pushViewController:msgController animated:YES];
//            } else {
//                MessageListViewController *ctrl = [[MessageListViewController alloc] init];
//                ctrl.currentUID = [UId longLongValue];
//                ctrl.userDelegate = self;
//                ctrl.groupDelegate = self;
//                self.navigationController.navigationBarHidden = NO;
//                self.hidesBottomBarWhenPushed = YES;
//                [self.navigationController pushViewController:ctrl animated:YES];
//                self.hidesBottomBarWhenPushed = NO;
//            }
        });
    });
}
+(BOOL)mkdir:(NSString*)path {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath:path]) {
        NSError *err;
        BOOL r = [fileManager createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:&err];
        
        if (!r) {
            NSLog(@"mkdir err:%@", err);
        }
        return r;
    }
    
    return YES;
}
//生成token
+(NSString*)login:(long long)uid {
    //调用app自身的服务器获取连接im服务必须的access token
    //    NSString *url = @"http://demo.gobelieve.io/auth/token";
    NSString * url = @"http://192.168.1.100:8010/course-im/auth/grant";
    NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]
                                                              cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                          timeoutInterval:60];
    
    
    [urlRequest setHTTPMethod:@"POST"];
    
    NSMutableDictionary *headers = [NSMutableDictionary dictionaryWithObject:@"application/json" forKey:@"Content-Type"];
    
    NSString * auth = [NSString stringWithFormat:@"Basic Nzo0NDk3NjBiMTIwNjEwYWMwYjNhYmRiZDk1NTI1NGVlMA=="];
    
    [headers setObject:auth forKey:@"Authorization"];
    
    [urlRequest setAllHTTPHeaderFields:headers];
    
    
    
#if TARGET_IPHONE_SIMULATOR
    NSString *deviceID = @"7C8A8F5B-E5F4-4797-8758-05367D2A4D61";
    NSLog(@"device id:%@", @"7C8A8F5B-E5F4-4797-8758-05367D2A4D61");
#else
    NSString *deviceID = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
    NSLog(@"device id:%@", [[[UIDevice currentDevice] identifierForVendor] UUIDString]);
#endif
    
    
    NSMutableDictionary *obj = [NSMutableDictionary dictionary];
    [obj setObject:[NSNumber numberWithLongLong:uid] forKey:@"uid"];
    [obj setObject:[NSString stringWithFormat:@"测试用户%lld", uid] forKey:@"user_name"];
    [obj setObject:[NSNumber numberWithInt:PLATFORM_IOS] forKey:@"platform_id"];
    [obj setObject:deviceID forKey:@"device_id"];
    
    NSData *postBody = [NSJSONSerialization dataWithJSONObject:obj options:0 error:nil];
    
    [urlRequest setHTTPBody:postBody];
    
    NSURLResponse *response = nil;
    
    NSError *error = nil;
    
    NSData *data = [NSURLConnection sendSynchronousRequest:urlRequest returningResponse:&response error:&error];
    if (error != nil) {
        NSLog(@"error:%@", error);
        return nil;
    }
    NSHTTPURLResponse *httpResp = (NSHTTPURLResponse*)response;
    if (httpResp.statusCode != 200) {
        return nil;
    }
    NSDictionary *e = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
    return [NSString stringWithFormat:@"%@", [e objectForKey:@"token"]];
    //    return [NSString stringWithFormat:@"%@",[[e objectForKey:@"body"] objectForKey:@"token"]];
}

+(NSString*)getDocumentPath {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *basePath = ([paths count] > 0) ? [paths objectAtIndex:0] : nil;
    return basePath;
}
#pragma mark - MessageViewControllerUserDelegate
//从本地获取用户信息, IUser的name字段为空时，显示identifier字段
+(IUser*)getUser:(int64_t)uid {
    IUser *u = [[IUser alloc] init];
    u.uid = uid;
    u.name = @"";
    u.avatarURL = @"http://api.gobelieve.io/images/e837c4c84f706a7988d43d62d190e2a1.png";
    u.identifier = [NSString stringWithFormat:@"uid:%lld", uid];
    return u;
}
//从服务器获取用户信息
+ (void)asyncGetUser:(int64_t)uid cb:(void(^)(IUser*))cb {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        IUser *u = [[IUser alloc] init];
        u.uid = uid;
        u.name = [NSString stringWithFormat:@"name:%lld", uid];
        u.avatarURL = @"http://api.gobelieve.io/images/e837c4c84f706a7988d43d62d190e2a1.png";
        u.identifier = [NSString stringWithFormat:@"uid:%lld", uid];
        dispatch_async(dispatch_get_main_queue(), ^{
            cb(u);
        });
    });
}
#pragma mark - MessageListViewControllerGroupDelegate
//从本地获取群组信息
+ (IGroup*)getGroup:(int64_t)gid {
    IGroup *g = [[IGroup alloc] init];
    g.gid = gid;
    g.name = @"";
    g.avatarURL = @"";
    g.identifier = [NSString stringWithFormat:@"gid:%lld", gid];
    return g;
}
//从服务器获取用户信息
+ (void)asyncGetGroup:(int64_t)gid cb:(void(^)(IGroup*))cb {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        IGroup *g = [[IGroup alloc] init];
        g.gid = gid;
        g.name = [NSString stringWithFormat:@"gname:%lld", gid];
        g.avatarURL = @"";
        g.identifier = [NSString stringWithFormat:@"gid:%lld", gid];
        dispatch_async(dispatch_get_main_queue(), ^{
            cb(g);
        });
    });
}
@end
