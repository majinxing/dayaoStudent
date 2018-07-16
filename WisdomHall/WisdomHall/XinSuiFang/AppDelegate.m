//
//  AppDelegate.m
//  XinSuiFang
//
//  Created by majinxing on 16/8/9.
//  Copyright © 2016年 majinxing. All rights reserved.
//

#import "AppDelegate.h"
#import "MJXRootViewController.h"
#import "MJXUserLoginViewController.h"
#import "MJXAppsettings.h"
#import "Utils.h"
#import "MJXTabBarController.h"
#import <RongIMLib/RongIMLib.h>

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) { // iOS8
        UIUserNotificationSettings *setting = [UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeBadge | UIUserNotificationTypeAlert | UIUserNotificationTypeSound categories:nil];
        [application registerUserNotificationSettings:setting];
    }
    
    if (launchOptions[UIApplicationLaunchOptionsLocalNotificationKey]) {
        NSLog(@"这里添加处理码");
        // 这里添加处理代码
    }
    
    
    //融云注册
    [[RCIMClient sharedRCIMClient] initWithAppKey:@"c9kqb3rdkbrkj"];
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    //self.window.rootViewController =[MJXRootViewController sharedInstance];
    
    //判断是否登录，没有则跳转登录页面
    if([[MJXAppsettings sharedInstance] isLogin])
    {
        MJXTabBarController *tabbar = [MJXTabBarController sharedInstance];
        self.window.rootViewController = tabbar;
        //self.window.rootViewController =[MJXRootViewController sharedInstance];
    }else{
     MJXUserLoginViewController *loginVc = [[MJXUserLoginViewController alloc]init];
        self.window.rootViewController= [[UINavigationController alloc]initWithRootViewController:loginVc];//
    }
    return YES;
}
/// 程序没有被杀死（处于前台或后台），点击通知后会调用此程序
- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification {
    NSLog(@"前后台");
    // 这里添加处理代码
}
- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
