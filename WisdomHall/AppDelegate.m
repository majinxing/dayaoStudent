//
//  AppDelegate.m
//  WisdomHall
//
//  Created by XTU-TI on 2017/4/24.
//  Copyright © 2017年 majinxing. All rights reserved.
//

#import "AppDelegate.h"
#import "DYTabBarViewController.h"
#import "TheLoginViewController.h"
#import <Hyphenate/Hyphenate.h>
#import "ChatHelper.h"
#import "ConversationVC.h"
#import <SystemConfiguration/CaptiveNetwork.h>
#import "DYHeader.h"
#import "NoticeViewController.h"
#import "FMDBTool.h"
#import "WorkingLoginViewController.h"

#import <Bugly/Bugly.h>
#import "JSMSSDK.h"
#import "JSMSConstant.h"

// 引入JPush功能所需头文件
#import "JPUSHService.h"
// iOS10注册APNs所需头文件
#ifdef NSFoundationVersionNumber_iOS_9_x_Max

#import <UserNotifications/UserNotifications.h>

#endif

// 如果需要使用idfa功能所需要引入的头文件（可选）
#import <AdSupport/AdSupport.h>


@interface AppDelegate ()<EMCallManagerDelegate,EMChatManagerDelegate,EMChatroomManagerDelegate,JPUSHRegisterDelegate>
@property(nonatomic,strong)ChatHelper * chat;
@property (nonatomic,strong)FMDatabase * db;

@end

@implementation AppDelegate

