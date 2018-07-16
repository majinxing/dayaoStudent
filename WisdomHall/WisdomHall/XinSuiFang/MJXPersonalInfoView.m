//
//  MJXPersonalInfoView.m
//  XinSuiFang
//
//  Created by majinxing on 16/8/15.
//  Copyright © 2016年 majinxing. All rights reserved.
//

#import "MJXPersonalInfoView.h"


@interface MJXPersonalInfoView()<UITextFieldDelegate>

@property (nonatomic,strong) UIView *fatherView;

@end
@implementation MJXPersonalInfoView
-(instancetype)initWithFrame:(CGRect)frame{
    self=[super initWithFrame:frame];
    if (self) {
        [self addTopView];
        [self addButton];
        _dict = [[NSMutableDictionary alloc] init];
    }
    return self;
}
-(void)addTopView{
    _fatherView = [[UIView alloc] initWithFrame:CGRectMake(0,0, APPLICATION_WIDTH-21.0/375.0*APPLICATION_WIDTH*2, 279)];
//    fatherView.layer.borderWidth = 1;
//    fatherView.layer.cornerRadius = 10;
//    fatherView.layer.masksToBounds = YES;
//    fatherView.layer.borderColor = [[UIColor colorWithHexString:@"#b3b3b3"] CGColor];
    
    for (int i=0; i<=4; i++) {
    UIView *lineOne = [MJXUIUtils setLineWithFrame:CGRectMake(10, 55*(i+1)+(i-1), _fatherView.frame.size.width-12, 1)];
    [_fatherView addSubview:lineOne];
    }
    _introduction = [UITextField new];
    NSArray *ary = [NSArray arrayWithObjects:@"姓名",@"医院",@"科室",@"职称",@"简介", nil];
    NSArray *text = [NSArray arrayWithObjects:@"请输入您的真实姓名方便医患交流",@"请选择您所在的医院",@"请选择您所在的科室",@"请选择您的职称",@"一句话概括您的专业特长",nil];
   
    for (int i=0; i<5; i++) {
      UILabel *lab = [MJXUIUtils setUIlableFrame:CGRectMake(20, 18+(55*i)+i-1, 50,25) withText:ary[i] withTitleColor:[UIColor colorWithHexString:@"#333333"] withFont:[UIFont systemFontOfSize:14]];
        [_fatherView addSubview:lab];
        if (i!=4) {
            UITextField *textFieldlab;
            textFieldlab = [MJXUIUtils setTextFieldLabelWithFrame:CGRectMake(70,2+55*i+i-1,_fatherView.frame.size.width-65,55.0) withPlaceholder:text[i]];
            textFieldlab.tag = i+1;
            textFieldlab.delegate=self;
            [textFieldlab addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
            [_fatherView addSubview:textFieldlab];
            if (i<4&&i>0) {
                UIButton *btn=[UIButton buttonWithType:UIButtonTypeCustom];
                btn.frame=CGRectMake(70,2+55*i+i-1,_fatherView.frame.size.width-65,55.0);
                btn.tag=i+100;
                [_fatherView addSubview:btn];
                [btn addTarget:self action:@selector(regionalPressed:) forControlEvents:UIControlEventTouchUpInside];
            }
        }
        if (i==4) {
            _introduction = [MJXUIUtils setTextFieldLabelWithFrame:CGRectMake(70,2+55*i+i-1,_fatherView.frame.size.width-65,55.0) withPlaceholder:text[i]];
            _introduction.tag=i+100;
            [_fatherView addSubview:_introduction];
        }
        
    }
    [self addSubview:_fatherView];

    
}

-(void)addButton{
    _complete = [UIButton buttonWithType:UIButtonTypeCustom];
    _complete.frame = CGRectMake(21.0/375.0*APPLICATION_WIDTH,CGRectGetMaxY(_fatherView.frame)+30, APPLICATION_WIDTH-21.0/375.0*APPLICATION_WIDTH*2, 44);
    [_complete setTitle:@"完 成 注 册" forState:UIControlStateNormal];
    _complete.backgroundColor = [UIColor colorWithHexString:@"#bfbfbf"];
    _complete.layer.cornerRadius = 8;
    _complete.layer.masksToBounds = YES;
    [_complete addTarget:self action:@selector(completeButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    _complete.userInteractionEnabled = NO;
    [self addSubview:_complete];
    
    UIImageView *skipImageView = [[UIImageView alloc] initWithFrame:CGRectMake(342.0/375.0*APPLICATION_WIDTH, CGRectGetMaxY(_complete.frame)+20+1, 9, 9)];
    skipImageView.image = [UIImage imageNamed:@"skip"];
    [self addSubview:skipImageView];
    
    UIButton *skip = [UIButton buttonWithType:UIButtonTypeCustom];
    skip.frame=CGRectMake(316.0/375.0*APPLICATION_WIDTH, CGRectGetMaxY(_complete.frame)+20, 35, 11);
    [skip setTitle:@"跳过" forState:UIControlStateNormal];
    [skip setTitleColor:[UIColor colorWithHexString:@"#999999"] forState:UIControlStateNormal];
    skip.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    
    skip.titleLabel.font = [UIFont systemFontOfSize:12];
    [skip addTarget:self action:@selector(skipPressed) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:skip];
}
#pragma mark delegate
-(void)regionalPressed:(UIButton *)btn{
    if (self.delegate&&[self.delegate respondsToSelector:@selector(personalInfoViewRegionalPressed:)]) {
        [self.delegate personalInfoViewRegionalPressed:btn];
    }
}
-(void)skipPressed{
    if (self.delegate&&[self.delegate respondsToSelector:@selector(personalInfoViewSkipPressed)]) {
        [self.delegate personalInfoViewSkipPressed];
    }
}
-(void)completeButtonPressed{
    if (self.delegate&&[self.delegate respondsToSelector:@selector(personalInfoViewCompletePressed)]) {
        [self.delegate personalInfoViewCompletePressed];
    }
}
-(void)textFieldDidChange:(UITextField *)t{
    for (int i=1; i<=5; i++) {
        UITextField *t=[self viewWithTag:i];
        if (t.text.length>0) {
            _complete.backgroundColor=[UIColor colorWithHexString:@"#01aeff"];
            _complete.userInteractionEnabled=YES;
            return;
        }
        _complete.backgroundColor=[UIColor colorWithHexString:@"#bfbfbf"];
        _complete.userInteractionEnabled=NO;
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
