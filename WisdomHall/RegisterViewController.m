//
//  RegisterViewController.m
//  WisdomHall
//
//  Created by XTU-TI on 2017/4/25.
//  Copyright © 2017年 majinxing. All rights reserved.
//

#import "RegisterViewController.h"
#import "DefineThePasswordViewController.h"
#import "DYHeader.h"
#import "UIUtils.h"
#import "JSMSConstant.h"
#import "JSMSSDK.h"
#import "DYTabBarViewController.h"
#import "ChatHelper.h"

@interface RegisterViewController ()<UITextFieldDelegate>
@property (strong, nonatomic) IBOutlet UIButton *getVerificationCodeBtn;
@property (nonatomic,copy)NSString * phoneNumber;
@property (nonatomic,copy)NSString * Verification;
@property (strong, nonatomic) IBOutlet UITextField *phoneTextFile;
@property (strong, nonatomic) IBOutlet UITextField *vTextFile;
@property (strong, nonatomic) IBOutlet UIButton *nextBtn;

@property (nonatomic,assign)NSInteger _nowSencond;

@property (nonatomic,strong)NSTimer *showTimer;

@end

@implementation RegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.phoneTextFile addTarget:self action:@selector(passConTextChange:) forControlEvents:UIControlEventEditingChanged];
    [self.vTextFile addTarget:self action:@selector(passConTextChange:) forControlEvents:UIControlEventEditingChanged];
    [self setNavigationTitle];
    // Do any additional setup after loading the view from its nib.
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    //点击屏幕 回收键盘
    [self.view endEditing:YES];
}
-(void)viewWillAppear:(BOOL)animated{
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}
/**
 *  显示navigation的标题
 **/
-(void)setNavigationTitle{
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    
    if ([_type isEqualToString:@"bindPhone"]) {
        self.title = @"绑定手机号";
        [self.nextBtn setTitle:@"绑定" forState:UIControlStateNormal];
    }else{
        self.title = @"注册";
    }
}
- (IBAction)getVerificationCodeButtonPressed:(id)sender {
    
    if ([UIUtils isSimplePhone:_phoneNumber]) {
        [self startTimer];
    }else{
        [UIUtils showInfoMessage:@"请输入正确的手机号" withVC:self];
    }
}
- (void)startTimer
{
    [JSMSSDK getVerificationCodeWithPhoneNumber:_phoneNumber andTemplateID:@"144851" completionHandler:^(id resultObject, NSError *error) {
        if (!error) {
            NSLog(@"Get verification code success!");
        }else{
            NSLog(@"失败");
        }
    }];
    
    [_getVerificationCodeBtn setEnabled:NO];
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
        [_getVerificationCodeBtn setEnabled:YES];
    }
    
    NSString *str = [NSString stringWithFormat:@"%ld秒", (long)count];
    [_getVerificationCodeBtn setTitle:str forState:UIControlStateNormal];
    [_getVerificationCodeBtn setTitleColor:[UIColor colorWithHexString:@"#999999"] forState:UIControlStateNormal];
    _getVerificationCodeBtn.layer.borderColor=[[UIColor colorWithHexString:@"#999999"] CGColor];
    
    //_sendVerification.titleLabel.text = str;// @"60秒";
    //    _sendVerification.backgroundColor=[UIColor grayColor];
    if(count <= 0)
    {
        [_getVerificationCodeBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
        [_getVerificationCodeBtn setTitleColor:[UIColor colorWithHexString:@"#01aeff"] forState:UIControlStateNormal];
        _getVerificationCodeBtn.layer.borderColor=[[UIColor colorWithHexString:@"#01aeff"] CGColor];
    }
}
- (IBAction)registerButtonPressed:(id)sender {
    if ([[NSString stringWithFormat:@"%@",_Verification] isEqualToString:@"0"]) {
        DefineThePasswordViewController * definePWVC = [[DefineThePasswordViewController alloc] init];
        definePWVC.phoneNumber = _phoneNumber;
        [self.navigationController pushViewController:definePWVC animated:YES];
        return;
    }
    //验证验证码
    [JSMSSDK commitWithPhoneNumber:_phoneNumber verificationCode:_Verification completionHandler:^(id resultObject, NSError *error) {
        
        if (!error)
        {
            if ([_type isEqualToString:@"bindPhone"]) {
                [self bindPhoneA];
            }else{
                // 验证成功
                DefineThePasswordViewController * definePWVC = [[DefineThePasswordViewController alloc] init];
                definePWVC.phoneNumber = _phoneNumber;
                [self.navigationController pushViewController:definePWVC animated:YES];
            }
        }else{
            [UIUtils showInfoMessage:@"验证码错误" withVC:self];

        }
    }];
    
}
-(void)bindPhoneA{
    NSDictionary * dict = [[NSDictionary alloc] initWithObjectsAndKeys:[NSString stringWithFormat:@"%@",_phoneTextFile.text],@"phone",_workNo,@"workNo", nil];
    [[NetworkRequest sharedInstance] POST:BindPhoe dict:dict succeed:^(id data) {
        NSString * str = [[data objectForKey:@"header"] objectForKey:@"code"];
        if ([str isEqualToString:@"0000"]) {
            NSMutableDictionary * dict = [[NSMutableDictionary alloc] init];
            dict = [data objectForKey:@"body"];
            NSString * type = [NSString stringWithFormat:@"%@",[dict objectForKey:@"type"]];
            if ([type isEqualToString:@"1"]) {
                [UIUtils showInfoMessage:@"您的身份是老师，本客户端只支持学生使用，请登录“律动校园”" withVC:self];
            }else{
                [[Appsetting sharedInstance] sevaUserInfoWithDict:dict withStr:_password];
                
                ChatHelper * c =[ChatHelper shareHelper];
                
                [self saveInfo];
                
                DYTabBarViewController *rootVC = [[DYTabBarViewController alloc] init];
                
                [UIApplication sharedApplication].keyWindow.rootViewController = rootVC;
            }
        }else if([str isEqualToString:@"1009"]){
            [UIUtils showInfoMessage:@"绑定失败：手机号已注册" withVC:self];
        }else{
            [UIUtils showInfoMessage:@"系统错误" withVC:self];
        }
        [self hideHud];
        
    } failure:^(NSError *error) {
        [UIUtils showInfoMessage:@"绑定失败请检查网络" withVC:self];
        [self hideHud];
    }];
}
-(void)saveInfo{
    //手机型号
    NSString * phoneModel =  [UIUtils deviceVersion];
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSString *app_build = [infoDictionary objectForKey:@"CFBundleVersion"];
    NSString *system = [infoDictionary objectForKey:@"DTSDKName"];
    
    UserModel * user = [[Appsetting sharedInstance] getUsetInfo];
    
    NSDictionary * dict = [[NSDictionary alloc] initWithObjectsAndKeys:[NSString stringWithFormat:@"%@",user.userPhone],@"contact",[NSString stringWithFormat:@"手机厂商：Apple\n手机型号：%@\n产品型号：\n设备型号：\n系统版本：ios %@\n App版本：律动课堂 %@",phoneModel,system,app_build],@"retroaction",phoneModel,@"phoneModels",app_build,@"version",user.peopleId,@"userId",@"2",@"type",nil];
    
    [[NetworkRequest sharedInstance] POST:FeedBack dict:dict succeed:^(id data) {
        
    } failure:^(NSError *error) {
        
    }];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark UITextFile
- (void)passConTextChange:(UITextField *)textField{
    if (textField.tag == 1) {
        _phoneNumber = textField.text;
    }else{
        _Verification = textField.text;
    }
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
