//
//  CreateChatGroupView.m
//  WisdomHall
//
//  Created by XTU-TI on 2018/7/18.
//  Copyright © 2018年 majinxing. All rights reserved.
//

#import "CreateChatGroupView.h"


@interface CreateChatGroupView()
@property (nonatomic,strong)UIButton * addPeopleBtn;

@property (nonatomic,strong)IMGroupModel * imGroupModel;

@property (nonatomic,strong)UITextField * inputName;

@property (nonatomic,strong)UITextView * introductionView;

@end
@implementation CreateChatGroupView
-(instancetype)init{
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}
-(void)addContentViewWithAry:(NSMutableArray *)ary{
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
    label.text = @"创建群组";
    label.font = [UIFont fontWithName:@"PingFangSC-Semibold" size:20];
    label.textColor = [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1/1.0];
    [whiteView addSubview:label];
    
    UILabel * groupName = [[UILabel alloc] initWithFrame:CGRectMake(25, CGRectGetMaxY(label.frame)+26, 60, 21)];
    
    groupName.text = @"群组名称";
    
    groupName.font = [UIFont fontWithName:@"PingFangSC-Regular" size:15];
    
    groupName.textColor = [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1/1.0];
    
    [whiteView addSubview:groupName];
    
    _inputName = [[UITextField alloc] initWithFrame:CGRectMake(CGRectGetMaxX(groupName.frame)+20, CGRectGetMaxY(label.frame)+26, 200, 20)];
    
    _inputName.placeholder = @"请输入";
    _inputName.font = [UIFont systemFontOfSize:15];
    [whiteView addSubview:_inputName];
    
    UIView * viewLine = [[UIView alloc] initWithFrame:CGRectMake(25, CGRectGetMaxY(groupName.frame)+10, APPLICATION_WIDTH-50, 1)];
    
    viewLine.backgroundColor = [UIColor grayColor];
    
    [whiteView addSubview:viewLine];
    
    UILabel * groupIntroduction = [[UILabel alloc] initWithFrame:CGRectMake(25, CGRectGetMaxY(viewLine.frame)+20, 60, 20)];
    
    groupIntroduction.font = [UIFont fontWithName:@"PingFangSC-Regular" size:15];
    
    groupIntroduction.textColor = [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1/1.0];
    
    [whiteView addSubview:groupIntroduction];
    
    groupIntroduction.text = @"群组简介";
    
    [whiteView addSubview:groupIntroduction];
    
    _introductionView = [[UITextView alloc] initWithFrame:CGRectMake(25, CGRectGetMaxY(groupIntroduction.frame)+10, APPLICATION_WIDTH-50, 160)];
    _introductionView.backgroundColor =  [UIColor colorWithRed:250/255.0 green:250/255.0 blue:250/255.0 alpha:1/1.0];
    [whiteView addSubview:_introductionView];
    
    UILabel * addPeople = [[UILabel alloc] initWithFrame:CGRectMake(25, CGRectGetMaxY(_introductionView.frame)+20, 60, 20)];
    addPeople.text = @"添加成员";
    addPeople.font = [UIFont fontWithName:@"PingFangSC-Regular" size:15];
    addPeople.textColor = [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1/1.0];
    [whiteView addSubview:addPeople];
    _addPeopleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _addPeopleBtn.frame = CGRectMake(25, CGRectGetMaxY(addPeople.frame)+10, 40, 40);
    _addPeopleBtn.layer.masksToBounds = YES;
    _addPeopleBtn.layer.cornerRadius = 20;
    _addPeopleBtn.backgroundColor = [UIColor colorWithRed:241/255.0 green:241/255.0 blue:241/255.0 alpha:1/1.0];
    [_addPeopleBtn setTitle:@"+" forState:UIControlStateNormal];
    _addPeopleBtn.titleLabel.font = [UIFont systemFontOfSize:35];
    [_addPeopleBtn addTarget:self action:@selector(addPeopleBtnPressed) forControlEvents:UIControlEventTouchUpInside];
    [whiteView addSubview:_addPeopleBtn];
    
    _peopleListView = [[peopleListView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_addPeopleBtn.frame)+10, CGRectGetMaxY(addPeople.frame)+10, self.frame.size.width-CGRectGetMaxX(_addPeopleBtn.frame)-10, 40)];
    
    [_peopleListView addGroupContentView:ary];
    [whiteView addSubview:_peopleListView];
    
    UIButton * createGroupBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    createGroupBtn.frame = CGRectMake(50,whiteView.frame.size.height-80, APPLICATION_WIDTH-100, 50);
    [createGroupBtn setBackgroundImage:[UIImage imageNamed:@"Rectangle3"] forState:UIControlStateNormal];
    createGroupBtn.layer.masksToBounds = YES;
    createGroupBtn.layer.cornerRadius = 25;
    [createGroupBtn setTitle:@"创建群组" forState:UIControlStateNormal];
    [createGroupBtn addTarget:self action:@selector(createGroupBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
    [whiteView addSubview:createGroupBtn];
    
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
    IMGroupModel * imGM = [[IMGroupModel alloc] init];
    imGM.groupName = _inputName.text;
    imGM.groupIntroduction = _introductionView.text;
    
    if (self.delegate&&[self.delegate respondsToSelector:@selector(createGroupBtnPressedDelegate:)]) {
        
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
