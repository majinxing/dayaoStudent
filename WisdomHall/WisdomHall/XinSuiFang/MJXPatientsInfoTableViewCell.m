//
//  MJXPatientsInfoTableViewCell.m
//  XinSuiFang
//
//  Created by majinxing on 16/9/2.
//  Copyright © 2016年 majinxing. All rights reserved.
//

#import "MJXPatientsInfoTableViewCell.h"
#import "UIImageView+WebCache.h"

@implementation MJXPatientsInfoTableViewCell

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
-(void)setNameWithPatients:(MJXPatients *)patients{
    
    UIImageView *image=[[UIImageView alloc] initWithFrame:CGRectMake(12, 12, 35, 35)];
        [image sd_setImageWithURL:[NSURL URLWithString:patients.patientHeadImageUrl] placeholderImage:[UIImage imageNamed:@"man"]];
    UILabel *name=[[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(image.frame)+12, 22, 200, 13)];
    name.text=patients.patientsName;
    name.textColor=[UIColor colorWithHexString:@"#666666"];
    name.font=[UIFont systemFontOfSize:14];
    //算文字长度的
    CGSize detailSize1 = [name.text sizeWithFont:[UIFont systemFontOfSize:14] constrainedToSize:CGSizeMake(200, MAXFLOAT) lineBreakMode:UILineBreakModeWordWrap];
    UILabel *age = [[UILabel alloc] initWithFrame:CGRectMake(name.frame.origin.x+detailSize1.width+13, 22, 60, 13)];
    age.text = [NSString stringWithFormat:@"  %@岁",patients.patientAge];
    age.textColor = [UIColor colorWithHexString:@"#666666"];
    age.font = [UIFont systemFontOfSize:14];
    
    //算文字长度的
    CGSize detailSize2 = [age.text sizeWithFont:[UIFont systemFontOfSize:14] constrainedToSize:CGSizeMake(260, MAXFLOAT) lineBreakMode:UILineBreakModeWordWrap];
    UIImageView *sex = [[UIImageView alloc] initWithFrame:CGRectMake(age.frame.origin.x+detailSize2.width+12, 22, 13, 13)];
    if ([patients.patientSex isEqualToString:@"男"]) {
        sex.image=[UIImage imageNamed:@"boy"];
    }else if ([patients.patientSex isEqualToString:@"女"]){
        sex.image=[UIImage imageNamed:@"girl"];
    }
    [self.contentView addSubview:name];
    [self.contentView addSubview:age];
    [self.contentView addSubview:sex];
    [self.contentView addSubview:image];
    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
