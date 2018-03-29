//
//  MJXRegisteredView.m
//  XinSuiFang
//
//  Created by majinxing on 16/8/15.
//  Copyright © 2016年 majinxing. All rights reserved.
//

#import "MJXRegisteredView.h"


@interface MJXRegisteredView()
@property (nonatomic,strong) UIView *fatherView;
@property (nonatomic,strong) UIButton *next;
@end
@implementation MJXRegisteredView
-(instancetype)initWithFrame:(CGRect)frame{
    self=[super initWithFrame:frame];
    if (self) {
        self.backgroundColor=[UIColor whiteColor];
        [self addTopView];
        [self addNextButton];
        [self keyboard];
    }
    return self;
}
-(void)addTopView{
//    UILabel *lab=[[UILabel alloc] initWithFrame:CGRectMake(21.5/375.0*APPLICATION_WIDTH, 124.0/667.0*APPLICATION_HEIGHT, APPLICATION_WIDTH-21.5/375.0*APPLICATION_WIDTH*2, 36)];
//    [lab setText:@"欢迎来到心随访"];
//    [lab setTextColor:[UIColor colorWithHexString:@"#01aeff"]];
//    lab.font=[UIFont systemFontOfSize:40];
//    lab.textAlignment=NSTextAlignmentCenter;
//    [self addSubview:lab];
    _fatherView = [[UIView alloc] initWithFrame:CGRectMake(21.5/375.0*APPLICATION_WIDTH, 75.0/667.0*APPLICATION_HEIGHT, APPLICATION_WIDTH-21.5/375.0*APPLICATION_WIDTH*2, 167.5+32+44+56)];
//    _fatherView.layer.borderWidth = 1;
    _fatherView.layer.cornerRadius = 10;
//    _fatherView.layer.masksToBounds = YES;
//    _fatherView.layer.borderColor = [[UIColor colorWithHexString:@"#b3b3b3"] CGColor];
    _fatherView.backgroundColor=[UIColor whiteColor];
    [self addSubview:_fatherView];
    
    UIView *lineOne = [MJXUIUtils setLineWithFrame:CGRectMake(6.0, 55, _fatherView.frame.size.width-12, 1)];
    [_fatherView addSubview:lineOne];
    
    UIView *lineTwo = [MJXUIUtils setLineWithFrame:CGRectMake(6.0, 111, _fatherView.frame.size.width-12, 1)];
    [_fatherView addSubview:lineTwo];
    
    UIView *lineThree = [MJXUIUtils setLineWithFrame:CGRectMake(6, 167+56, _fatherView.frame.size.width-12, 1)];
    [_fatherView addSubview:lineThree];
    
    UIView *lineFour = [MJXUIUtils setLineWithFrame:CGRectMake(6, 167, _fatherView.frame.size.width-12, 1)];
    [_fatherView addSubview:lineFour];
    
    UILabel *userPhoneLab = [MJXUIUtils setUIlableFrame:CGRectMake(9, 21, 50, 20) withText:@"手机号" withTitleColor:[UIColor colorWithHexString:@"#333333"] withFont:[UIFont systemFontOfSize:15]];
    [_fatherView addSubview:userPhoneLab];
    
    UILabel *VerificationCodeLab = [MJXUIUtils setUIlableFrame:CGRectMake(9, 77, 50, 20) withText:@"验证码" withTitleColor:[UIColor colorWithHexString:@"#333333"] withFont:[UIFont systemFontOfSize:15]];
    [_fatherView addSubview:VerificationCodeLab];
    
    UILabel *password = [MJXUIUtils setUIlableFrame:CGRectMake(9, 77+55+1, 50, 20) withText:@"密   码" withTitleColor:[UIColor colorWithHexString:@"#333333"] withFont:[UIFont systemFontOfSize:15]];
    [_fatherView addSubview:password];
    
    UILabel *userName = [MJXUIUtils setUIlableFrame:CGRectMake(9, 77+55+55+1+1, 50, 20) withText:@"姓   名" withTitleColor:[UIColor colorWithHexString:@"#333333"] withFont:[UIFont systemFontOfSize:15]];
    [_fatherView addSubview:userName];
    
    
    self.userPhone = [[UITextField alloc] initWithFrame:CGRectMake(60,3,140,55.0)];
    self.userPhone.placeholder = @"请输入手机号";
    self.userPhone.font = [UIFont systemFontOfSize:15];

    [_fatherView addSubview:self.userPhone];
    
    self.VerificationCode = [[UITextField alloc] initWithFrame:CGRectMake(60,3+56,_fatherView.frame.size.width-60,55.0)];
    self.VerificationCode.placeholder = @"请输入验证码";
    self.VerificationCode.font = [UIFont systemFontOfSize:15];

    [_fatherView addSubview:self.VerificationCode];
    
    self.password = [[UITextField alloc] initWithFrame:CGRectMake(60,3+56+56,_fatherView.frame.size.width-60,55.0)];
    self.password.placeholder = @"6-12为的数字或 字母";
    self.password.font = [UIFont systemFontOfSize:15];
    self.password.secureTextEntry=YES;
    [_fatherView addSubview:self.password];
    
    _name = [[UITextField alloc] initWithFrame:CGRectMake(60, 3+56+56+56, _fatherView.frame.size.width-60, 55)];
    _name.placeholder = @"请输入姓名";
    self.name.font = [UIFont systemFontOfSize:15];
    //self.name.secureTextEntry = YES;
    [_fatherView addSubview:_name];
    
    //监听文字变化
    [_userPhone addTarget:self action:@selector(textFieldDidChange) forControlEvents:UIControlEventEditingChanged];
    [_VerificationCode addTarget:self action:@selector(textFieldDidChange) forControlEvents:UIControlEventEditingChanged];
    [_password addTarget:self action:@selector(textFieldDidChange) forControlEvents:UIControlEventEditingChanged];
    [_name addTarget:self action:@selector(textFieldDidChange) forControlEvents:UIControlEventEditingChanged];

    _VerificationCodeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _VerificationCodeButton.frame = CGRectMake(200, 8.5, _fatherView.frame.size.width-210,38.5 );
    _VerificationCodeButton.layer.cornerRadius = 6;
    _VerificationCodeButton.layer.masksToBounds = YES;
    [_VerificationCodeButton setTitle:@"获取验证码" forState:UIControlStateNormal];
    [_VerificationCodeButton setTitleColor:[UIColor colorWithHexString:@"#01aeff"] forState:UIControlStateNormal];
    _VerificationCodeButton.titleLabel.font=[UIFont systemFontOfSize:12];
    _VerificationCodeButton.layer.borderWidth=1;
    _VerificationCodeButton.layer.borderColor=[[UIColor colorWithHexString:@"#01aeff"] CGColor];
    [_VerificationCodeButton addTarget:self action:@selector(VerificationCodeButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    [_fatherView addSubview:_VerificationCodeButton];

}
-(void)addNextButton{
    _next = [UIButton buttonWithType:UIButtonTypeCustom];
    _next.frame = CGRectMake(0,CGRectGetMaxY(self.password.frame)+27+56,_fatherView.frame.size.width, 44);
    _next.backgroundColor = [UIColor colorWithHexString:@"#bfbfbf"];
    [_next setTitle:@"下 一 步" forState:UIControlStateNormal];
    _next.titleLabel.font = [UIFont systemFontOfSize:17];
    [_next setTitleColor:[UIColor colorWithHexString:@"#ffffff"] forState:UIControlStateNormal];
    _next.layer.cornerRadius = 8;
    _next.layer.masksToBounds = YES;
    [_next addTarget:self action:@selector(nextButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    
    _next.userInteractionEnabled=NO;//mjx
    
    [_fatherView addSubview:_next];
    
    UIButton *contact = [UIButton buttonWithType:UIButtonTypeCustom];
    [contact setTitle:@"有困难？联系客服 010-82826700" forState:UIControlStateNormal];
    [contact setTitleColor:[UIColor colorWithHexString:@"#666666"] forState:UIControlStateNormal];
    contact.titleLabel.font = [UIFont systemFontOfSize:11];
    contact.frame = CGRectMake(APPLICATION_WIDTH/2-89,CGRectGetMaxY(self.frame)-30,177.5, 10);
    contact.titleLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:contact];
}

-(void)textFieldDidChange{
    if (![_userPhone.text isEqual:@""]&&_password.text.length>=6 &&![_VerificationCode.text isEqual:@""]&&![_name.text isEqualToString:@""]) {
        _next.userInteractionEnabled=YES;
        _next.backgroundColor=[UIColor colorWithHexString:@"#01aeff"];
    }else{
        _next.userInteractionEnabled=NO;
        _next.backgroundColor=[UIColor colorWithHexString:@"#bfbfbf"];
    }
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
-(void)keyboard{
    //增加监听，当键盘出现或改变时收出消息
    
    [[NSNotificationCenter defaultCenter] addObserver:self
     
                                             selector:@selector(keyboardWillShow:)
     
                                                 name:UIKeyboardWillShowNotification
     
                                               object:nil];
    
    
    
    //增加监听，当键退出时收出消息
    
    [[NSNotificationCenter defaultCenter] addObserver:self
     
                                             selector:@selector(keyboardWillHide:)
     
                                                 name:UIKeyboardWillHideNotification
     
                                               object:nil];
}
//当键盘出现或改变时调用

- (void)keyboardWillShow:(NSNotification *)aNotification

{
    
    //获取键盘的高度
    
    NSDictionary *userInfo = [aNotification userInfo];
    
    NSValue *aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    
    CGRect keyboardRect = [aValue CGRectValue];
    
//    double height = keyboardRect.size.height;
   // _fatherView.frame=CGRectMake(21.5/375.0*APPLICATION_WIDTH,64+10.0/667.0*APPLICATION_HEIGHT,APPLICATION_WIDTH-21.5/375.0*APPLICATION_WIDTH*2,167.5+32+44);
    //    NSLog(@"%lf",height);
}


//当键退出时调用

- (void)keyboardWillHide:(NSNotification *)aNotification

{
    //_fatherView.frame=CGRectMake(21.5/375.0*APPLICATION_WIDTH, 200.0/667.0*APPLICATION_HEIGHT, APPLICATION_WIDTH-21.5/375.0*APPLICATION_WIDTH*2, 167.5+32+44);
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
