//
//  AskForLeaveView.m
//  WisdomHall
//
//  Created by XTU-TI on 2018/7/21.
//  Copyright © 2018年 majinxing. All rights reserved.
//

#import "AskForLeaveView.h"


@interface AskForLeaveView()
@property (nonatomic,strong)UIButton * addPeopleBtn;

@property (nonatomic,strong)IMGroupModel * imGroupModel;

@property (nonatomic,strong)UITextField * inputName;

@property (nonatomic,strong)UITextView * introductionView;



@end
@implementation AskForLeaveView
-(instancetype)init{
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}
-(void)addContentViewWithAry:(NSMutableArray *)ary {
    UIButton * blackView = [UIButton buttonWithType:UIButtonTypeCustom];
    
    blackView.frame =  CGRectMake(0, 0, APPLICATION_WIDTH, APPLICATION_HEIGHT);
    blackView.backgroundColor = [UIColor blackColor];
    blackView.alpha = 0.5;
    [blackView addTarget:self action:@selector(outSelfView) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:blackView];
    
    UIButton * whiteView = [UIButton buttonWithType:UIButtonTypeCustom];
    
    whiteView.frame = CGRectMake(0, 125, APPLICATION_WIDTH, APPLICATION_HEIGHT-125);
    
    whiteView.backgroundColor = [UIColor whiteColor];
    [whiteView addTarget:self action:@selector(endEdite) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:whiteView];
    whiteView.layer.masksToBounds = YES;
    whiteView.layer.cornerRadius = 14;
    
    UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(25, 10, 200, 28)];
    label.text = @"请假申请";
    label.font = [UIFont fontWithName:@"PingFangSC-Semibold" size:20];
    label.textColor = [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1/1.0];
    [whiteView addSubview:label];
    
    UserModel * user = [[Appsetting sharedInstance] getUsetInfo];
    
    UILabel * groupName = [[UILabel alloc] initWithFrame:CGRectMake(25, CGRectGetMaxY(label.frame)+26, 60, 21)];
    
    groupName.text = @"请假人";
    
    groupName.font = [UIFont fontWithName:@"PingFangSC-Regular" size:15];
    
    groupName.textColor = [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1/1.0];
    
    [whiteView addSubview:groupName];
    
    _inputName = [[UITextField alloc] initWithFrame:CGRectMake(CGRectGetMaxX(groupName.frame)+20, CGRectGetMaxY(label.frame)+26, 200, 20)];
    
    _inputName.text = user.userName;
    _inputName.font = [UIFont systemFontOfSize:15];
    [_inputName endEditing:NO];
    [whiteView addSubview:_inputName];
    
    UIView * viewLine = [[UIView alloc] initWithFrame:CGRectMake(25, CGRectGetMaxY(groupName.frame)+10, APPLICATION_WIDTH-50, 1)];
    
    viewLine.backgroundColor = [UIColor grayColor];
    
    [whiteView addSubview:viewLine];
    
    UILabel * groupIntroduction = [[UILabel alloc] initWithFrame:CGRectMake(25, CGRectGetMaxY(viewLine.frame)+20, 60, 20)];
    
    groupIntroduction.font = [UIFont fontWithName:@"PingFangSC-Regular" size:15];
    
    groupIntroduction.textColor = [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1/1.0];
    
    [whiteView addSubview:groupIntroduction];
    
    groupIntroduction.text = @"请假原因";
    
    [whiteView addSubview:groupIntroduction];
    
    _introductionView = [[UITextView alloc] initWithFrame:CGRectMake(25, CGRectGetMaxY(groupIntroduction.frame)+10, APPLICATION_WIDTH-50, 160)];
    _introductionView.backgroundColor =  [UIColor colorWithRed:250/255.0 green:250/255.0 blue:250/255.0 alpha:1/1.0];
    [whiteView addSubview:_introductionView];
    

    UILabel * pictureLable = [[UILabel alloc] initWithFrame:CGRectMake(25, CGRectGetMaxY(_introductionView.frame)+10, 100, 20)];
    pictureLable.text = @"照片证明";
    pictureLable.font = [UIFont fontWithName:@"PingFangSC-Regular" size:15];

    [whiteView addSubview:pictureLable];
    
    _picturebtn = [UIButton buttonWithType:UIButtonTypeCustom];
    
    _picturebtn.frame = CGRectMake(25, CGRectGetMaxY(pictureLable.frame)+10, 70, 70);
    
    [_picturebtn addTarget:self action:@selector(picturebtnPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    [_picturebtn setBackgroundImage:[UIImage imageNamed:@"相机"] forState:UIControlStateNormal];
    
    [whiteView addSubview:_picturebtn];
    
    UIButton * createGroupBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    createGroupBtn.frame = CGRectMake(50,whiteView.frame.size.height-80, APPLICATION_WIDTH-100, 50);
    [createGroupBtn setBackgroundImage:[UIImage imageNamed:@"Rectangle3"] forState:UIControlStateNormal];
    createGroupBtn.layer.masksToBounds = YES;
    createGroupBtn.layer.cornerRadius = 25;
    [createGroupBtn setTitle:@"提交申请" forState:UIControlStateNormal];
    [createGroupBtn addTarget:self action:@selector(createGroupBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
    [whiteView addSubview:createGroupBtn];
    
}
-(void)picturebtnPressed:(UIButton *)btn{
    if (self.delegate&&[self.delegate respondsToSelector:@selector(picturebtnPressedDelegate:)]) {
        [self.delegate picturebtnPressedDelegate:btn];
    }
}
-(void)addPeopleBtnPressed{
    if (self.delegate&&[self.delegate respondsToSelector:@selector(addPeopleBtnPressedDelegae)]) {
        [self.delegate addPeopleBtnPressedDelegae];
    }
}
-(void)outSelfView{
    if (self.delegate&&[self.delegate respondsToSelector:@selector(outSelfViewDelegate)]) {
        [self.delegate outSelfViewDelegate];
    }
}
-(void)endEdite{
    if (self.delegate&&[self.delegate respondsToSelector:@selector(endEditeDelegate)]) {
        [self.delegate endEditeDelegate];
    }
}
-(void)createGroupBtnPressed:(UIButton *)btn{
   
    if (self.delegate&&[self.delegate respondsToSelector:@selector(askForLeaveWithReationDelegate:)]) {
        [self.delegate askForLeaveWithReationDelegate:_introductionView.text];
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
