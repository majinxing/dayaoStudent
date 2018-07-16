//
//  MJXRootViewController.m
//  XinSuiFang
//
//  Created by majinxing on 16/8/9.
//  Copyright © 2016年 majinxing. All rights reserved.
//

#import "MJXRootViewController.h"
#import "AppDelegate.h"
#import "Utils.h"
#define SELECTED_VIEW_CONTROLLER_TAG 9000001

@interface MJXRootViewController ()
//@property(nonatomic,strong)static MJXRootViewController *_sharedInstance;
@end

@implementation MJXRootViewController

//单例初始化
+ (MJXRootViewController *)sharedInstance
{
    static MJXRootViewController *_sharedInstance = nil;
    @synchronized(self)
    {
        if (_sharedInstance == nil)
            _sharedInstance = [[MJXRootViewController alloc] init];
    }
    return _sharedInstance;
}
- (void)_setTabbarView
{
    self.myPatientsVC = [[MJXMyPatientsViewController alloc] init];
    self.myPatientsVC.viewIndex = ETabBarItemTypeHomeRecommend;
    
    self.consultingVC = [[MJXConsultingViewController alloc] init];
    self.consultingVC.viewIndex = ETabBarItemTypeConsulting;
    
    self.followUpVC = [[MJXFollowUpViewController alloc] init];
    self.followUpVC.viewIndex = ETabBarItemTypeFollowUp;
    
    self.personalCenterVC = [[MJXPersonalCenterViewController alloc] init];
    self.personalCenterVC.viewIndex = ETabBarItemTypePersonalCenter;
    
     self.tabViewControllersArray = [NSArray arrayWithObjects:self.myPatientsVC, self.consultingVC, self.followUpVC, self.personalCenterVC, nil];
}

- (void)_initMainViewController
{
    self.mainViewController = [[UIViewController alloc]init];
    UIView *mainView = [[UIView alloc]initWithFrame:MAIN_SCREEN_FRAME];
    mainView.backgroundColor = [UIColor colorWithHexString:@"#F8F8F8" alpha:1.0f];
    self.mainViewController.view = mainView;
    
    self.mainNavViewController = [[MJXNavigationController alloc] initWithRootViewController:self.mainViewController];
    self.mainNavViewController.navigationBarHidden = YES;
    self.mainNavViewController.delegate = self;
    [self addChildViewController:self.mainNavViewController];//View Controller中可以添加多个sub view，在需要的时候显示出来；可以通过viewController(parent)中可以添加多个child viewController;来控制页面中的sub view，降低代码耦合度； 通过切换，可以显示不同的view；，替代之前的addSubView的管理
    [self.view addSubview:self.mainNavViewController.view];
    
    
}
- (void)_initTabbarItems
{
    
    MJXTabbarView *homeTabBar = [[MJXTabbarView alloc] initWithFrame:CGRectMake(0.0f, APPLICATION_HEIGHT - TAB_BAR_HEIGHT, APPLICATION_WIDTH, TAB_BAR_HEIGHT)];
    
    homeTabBar.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleWidth;
    self.rootHomePageTabBar = homeTabBar;
    MJXTabbarItem *homeRecommend = [[MJXTabbarItem alloc] initWithTitle:@"我的患者"
                                                                image:[UIImage imageNamed:@"gray-patient"]
                                                        selectedImage:[UIImage imageNamed:@"patient"]
                                                                  tag:ETabBarItemTypeHomeRecommend];
    MJXTabbarItem *ppenClasses = [[MJXTabbarItem alloc] initWithTitle:@"最近咨询"
                                                              image:[UIImage imageNamed:@"tab-courses-icon"]
                                                      selectedImage:[UIImage imageNamed:@"tab-courses-icon-selected"]
                                                                tag:ETabBarItemTypeConsulting];
    MJXTabbarItem *practise = [[MJXTabbarItem alloc] initWithTitle:@"随访计划"
                                                           image:[UIImage imageNamed:@"tab-home-icon"]
                                                   selectedImage:[UIImage imageNamed:@"tab-home-icon-selected"]
                                                             tag:ETabBarItemTypeFollowUp];
    MJXTabbarItem *personalCenter = [[MJXTabbarItem alloc] initWithTitle:@"我"
                                                                 image:[UIImage imageNamed:@"gray-ME"]
                                                         selectedImage:[UIImage imageNamed:@"gray-ME-拷贝"]
                                                                   tag:ETabBarItemTypePersonalCenter];
    self.rootHomePageTabBar.tabItems = [NSArray arrayWithObjects:homeRecommend, ppenClasses, practise, personalCenter, nil];
    self.rootHomePageTabBar.delegate = self;
    
    [self.mainViewController.view addSubview:self.rootHomePageTabBar];
}
- (void)_setInitFirstTabView
{
    if (self.tabViewControllersArray && [self.tabViewControllersArray count] > 0)
    {
        UIViewController *initViewController = [self.tabViewControllersArray objectAtIndex:0];
        initViewController.view.tag = SELECTED_VIEW_CONTROLLER_TAG;
        
        // 导航容器
        
        [self.mainViewController.view insertSubview:initViewController.view belowSubview:self.rootHomePageTabBar];
    }
}
-(void) initPerson
{
//    if ([TTAppsettings sharedInstance].isLogin)
//    {
//        TTUserModel *user;
//        user=[[TTAppsettings sharedInstance]getUserInfo];
//        
//        self.person = [TTPersonPortalData new];
//        
//        self.person.user_id = [[NSString alloc] initWithString: user.userid];
//        self.person.user_nickname = [[NSString alloc] initWithString: user.userName];
//        self.person.user_portalurl = [[NSString alloc] initWithString: user.userHeaderImagePath];
//        self.person.vip=[[NSString alloc] initWithString:user.vip];
//        self.person.user_isteacher = [[NSString alloc] initWithString:user.is_teacher];
//        if(CHECK_STRING_VALID(user.userdesc))
//            self.person.user_description = [[NSString alloc] initWithString:user.userdesc];
//    }
}

