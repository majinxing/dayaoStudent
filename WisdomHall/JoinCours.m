//
//  JoinCours.m
//  WisdomHall
//
//  Created by XTU-TI on 2017/8/17.
//  Copyright © 2017年 majinxing. All rights reserved.
//

#import "JoinCours.h"
#import "DYHeader.h"

@implementation JoinCours
-(instancetype)init{
    self = [super init];
    if (self) {
        [self addContentView];
    }
    return self;
}
-(void)addContentView{
    UIView * v = [[UIView alloc] initWithFrame:CGRectMake(0, 0, APPLICATION_WIDTH, APPLICATION_HEIGHT)];
    
    v.backgroundColor = [UIColor blackColor];
    
    v.alpha = 0.3;
    
    [self addSubview:v];
    
    UIView * father = [[UIView alloc] initWithFrame:CGRectMake(APPLICATION_WIDTH/2-120, 200, 240, 180)];
    
    father.backgroundColor = [UIColor colorWithRed:250/255.0 green:250/255.0 blue:250/255.0 alpha:1/1.0];;
    
    [self addSubview:father];
    
    UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(20,25, 200-40, 20)];
    label.textColor = [UIColor blackColor];
    label.text = @"请输入邀请码:";
    label.font = [UIFont fontWithName:@"PingFangSC-Thin" size:12];;
    [father addSubview:label];
    
    _courseNumber = [[UITextField alloc] initWithFrame:CGRectMake(20,43, 200-20, 36)];
    _courseNumber.font = [UIFont systemFontOfSize:14];
    _courseNumber.placeholder = @"请输入邀请码";
    _courseNumber.keyboardType = UIKeyboardTypeNumberPad;
    _courseNumber.textColor = [UIColor colorWithHexString:@"#29a7e1"];
    [father addSubview:_courseNumber];
    
    UIButton * cancel = [UIButton buttonWithType:UIButtonTypeCustom];
    cancel.frame = CGRectMake(225, -15, 30, 30);
    [cancel setTitle:@"X" forState:UIControlStateNormal];
//    [cancel setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    cancel.backgroundColor = [UIColor blackColor];
    cancel.titleLabel.font = [UIFont systemFontOfSize:12];
    cancel.layer.masksToBounds = YES;
    cancel.layer.cornerRadius = 15;
//    cancel.layer.borderWidth = 1;
//    cancel.layer.borderColor = [UIColor colorWithHexString:@"#29a7e1"].CGColor;
    [cancel addTarget:self action:@selector(joinCoures:) forControlEvents:UIControlEventTouchUpInside];
    cancel.tag = 1;
    [father addSubview:cancel];
//
    UIButton * determine = [UIButton buttonWithType:UIButtonTypeCustom];
    determine.frame = CGRectMake(20,120, 200, 44);
//    [determine setTitleColor:[UIColor colorWithHexString:@"#29a7e1"] forState:UIControlStateNormal];
    [determine setTitle:@"加入" forState:UIControlStateNormal];
    determine.titleLabel.font = [UIFont systemFontOfSize:12];
    determine.layer.masksToBounds = YES;
//    determine.layer.borderWidth = 1;
//    determine.layer.borderColor = [UIColor colorWithHexString:@"#29a7e1"].CGColor;
    determine.layer.cornerRadius = 22;
    determine.backgroundColor = [UIColor colorWithHexString:@"#0072FD"];
    [determine addTarget:self action:@selector(joinCoures:) forControlEvents:UIControlEventTouchUpInside];
    determine.tag = 2;
    [father addSubview:determine];
    
    
}
-(void)joinCoures:(UIButton *)btn{
    if (self.delegate&&[self.delegate respondsToSelector:@selector(joinCourseDelegete:)]) {
        [self.delegate joinCourseDelegete:btn];
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
