//
//  MJXForgetPasswordViewController.m
//  XinSuiFang
//
//  Created by majinxing on 16/8/12.
//  Copyright © 2016年 majinxing. All rights reserved.
//

#import "MJXForgetPasswordViewController.h"
#import "MJXForgetPasswordView.h"
#import "MJXRootViewController.h"
#import "MJXTabBarController.h"
@interface MJXForgetPasswordViewController ()
@property (nonatomic,strong)MJXForgetPasswordView *forgetPasswordView;
@property (nonatomic,assign)NSInteger _nowSencond;

@property (nonatomic,strong)NSTimer *showTimer;
@end

@implementation MJXForgetPasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor colorWithHexString:@"#f7f7f7"];
    
    
    _forgetPasswordView=[[MJXForgetPasswordView alloc] initWithFrame:CGRectMake(0, 0, APPLICATION_WIDTH, APPLICATION_HEIGHT)];
    _forgetPasswordView.delegate=self;
    [self.view addSubview:_forgetPasswordView];
    
    [MJXUIUtils addNavigationWithView:self.view withTitle:@"忘记密码"];
    [self addBackButton];
    // Do any additional setup after loading the view from its nib.
}
-(void)addBackButton{
    UIImageView *backImage=[[UIImageView alloc] initWithFrame:CGRectMake(20, 20+15, 7, 15)];
    backImage.image=[UIImage imageNamed:@"return"];
    [self.view addSubview:backImage];
    UIButton *back=[UIButton buttonWithType:UIButtonTypeCustom];
    //    [back setImage:[UIImage imageNamed:@"返回"] forState:UIControlStateNormal];
    back.frame=CGRectMake(0,20,60, 44);
    [back addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:back];
}
-(void)back{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)sendPhone:(NSString *)string{
    NSString *url=[NSString stringWithFormat:@"%@%@",MJXBaseURL,@"/user/forgetPassword/getVerificationCode"];
     AFHTTPRequestOperationManager *manger = [MJXClient setAFHTTPRequestOperationManagerSomeQuality];
    [manger POST:url parameters:@{
                                  @"username" :string
                                  } success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                               [self processReturnValue:[responseObject objectForKey:@"errorcode"]withResults:@""];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         [self processReturnValue:@"404"withResults:@""];
    }];
}
-(void)processReturnValue:(NSString *)errorcode withResults:(NSString *)results
{
    
    if ([errorcode isEqualToString:@"404"]) {
        [self alertWithError:@"网络异常" withButtonTitle:@""];
    }else if ([errorcode isEqualToString:@"403"]){
        [self alertWithError:@"用户不存在" withButtonTitle:@""];
    }else if ([errorcode isEqualToString:@"402"]){
        [self alertWithError:@"验证码错误" withButtonTitle:@""];
    }else if ([errorcode isEqualToString:@"406"]){
        [self alertWithError:@"验证码超时" withButtonTitle:@""];
    }
}
-(void)alertWithError:(NSString *)error withButtonTitle:(NSString *)title{
    NSString *message = error;
    
    NSString *cancelButtonTitle = NSLocalizedString(@"取消", nil);
    NSString *otherButtonTitle = NSLocalizedString(title, nil);
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:message preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:cancelButtonTitle style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
    }];
    
    UIAlertAction *otherAction = [UIAlertAction actionWithTitle:otherButtonTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
    }];
    
    // Add the actions.
    [alertController addAction:cancelAction];
    if (![title isEqualToString:@""]) {
        [alertController addAction:otherAction];
    }
    [self presentViewController:alertController animated:YES completion:nil];
}
- (void)startTimer
{
    if (![_forgetPasswordView.userPhone.text isEqualToString:@""]&&![_forgetPasswordView.userPhone.text isKindOfClass:[NSNull class]]&&_forgetPasswordView.userPhone.text!=nil&&_forgetPasswordView.userPhone.text.length==11) {
        [self sendPhone:_forgetPasswordView.userPhone.text];
        [_forgetPasswordView.VerificationCodeButton setEnabled:NO];
        //时间间隔
        NSTimeInterval timeInterval = 1.0 ;
        __nowSencond = 0;
        //定时器
        _showTimer = [NSTimer scheduledTimerWithTimeInterval:timeInterval
                                                      target:self
                                                    selector:@selector(handleMaxShowTimer:)
                                                    userInfo:nil
                                                     repeats:YES];
        [_showTimer fire];

    }else{
        UIAlertView *alertView = [[UIAlertView alloc]
                                  initWithTitle:@"请输入正确的手机号码"
                                  message:nil
                                  delegate:self
                                  cancelButtonTitle:nil
                                  otherButtonTitles:@"我知道了", nil];
        [alertView show];

    }
    
}
//回收键盘的
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    
    [self.view endEditing:YES];
    
}
//触发事件
-(void)handleMaxShowTimer:(NSTimer *)theTimer
{
    __nowSencond ++;
    NSInteger count = 60 - __nowSencond;
    if(__nowSencond >= 60)
    {
        [_showTimer invalidate];
        [_forgetPasswordView.VerificationCodeButton setEnabled:YES];
        
    }
    
    NSString *str = [NSString stringWithFormat:@"%ld秒后重新发送", (long)count];
    [_forgetPasswordView.VerificationCodeButton setTitle:str forState:UIControlStateNormal];
    _forgetPasswordView.VerificationCodeButton.layer.borderColor=[[UIColor colorWithHexString:@"#999999"] CGColor];
    [_forgetPasswordView.VerificationCodeButton setTitleColor:[UIColor colorWithHexString:@"#999999"] forState:UIControlStateNormal];
    if(count <= 0)
    {
         [_forgetPasswordView.VerificationCodeButton setTitle:@"获取验证码" forState:UIControlStateNormal];
        _forgetPasswordView.VerificationCodeButton.layer.borderColor=[[UIColor colorWithHexString:@"#01aeff"] CGColor];
        [_forgetPasswordView.VerificationCodeButton setTitleColor:[UIColor colorWithHexString:@"#01aeff"] forState:UIControlStateNormal];
    }
}