- (void)tabBar:(MJXTabbarView *)tabBar didSelectItem:(MJXTabbarItem *)item
{
    if (tabBar.selectedItem != item)
    {
        [self didSelectTab:(MJXTabbarItemType)item.tag];
    }
}

- (void)didSelectTab:(MJXTabbarItemType)barItemType
{
    UIViewController *selectViewController = [self.tabViewControllersArray objectAtIndex:barItemType];
    
    if (barItemType == [self currentTabType]) return;
    
    UIView *currentView = [self.view viewWithTag:SELECTED_VIEW_CONTROLLER_TAG];
    [currentView removeFromSuperview];
    
    switch (barItemType)
    {
        case ETabBarItemTypeHomeRecommend:
        {
            selectViewController.view.tag = SELECTED_VIEW_CONTROLLER_TAG;
            [self.mainViewController.view insertSubview:selectViewController.view belowSubview:self.rootHomePageTabBar];
            
            break;
        }
        case ETabBarItemTypeConsulting:
        {
            selectViewController.view.tag = SELECTED_VIEW_CONTROLLER_TAG;
            [self.mainViewController.view insertSubview:selectViewController.view belowSubview:self.rootHomePageTabBar];
            
            break;
        }
        case ETabBarItemTypeFollowUp:
        {
            
            
            selectViewController.view.tag = SELECTED_VIEW_CONTROLLER_TAG;
            [self.mainViewController.view insertSubview:selectViewController.view belowSubview:self.rootHomePageTabBar];
            
        }
        case ETabBarItemTypePersonalCenter:
        {
            selectViewController.view.tag = SELECTED_VIEW_CONTROLLER_TAG;
            [self.mainViewController.view insertSubview:selectViewController.view belowSubview:self.rootHomePageTabBar];
            break;
        }
        default:
            break;
    }
    
    //    [[NSNotificationCenter defaultCenter] postNotificationName:NotificationTTRootTabBarDidChanged object:nil userInfo:@{NotificationTTRootTabBarKeyViewIndex:[NSNumber numberWithUnsignedInteger:barItemType]}];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self setNeedsStatusBarAppearanceUpdate];
    });
}
- (MJXTabbarItemType)currentTabType
{
    MJXTabbarItem *currentItem = self.rootHomePageTabBar.selectedItem;
    return (MJXTabbarItemType)currentItem.tag;
}
- (void)rootVCHideTabbarWithAnimation
{
    [UIView animateWithDuration:0.333 animations:^{
        CGRect frame = self.rootHomePageTabBar.frame;
        frame.origin.y = APPLICATION_HEIGHT;
        self.rootHomePageTabBar.frame = frame;
       // self.rootHomePageTabBar.top = APPLICATION_HEIGHT;
    } completion:^(BOOL finished) {
        
    }];
}
- (void)rootVCShowTabbarWithAnimation
{
    [UIView animateWithDuration:0.4 animations:^{
        CGRect frame = self.rootHomePageTabBar.frame;
        frame.origin.y = APPLICATION_HEIGHT-TAB_BAR_HEIGHT;
        self.rootHomePageTabBar.frame = frame;
       // self.rootHomePageTabBar.top = APPLICATION_HEIGHT-TAB_BAR_HEIGHT;
    } completion:^(BOOL finished) {
        
    }];
}
- (void)hideTabbar
{
    self.rootHomePageTabBar.hidden = YES;
}
- (void) loadUI
{
    self.view.exclusiveTouch = YES;
    [self _initMainViewController];
    [self _initTabbarItems];
    [self _setTabbarView];
    [self _setInitFirstTabView];
}
-(void)loadView{
    [super loadView];
    //[self initPerson];
    //[self loadUI];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
-(void)viewWillAppear:(BOOL)animated{
    //[self loadView];
    
    [self initPerson];
    [self loadUI];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)resumeTabbar
{
    CGRect frame = self.rootHomePageTabBar.frame;
    frame.origin.y =  APPLICATION_HEIGHT-TAB_BAR_HEIGHT;
    self.rootHomePageTabBar.frame = frame;
//    self.rootHomePageTabBar.top = APPLICATION_HEIGHT-TAB_BAR_HEIGHT;
    self.rootHomePageTabBar.hidden = NO;
}

- (void)updateStatusBarAppearance
{
    [self setNeedsStatusBarAppearanceUpdate];
}

#pragma mark - NavigationControllerDelegate Methods

- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    // 界面展示后设置滑动返回手势可用
    if ([self.mainNavViewController respondsToSelector:@selector(interactivePopGestureRecognizer)])
    {
        // 在二级(或更高)页面时, 可使用返回手势
        self.mainNavViewController.interactivePopGestureRecognizer.enabled = YES;
    }
}

