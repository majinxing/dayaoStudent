//
//  NavBarNavigationController.m
//  WisdomHall
//
//  Created by XTU-TI on 2018/3/14.
//  Copyright © 2018年 majinxing. All rights reserved.
//

#import "NavBarNavigationController.h"
#import "DYHeader.h"
#import <CoreLocation/CoreLocation.h>
#import "JPUSHService.h"
#import "VoiceViewController.h"
#import "DYTabBarViewController.h"

@interface NavBarNavigationController ()<MessageViewControllerUserDelegate>
@property (nonatomic,strong)NSDictionary * dict;
@end
@implementation NavBarNavigationController

+(NavBarNavigationController *)sharedInstance{
    static dispatch_once_t predicate;
    
    static NavBarNavigationController * sharedDYTabBarViewControllerInstance = nil;
    dispatch_once(&predicate, ^{
        sharedDYTabBarViewControllerInstance = [[self alloc] init];
        
        [[NSNotificationCenter defaultCenter]
         addObserver:sharedDYTabBarViewControllerInstance
         selector:@selector(networkDidReceiveMessage:)
         name:kJPFNetworkDidReceiveMessageNotification object:nil];
        
        [[NSNotificationCenter defaultCenter]
         addObserver:sharedDYTabBarViewControllerInstance
         selector:@selector(setColor)
         name:ThemeColorChangeNotification object:nil];
        
        [[NSNotificationCenter defaultCenter]
         addObserver:sharedDYTabBarViewControllerInstance
         selector:@selector(inApp)
         name:InApp object:nil];
        
        [[NSNotificationCenter defaultCenter]
         addObserver:sharedDYTabBarViewControllerInstance
         selector:@selector(outApp)
         name:OutApp object:nil];
        
        [[NSNotificationCenter defaultCenter]
         addObserver:sharedDYTabBarViewControllerInstance
         selector:@selector(stopTime)
         name:@"stopTime" object:nil];
    });
    return sharedDYTabBarViewControllerInstance;
}
-(void)setColor{
    self.navigationBar.barTintColor = [UIColor whiteColor];// [[ThemeTool shareInstance] getThemeColor];
}
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (void)viewDidLoad {
    self.navigationBar.barTintColor = [UIColor whiteColor]; //[[ThemeTool shareInstance] getThemeColor];
    self.navigationBar.tintColor = [UIColor blackColor];
    
    [self.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:17],NSForegroundColorAttributeName:[UIColor blackColor]}];
    
    
}
- (void)networkDidReceiveMessage:(NSNotification *)notification {
    
    NSDictionary * userInfo = [notification userInfo];
    
    NSString * strIM = [userInfo objectForKey:@"content_type"];
    
    if ([strIM isEqualToString:@"im"]) {
        
        NSError * err;
        
        NSString *content = [userInfo valueForKey:@"content"];
        
        NSData *jsonData = [content dataUsingEncoding:NSUTF8StringEncoding];
        
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&err];
        
        UserModel * user = [[Appsetting sharedInstance] getUsetInfo];
        
        VoiceViewController* msgController = [[VoiceViewController alloc] init];
        
        //        NSString * strq = [NSString stringWithUTF8String:object_getClassName(msgController)];
        //        if( strq == @"VoiceViewController"){
        //                NSLog(@"%s",__func__);
        //        }
        
        msgController.userDelegate = self;
        
        NSString * str = [NSString stringWithFormat:@"%@",[dic objectForKey:@"teacherIM"]];
        
        NSString * str1 = [NSString stringWithFormat:@"%@",user.peopleId];
        
        msgController.peerUID = [str integerValue];//con.cid;@"5012012551319";//
        
        msgController.peerName = [NSString stringWithFormat:@"%@",[dic objectForKey:@"teacherName"]];//con.name;
        
        msgController.currentUID = [str1 integerValue];
        
        //        msgController.backType = @"TabBar";
        
        msgController.hidesBottomBarWhenPushed = YES;
        
        DYTabBarViewController * root = (DYTabBarViewController *)[UIApplication sharedApplication].keyWindow.rootViewController;
        
        if ([root isKindOfClass:[UITabBarController class]]) {//判断是否是当前根视图
            
            UINavigationController *nav = root.selectedViewController;//获取到当前视图的导航视图
            
            [nav.topViewController.navigationController pushViewController:msgController animated:YES];//获取当前跟视图push到的最高视图层,然后进行push到目的页面
            
        }
        //        [self.navigationController pushViewController:msgController animated:ye];
        
        //        [UIApplication sharedApplication].keyWindow.rootViewController = [[UINavigationController alloc]initWithRootViewController:msgController];
        
        NSDictionary * dict = [[NSDictionary alloc] initWithObjectsAndKeys:[NSString stringWithFormat:@"%@",[dic objectForKey:@"relObjectDetailID"]],@"relDetailId",[NSString stringWithFormat:@"%@",[dic objectForKey:@"relObjectType"]],@"relType",nil];
        
        [[NetworkRequest sharedInstance] POST:StudentReply dict:dict succeed:^(id data) {
            
        } failure:^(NSError *error) {
            
        }];
    }
}
#pragma mark - MessageViewControllerUserDelegate
//从本地获取用户信息, IUser的name字段为空时，显示identifier字段
- (IUser*)getUser:(int64_t)uid {
    IUser *u = [[IUser alloc] init];
    u.uid = uid;
    u.name = @"";
    u.avatarURL = @"http://api.gobelieve.io/images/e837c4c84f706a7988d43d62d190e2a1.png";
    u.identifier = [NSString stringWithFormat:@"uid:%lld", uid];
    return u;
}
//从服务器获取用户信息
- (void)asyncGetUser:(int64_t)uid cb:(void(^)(IUser*))cb {
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
-(void)stopTime{
    
    [[NavBarNavigationController sharedInstance].showTimer invalidate];
    
    [NavBarNavigationController sharedInstance].showTimer = nil;
    
    [self outApp];
}
-(void)inApp{
    //时间间隔
    NSTimeInterval timeInterval = 25;
    if (![NavBarNavigationController sharedInstance].showTimer) {
        //定时器
        [NavBarNavigationController sharedInstance].showTimer = [NSTimer scheduledTimerWithTimeInterval:timeInterval
                                                                                                 target:self
                                                                                               selector:@selector(handleMaxShowTimer:)
                                                                                               userInfo:nil
                                                                                                repeats:YES];
    }
    
    
    [[NavBarNavigationController sharedInstance].showTimer fire];
}
-(void)handleMaxShowTimer:(NSTimer *)theTimer{
    
    UserModel * user = [[Appsetting sharedInstance] getUsetInfo];
    
    if (![UIUtils isBlankString:user.peopleId]) {
        
        NSDictionary * dict = @{@"appState":@"1",@"id":[NSString stringWithFormat:@"%@",user.peopleId]};
        
        [[NetworkRequest sharedInstance] POST:ChangeAppState dict:dict succeed:^(id data) {
            //            NSLog(@"%@",data);
            NSString * str = [NSString stringWithFormat:@"%@",[[data objectForKey:@"header"] objectForKey:@"code"]];
            if ([str isEqualToString:@"401"]) {
                //                [[NavBarNavigationController sharedInstance].showTimer invalidate];
            }
        } failure:^(NSError *error) {
            
        }];
    }
}
-(void)outApp{
    
    UserModel * user = [[Appsetting sharedInstance] getUsetInfo];
    
    [[NavBarNavigationController sharedInstance].showTimer invalidate];
    
    [NavBarNavigationController sharedInstance].showTimer = nil;
    
    if (![UIUtils isBlankString:user.peopleId]) {
        
        NSDictionary * dict = @{@"appState":@"3",@"id":[NSString stringWithFormat:@"%@",user.peopleId]};
        
        [[NetworkRequest sharedInstance] POST:ChangeAppState dict:dict succeed:^(id data) {
            //            NSLog(@"%@",data);
        } failure:^(NSError *error) {
            
        }];
    }
    
}
@end
