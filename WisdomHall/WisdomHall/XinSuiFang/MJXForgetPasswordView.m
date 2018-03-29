//
//  MJXForgetPasswordView.m
//  XinSuiFang
//
//  Created by majinxing on 16/8/16.
//  Copyright © 2016年 majinxing. All rights reserved.
//

#import "MJXForgetPasswordView.h"


@interface MJXForgetPasswordView()
@property (nonatomic,strong) UIView *fatherView;

@end
@implementation MJXForgetPasswordView
-(instancetype)initWithFrame:(CGRect)frame{
    self=[super initWithFrame:frame];
    if (self) {
        [self addTopView];
        [self addNextButton];
    }
    return self;
}
-(void)addTopView{
    
    _fatherView = [[UIView alloc] initWithFrame:CGRectMake(0, 64+10.0/667.0*APPLICATION_HEIGHT, APPLICATION_WIDTH, 167.5)];
    _fatherView.backgroundColor=[UIColor whiteColor];
//    fatherView.layer.borderWidth = 1;
//    fatherView.layer.cornerRadius = 10;
//    fatherView.layer.masksToBounds = YES;
//    fatherView.layer.borderColor = [[UIColor colorWithHexString:@"#b3b3b3"] CGColor];
    [self addSubview:_fatherView];
    
    UIView *lineOne = [MJXUIUtils setLineWithFrame:CGRectMake(27.0, 55, _fatherView.frame.size.width-54, 1)];
    [_fatherView addSubview:lineOne];
    
    UIView *lineTwo = [MJXUIUtils setLineWithFrame:CGRectMake(27.0, 111, _fatherView.frame.size.width-54, 1)];
    [_fatherView addSubview:lineTwo];
    
//    UILabel *userPhoneLab = [MJXUIUtils setUIlableFrame:CGRectMake(27, 21, 50, 20) withText:@"手机号" withTitleColor:[UIColor colorWithHexString:@"#333333"] withFont:[UIFont systemFontOfSize:14]];
//    [_fatherView addSubview:userPhoneLab];
//    
//    UILabel *VerificationCodeLab = [MJXUIUtils setUIlableFrame:CGRectMake(27, 77, 50, 20) withText:@"验证码" withTitleColor:[UIColor colorWithHexString:@"#333333"] withFont:[UIFont systemFontOfSize:14]];
//    [_fatherView addSubview:VerificationCodeLab];
//    
//    UILabel *password = [MJXUIUtils setUIlableFrame:CGRectMake(27, 77+55+1, 50, 20) withText:@"密   码" withTitleColor:[UIColor colorWithHexString:@"#333333"] withFont:[UIFont systemFontOfSize:14]];
//    [_fatherView addSubview:password];
    
    
    self.userPhone = [[UITextField alloc] initWithFrame:CGRectMake(27,3,140,55.0)];
    self.userPhone.placeholder = @"请输入手机号";
    self.userPhone.font = [UIFont systemFontOfSize:15];
    [self.userPhone setTextColor:[UIColor colorWithHexString:@"#333333"]];
    [_fatherView addSubview:self.userPhone];
    
    self.VerificationCode = [[UITextField alloc] initWithFrame:CGRectMake(27,3+56,_fatherView.frame.size.width-27,55.0)];
    self.VerificationCode.placeholder = @"请输入验证码";
    self.VerificationCode.font = [UIFont systemFontOfSize:15];
    [self.VerificationCode setTextColor:[UIColor colorWithHexString:@"#333333"]];
    [_fatherView addSubview:self.VerificationCode];
    
    self.password = [[UITextField alloc] initWithFrame:CGRectMake(27,3+56+56,_fatherView.frame.size.width-27,55.0)];
    self.password.placeholder = @"密码为6-12为的数字或字母";
    self.password.font = [UIFont systemFontOfSize:15];
    self.password.secureTextEntry=YES;
    [self.password setTextColor:[UIColor colorWithHexString:@"#333333"]];
    [_fatherView addSubview:self.password];
    
    _VerificationCodeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _VerificationCodeButton.frame = CGRectMake(200+20, 8.5, _fatherView.frame.size.width-210-40,38.5 );
    _VerificationCodeButton.layer.cornerRadius = 6;
    _VerificationCodeButton.layer.masksToBounds = YES;
    _VerificationCodeButton.layer.borderWidth=1;
    _VerificationCodeButton.layer.borderColor=[[UIColor colorWithHexString:@"#01aeff"] CGColor];
    [_fatherView addSubview:_VerificationCodeButton];
    [_VerificationCodeButton setTitle:@"获取验证码" forState:UIControlStateNormal];
    _VerificationCodeButton.titleLabel.font=[UIFont systemFontOfSize:12];
    [_VerificationCodeButton setTitleColor:[UIColor colorWithHexString:@"#01aeff"] forState:UIControlStateNormal];
    [_VerificationCodeButton addTarget:self action:@selector(VerificationCodeButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    
}
-(void)addNextButton{
    UIButton *next = [UIButton buttonWithType:UIButtonTypeCustom];
    next.frame = CGRectMake(21.0/375.0*APPLICATION_WIDTH,CGRectGetMaxY(_fatherView.frame)+30,APPLICATION_WIDTH-21.0/375.0*APPLICATION_WIDTH*2, 44);
    next.backgroundColor = [UIColor colorWithHexString:@"#01afff"];
    [next setTitle:@"重置密码并登录" forState:UIControlStateNormal];
    next.titleLabel.font = [UIFont systemFontOfSize:17];
    [next setTitleColor:[UIColor colorWithHexString:@"#ffffff"] forState:UIControlStateNormal];
    next.layer.cornerRadius = 8;
    next.layer.masksToBounds = YES;
    [next addTarget:self action:@selector(nextButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:next];
    
}


-(void)VerificationCodeButtonPressed{
    if (self.delegate&&[self.delegate respondsToSelector:@selector(registeredViewVerificationCodeButtonPressed)]) {
        [self.delegate registeredViewVerificationCodeButtonPressed];
    }
}
-(void)nextButtonPressed{
    if (self.delegate&&[self.delegate respondsToSelector:@selector(registeredViewNextbuttonPressed)]) {
        [self.delegate registeredViewNextbuttonPressed];
    }
    
}
//回收键盘的
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    
    [self.window endEditing:YES];
    
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
