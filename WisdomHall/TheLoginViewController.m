//
//  TheLoginViewController.m
//  WisdomHall
//
//  Created by XTU-TI on 2017/4/25.
//  Copyright © 2017年 majinxing. All rights reserved.
//

#import "TheLoginViewController.h"
#import "DYHeader.h"
#import "DYTabBarViewController.h"
#import "RegisterViewController.h"
#import "ForgotPasswordViewController.h"
#import "NetworkRequest.h"
#import "ChatHelper.h"

@interface TheLoginViewController ()<UITextFieldDelegate>
@property (strong, nonatomic) IBOutlet UITextField *personalAccount;
@property (strong, nonatomic) IBOutlet UITextField *personalPassword;
@property (strong, nonatomic) IBOutlet UIButton *LoginButton;



@end

@implementation TheLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];//secureTextEntry
    
    [self xib];
    
    // Do any additional setup after loading the view from its nib.
}
-(void)viewWillAppear:(BOOL)animated{
    self.navigationController.navigationBarHidden = YES;
}
- (IBAction)back:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)xib{
    _personalPassword.secureTextEntry = YES;
    
    [_personalAccount addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    
    [_personalPassword addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    
    //    [_personalAccount setValue:[UIColor whiteColor] forKeyPath:@"_placeholderLabel.textColor"];
    //    [_personalPassword setValue:[UIColor whiteColor] forKeyPath:@"_placeholderLabel.textColor"];
    UserModel * user = [[Appsetting sharedInstance] getUsetInfo];
    
    _personalAccount.text = user.userPhone;
    
    _personalPassword.text = user.userPassword;
    
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    //点击屏幕 回收键盘
    [self.view endEditing:YES];
}
- (IBAction)LoginButtonPressed:(id)sender {
    //15243670131
    [self showHudInView:self.view hint:NSLocalizedString(@"正在加载", @"Load data...")];
    if ([UIUtils isSimplePhone:_personalAccount.text]) {
        
        NSDictionary * dict = [[NSDictionary alloc] initWithObjectsAndKeys:_personalAccount.text,@"phone",_personalPassword.text,@"password", nil];
        NSString * str = _personalPassword.text;
        [[NetworkRequest sharedInstance] POST:Login dict:dict succeed:^(id data) {
            NSDictionary * d = [data objectForKey:@"header"];
            if ([[d objectForKey:@"code"] isEqualToString:@"0000"]) {
                [self hideHud];
                NSMutableDictionary * dict = [[NSMutableDictionary alloc] init];
                dict = [data objectForKey:@"body"];
                NSString * type = [NSString stringWithFormat:@"%@",[dict objectForKey:@"type"]];
                if ([type isEqualToString:@"1"]) {
                    [UIUtils showInfoMessage:@"您的身份是老师，本客户端只支持学生使用，请登录“律动校园”" withVC:self];
                    [self hideHud];
                }else{
                    [[Appsetting sharedInstance] sevaUserInfoWithDict:dict withStr:str];
                    
                    ChatHelper * c =[ChatHelper shareHelper];
                    
                    [self saveInfo];
                    
                    DYTabBarViewController *rootVC = [[DYTabBarViewController alloc] init];
                    
                    [UIApplication sharedApplication].keyWindow.rootViewController = rootVC;
                }
                
            }else if([[d objectForKey:@"code"] isEqualToString:@"1001"]){
                [self hideHud];
                
                [UIUtils showInfoMessage:@"密码错误" withVC:self];
                
            }else{
                [UIUtils showInfoMessage:@"登录失败" withVC:self];
            }
            
        } failure:^(NSError *error) {
            [self hideHud];
            
            [UIUtils showInfoMessage:@"请检查网络连接状态" withVC:self];
            
        }];
    }else{
        [self hideHud];
        [UIUtils showInfoMessage:@"请输入正确的手机号" withVC:self];
      
    }
    
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
/**
 * 注册
 **/
- (IBAction)registeredButtonPressed:(id)sender {
    RegisterViewController * registerVC = [[RegisterViewController alloc] init];
    UIBarButtonItem * backButtonItem = [[UIBarButtonItem alloc] init];
    backButtonItem.title = @"取消";
    self.navigationItem.backBarButtonItem = backButtonItem;
    [self.navigationController pushViewController:registerVC animated:YES];
    
}
/**
 * 忘记密码
 **/
- (IBAction)forgotPasswordPressed:(id)sender {
    ForgotPasswordViewController * forgetVC = [[ForgotPasswordViewController alloc] init];
    // self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:nil action:nil];
    // 方式二
    UIBarButtonItem * backButtonItem = [[UIBarButtonItem alloc] init];
    backButtonItem.title = @"返回";
    self.navigationItem.backBarButtonItem = backButtonItem;
    [self.navigationController pushViewController:forgetVC animated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark UITextFileDelegate
-(void)textFieldDidChange:(UITextField *)textFile{
    
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
