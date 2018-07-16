//
//  MJXRootViewController.h
//  XinSuiFang
//
//  Created by majinxing on 16/8/9.
//  Copyright © 2016年 majinxing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MJXNavigationController.h"
#import "MJXTabbarView.h"
#import "MJXMyPatientsViewController.h"
#import "MJXConsultingViewController.h"
#import "MJXFollowUpViewController.h"
#import "MJXPersonalCenterViewController.h"
@interface MJXRootViewController : UIViewController<UINavigationControllerDelegate,UIGestureRecognizerDelegate,MJXTaBarDelegate>
@property (nonatomic,strong)MJXTabbarView *rootHomePageTabBar;
@property (nonatomic,strong)NSArray *tabViewControllersArray;
@property (nonatomic, strong) MJXNavigationController *mainNavViewController; // 主框架导航容器
@property (nonatomic,strong)UIViewController *mainViewController;
@property (nonatomic,strong)MJXMyPatientsViewController *myPatientsVC;
@property (nonatomic,strong)MJXConsultingViewController *consultingVC;
@property (nonatomic,strong)MJXFollowUpViewController *followUpVC;
@property (nonatomic,strong)MJXPersonalCenterViewController *personalCenterVC;

+ (MJXRootViewController *)sharedInstance;//初始化
- (MJXTabbarItemType)currentTabType;
- (void)didSelectTab:(MJXTabbarItemType)barItemType;
- (void)tabBar:(MJXTabbarView *)tabBar didSelectItem:(MJXTabbarItem *)item;
- (void)hideTabbar;
- (void)resumeTabbar;
- (void)rootVCHideTabbarWithAnimation;   //动效隐藏
- (void)rootVCShowTabbarWithAnimation;   //动效显示
@end
