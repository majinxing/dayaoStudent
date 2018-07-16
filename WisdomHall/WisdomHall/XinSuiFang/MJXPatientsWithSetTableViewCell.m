//
//  MJXPatientsWithSetTableViewCell.m
//  XinSuiFang
//
//  Created by majinxing on 16/9/25.
//  Copyright © 2016年 majinxing. All rights reserved.
//

#import "MJXPatientsWithSetTableViewCell.h"

@implementation MJXPatientsWithSetTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self != nil)
    {
        
    }
    return self;
}
-(void)receivingPatientCounseling:(NSString *)YN withTitleStr:(NSString *)titleStr{
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(20, 23, 200, 15)];
    label.font = [UIFont systemFontOfSize:15];
    label.textColor = [UIColor colorWithHexString:@"#333333"];
    label.text = titleStr;
    [self.contentView addSubview:label];
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(APPLICATION_WIDTH-17-50, 18, 50, 24);
    if ([titleStr isEqualToString:@"接收患者咨询"]) {
    if ([YN isEqualToString:@"1"]) {
        [btn setImage:[UIImage imageNamed:@"kai-0"] forState:UIControlStateNormal];
    }else{
        [btn setImage:[UIImage imageNamed:@"guan-0"] forState:UIControlStateNormal];
    }
    [btn addTarget:self action:@selector(switchBtn:) forControlEvents:UIControlEventTouchUpInside];
    }else if ([titleStr isEqualToString:@"邀请患者加入心随访"]){
        [btn setImage:[UIImage imageNamed:@"fasong"] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(immediatelySend) forControlEvents:UIControlEventTouchUpInside];
    
    }else if ([titleStr isEqualToString:@"分组设置"]){
        btn.frame = CGRectMake(APPLICATION_WIDTH-22-6, 25, 6, 11);
        [btn setImage:[UIImage imageNamed:@"down"] forState:UIControlStateNormal];
    
    }
    [self.contentView addSubview:btn];

}
-(void)switchBtn:(UIButton *)btn{
    if (self.delegae&&[self.delegae respondsToSelector:@selector(switchBtnPressed:)]) {
        [self.delegae switchBtnPressed:btn];
    }

}
-(void)immediatelySend{
    if (self.delegae&&[self.delegae respondsToSelector:@selector(immediatelySendBtnPressed)]) {
        [self.delegae immediatelySendBtnPressed];
    }

}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
