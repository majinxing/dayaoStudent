//
//  MJXForgetPasswordView.h
//  XinSuiFang
//
//  Created by majinxing on 16/8/16.
//  Copyright © 2016年 majinxing. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol forgetPasswordViewDelegate <NSObject>
-(void)registeredViewVerificationCodeButtonPressed;
-(void)registeredViewNextbuttonPressed;

@end
@interface MJXForgetPasswordView : UIView

@property (nonatomic,strong) UITextField *userPhone;
@property (nonatomic,strong) UITextField *VerificationCode;
@property (nonatomic,strong) UITextField *password;
@property (nonatomic,strong) UIButton *VerificationCodeButton;
@property (nonatomic,strong) id delegate;
@end
