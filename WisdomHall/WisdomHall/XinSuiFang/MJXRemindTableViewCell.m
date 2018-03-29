//
//  MJXRemindTableViewCell.m
//  XinSuiFang
//
//  Created by majinxing on 16/9/21.
//  Copyright © 2016年 majinxing. All rights reserved.
//

#import "MJXRemindTableViewCell.h"

@implementation MJXRemindTableViewCell

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
-(void)addTimeButtonWithButtonTitle:(NSString *)buttonTitle{
    UIImageView * tixing = [[UIImageView alloc] initWithFrame:CGRectMake(20, 10, 15, 12)];
    tixing.image = [UIImage imageNamed:@"laba"];
    [self.contentView addSubview:tixing];
    
    UILabel *lable = [[UILabel alloc] init];
    //自动折行设置
    lable.lineBreakMode = UILineBreakModeWordWrap;
    lable.numberOfLines = 0;
    lable.text = @"系统将根据您设定的日期自动发送随访提醒";
    lable.font = [UIFont systemFontOfSize:15];
    CGSize  h  = [lable.text sizeWithFont:[UIFont systemFontOfSize:15] constrainedToSize:CGSizeMake(APPLICATION_WIDTH-CGRectGetMaxX(tixing.frame)-4, MAXFLOAT) lineBreakMode:UILineBreakModeWordWrap];;
    lable.frame = CGRectMake(CGRectGetMaxX(tixing.frame)+4, 7, APPLICATION_WIDTH-CGRectGetMaxX(tixing.frame)-4, h.height);
    lable.textColor = [UIColor colorWithHexString:@"#999999"];
    [self.contentView addSubview:lable];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.layer.cornerRadius = 5;
    button.layer.masksToBounds = YES;
   
    button.frame = CGRectMake(20, CGRectGetMaxY(lable.frame)+18, APPLICATION_WIDTH-40, 40);
    button.titleLabel.font = [UIFont systemFontOfSize:15];
    [button setTitleColor:[UIColor colorWithHexString:@"#01aeff"] forState:UIControlStateNormal];
    button.layer.borderWidth = 1;
    button.layer.borderColor = [[UIColor colorWithHexString:@"#01aeff"] CGColor];
    [button setTitle:buttonTitle forState:UIControlStateNormal];
    [button addTarget:self action:@selector(chanageTime:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.contentView addSubview:button];
    self.height = 10+h.height+18+40+25;

}

-(void)chanageTime:(UIButton *)btn{
    if (self.delegate&&[self.delegate respondsToSelector:@selector(chanageTimeButtonPressed:)]) {
        [self.delegate chanageTimeButtonPressed:btn];
    }
}
-(void)addInformTheContentWithSendTime:(NSString *)sendTime withTime:(NSString *)time withPatientName:(NSString *)name{
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(10.5, 0, 1, 100)];
    line.backgroundColor = [UIColor colorWithHexString:@"#e5e5e5"];
    [self.contentView addSubview:line];
    
    UIImageView *round = [[UIImageView alloc] initWithFrame:CGRectMake(5, 10, 10, 10)];
    round.layer.cornerRadius = 5;
    round.layer.masksToBounds = YES;
    [self.contentView addSubview:round];
    
    UILabel *titleTime = [[UILabel alloc] initWithFrame:CGRectMake(30, 10, 200, 15)];
    titleTime.text = [NSString stringWithFormat:@"%@  9:00",sendTime];
    titleTime.font = [UIFont systemFontOfSize:13];
    [self.contentView addSubview:titleTime];
    
    UITextView *text = [[UITextView alloc] initWithFrame:CGRectMake(20, 30, APPLICATION_WIDTH-20, 50)];
    text.userInteractionEnabled = NO;
    text.font = [UIFont systemFontOfSize:13];
    [self.contentView addSubview:text];
    
    if ([sendTime isEqualToString:[self getCurrentDate]]) {
      text.text = [NSString stringWithFormat:@"【立即发送】%@给%@发送基准日期%@后的复查提醒",sendTime,name,time];
    }else{
      text.text = [NSString stringWithFormat:@"【%@】%@给%@发送基准日期%@后的复查提醒",time,sendTime,name,time];
    }
    if ([sendTime isEqualToString:[self getCurrentDate]]) {
        
        titleTime.textColor = [UIColor colorWithHexString:@"#01aeff"];
        text.textColor = [UIColor colorWithHexString:@"#01aeff"];
        round.image = [UIImage imageNamed:@"lijifs"];
        round.frame = CGRectMake(5, 10, 15, 15);
    }else{
        round.backgroundColor = [UIColor colorWithHexString:@"#e5e5e5"];
//        titleTime.backgroundColor = [UIColor colorWithHexString:@"#999999"];
//        text.backgroundColor = [UIColor colorWithHexString:@"#999999"];
//        round.backgroundColor = [UIColor colorWithHexString:@"#999999"];
    }
 
}
/**
 *  获取当地日期
 */
-(NSString *)getCurrentDate
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    int unit = NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    
    //获得当前时间的年月日时分
    NSDateComponents *nowCmps = [calendar components:unit fromDate:[NSDate date]];
    NSString *m = [[NSString alloc] init];
    NSString *d = [[NSString alloc] init];
    if (nowCmps.month<10) {
        m = [NSString stringWithFormat:@"0%d",(int)nowCmps.month];
    }else{
        m = [NSString stringWithFormat:@"%d",(int)nowCmps.month];
    }
        
    if (nowCmps.day<10) {
        d = [NSString stringWithFormat:@"0%d",(int)nowCmps.day];
    }else{
        d = [NSString stringWithFormat:@"%d",(int)nowCmps.day];
    }
    NSString *nowDate = [NSString stringWithFormat:@"%ld-%@-%@",nowCmps.year,m,d];
    return nowDate;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
