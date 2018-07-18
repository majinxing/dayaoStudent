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
#import "TheMessageViewController.h"
#import "OfficeViewController.h"
#import "DiscussViewController.h"
#import "OfficeViewController.h"
#import "NavBarNavigationController.h"
#import <Hyphenate/Hyphenate.h>
#import "ConversationVC.h"
#import "ChatHelper.h"

#import "AFNetworking/AFNetworking.h"

#import "MainViewController.h"
#import "MessageListViewController.h"
#import "GroupLoginViewController.h"

#import "HomePageViewController.h"

#import "IMTool.h"

static dispatch_once_t predicate;

@interface DYTabBarViewController ()<UIAlertViewDelegate>
@property (nonatomic,copy)NSString * url;
@property (nonatomic,strong) ChatHelper * chat;
@property (nonatomic,strong)UserModel *user;
@end

@implementation DYTabBarViewController
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
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
    
//    [self addChildViewControllerWithClassname:[OfficeViewController description] imagename:@"办公_normal" title:@"首页" withSelectImageName:@"办公"];
//    HomePageViewController
    [self addChildViewControllerWithClassname:[HomePageViewController description] imagename:@"home2" title:@"首页" withSelectImageName:@"home"];

//    [self addChildViewControllerWithClassname:[SignInViewController description] imagename:@"课程(1)" title:@"课程" withSelectImageName:@"课程"];
    
//    [self addChildViewControllerWithClassname:[MainViewController description] imagename:@"chat" title:@"消息" withSelectImageName:@"chat2"];

    [self addChildViewControllerWithClassname:[MessageListViewController description] imagename:@"chat" title:@"消息" withSelectImageName:@"chat2"];
    
    [self addChildViewControllerWithClassname:[PersonalCenterViewController description] imagename:@"my" title:@"我的" withSelectImageName:@"my2"];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:InApp object:nil];
//    // 1.注册通知
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(voiceCalls:) name:@"VoiceCalls" object:nil];

    [self selectApp];
    
    _user = [[Appsetting sharedInstance] getUsetInfo];
    
    [IMTool IMLogin:[NSString stringWithFormat:@"%@%@",_user.school,_user.studentId]];


    // Do any additional setup after loading the view from its nib.
}
-(void)viewWillAppear:(BOOL)animated{
    _chat = [ChatHelper shareHelper];

    [_chat getOut];
    
    _chat = [ChatHelper shareHelper];
}
-(void)voiceCalls:(NSNotification *)dict{
    EMCallSession * aSession = [dict.userInfo objectForKey:@"session"];
    ConversationVC * c  = [[ConversationVC alloc] init];
    c.callSession = aSession;
    UserModel * user = [[Appsetting sharedInstance] getUsetInfo];
    
    int n = (int)[NSString stringWithFormat:@"%@",user.school].length;
    
    NSMutableString * str = [NSMutableString stringWithFormat:@"%@",aSession.remoteName];
    [str deleteCharactersInRange:NSMakeRange(0,n)];
    c.teacherName = str;
    c.call = CALLED;
    self.hidesBottomBarWhenPushed = YES;
    [self presentViewController:c animated:YES completion:^{
        
    }];
//    [self.navigationController pushViewController:c animated:YES];
    //    调用:
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
