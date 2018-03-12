//
//  RedefineThePasswordViewController.m
//  WisdomHall
//
//  Created by XTU-TI on 2017/4/28.
//  Copyright © 2017年 majinxing. All rights reserved.
//

#import "RedefineThePasswordViewController.h"
#import "DYTabBarViewController.h"
#import "DYHeader.h"
#import "TheLoginViewController.h"

@interface RedefineThePasswordViewController ()

@property (strong, nonatomic) IBOutlet UITextField *confirmPassword;

@property (strong, nonatomic) IBOutlet UITextField *password;

@end

@implementation RedefineThePasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    // Do any additional setup after loading the view from its nib.
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    //点击屏幕 回收键盘
    [self.view endEditing:YES];
}
- (IBAction)submit:(id)sender {
    [self showHudInView:self.view hint:NSLocalizedString(@"正在加载", @"Load data...")];
    if ([_password.text isEqualToString:_confirmPassword.text]) {
        if ([UIUtils isBlankString:_password.text]) {
            [self hideHud];

            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"密码不能为空" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
            [alertView show];
        }else{

            NSDictionary * dict = [[NSDictionary alloc] initWithObjectsAndKeys:_phoneNumber,@"phone",_password.text,@"password",nil];
            
            [[NetworkRequest sharedInstance] POST:ResetPassword dict:dict succeed:^(id data) {
                NSLog(@"succeed%@",data);
                [self hideHud];

                for (UIViewController *controller in self.navigationController.viewControllers) {
                    if ([controller isKindOfClass:[TheLoginViewController class]]) {
                        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"修改密码成功请登录" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
                        [alertView show];
                        [self.navigationController popToViewController:controller animated:YES];
                    }
                }
//                DYTabBarViewController *rootVC = [[DYTabBarViewController alloc] init];
//                [UIApplication sharedApplication].keyWindow.rootViewController = rootVC;
                
            } failure:^(NSError *error) {
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"修改密码失败" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
                [alertView show];

            }];
        }
    }else{
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"两次输入密码不一致" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alertView show];
    }
    
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
