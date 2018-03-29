//
//  MJXTemplateNameTableViewCell.m
//  XinSuiFang
//
//  Created by majinxing on 16/9/26.
//  Copyright © 2016年 majinxing. All rights reserved.
//

#import "MJXTemplateNameTableViewCell.h"

@implementation MJXTemplateNameTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self != nil)
    {
        _templateName = [[NSString alloc] init];
    }
    return self;
}
-(void)setUserTemplateWithImage:(NSString *)imageStr withTitleText:(NSString *)textStr{
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(20, 20, 20, 20)];
    imageView.image = [UIImage imageNamed:imageStr];
    [self.contentView addSubview:imageView];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(imageView.frame)+15, 23, 150, 14)];
    label.font= [UIFont systemFontOfSize:14];
    label.textColor = [UIColor colorWithHexString:@"#333333"];
    label.text = textStr;
    [self.contentView addSubview:label];
    if ([textStr isEqualToString:@"使用随访模板"]) {
        UIView *line  = [[UIView alloc] initWithFrame:CGRectMake(0, 59, APPLICATION_WIDTH, 1)];
        line.backgroundColor = [UIColor colorWithHexString:@"#e5e5e5"];
        [self.contentView addSubview:line];
    }
}
-(void)setTemplateName:(NSString *)name{
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(20, 23, APPLICATION_WIDTH-40, 14)];
    label.font = [UIFont systemFontOfSize:14];
    label.textColor = [UIColor colorWithHexString:@"#333333"];
    label.text =name;
    _templateName = name;
    [self.contentView addSubview:label];
    UIView *line  = [[UIView alloc] initWithFrame:CGRectMake(0, 59, APPLICATION_WIDTH, 1)];
    line.backgroundColor = [UIColor colorWithHexString:@"#e5e5e5"];
    [self.contentView addSubview:line];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
