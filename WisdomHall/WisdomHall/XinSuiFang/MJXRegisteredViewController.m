//
//  MJXRegisteredViewController.m
//  XinSuiFang
//
//  Created by majinxing on 16/8/12.
//  Copyright © 2016年 majinxing. All rights reserved.
//

#import "MJXRegisteredViewController.h"
#import "MJXRegisteredView.h"
#import "MJXPersonalInfoViewController.h"
#import "MBProgressHUD.h"
@interface MJXRegisteredViewController ()<MJXRegisteredViewDelegate,UIAlertViewDelegate>
@property (nonatomic,strong)MJXRegisteredView *registeredView;
@property (nonatomic,assign)NSInteger _nowSencond;

@property (nonatomic,strong)NSTimer *showTimer;
@property (nonatomic,strong) MBProgressHUD * HUD;

@end

@implementation MJXRegisteredViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    _registeredView=[[MJXRegisteredView alloc] initWithFrame:CGRectMake(0,0, APPLICATION_WIDTH, APPLICATION_HEIGHT)];
    _registeredView.delegate=self;
    [self.view addSubview:_registeredView];
    [MJXUIUtils addNavigationWithView:self.view withTitle:@"医生注册"];
    [self addBackButton];
    
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

#pragma mark - MJXRegisteredViewDelegate

-(void)registeredViewVerificationCodeButtonPressed
{
    
    [self startTimer];
    //    NSLog(@"%s",__func__);
}
- (void)startTimer
{
    if (![_registeredView.userPhone.text isEqualToString:@""]&&![_registeredView.userPhone.text isKindOfClass:[NSNull class]]&&_registeredView.userPhone.text!=nil&&_registeredView.userPhone.text.length==11) {
        
        
        [self sendPhoneNumber:_registeredView.userPhone.text];
        [_registeredView.VerificationCodeButton setEnabled:NO];
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
-(void)sendPhoneNumber:(NSString *)phone{
    if (![phone isKindOfClass:[NSNull class]]&&![phone isEqualToString:@""]&&phone!=nil) {
        
        NSString *url = [NSString stringWithFormat:@"%@%@",MJXBaseURL,@"/user/regist/getVerificationCode"];
        AFHTTPRequestOperationManager *manger = [MJXClient setAFHTTPRequestOperationManagerSomeQuality];
        [manger POST:url parameters:@{
                                      @"username" :phone
                                      } success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                          NSLog(@"成功%@",responseObject);
                                          [self processReturnValue:[NSString stringWithFormat:@"%@",[responseObject objectForKey:@"statusCode"]]withResults:@""];
                                          
                                      } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                          [self processReturnValue:@"404" withResults:@""];
                                      }];
    }else{
        
    }
}
-(void)processReturnValue:(NSString *)errorcode withResults:(NSString *)results
{
    
    if ([errorcode isEqualToString:@"404"]) {
        [self alertWithError:@"网络异常" withButtonTitle:@""];
    }else if ([errorcode isEqualToString:@"400"]){
        [self alertWithError:@"用户已存在" withButtonTitle:@""];
    }else if ([errorcode isEqualToString:@"402"]){
        [self alertWithError:@"验证码错误" withButtonTitle:@""];
    }else if ([errorcode isEqualToString:@"406"]){
        [self alertWithError:@"验证码超时" withButtonTitle:@""];
    }
}

//触发事件
-(void)handleMaxShowTimer:(NSTimer *)theTimer
{
    __nowSencond ++;
    NSInteger count = 60 - __nowSencond;
    if(__nowSencond >= 60)
    {
        [_showTimer invalidate];
        [_registeredView.VerificationCodeButton setEnabled:YES];
    }
    
    NSString *str = [NSString stringWithFormat:@"%ld秒后重新发送", (long)count];
    [_registeredView.VerificationCodeButton setTitle:str forState:UIControlStateNormal];
    [_registeredView.VerificationCodeButton setTitleColor:[UIColor colorWithHexString:@"#999999"] forState:UIControlStateNormal];
    _registeredView.VerificationCodeButton.layer.borderColor=[[UIColor colorWithHexString:@"#999999"] CGColor];
    
    //_registeredView.VerificationCodeButton.titleLabel.text = str;// @"60秒";
    //    _registeredView.VerificationCodeButton.backgroundColor=[UIColor grayColor];
    if(count <= 0)
    {
        [_registeredView.VerificationCodeButton setTitle:@"获取验证码" forState:UIControlStateNormal];
        [_registeredView.VerificationCodeButton setTitleColor:[UIColor colorWithHexString:@"#01aeff"] forState:UIControlStateNormal];
        _registeredView.VerificationCodeButton.layer.borderColor=[[UIColor colorWithHexString:@"#01aeff"] CGColor];
    }
}


-(void)registeredViewNextbuttonPressed{
    //    MJXPersonalInfoViewController *personalInfoVC = [[MJXPersonalInfoViewController alloc] init];
    //    [self.navigationController pushViewController:personalInfoVC animated:YES];
    
    NSLog(@"%@----%@-----%@",_registeredView.userPhone.text,_registeredView.VerificationCode.text,_registeredView.password.text);
    //    NSLog(@"%s",__func__);
    [self showHUD:self.view mode:MBProgressHUDModeIndeterminate text:nil detailText:nil];
    
    NSString *url = [NSString stringWithFormat:@"%@%@",MJXBaseURL,@"/user/regist/register"];
    AFHTTPRequestOperationManager *manger = [MJXClient setAFHTTPRequestOperationManagerSomeQuality];
    [manger POST:url parameters:@{
                                  @"username" : _registeredView.userPhone.text,
                                  @"password" : _registeredView.password.text,
                                  @"validateCode" :_registeredView.VerificationCode.text,
                                  @"docName" : _registeredView.name.text
                                  } success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                      [self hide:0];
                                      [self processReturnValue:[responseObject objectForKey:@"statusCode"]withResults:@""];
                                      if ([[responseObject objectForKey:@"statusCode"] isEqualToString:@"200"]) {
                                          MJXPersonalInfoViewController *personalInfoVC = [[MJXPersonalInfoViewController alloc] init];
                                          [self.navigationController pushViewController:personalInfoVC animated:YES];
                                      }
                                      
                                  } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                      [self hide:0];
                                      [self processReturnValue:@"404" withResults:@""];
                                  }];
}
-(void)alertWithError:(NSString *)error withButtonTitle:(NSString *)title{
    NSString *message = error;
    
    NSString *cancelButtonTitle = NSLocalizedString(@"取消", nil);
    NSString *otherButtonTitle = NSLocalizedString(title, nil);
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:cancelButtonTitle style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
    }];
    
    UIAlertAction *otherAction = [UIAlertAction actionWithTitle:otherButtonTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        if ([title isEqualToString:@"注册"]) {
            
        }else if ([title isEqualToString:@"重置密码"]){
        }
        
    }];
    
    // Add the actions.
    [alertController addAction:cancelAction];
    if (![title isEqualToString:@""]) {
        [alertController addAction:otherAction];
    }
    [self presentViewController:alertController animated:YES completion:nil];
}
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
/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