#pragma mark - delegate

-(void)registeredViewVerificationCodeButtonPressed
{
    [self startTimer];
//    NSLog(@"%s",__func__);
}
-(void)registeredViewNextbuttonPressed{
    if (_forgetPasswordView.password.text.length>=6&&_forgetPasswordView.password.text!=nil&&_forgetPasswordView.password.text.length<=12) {
        
    }else{
        UIAlertView* alert=[[UIAlertView alloc] initWithTitle:@""
                                                      message:@"请输入6-12位的数字或字母"
                                                     delegate:self
                                            cancelButtonTitle:@"确认"
                                            otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    
    NSString *url=[NSString stringWithFormat:@"%@%@",MJXBaseURL,@"/user/forgetPassword/resetPassword"];
    AFHTTPRequestOperationManager *manger = [MJXClient setAFHTTPRequestOperationManagerSomeQuality];
    [manger POST:url parameters:@{
                                  @"username" : _forgetPasswordView.userPhone.text,
                                  @"validateCode" :_forgetPasswordView.VerificationCode.text,
                                  @"password" : _forgetPasswordView.password.text
                                  } success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                      [self processReturnValue:[responseObject objectForKey:@"statusCode"]withResults:@""];
                                      if ([[responseObject objectForKey:@"statusCode"] isEqualToString:@"200"]) {
                                          [[MJXAppsettings sharedInstance] saveUserInfoWithPhone:_forgetPasswordView.userPhone.text withToken:@""];
                                          MJXTabBarController *rootVC = [[MJXTabBarController alloc] init];
                                          [UIApplication sharedApplication].keyWindow.rootViewController = rootVC;
                                      }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"ccvv");
        [self processReturnValue:@"404" withResults:@""];
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
