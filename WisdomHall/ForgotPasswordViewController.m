//
//  ForgotPasswordViewController.m
//  WisdomHall
//
//  Created by XTU-TI on 2017/4/25.
//  Copyright © 2017年 majinxing. All rights reserved.
//

#import "ForgotPasswordViewController.h"
#import "RedefineThePasswordViewController.h"
#import "DYHeader.h"
#import "JSMSSDK.h"
#import "JSMSConstant.h"


@interface ForgotPasswordViewController ()
@property (strong, nonatomic) IBOutlet UITextField *phoneNumber;

@property (strong, nonatomic) IBOutlet UITextField *Verification;
@property (strong, nonatomic) IBOutlet UIButton *sendVerification;

@property (nonatomic,assign)NSInteger _nowSencond;

@property (nonatomic,strong)NSTimer *showTimer;

@end

@implementation ForgotPasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithHexString:@"#fafafa"];
    [self setNavigationTitle];
    
    // Do any additional setup after loading the view from its nib.
}

-(void)viewWillAppear:(BOOL)animated{
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    //点击屏幕 回收键盘
    [self.view endEditing:YES];
}
/**
 *  显示navigation的标题
 **/
-(void)setNavigationTitle{
//    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    
    self.title = @"忘记密码";
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)sendVerificationBtnPressed:(id)sender {
    if ([UIUtils isSimplePhone:_phoneNumber.text]) {
        [self startTimer];
        
    }else{
        [UIUtils showInfoMessage:@"请输入正确的手机号" withVC:self];

    }
}
- (void)startTimer
{
    NSDictionary * dict = [[NSDictionary alloc] initWithObjectsAndKeys:_phoneNumber.text,@"phone",@"3",@"type", nil];
    
    [[NetworkRequest sharedInstance] POST:SmsSend dict:dict succeed:^(id data) {
        NSString * message = [NSString stringWithFormat:@"%@",[[data objectForKey:@"header"] objectForKey:@"message"]];
        if (![message isEqualToString:@"成功"]) {
            [UIUtils showInfoMessage:message withVC:self];
        }
    } failure:^(NSError *error) {
        [UIUtils showInfoMessage:@"网络连接失败，请检查网络" withVC:self];
    }];
//    [JSMSSDK getVerificationCodeWithPhoneNumber:_phoneNumber.text andTemplateID:@"144851" completionHandler:^(id resultObject, NSError *error) {
//        if (!error) {
//            NSLog(@"Get verification code success!");
//        }else{
//            NSLog(@"Get verification code failure!");
//            NSLog(@"%@",error);
//        }
//    }];
    
    [_sendVerification setEnabled:NO];
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
}

//触发事件
-(void)handleMaxShowTimer:(NSTimer *)theTimer
{
    __nowSencond ++;
    NSInteger count = 60 - __nowSencond;
    if(__nowSencond >= 60)
    {
        [_showTimer invalidate];
        [_sendVerification setEnabled:YES];
    }
    
    NSString *str = [NSString stringWithFormat:@"%ld秒", (long)count];
    
    [_sendVerification setTitle:str forState:UIControlStateNormal];
    [_sendVerification setTitleColor:[UIColor colorWithHexString:@"#999999"] forState:UIControlStateNormal];
    _sendVerification.layer.borderColor=[[UIColor colorWithHexString:@"#999999"] CGColor];
    
    //_sendVerification.titleLabel.text = str;// @"60秒";
    //    _sendVerification.backgroundColor=[UIColor grayColor];
    if(count <= 0)
    {
        [_sendVerification setTitle:@"获取验证码" forState:UIControlStateNormal];
        [_sendVerification setTitleColor:[UIColor colorWithHexString:@"#01aeff"] forState:UIControlStateNormal];
        _sendVerification.layer.borderColor=[[UIColor colorWithHexString:@"#01aeff"] CGColor];
    }
}

- (IBAction)nextButtonPressed:(id)sender {
    
    NSDictionary * dict = [[NSDictionary alloc] initWithObjectsAndKeys:_phoneNumber.text,@"phone",@"3",@"type",_Verification.text,@"code",nil];
    [[NetworkRequest sharedInstance] POST:SmsValidate dict:dict succeed:^(id data) {
        NSString * message = [NSString stringWithFormat:@"%@",[[data objectForKey:@"header"] objectForKey:@"message"]];
        if ([message isEqualToString:@"成功"]) {
            // 验证成功
            RedefineThePasswordViewController * redeFineVC = [[RedefineThePasswordViewController alloc] init];
            redeFineVC.phoneNumber = _phoneNumber.text;
            [self.navigationController pushViewController:redeFineVC animated:YES];
        }else{
            [UIUtils showInfoMessage:message withVC:self];
        }
        
    } failure:^(NSError *error) {
        [UIUtils showInfoMessage:@"网络连接失败，请检查网络" withVC:self];
    }];
//    //验证验证码
//    [JSMSSDK commitWithPhoneNumber:_phoneNumber.text verificationCode:_Verification.text completionHandler:^(id resultObject, NSError *error) {
//        if (!error)
//        {
//            // 验证成功
//            RedefineThePasswordViewController * redeFineVC = [[RedefineThePasswordViewController alloc] init];
//            redeFineVC.phoneNumber = _phoneNumber.text;
//            [self.navigationController pushViewController:redeFineVC animated:YES];
//        }else
//        {
//            [UIUtils showInfoMessage:@"请输入正确的验证码" withVC:self];
//
//        }
//    }];
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
