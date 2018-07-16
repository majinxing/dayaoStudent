//
//  MJXPatientsCell.m
//  XinSuiFang
//
//  Created by majinxing on 16/8/26.
//  Copyright © 2016年 majinxing. All rights reserved.
//

#import "MJXPatientsCell.h"
#import "UIImageView+WebCache.h"
#import <Foundation/Foundation.h>

@interface MJXPatientsCell ()
@property (nonatomic,strong) UIImageView *headImageView;
@property (nonatomic,strong) UILabel *nameWithAge;
@property (nonatomic,strong) UIImageView *sexImageView;
@property (nonatomic,strong) UILabel *diagnosis;
@property (nonatomic,strong) UITextField *filed;
@property (nonatomic,strong) UIImageView *open;//分组的那个三角
@property (nonatomic,strong) UIButton * attentionBtn;//接收按钮
@end
@implementation MJXPatientsCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self != nil)
    {
        _open = [[UIImageView alloc] init];
        _headImageView = [[UIImageView alloc] init];
        _headImageView.layer.cornerRadius = 5;
        _headImageView.layer.masksToBounds = YES;
        _nameWithAge = [[UILabel alloc] init];
        
        _attentionBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _attentionBtn.layer.masksToBounds = YES;
        _attentionBtn.layer.cornerRadius = 5;
        _attentionBtn.layer.borderColor = [[UIColor colorWithHexString:@"#01aeff"] CGColor];
        _attentionBtn.layer.borderWidth = 1;
        [_attentionBtn setTitle:@"接受" forState:UIControlStateNormal];
        [_attentionBtn setTitleColor:[UIColor colorWithHexString:@"#01aeff"] forState:UIControlStateNormal];
        
    }
    return self;
}
-(void)setGroupNameWithString:(NSString *)str{
    _filed = [[UITextField alloc] initWithFrame:CGRectMake(10, 0, APPLICATION_WIDTH-15, 60)];
    _filed.text = str;
    _filed.font = [UIFont systemFontOfSize:15];
    _filed.textColor = [UIColor colorWithHexString:@"#333333"];
    [self.contentView addSubview:_filed];
    
    [_filed addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    UIImageView *delect = [[UIImageView alloc] initWithFrame:CGRectMake(APPLICATION_WIDTH-15-20, 20, 15, 15)];
    delect.image = [UIImage imageNamed:@"close-2"];
    [self.contentView addSubview:delect];
    UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(APPLICATION_WIDTH-15-10-15, 0, 40, 50);
    [btn addTarget:self action:@selector(btnDelecate) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:btn];
    
}
-(void)btnDelecate{
    if (self.delegate&&[self.delegate respondsToSelector:@selector(btnDelecatePressed)]) {
        [self.delegate btnDelecatePressed];
    }
}
-(void)textFieldDidChange:(UITextField *)textFiled{
    if (self.delegate&&[self.delegate respondsToSelector:@selector(textFieldDidChangeDid:)]) {
        [self.delegate textFieldDidChangeDid:textFiled];
    }
}
-(void)addNewPatientsButton{
    UIButton *add = [UIButton buttonWithType:UIButtonTypeCustom];
    add.frame = CGRectMake(10, 10, 40, 40);
    [add setBackgroundImage:[UIImage imageNamed:@"tianj"] forState:UIControlStateNormal];
    [add addTarget:self action:@selector(addPatients) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:add];
    
    UILabel *labl = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(add.frame)+13, 22, 100, 16)];
    labl.font = [UIFont systemFontOfSize:15];
    labl.textColor = [UIColor colorWithHexString:@"#333333"];
    labl.text = @"添加成员";
    [self.contentView addSubview:labl];
    
}
-(void)setAddPatientButton{
    
    UIButton *seeAddP=[UIButton buttonWithType:UIButtonTypeCustom];
    seeAddP.frame=CGRectMake(10, 10, 45, 45);
    [seeAddP setImage:[UIImage imageNamed:@"new"] forState:UIControlStateNormal];
    [seeAddP addTarget:self action:@selector(seeAddPatient) forControlEvents:UIControlEventTouchUpInside];
    
    [self.contentView addSubview:seeAddP];
    
    UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(seeAddP.frame)+13, 23, 120, 15)];
    label.font = [UIFont systemFontOfSize:14];
    label.textColor = [UIColor colorWithHexString:@"#333333"];
    label.text = @"新的患者";
    [self.contentView addSubview:label];
}
-(void)setCreateAGroup{
    UIImageView *seeAddP=[[UIImageView alloc] init];
    seeAddP.frame=CGRectMake(20, 20, 20, 20);
    seeAddP.image = [UIImage imageNamed:@"create"];
    
    [self.contentView addSubview:seeAddP];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(seeAddP.frame)+5, 22, 100, 15)];
    label.text = @"创建分组";
    label.font = [UIFont systemFontOfSize:15];
    label.textColor = [UIColor colorWithHexString:@"#333333"];
    [self.contentView addSubview:label];
    UIButton *createAGroupBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [createAGroupBtn addTarget:self action:@selector(createAGroup) forControlEvents:UIControlEventTouchUpInside];
    createAGroupBtn.frame = CGRectMake(0, 0, APPLICATION_WIDTH, 60);
    [self.contentView addSubview:createAGroupBtn];
    
}
-(void)createAGroup{
    if (self.delegate&&[self.delegate respondsToSelector:@selector(createAGroupButtonPressed)]) {
        [self.delegate createAGroupButtonPressed];
    }
}

