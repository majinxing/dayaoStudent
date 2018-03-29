//
//  SystemSettingsViewController.m
//  WisdomHall
//
//  Created by XTU-TI on 2017/4/28.
//  Copyright © 2017年 majinxing. All rights reserved.
//

#import "SystemSettingsViewController.h"
#import "TheLoginViewController.h"
#import "DYTabBarViewController.h"
#import "DYHeader.h"
#import "ChatHelper.h"
#import "WorkingLoginViewController.h"
@interface SystemSettingsViewController ()
@property (strong, nonatomic) IBOutlet UIButton *outApp;

@end

@implementation SystemSettingsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"系统设置";
    self.view.backgroundColor = [UIColor whiteColor];
    self.outApp.backgroundColor = [[Appsetting sharedInstance] getThemeColor];
    // Do any additional setup after loading the view from its nib.
}
- (IBAction)logoutButtonPressed:(id)sender {
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [[Appsetting sharedInstance] getOut];
        
        DYTabBarViewController *rootVC = [DYTabBarViewController sharedInstance];
        rootVC = nil;
        ChatHelper * c =[ChatHelper shareHelper];
        [c getOut];
        
        WorkingLoginViewController * userLogin = [[WorkingLoginViewController alloc] init];
        //    TheLoginViewController * userLogin = [[TheLoginViewController alloc] init];
        
        [UIApplication sharedApplication].keyWindow.rootViewController =[[UINavigationController alloc] initWithRootViewController:userLogin];
    });
   
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