-(void)dealloc{
    
    //移除消息回调
    [[EMClient sharedClient].chatManager removeDelegate:self];
}
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    [Bugly startWithAppId:@"64f1536e43"];//用于崩溃统计
    

    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    
    
    if ([[Appsetting sharedInstance] isLogin]) {
        _chat = [ChatHelper shareHelper];
        DYTabBarViewController * tab = [[DYTabBarViewController alloc] init];
        self.window.rootViewController = tab;
    }else{
        WorkingLoginViewController * loginVC = [[WorkingLoginViewController alloc] init];
//        TheLoginViewController * loginVC = [[TheLoginViewController alloc] init];
        self.window.rootViewController = [[UINavigationController alloc]initWithRootViewController:loginVC];
    }

    // iOS8之后和之前应区别对待
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeBadge | UIUserNotificationTypeAlert | UIUserNotificationTypeSound categories:nil];
        [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
    } else {
        [application registerForRemoteNotificationTypes:UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeBadge | UIUserNotificationTypeSound];
    }
    
    
    //Required
    //notice: 3.0.0及以后版本注册可以这样写，也可以继续用之前的注册方式
    JPUSHRegisterEntity * entity = [[JPUSHRegisterEntity alloc] init];
    entity.types = JPAuthorizationOptionAlert|JPAuthorizationOptionBadge|JPAuthorizationOptionSound;
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
        // 可以添加自定义categories
        // NSSet<UNNotificationCategory *> *categories for iOS10 or later
        // NSSet<UIUserNotificationCategory *> *categories for iOS8 and iOS9
    }
    [JPUSHService registerForRemoteNotificationConfig:entity delegate:self];
    

    NSString *advertisingId = [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];
    
    // Required
    // init Push
    // notice: 2.1.5版本的SDK新增的注册方法，改成可上报IDFA，如果没有使用IDFA直接传nil
    // 如需继续使用pushConfig.plist文件声明appKey等配置内容，请依旧使用[JPUSHService setupWithOption:launchOptions]方式初始化。
    [JPUSHService setupWithOption:launchOptions appKey:@"c8372310b33f2ddd74fcaead"
                          channel:@"App Store"
                 apsForProduction:1
            advertisingIdentifier:advertisingId];
    
    [JSMSSDK registerWithAppKey:@"c8372310b33f2ddd74fcaead"];//极光短信注册
    return YES;
}
-(void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken{
    /// Required - 注册 DeviceToken
    [JPUSHService registerDeviceToken:deviceToken];
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    //Optional
    NSLog(@"did Fail To Register For Remote Notifications With Error: %@", error);
}

-(void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification{
    
    NoticeViewController * n = [[NoticeViewController alloc] init];
    _chat = [ChatHelper shareHelper];
    n.backType = @"TabBar";
    self.window.rootViewController = [[UINavigationController alloc]initWithRootViewController:n];
    
        NSLog(@"%s",__func__);
    
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    
    // Required,For systems with less than or equal to iOS6
    [JPUSHService handleRemoteNotification:userInfo];
}

- (void)applicationWillResignActive:(UIApplication *)application {
    [application setApplicationIconBadgeNumber:0];
    [application cancelAllLocalNotifications];
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    [[EMClient sharedClient] applicationDidEnterBackground:application];
    _chat.outOrIn = @"out";
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    [[EMClient sharedClient] applicationWillEnterForeground:application];
    _chat.outOrIn = @"In";
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}
#pragma mark- JPUSHRegisterDelegate
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(NSInteger))completionHandler {
    
    NSDictionary * userInfo = notification.request.content.userInfo;
    
    UNNotificationRequest *request = notification.request; // 收到推送的请求
    
    UNNotificationContent *content = request.content; // 收到推送的消息内容
    
    NSNumber *badge = content.badge;  // 推送消息的角标
    NSString *body = content.body;    // 推送消息体
    UNNotificationSound *sound = content.sound;  // 推送消息的声音
    NSString *subtitle = content.subtitle;  // 推送消息的副标题
    NSString *title = content.title;  // 推送消息的标题
    
    if([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [JPUSHService handleRemoteNotification:userInfo];
        NSLog(@"iOS10 前台收到远程通知:%@", [self logDic:userInfo]);
        
        
    }
    else {
        // 判断为本地通知
        NSLog(@"iOS10 前台收到本地通知:{\nbody:%@，\ntitle:%@,\nsubtitle:%@,\nbadge：%@，\nsound：%@，\nuserInfo：%@\n}",body,title,subtitle,badge,sound,userInfo);
    }
    NoticeViewController * n = [[NoticeViewController alloc] init];
    _chat = [ChatHelper shareHelper];
    n.backType = @"TabBar";
    self.window.rootViewController = [[UINavigationController alloc]initWithRootViewController:n];
    
    completionHandler(UNNotificationPresentationOptionBadge|UNNotificationPresentationOptionSound|UNNotificationPresentationOptionAlert); // 需要执行这个方法，选择是否提醒用户，有Badge、Sound、Alert三种类型可以设置
}


- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)())completionHandler {
    
    NSDictionary * userInfo = response.notification.request.content.userInfo;
    UNNotificationRequest *request = response.notification.request; // 收到推送的请求
    UNNotificationContent *content = request.content; // 收到推送的消息内容
    
    NSNumber *badge = @1;  // 推送消息的角标
    NSString *body = content.body;    // 推送消息体
    UNNotificationSound *sound = content.sound;  // 推送消息的声音
    NSString *subtitle = content.subtitle;  // 推送消息的副标题
    NSString *title = content.title;  // 推送消息的标题
    
    if([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [JPUSHService handleRemoteNotification:userInfo];
        NSLog(@"iOS10 收到远程通知:%@", [self logDic:userInfo]);
//        [rootViewController addNotificationCount];
        
    }
    else {
        // 判断为本地通知
        NSLog(@"iOS10 收到本地通知:{\nbody:%@，\ntitle:%@,\nsubtitle:%@,\nbadge：%@，\nsound：%@，\nuserInfo：%@\n}",body,title,subtitle,badge,sound,userInfo);
    }
    
    completionHandler();  // 系统要求执行这个方法
}
//前台运行时接受推送信息 app未杀死，从前台转后台会走
- (void)application:(UIApplication *)application
didReceiveRemoteNotification:(NSDictionary *)userInfo
fetchCompletionHandler:
(void (^)(UIBackgroundFetchResult))completionHandler {
    
    [JPUSHService handleRemoteNotification:userInfo];
    
    NSString * strUrl = [[userInfo objectForKey:@"aps"] objectForKey:@"alert"];
    
    NSString * time = [UIUtils getTime];
    
    [self insertedIntoNoticeTable:time noticeContent:strUrl];
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:strUrl message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
    
    [alertView show];

    NSLog(@"iOS7及以上系统，收到通知:%@", [self logDic:userInfo]);
    
    if ([[UIDevice currentDevice].systemVersion floatValue]<10.0 || application.applicationState>0) {
    }
    
    completionHandler(UIBackgroundFetchResultNewData);
    
}
// log NSSet with UTF8
// if not ,log will be \Uxxx
- (NSString *)logDic:(NSDictionary *)dic {
    if (![dic count]) {
        return nil;
    }
    NSString *tempStr1 =
    [[dic description] stringByReplacingOccurrencesOfString:@"\\u"
                                                 withString:@"\\U"];
    NSString *tempStr2 =
    [tempStr1 stringByReplacingOccurrencesOfString:@"\"" withString:@"\\\""];
    NSString *tempStr3 =
    [[@"\"" stringByAppendingString:tempStr2] stringByAppendingString:@"\""];
    NSData *tempData = [tempStr3 dataUsingEncoding:NSUTF8StringEncoding];
    NSString *str =
    [NSPropertyListSerialization propertyListFromData:tempData
                                     mutabilityOption:NSPropertyListImmutable
                                               format:NULL
                                     errorDescription:NULL];
    return str;
}
#pragma mark FMDB
-(void)insertedIntoNoticeTable:(NSString *)noticeTime noticeContent:(NSString *)content{
    
    _db = [FMDBTool createDBWithName:SQLITE_NAME];
    
    [self creatTextTable:NOTICE_TABLE_NAME];
    
    if ([_db open]) {
        NSString * sql = [NSString stringWithFormat:@"insert into %@ (noticeTime, noticeContent) values ('%@', '%@')",NOTICE_TABLE_NAME,noticeTime,content];
        
        BOOL rs = [FMDBTool insertWithDB:_db tableName:NOTICE_TABLE_NAME withSqlStr:sql];
        
        if (!rs) {
            NSLog(@"失败");
        }
        
    }
    [_db close];
}
-(void)creatTextTable:(NSString *)tableName{
    if ([_db open]) {
        BOOL result = [FMDBTool createTableWithDB:_db tableName:tableName
                                       parameters:@{
                                                    @"noticeTime" : @"text",
                                                    @"noticeContent" : @"text",
                                                    }];
        if (result)
        {
            NSLog(@"建表成功");
        }
        else
        {
            NSLog(@"建表失败");
        }
    }
    [_db close];
}
@end
