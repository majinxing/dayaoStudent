//
//  DYTabBarViewController.m
//  WisdomHall
//
//  Created by XTU-TI on 2017/4/24.
//  Copyright © 2017年 majinxing. All rights reserved.
//

#import "DYTabBarViewController.h"
#import "SignInViewController.h"
#import "MeetingViewController.h"
#import "PersonalCenterViewController.h"
#import "AllTheMeetingViewController.h"
#import "DYHeader.h"
#import "CourseListALLViewController.h"
//#import "OfficeViewController.h"
//#import "DiscussViewController.h"
//#import "OfficeViewController.h"
#import "NavBarNavigationController.h"

//#import <Hyphenate/Hyphenate.h>

//#import "ConversationVC.h"
#import "ChatHelper.h"

#import "AFNetworking/AFNetworking.h"

#import "MainViewController.h"
#import "MessageListViewController.h"
#import "GroupLoginViewController.h"

#import "HomePageViewController.h"

#import "IMTool.h"

#import "VoiceViewController.h"
#import "JPUSHService.h"

#import "IMHttpAPI.h"


#import "PeerMessageHandler.h"

#import "GroupMessageHandler.h"

#import "CustomerMessageHandler.h"

#import "CustomerMessageDB.h"

#import "CustomerOutbox.h"

#import "IMService.h"

#include <netdb.h>

#include <arpa/inet.h>

#include <netinet/in.h>

//#ifdef TEST_ROOM
#import "RoomLoginViewController.h"
//#elif defined TEST_GROUP
#import "GroupLoginViewController.h"
//#elif defined TEST_CUSTOMER
#import "CustomerViewController.h"
#import "CustomerManager.h"



@interface DYTabBarViewController ()<UIAlertViewDelegate>
@property (nonatomic,copy)NSString * url;
@property (nonatomic,strong) ChatHelper * chat;
@property (nonatomic,strong)UserModel *user;
@end

@implementation DYTabBarViewController
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
-(void)attempDealloc{
    predicate = 0;

}
    
    

/**
 *  单例初始化
 */
+(DYTabBarViewController *)sharedInstance{
    static DYTabBarViewController * sharedDYTabBarViewControllerInstance = nil;
    dispatch_once(&predicate, ^{
        sharedDYTabBarViewControllerInstance = [[self alloc] init];
    });
    return sharedDYTabBarViewControllerInstance;
}
- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    NavBarNavigationController * n = [NavBarNavigationController sharedInstance];
    
    [self addChildViewControllerWithClassname:[HomePageViewController description] imagename:@"home2" title:@"首页" withSelectImageName:@"home"];

    

    [self addChildViewControllerWithClassname:[MessageListViewController description] imagename:@"chat" title:@"消息" withSelectImageName:@"chat2"];
    
    [self addChildViewControllerWithClassname:[PersonalCenterViewController description] imagename:@"my" title:@"我的" withSelectImageName:@"my2"];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:InApp object:nil];

    [self selectApp];
    
   [[NSNotificationCenter defaultCenter] postNotificationName:@"stopTime" object:nil];
    
    [self IM:nil];
    
    _user = [[Appsetting sharedInstance] getUsetInfo];
//
    [IMTool IMLogin:[NSString stringWithFormat:@"%@",_user.peopleId]];


    
    // Do any additional setup after loading the view from its nib.
}

-(void)viewWillAppear:(BOOL)animated{

}
-(void)IM:(UIApplication *)application{
    
    
    _user = [[Appsetting sharedInstance] getUsetInfo];
    
    
    //app可以单独部署服务器，给予第三方应用更多的灵活性
    [IMHttpAPI instance].apiURL =  [NSString stringWithFormat:@"%@",_user.host];
    
    NSMutableString * strHost = [NSMutableString stringWithFormat:@"%@",_user.host];
    
 
    [strHost deleteCharactersInRange:NSMakeRange(0, 7)];
    
    NSArray * ary = [strHost componentsSeparatedByString:@":"];
    
    [IMService instance].host = ary[0];
    
    
    //    //app可以单独部署服务器，给予第三方应用更多的灵活性
    //        [IMHttpAPI instance].apiURL = @"http://api.gobelieve.io";
    //        [IMService instance].host = @"imnode2.gobelieve.io";
    
    //
    
#if TARGET_IPHONE_SIMULATOR
    NSString *deviceID = @"7C8A8F5B-E5F4-4797-8758-05367D2A4D61";
#else
    NSString *deviceID = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
#endif
    [IMService instance].deviceID = deviceID;
    NSLog(@"device id:%@", deviceID);
    
    [IMService instance].peerMessageHandler = [PeerMessageHandler instance];
    [IMService instance].groupMessageHandler = [GroupMessageHandler instance];
    [IMService instance].customerMessageHandler = [CustomerMessageHandler instance];
    
    [[IMService instance] startRechabilityNotifier];
    
    //    UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeAlert
    //                                                                                         | UIUserNotificationTypeBadge
    //                                                                                         | UIUserNotificationTypeSound) categories:nil];
    //    [application registerUserNotificationSettings:settings];
    
    
    [self refreshHost];
}
-(NSString*)IP2String:(struct in_addr)addr {
    char buf[64] = {0};
    const char *p = inet_ntop(AF_INET, &addr, buf, 64);
    if (p) {
        return [NSString stringWithUTF8String:p];
    }
    return nil;
    
}

