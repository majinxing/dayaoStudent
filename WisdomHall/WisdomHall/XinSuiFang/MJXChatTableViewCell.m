//
//  MJXChatTableViewCell.m
//  XinSuiFang
//
//  Created by majinxing on 16/10/24.
//  Copyright © 2016年 majinxing. All rights reserved.
//

#import "MJXChatTableViewCell.h"
#import "MJXPatients.h"
#import "UIImageView+WebCache.h"

@interface MJXChatTableViewCell ()
@property (nonatomic,strong)UILabel * chatLabel;
@end
@implementation MJXChatTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self != nil)
    {
        self.backgroundColor = [UIColor colorWithHexString:@"#f2f2f2"];
        _chatLabel = [[UILabel alloc] init];
        _chatLabel.font = [UIFont systemFontOfSize:13];
        _chatLabel.textColor = [UIColor colorWithHexString:@"#b2b2b2"];
    }
    return self;
}
-(void)addChatViewWithChatStr:(NSString *)chatStr withPatients:(MJXPatients *)patients withUser:(NSString *)user withDirection:(BOOL)NN{
    //聊天头像
    UIImageView * headImage = [[UIImageView alloc] init];
    headImage.image = [UIImage imageNamed:@"man"];
    headImage.layer.cornerRadius = 20;
    headImage.layer.masksToBounds = YES;
    
    [self.contentView addSubview:headImage];
    
    UIImageView * sanjiao = [[UIImageView alloc] init];
    [self.contentView addSubview:sanjiao];
    
    UITextView * chat = [[UITextView alloc] init];
    chat.font = [UIFont systemFontOfSize:13];
    chat.textColor = [UIColor colorWithHexString:@"#333333"];
    chat.text = chatStr;
    chat.layer.cornerRadius = 5;
    chat.layer.masksToBounds = YES;
    chat.userInteractionEnabled = NO;
    CGSize sizeStr = [self heightForString:chatStr fontSize:15 andWidth:(243.0/375.0*APPLICATION_WIDTH)];
    
    chat.backgroundColor = [UIColor whiteColor];
    
    [self.contentView addSubview:chat];
    
    if (NN) {
        headImage.frame = CGRectMake(APPLICATION_WIDTH - 50, 10, 40, 40);
        chat.frame = CGRectMake(APPLICATION_WIDTH - 60 - sizeStr.width, 15, sizeStr.width, sizeStr.height);
        sanjiao.frame = CGRectMake(CGRectGetMaxX(chat.frame), 20, 5, 10);
        sanjiao.image = [UIImage imageNamed:@"duihuankuangyou"];
    }else{
        headImage.frame = CGRectMake(10, 10, 40, 40);
        sanjiao.frame = CGRectMake(CGRectGetMaxX(headImage.frame)+5, 20, 5, 10);
        sanjiao.image = [UIImage imageNamed:@"duihuakang"];
        chat.frame = CGRectMake(CGRectGetMaxX(sanjiao.frame), 10, sizeStr.width, sizeStr.height);
    }
    self.height = 10+sizeStr.height;
}
-(CGSize)heightForString:(NSString *)value fontSize:(float)fontSize andWidth:(float)width{
    UITextView *detailTextView = [[UITextView alloc]initWithFrame:CGRectMake(0, 0, width, 0)];
    detailTextView.font = [UIFont systemFontOfSize:fontSize];    detailTextView.text = value;
    CGSize deSize = [detailTextView sizeThatFits:CGSizeMake(width,CGFLOAT_MAX)];
    return deSize;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
//最近咨询列表
-(void)addPatientsChatInfoWith:(MJXPatients *)patients{
    UIImageView * headImage = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 45, 45)];
    headImage.layer.cornerRadius = 5;
    headImage.layer.masksToBounds = YES;
    
    [self.contentView addSubview:headImage];
    if (![patients.patientHeadImageUrl isEqualToString:@""]&&![patients.patientHeadImageUrl isKindOfClass:[NSNull class]]&&patients.patientHeadImageUrl!=nil) {
        if ([patients.patientSex isEqualToString:@"女"]) {
          [headImage sd_setImageWithURL:[NSURL URLWithString:patients.patientHeadImageUrl] placeholderImage:[UIImage imageNamed:@"woman"]];
        }else{
            [headImage sd_setImageWithURL:[NSURL URLWithString:patients.patientHeadImageUrl] placeholderImage:[UIImage imageNamed:@"man"]];
        }
    }else{
        if ([patients.patientSex isEqualToString:@"女"]) {
            headImage.image = [UIImage imageNamed:@"woman"];
        }else{
            headImage.image = [UIImage imageNamed:@"man"];
        }
    }
    
    
    UILabel * name = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(headImage.frame)+12, 14, 120, 15)];
    name.font = [UIFont systemFontOfSize:14];
    name.textColor = [UIColor colorWithHexString:@"#333333"];
    name.text = patients.patientsName;
    [self.contentView addSubview:name];
    
    //算文字长度的
    CGSize detailSize1 = [name.text sizeWithFont:[UIFont systemFontOfSize:14] constrainedToSize:CGSizeMake(120, MAXFLOAT) lineBreakMode:UILineBreakModeWordWrap];
    UILabel * age = [[UILabel alloc] initWithFrame:CGRectMake(name.frame.origin.x+detailSize1.width+10, 14, 50, 15)];
    age.font = [UIFont systemFontOfSize:14];
    age.textColor = [UIColor colorWithHexString:@"#333333"];
    age.text = [NSString stringWithFormat:@"%@ 岁",patients.patientAge];
    [self.contentView addSubview:age];
    
    _chatLabel.frame = CGRectMake(CGRectGetMaxX(headImage.frame)+12, CGRectGetMaxY(name.frame)+10, APPLICATION_WIDTH-(CGRectGetMaxX(headImage.frame)+12)*2 , 15);
    _chatLabel.text = patients.theLastChat;
    [self.contentView addSubview:_chatLabel];
    //算文字长度的
    CGSize detailSize2 = [age.text sizeWithFont:[UIFont systemFontOfSize:14] constrainedToSize:CGSizeMake(120, MAXFLOAT) lineBreakMode:UILineBreakModeWordWrap];
    UIImageView * sex = [[UIImageView alloc] initWithFrame:CGRectMake(age.frame.origin.x+detailSize2.width+10, 14, 15, 15)] ;
    if ([patients.patientSex isEqualToString:@"女"]) {
        sex.image = [UIImage imageNamed:@"girl"];
    }else{
        sex.image = [UIImage imageNamed:@"boy"];
    }
    [self.contentView addSubview:sex];
    
    UILabel * time = [[UILabel alloc] initWithFrame:CGRectMake(APPLICATION_WIDTH-80, 14, 80, 15)];
    time.font = [UIFont systemFontOfSize:14];
    time.textColor = [UIColor colorWithHexString:@"#999999"];
    NSArray *array = [patients.sendTime componentsSeparatedByString:@"-"];
    time.text = [NSString stringWithFormat:@"%@-%@-%@",array[0],array[1],array[2]];
    [self.contentView addSubview:time];
    
    UIView * line = [[UIView alloc] initWithFrame:CGRectMake(0, 59, APPLICATION_WIDTH, 1)];
    line.backgroundColor = [UIColor colorWithHexString:@"#e5e5e5"];
    [self.contentView addSubview:line];
    
}

@end
