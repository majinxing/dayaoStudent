//
//  SynchronousCourseView.m
//  WisdomHall
//
//  Created by XTU-TI on 2018/3/23.
//  Copyright © 2018年 majinxing. All rights reserved.
//

#import "SynchronousCourseView.h"
#import "DYHeader.h"

@interface SynchronousCourseView()
@property (nonatomic,strong)UITextField * accountFile;
@property (nonatomic,strong)UITextField * passwordFile;
@end

@implementation SynchronousCourseView
-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self addContentView];
    }
    return self;
}
-(void)addContentView{
    UIButton * backViewBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backViewBtn.frame = CGRectMake(0, 0, APPLICATION_WIDTH, APPLICATION_HEIGHT);
    backViewBtn.backgroundColor = [UIColor blackColor];
    backViewBtn.alpha  = 0.4;
    [backViewBtn addTarget:self action:@selector(outView) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:backViewBtn];
    
    UIView * view1 = [[UIView alloc] initWithFrame:CGRectMake(50, 100, APPLICATION_WIDTH-100, 250)];
    view1.backgroundColor = [UIColor whiteColor];
    [self addSubview:view1];
    
    UILabel * titleLable = [[UILabel alloc] initWithFrame:CGRectMake(10, 20, view1.frame.size.width-20, 40)];
    titleLable.text = @"请输入您登陆学校教务处的账号和密码，以便我们同步您的课程数据";
    titleLable.numberOfLines = 0;
    titleLable.font = [UIFont systemFontOfSize:14];
    titleLable.textAlignment = NSTextAlignmentCenter;
    titleLable.alpha = 0.5;
    [view1 addSubview:titleLable];
    
    UILabel * accountLab = [[UILabel alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(titleLable.frame)+20, 50, 20)];
    accountLab.text = @"账 号:";
    accountLab.font = [UIFont systemFontOfSize:15];
    accountLab.textColor = [UIColor colorWithHexString:@"#29a7e1"];
    accountLab.alpha = 0.7;
    [view1 addSubview:accountLab];
    
    _accountFile = [[UITextField alloc] initWithFrame:CGRectMake(CGRectGetMaxX(accountLab.frame)+10, CGRectGetMaxY(titleLable.frame)+20, 200, 20)];
    
    _accountFile.placeholder = @"账号";
    _accountFile.font = [UIFont systemFontOfSize:14];
    UserModel * user = [[Appsetting sharedInstance] getUsetInfo];
    _accountFile.text = [NSString stringWithFormat:@"%@",user.studentId];
    [_accountFile setEnabled:NO];
    _accountFile.alpha = 0.7;
    [view1 addSubview:_accountFile];
    
    UIView * line1 = [[UIView alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(accountLab.frame)+ 10, view1.frame.size.width-40, 1)];
    line1.backgroundColor = [UIColor blackColor];
    line1.alpha = 0.5;
    [view1 addSubview:line1];
    
    UILabel * accountLab1 = [[UILabel alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(line1.frame)+20, 50, 20)];
    accountLab1.text = @"密 码:";
    accountLab1.font = [UIFont systemFontOfSize:15];
    accountLab1.textColor = [UIColor colorWithHexString:@"#29a7e1"];
    [view1 addSubview:accountLab1];
    
    _passwordFile = [[UITextField alloc] initWithFrame:CGRectMake(CGRectGetMaxX(accountLab1.frame)+10, CGRectGetMaxY(line1.frame)+20, 80, 20)];
    
    _passwordFile.placeholder = @"密码";
    _passwordFile.font = [UIFont systemFontOfSize:14];
    [view1 addSubview:_passwordFile];
    
    UIView * line2 = [[UIView alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(accountLab1.frame)+5, view1.frame.size.width-40, 1)];
    line2.backgroundColor = [UIColor blackColor];
    line2.alpha = 0.5;
    [view1 addSubview:line2];
    
    UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(20, CGRectGetMaxY(line2.frame)+20, view1.frame.size.width-40, 40);
    btn.backgroundColor = [[Appsetting sharedInstance] getThemeColor];
    [btn setTitle:@"提交" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(submit) forControlEvents:UIControlEventTouchUpInside];
    [view1 addSubview:btn];
}
-(void)submit{
    if (![UIUtils isBlankString:_accountFile.text]&&![UIUtils isBlankString:_passwordFile.text]) {
        if (self.delegate&&[self.delegate respondsToSelector:@selector(submitDelegateWithAccount:withPassword:)]) {
            [self.delegate submitDelegateWithAccount:_accountFile.text withPassword:_passwordFile.text];
        }
    }else{
        [UIUtils showInfoMessage:@"请填信息完整再提交"];
    }
}
-(void)outView{
    if (self.delegate&&[self.delegate respondsToSelector:@selector(outViewDelegate)]) {
        [self.delegate outViewDelegate];
    }
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