-(NSString*)resolveIP:(NSString*)host {
    struct addrinfo hints;
    struct addrinfo *result, *rp;
    int s;
    
    char buf[32];
    snprintf(buf, 32, "%d", 0);
    
    memset(&hints, 0, sizeof(struct addrinfo));
    hints.ai_family = AF_INET;
    hints.ai_socktype = SOCK_STREAM;
    hints.ai_protocol = IPPROTO_TCP;
    hints.ai_flags = 0;
    
    s = getaddrinfo([host UTF8String], buf, &hints, &result);
    if (s != 0) {
        NSLog(@"get addr info error:%s", gai_strerror(s));
        return nil;
    }
    NSString *ip = nil;
    rp = result;
    if (rp != NULL) {
        struct sockaddr_in *addr = (struct sockaddr_in*)rp->ai_addr;
        ip = [self IP2String:addr->sin_addr];
    }
    freeaddrinfo(result);
    return ip;
}
-(void)refreshHost {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
        NSLog(@"refresh host ip...");
        
        for (int i = 0; i < 10; i++) {
            NSString *host = @"imnode.gobelieve.io";
            NSString *ip = [self resolveIP:host];
            
            NSString *apiHost = @"api.gobelieve.io";
            NSString *apiIP = [self resolveIP:apiHost];
            
            
            NSLog(@"host:%@ ip:%@", host, ip);
            NSLog(@"api host:%@ ip:%@", apiHost, apiIP);
            
            if (ip.length == 0 || apiIP.length == 0) {
                continue;
            } else {
                break;
            }
        }
    });
}
#pragma mark Alter
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if (alertView.tag == 2) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:_url]];
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"请更新最新版本" message:nil delegate:nil cancelButtonTitle:nil otherButtonTitles:nil];
        //        alertView.delegate = self;
        //        alertView.tag = 3;
        [alertView show];
    }else if(alertView.tag == 1){
        if (buttonIndex == 1) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:_url]];
        }
        
    }
    
}
/**
 *  添加子控制器
 *
 *  @param classname 类名字
 *  @param imagename tabbar图片名字
 *  @param title     tabbar文字
 */
- (void)addChildViewControllerWithClassname:(NSString *)classname
                                  imagename:(NSString *)imagename
                                      title:(NSString *)title withSelectImageName:(NSString *)selectName{
    //通过名字获取到类方法
    UIViewController *vc = [[NSClassFromString(classname) alloc] init];
    //设置导航
    NavBarNavigationController *nav = [[NavBarNavigationController alloc] initWithRootViewController:vc];
    //tabbar 显示文字
    nav.tabBarItem.title = title;
    //tabbar 普通状态下图片(图片保持原尺寸)
    nav.tabBarItem.image = [[UIImage imageNamed:imagename]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    //tabbar 选择状态下图片
    UIImage * i = [[Appsetting sharedInstance] grayscale:[UIImage imageNamed:selectName]];
  
    nav.tabBarItem.selectedImage = [i imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIColor * selectColor = [UIColor blackColor];//[[Appsetting sharedInstance] getThemeColor];
    //设置字体颜色（选中类型）
    [nav.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName:selectColor} forState:UIControlStateSelected];
    //设置字体颜色（普通类型）
    [nav.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor blackColor]} forState:UIControlStateNormal];
    [self addChildViewController:nav];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)selectApp{
    
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    
    //    CFShow((__bridge CFTypeRef)(infoDictionary));
    
    
    NSString *app_Version = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    NSString *app_build = [infoDictionary objectForKey:@"CFBundleVersion"];
    //    NSLog(@"%@-------%@",app_Version,app_build);
    
    NSDictionary * dict = [[NSDictionary alloc] initWithObjectsAndKeys:@"4",@"type", nil];
    [[NetworkRequest sharedInstance] GET:QueryApp dict:dict succeed:^(id data) {
        //        NSLog(@"%@",data);
        NSString * str = [[data objectForKey:@"body"] objectForKey:@"version"];
        NSString * q = [[data objectForKey:@"body"] objectForKey:@"isAutoUpdate"];
        
        if (![[NSString stringWithFormat:@"%@",str] isEqualToString:app_build]) {
            BOOL b =  [UIUtils compareTheVersionNumber:str withLocal:app_build];
            if (!b) {
                return ;
            }
            
            if ([[NSString stringWithFormat:@"%@",q] isEqualToString:@"0"]) {//0非强制更新
                _url = [[data objectForKey:@"body"] objectForKey:@"downloadUrl"];
                
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"请更新最新版本" message:nil delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
                alertView.delegate = self;
                alertView.tag = 1;
                [alertView show];
                
            }else{
                _url = [[data objectForKey:@"body"] objectForKey:@"downloadUrl"];
                if ([UIUtils isBlankString:_url]) {
                    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"请更新最新版本" message:nil delegate:nil cancelButtonTitle:nil otherButtonTitles:nil];
                    alertView.delegate = self;
                    alertView.tag = 3;
                    [alertView show];
                }else{
                    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"请更新最新版本" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
                    alertView.delegate = self;
                    alertView.tag = 2;
                    [alertView show];
                }
            }
            
        }
    } failure:^(NSError *error) {
        
    }];
}



/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
