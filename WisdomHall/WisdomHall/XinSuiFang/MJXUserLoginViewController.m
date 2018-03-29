//
//  MJXUserLoginViewController.m
//  XinSuiFang
//
//  Created by majinxing on 16/8/11.
//  Copyright © 2016年 majinxing. All rights reserved.
//

#import "MJXUserLoginViewController.h"
#import "MJXUserLoginView.h"
#import "MJXRegisteredViewController.h"
#import "MJXForgetPasswordViewController.h"
#import "MJXTabBarController.h"
#import "AFNetworking.h"
#import "Utils.h"
#import "MJXClient.h"
#import "MBProgressHUD.h"

@interface MJXUserLoginViewController ()<MJXUserLoginViewDeleate>
@property (nonatomic,strong) MJXUserLoginView *loginView;
@property NSUserDefaults *passwordMistake;
@property (nonatomic,strong) MBProgressHUD * HUD;


@end

@implementation MJXUserLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _passwordMistake = [NSUserDefaults standardUserDefaults];//本地化处理

    self.navigationController.navigationBarHidden = YES;//用来隐藏
    self.view.backgroundColor=[UIColor whiteColor];
    
    _loginView=[[MJXUserLoginView alloc] initWithFrame:CGRectMake(0, 0, APPLICATION_WIDTH, APPLICATION_HEIGHT)];
    _loginView.delegate=self;
    [self.view addSubview:_loginView];
    // Do any additional setup after loading the view from its nib.
}

-(void)viewWillAppear:(BOOL)animated{

}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - MJXUserLoginViewDeleate
//登录
-(void)userLoginViewLoginButtonPressed{
    NSLog(@"%@",self.loginView.userPhone.text);
    NSLog(@"%@",self.loginView.passWord.text);
//    NSLog(@"%s",__func__);
    //展示风火轮
    [self showHUD:self.view mode:MBProgressHUDModeIndeterminate text:nil detailText:nil];
    
    if (![MJXUIUtils isSimplePhone:self.loginView.userPhone.text]) {
        [self processReturnValue:@"errorPhone" withResults:@""];
    }
    
    NSString *url = [NSString stringWithFormat:@"%@%@",MJXBaseURL,@"/user/login"];
    AFHTTPRequestOperationManager *manger = [MJXClient setAFHTTPRequestOperationManagerSomeQuality];
    [manger POST:url parameters:@{
                                             @"username" : self.loginView.userPhone.text ,@"password":self.loginView.passWord.text} success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                                 [self hide:0];

                                                 NSString *token;
                                                 if ([[responseObject objectForKey:@"statusCode"] isEqualToString:@"200"]) {
                                                   token=[[responseObject objectForKey:@"result"] objectForKey:@"token"];
                                                 }
                                                 [self processReturnValue:[responseObject objectForKey:@"statusCode"] withResults:token];
                                                 NSLog(@"%@",responseObject);
    }
         failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"失败%@",error);
              [self hide:0];
             [self processReturnValue:@"404" withResults:@""];
        
    }];

}

-(void)processReturnValue:(NSString *)errorcode withResults:(NSString *)results
{

    if ([errorcode isEqualToString:@"403"]) {
        [self alertWithError:@"账号不存在" withButtonTitle:@"注册"];
    }else if([errorcode isEqualToString:@"405"]){
        NSString * number = [_passwordMistake valueForKey:@"passwordMistake"];
        if (number.length>0&&number!=nil) {
            [_passwordMistake setValue:[NSString stringWithFormat:@"%d",[number intValue]+1] forKey:@"passwordMistake"];
        }else{
            [_passwordMistake setValue:@"0" forKey:@"passwordMistake"];
            number = [_passwordMistake valueForKey:@"passwordMistake"];
        }
        [self alertWithError:[NSString stringWithFormat:@"密码错误,您还有%d次机会，找回密码？",5-[number intValue]+1]withButtonTitle:@"重置密码"];
    }else if ([errorcode isEqualToString:@"200"]){
        
        [_passwordMistake setValue:@"0" forKey:@"passwordMistake"];
        
        [[MJXAppsettings sharedInstance] saveUserInfoWithPhone:self.loginView.userPhone.text withToken:results];
        
        MJXTabBarController *rootVC = [[MJXTabBarController alloc] init];
        
        [UIApplication sharedApplication].keyWindow.rootViewController = rootVC;
        
    }else if ([errorcode isEqualToString:@"404"]){
        [self alertWithError:@"网络异常" withButtonTitle:@""];
    }else if ([errorcode isEqualToString:@"errorPhone"]){
        [self alertWithError:@"请输入正确的手机号" withButtonTitle:@""];
    }
    
    
}
-(void)alertWithError:(NSString *)error withButtonTitle:(NSString *)title{
    //NSString *title =@"信息错误";
    NSString *message = error;

    NSString *cancelButtonTitle = NSLocalizedString(@"取消", nil);
    NSString *otherButtonTitle = NSLocalizedString(title, nil);
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:message preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:cancelButtonTitle style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
    }];
    
    UIAlertAction *otherAction = [UIAlertAction actionWithTitle:otherButtonTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        if ([title isEqualToString:@"注册"]) {
            [self userLoginViewRegisteredButtonPressed];
        }else if ([title isEqualToString:@"重置密码"]){
            [self userLoginViewForgetPasswordButtonPresssed];
        }

    }];
    
    // Add the actions.
    [alertController addAction:cancelAction];
    if (![title isEqualToString:@""]) {
        [alertController addAction:otherAction];
    }
    [self presentViewController:alertController animated:YES completion:nil];
}


//注册
-(void)userLoginViewRegisteredButtonPressed{
    MJXRegisteredViewController *registered = [[MJXRegisteredViewController alloc] init];
    ;
    [self.navigationController pushViewController:registered animated:YES];
};
-(void)userLoginViewForgetPasswordButtonPresssed{
    MJXForgetPasswordViewController *forgetPasswordVC=[[MJXForgetPasswordViewController alloc] init];
    [self.navigationController pushViewController:forgetPasswordVC animated:YES];
};

//回收键盘的
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    
    [self.view endEditing:YES];
    
}
#pragma mark HUD
//展示风火轮HUD
- (void)showHUD:(UIView *)view mode:(MBProgressHUDMode)mode text:(NSString *)text detailText:(NSString *)detailText
{
    _HUD = [MBProgressHUD showHUDAddedTo:view animated:YES];
    [_HUD setMode:mode];
    [_HUD setLabelText:text];
    [_HUD setDetailsLabelText:detailText];
}

//隐藏风火轮HUD
- (void)hide:(CGFloat)delay
{
    [_HUD hide:YES afterDelay:delay];
}
@end
