//
//  MJXUserLoginView.m
//  XinSuiFang
//
//  Created by majinxing on 16/8/12.
//  Copyright © 2016年 majinxing. All rights reserved.
//

#import "MJXUserLoginView.h"

@interface MJXUserLoginView ()<UITextFieldDelegate>
@property (nonatomic,strong) UIView *fatherView;
@property (nonatomic,strong) UIButton *login;
@property (nonatomic,strong) UIView *nView;
@end
@implementation MJXUserLoginView
- (instancetype) initWithFrame:(CGRect)frame{
    self=[super initWithFrame:frame];
    if (self) {
        [self addTopView];
        [self addContentView];
        [self addButton];
        [self keyboard];
        
    }
    return self;
}
//加载顶部视图
-(void)addTopView{
    UILabel *lab=[[UILabel alloc] initWithFrame:CGRectMake(0, (150.0/667.0)*APPLICATION_HEIGHT, APPLICATION_WIDTH, 35)];
    lab.textAlignment=NSTextAlignmentCenter;
    lab.font=[UIFont systemFontOfSize:40];
    lab.text=@"欢迎来到心随访";
    lab.textColor=[UIColor colorWithHexString:@"#01aeff"];
    [self addSubview:lab];
}


-(void)addContentView{
    _fatherView=[[UIView alloc] initWithFrame:CGRectMake(21.5/375.0*APPLICATION_WIDTH, 238/667.0*APPLICATION_HEIGHT,APPLICATION_WIDTH-21.5/375.0*APPLICATION_WIDTH*2,250)];
    _fatherView.backgroundColor=[UIColor whiteColor];
//    _fatherView.layer.borderWidth=1;
//    _fatherView.layer.cornerRadius=10;
//    _fatherView.layer.masksToBounds=YES;
//    _fatherView.layer.borderColor=[[UIColor colorWithHexString:@"#b3b3b3"] CGColor];
    [self addSubview:_fatherView];
    
    UIView *line = [MJXUIUtils setLineWithFrame:CGRectMake(6,50,_fatherView.frame.size.width-12, 1)];
    [_fatherView addSubview:line];
    UIView *lineT = [MJXUIUtils setLineWithFrame:CGRectMake(6,105,_fatherView.frame.size.width-12, 1)];
    [_fatherView addSubview:lineT];
    
    UIImageView *phone=[[UIImageView alloc] initWithFrame:CGRectMake(22,17,15, 22)];
    phone.image=[UIImage imageNamed:@"iphone"];
    [_fatherView addSubview:phone];
    
    UIImageView *password=[[UIImageView alloc] initWithFrame:CGRectMake(22,74,15, 22)];
    password.image=[UIImage imageNamed:@"key"];
    [_fatherView addSubview:password];
    
    self.userPhone=[[UITextField alloc] initWithFrame:CGRectMake(51,2,_fatherView.frame.size.width-51,50.0)];
    self.userPhone.placeholder=@"请输入手机号";
    self.userPhone.font=[UIFont systemFontOfSize:15];
    self.userPhone.delegate=self;
    if ([[MJXAppsettings sharedInstance] getUserPhone].length) {
        self.userPhone.text=[[MJXAppsettings sharedInstance] getUserPhone];
    };
//    self.userPhone.secureTextEntry=YES;
    [_fatherView addSubview:self.userPhone];
    
    self.passWord = [[UITextField alloc] initWithFrame:CGRectMake(51,55,_fatherView.frame.size.width-51,55.0)];
    self.passWord.placeholder = @"请输入密码";
    self.passWord.font = [UIFont systemFontOfSize:15];
     self.passWord.secureTextEntry = YES;
    self.passWord.delegate = self;
    [_fatherView addSubview:self.passWord];
    
    [_userPhone addTarget:self action:@selector(textFieldDidChange) forControlEvents:UIControlEventEditingChanged];
    [_passWord addTarget:self action:@selector(textFieldDidChange) forControlEvents:UIControlEventEditingChanged];
}
-(void)addButton{
    _login=[UIButton buttonWithType:UIButtonTypeCustom];
    _login.frame=CGRectMake(0,135,_fatherView.frame.size.width, 55.0);
    [_login setTitle:@"登 录" forState:UIControlStateNormal
     ];
    _login.backgroundColor=[UIColor colorWithHexString:@"#bfbfbf"];
    _login.layer.cornerRadius=8;
    _login.layer.masksToBounds=YES;
    _login.titleLabel.font=[UIFont systemFontOfSize:17];
    [_login addTarget:self action:@selector(loginButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    [_fatherView addSubview:_login];
    _login.userInteractionEnabled=NO;
    UIView *line=[[UIView alloc] initWithFrame:CGRectMake(_fatherView.frame.size.width/2-0.5, CGRectGetMaxY(_login.frame)+34+5, 1, 20)];
    line.backgroundColor=[UIColor colorWithHexString:@"#999999"];
    [_fatherView addSubview:line];
    
    UIButton *registered=[UIButton buttonWithType:UIButtonTypeCustom];
    registered.frame=CGRectMake(line.frame.origin.x-20-59-20,CGRectGetMaxY(_login.frame)+34, 80, 30);
//registered.backgroundColor=[UIColor redColor];
    [registered setTitle:@"快速注册" forState:UIControlStateNormal];
    [registered setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    registered.titleLabel.font = [UIFont systemFontOfSize:15];
    [registered addTarget:self action:@selector(registeredButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    [registered setTitleColor:[UIColor colorWithHexString:@"#999999"] forState:UIControlStateNormal];
    [_fatherView addSubview:registered];
    
    UIButton *forgetPassword=[UIButton buttonWithType:UIButtonTypeCustom];
    forgetPassword.frame=CGRectMake(line.frame.origin.x+20.0,CGRectGetMaxY(_login.frame)+34, 80, 30);
    [forgetPassword setTitle:@"忘记密码" forState:UIControlStateNormal];
    [forgetPassword setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    forgetPassword.titleLabel.font = [UIFont systemFontOfSize:15];
    [forgetPassword addTarget:self action:@selector(forgetPasswordButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    [forgetPassword setTitleColor:[UIColor colorWithHexString:@"#999999"] forState:UIControlStateNormal];
    [_fatherView addSubview:forgetPassword];
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
    
   // NSValue *aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    
   //CGRect keyboardRect = [aValue CGRectValue];
    
//    double height = keyboardRect.size.height;
    _fatherView.frame=CGRectMake(21.5/375.0*APPLICATION_WIDTH, 119.0/667.0*APPLICATION_HEIGHT,APPLICATION_WIDTH-21.5/375.0*APPLICATION_WIDTH*2,250);
    [self addNavigationWithView];
    //    NSLog(@"%lf",height);
}


//当键退出时调用

- (void)keyboardWillHide:(NSNotification *)aNotification

{
    
    _fatherView.frame=CGRectMake(21.5/375.0*APPLICATION_WIDTH, 238/667.0*APPLICATION_HEIGHT,APPLICATION_WIDTH-21.5/375.0*APPLICATION_WIDTH*2,250);
    [_nView removeFromSuperview];
}
//添加navigation视图
-(void)addNavigationWithView{
    self.nView= [[UIView alloc] initWithFrame:CGRectMake(0, 0,APPLICATION_WIDTH, 65)];
    self.nView.backgroundColor=[UIColor whiteColor];
    UIView *line=[[UIView alloc] initWithFrame:CGRectMake(0, 64, APPLICATION_WIDTH, 1)];
    line.backgroundColor=[UIColor colorWithHexString:@"#e5e5e5"];
    UILabel *title=[[UILabel alloc] initWithFrame:CGRectMake(APPLICATION_WIDTH/2-30, 34, 60, 20)];
    [title setText:@"登录"];
    title.textAlignment = NSTextAlignmentCenter ;
    title.textColor=[UIColor colorWithHexString:@"#333333"];
    title.font=[UIFont systemFontOfSize:17];
    [_nView addSubview:line];
    [_nView addSubview:title];
    UIImageView *backImage=[[UIImageView alloc] initWithFrame:CGRectMake(22.0/375.0*APPLICATION_WIDTH, 35, 7, 15)];
    backImage.image=[UIImage imageNamed:@"return"];
    [_nView addSubview:backImage];
    [self addSubview:_nView];
}

-(void)loginButtonPressed{
    if (self.delegate&&[self.delegate respondsToSelector:@selector( userLoginViewLoginButtonPressed)]) {
        [self.delegate userLoginViewLoginButtonPressed];
    }

}
-(void)registeredButtonPressed{
    if (self.delegate&&[self.delegate respondsToSelector:@selector(userLoginViewRegisteredButtonPressed)]) {
        [self.delegate userLoginViewRegisteredButtonPressed];
    }
}
-(void)forgetPasswordButtonPressed{
    if (self.delegate&&[self.delegate respondsToSelector:@selector(userLoginViewForgetPasswordButtonPresssed)]) {
        [self.delegate userLoginViewForgetPasswordButtonPresssed];
    }
}

//回收键盘的
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    
    [self endEditing:YES];
    
}
-(void)textFieldDidChange{
    if (self.userPhone.text!=nil&&self.userPhone.text.length>0) {
        int length = [self convertToInt:self.userPhone.text];
        if (length>=12) {
            //如果输入框中的文字大于11，就截取前11个作为输入框的文字
                self.userPhone.text = [self.userPhone.text substringToIndex:11];
        }
    }
    
    if (![self.userPhone.text isEqual:@""]&&![self.passWord.text isEqual:@""]) {
        _login.userInteractionEnabled=YES;
        _login.backgroundColor=[UIColor colorWithHexString:@"#01aeff"];
    }else{
        _login.userInteractionEnabled=NO;
        _login.backgroundColor=[UIColor colorWithHexString:@"#bfbfbf"];
    }
}
- (int)convertToInt:(NSString *)strtemp//判断中英混合的的字符串长度
{
    int strlength = 0;
    for (int i=0; i< [strtemp length]; i++) {
        int a = [strtemp characterAtIndex:i];
        if( a > 0x4e00 && a < 0x9fff) { //判断是否为中文
            strlength += 2;
        }else{
            strlength +=1;
        }
    }
    return strlength;
}
//-textField
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