-(void)setGroupName:(MJXPatients *)patient{
    if (![patient.groupName isEqualToString:@""]&&patient.groupName.length>0&&patient.groupName!=nil) {
        UILabel *lable = [[UILabel alloc] initWithFrame:CGRectMake(16, 16, 180, 17)];
        lable.text = patient.groupName;
        lable.font = [UIFont systemFontOfSize:15];
        lable.textColor = [UIColor colorWithHexString:@"#333333"];
        [self.contentView addSubview:lable];
        UIView * line = [[UIView alloc] initWithFrame:CGRectMake(0, 59, APPLICATION_WIDTH, 1)];
        line.backgroundColor = [UIColor colorWithHexString:@"#e5e5e5"];
        [self.contentView addSubview:line];
    }
}
//分组可选择
-(void)setGroupName:(MJXPatients *)patient withSelect:(BOOL)NN withTag:(int)tagBtn{
    if (![patient.groupName isEqualToString:@""]&&patient.groupName.length>0&&patient.groupName!=nil) {
        UILabel *lable = [[UILabel alloc] initWithFrame:CGRectMake(16, 16, 180, 17)];
        lable.text = patient.groupName;
        lable.font = [UIFont systemFontOfSize:15];
        lable.textColor = [UIColor colorWithHexString:@"#333333"];
        [self.contentView addSubview:lable];
    }
    UIImageView * image = [[UIImageView alloc] initWithFrame:CGRectMake(APPLICATION_WIDTH-10-18, 21, 18, 18)];
    [self.contentView addSubview:image];
    if (NN) {
        image.image = [UIImage imageNamed:@"xuanzhong"];
    }else{
        image.image = [UIImage imageNamed:@"ｙｅｓ"];
    }
    UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(APPLICATION_WIDTH-60, 0, 60, 60);
    btn.tag = tagBtn;
    //btn.backgroundColor = [UIColor greenColor];
    [btn addTarget:self action:@selector(selectBtn:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.contentView addSubview:btn];
    UIView * line = [[UIView alloc] initWithFrame:CGRectMake(0, 59, APPLICATION_WIDTH, 1)];
    line.backgroundColor = [UIColor colorWithHexString:@"#e5e5e5"];
    [self.contentView addSubview:line];
}
-(void)selectBtn:(UIButton *)btn{
    if (self.delegate&&[self.delegate respondsToSelector:@selector(selectBtnPressed:)]) {
        [self.delegate selectBtnPressed:btn];
    }
}
-(void)setInitializeDataWithPatient:(MJXPatients *)patient{
    
    if (![patient.groupName isEqualToString:@""]&&patient.groupName.length>0&&patient.groupName!=nil) {
        _open.frame = CGRectMake(10,20,10,8);
        if (patient.gruopOpen) {
            _open.image = [UIImage imageNamed:@"sanjz"];
        }else{
            _open.frame = CGRectMake(10, 20, 8, 10);
            _open.image = [UIImage imageNamed:@"sanj"];
        }
        
        [self.contentView addSubview:_open];
        
        UILabel *lable = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_open.frame)+6, 16, 180, 17)];
        lable.text = patient.groupName;
        lable.font = [UIFont systemFontOfSize:15];
        lable.textColor = [UIColor colorWithHexString:@"#333333"];
        [self.contentView addSubview:lable];
        
        UIView * line = [[UIView alloc] initWithFrame:CGRectMake(0, 59, APPLICATION_WIDTH, 1)];
        line.backgroundColor = [UIColor colorWithHexString:@"#e6e6e6"];
        [self.contentView addSubview:line];
        return;
    }
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(APPLICATION_WIDTH-60,0,60,60);
    button.tag = [patient.tag intValue]+1;
    [button addTarget:self action:@selector(patientsInGroupButton:) forControlEvents:UIControlEventTouchUpInside];
    
    UIImageView * select = [[UIImageView alloc] initWithFrame:CGRectMake(APPLICATION_WIDTH-35,22, 15, 15)];
    [self.contentView addSubview:select];
    if (![patient.status isEqualToString:@""]&&patient.status.length>0&&patient.status!=nil) {
        if ([patient.status isEqualToString:@"1"]) {
            select.image = [UIImage imageNamed:@"ｙｅｓ"];
            //[button setBackgroundImage:[UIImage imageNamed:@"ｙｅｓ"] forState:UIControlStateNormal];
        }else{
            select.image = [UIImage imageNamed:@"xuanzhong"];
            //[button setBackgroundImage:[UIImage imageNamed:@"xuanzhong"] forState:UIControlStateNormal];
            //button.userInteractionEnabled = NO;
        }
        
    }else{
        button.frame = CGRectMake(0,0,0,0);
    }
    [self.contentView addSubview:button];
    
    if ([patient.attention isEqualToString:@"0"]) {
        _attentionBtn.frame = CGRectMake(APPLICATION_WIDTH-18-75, 15, 75, 35);
        _attentionBtn.tag = [patient.patientId intValue] +1;
        [_attentionBtn addTarget:self action:@selector(attentionButton:) forControlEvents:UIControlEventTouchUpInside];
    }else{
        _attentionBtn.frame = CGRectMake(0, 0, 0, 0);
    }
    [self.contentView addSubview:_attentionBtn];

    
    _headImageView.frame = CGRectMake(10, 10, 45, 45);
    
    NSString * Hurl = [NSString stringWithFormat:@"%@",patient.patientHeadImageUrl];
    if (Hurl!=nil&&![Hurl isEqualToString:@""]&&![Hurl isEqualToString:@"<null>"]&&![Hurl isEqual:@"<null>"]&&Hurl.length>0) {
        [self.headImageView sd_setImageWithURL:[NSURL URLWithString:patient.patientHeadImageUrl] placeholderImage:[UIImage imageNamed:@"woman"]];
        
    }else{
        NSString * sex = [NSString stringWithFormat:@"%@",patient.patientSex];
        if ([sex isEqualToString:@"女"]) {
            _headImageView.image=[UIImage imageNamed:@"woman"];
        }else{
            _headImageView.image=[UIImage imageNamed:@"man"];
        }
        
    }
    _nameWithAge.frame =CGRectMake(CGRectGetMaxX(_headImageView.frame)+13, 11, 200, 13);
    _nameWithAge.text =[NSString stringWithFormat:@"%@",patient.patientsName]; //patient.patientAge;
    [_nameWithAge setTextColor:[UIColor colorWithHexString:@"#333333"]];
    _nameWithAge.font = [UIFont systemFontOfSize:14];
    //算文字长度的
    CGSize detailSize1 = [_nameWithAge.text sizeWithFont:[UIFont systemFontOfSize:15] constrainedToSize:CGSizeMake(200, MAXFLOAT) lineBreakMode:UILineBreakModeWordWrap];
    UILabel *age=[[UILabel alloc] initWithFrame:CGRectMake(_nameWithAge.frame.origin.x+detailSize1.width, 11,60, 13)];
    age.text=[NSString stringWithFormat:@"    %@岁",patient.patientAge];
    [age setTextColor:[UIColor colorWithHexString:@"#333333"]];
    age.font = [UIFont systemFontOfSize:14];
    
    _diagnosis=[[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_headImageView.frame)+13, CGRectGetMaxY(_nameWithAge.frame)+16, APPLICATION_WIDTH-2*(CGRectGetMaxX(_diagnosis.frame)+13), 13)];
    [_diagnosis setTextColor:[UIColor colorWithHexString:@"#777777"]];
    _diagnosis.font=[UIFont systemFontOfSize:13];
    _diagnosis.text=[NSString stringWithFormat:@"诊断:%@",patient.patientDiagnosis];//@"诊断：啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊";
    //算文字长度的
    CGSize detailSize = [age.text sizeWithFont:[UIFont systemFontOfSize:15] constrainedToSize:CGSizeMake(260, MAXFLOAT) lineBreakMode:UILineBreakModeWordWrap];
    _sexImageView=[[UIImageView alloc] initWithFrame:CGRectMake(age.frame.origin.x+detailSize.width, 11, 13, 13)];
    NSString * sex = [NSString stringWithFormat:@"%@",patient.patientSex];
    if ([sex isEqualToString:@"女"]) {
        _sexImageView.image=[UIImage imageNamed:@"girl"];
    }else{
        _sexImageView.image=[UIImage imageNamed:@"boy"];
    }
    
    UIView * line = [[UIView alloc] initWithFrame:CGRectMake(10.0/375.0*APPLICATION_WIDTH, 64, APPLICATION_WIDTH-2*10.0/375.0*APPLICATION_WIDTH, 1)];
    line.backgroundColor = [UIColor colorWithHexString:@"#e6e6e6"];
    [self.contentView addSubview:line];
    [self.contentView addSubview:age];
    [self.contentView addSubview:_headImageView];
    [self.contentView addSubview:_nameWithAge];
    [self.contentView addSubview:_diagnosis];
    [self.contentView addSubview:_sexImageView];
}
-(void)seeAddPatient{
    if (self.delegate&&[self.delegate respondsToSelector:@selector(seeAddNewPatientsButtonPressed)]) {
        [self.delegate seeAddNewPatientsButtonPressed];
    }
}
-(void)setGroupManagement{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setBackgroundImage:[UIImage imageNamed:@"guanli"] forState:UIControlStateNormal];
    button.frame = CGRectMake(10, 5, 40, 40);
    [button addTarget:self action:@selector(groupManagement) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:button];
    UILabel *lable = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(button.frame)+10, 18, 100, 14)];
    lable.text = @"分组管理";
    lable.font = [UIFont systemFontOfSize:15];
    lable.textColor = [UIColor colorWithHexString:@"#333333"];
    [self.contentView addSubview:lable];
    
    UIView * line = [[UIView alloc] initWithFrame:CGRectMake(0, 59, APPLICATION_WIDTH, 11)];
    line.backgroundColor = [UIColor colorWithHexString:@"#f7f7f7"];
    [self.contentView addSubview:line];
}
-(void)groupManagement{
    if (self.delegate&&[self.delegate respondsToSelector:@selector(groupManagementPressed)]) {
        [self.delegate groupManagementPressed];
    }
}
-(void)addPatients{
    if (self.delegate&&[self.delegate respondsToSelector:@selector(addPatientsButtonPressed)]) {
        [self.delegate addPatientsButtonPressed];
    }
}
-(void)patientsInGroupButton:(UIButton *)btn{
    if (self.delegate&&[self.delegate respondsToSelector:@selector(patientsInGroupButtonPressed:)]) {
        [self.delegate patientsInGroupButtonPressed:btn];
    }
}
-(void)attentionButton:(UIButton *)btn{
    if (self.delegate&&[self.delegate respondsToSelector:@selector(attentionButtonPressed:)]) {
        [self.delegate attentionButtonPressed:btn];
    }
}
@end