#pragma mark UIAlertViewDelegate
- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (UIViewController *)childViewControllerForStatusBarStyle
{
    if (_mainNavViewController.viewControllers.count >= 2)
    {
        return _mainNavViewController.topViewController;
    }
    else
    {
        MJXTabbarItemType currentTab = [self currentTabType];
        UIViewController *currentVC = nil;
        switch (currentTab) {
            case ETabBarItemTypeHomeRecommend:
                currentVC = self.myPatientsVC;
                break;
            case ETabBarItemTypeConsulting:
                currentVC = self.consultingVC;
                break;
            case ETabBarItemTypeFollowUp:
                currentVC = self.followUpVC;
                break;
            case ETabBarItemTypePersonalCenter:
                currentVC = self.personalCenterVC;
                break;
            default:
                break;
        }
        return currentVC;
    }
    return 0;
}

- (UIViewController *)childViewControllerForStatusBarHidden
{
    if (_mainNavViewController.viewControllers.count >= 2)
    {
        return _mainNavViewController.topViewController;
    }
    else
    {
        MJXTabbarItemType currentTab = [self currentTabType];
        UIViewController *currentVC = nil;
        switch (currentTab) {
            case ETabBarItemTypeHomeRecommend:
                currentVC = self.myPatientsVC;
                break;
            case ETabBarItemTypeConsulting:
                currentVC = self.consultingVC;
                break;
            case ETabBarItemTypeFollowUp:
                currentVC = self.followUpVC;
                break;
            case ETabBarItemTypePersonalCenter:
                currentVC = self.personalCenterVC;
                break;
            default:
                break;
        }
        return currentVC;
    }
    return 0;
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
