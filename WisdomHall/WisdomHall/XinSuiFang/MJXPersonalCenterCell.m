//
//  MJXPersonalCenterCell.m
//  XinSuiFang
//
//  Created by majinxing on 16/10/9.
//  Copyright © 2016年 majinxing. All rights reserved.
//

#import "MJXPersonalCenterCell.h"
#import "UIImageView+WebCache.h"

@implementation MJXPersonalCenterCell

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
-(void)setImageWithImageName:(NSString *)nameImage{
    UIImage * image = [UIImage imageNamed:nameImage];
    UIImageView * imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, APPLICATION_WIDTH, image.size.height)];
    imageView.image = image;
    self.height = image.size.height;
    [self.contentView addSubview:imageView];

}
-(void)addHeadImage:(NSString *)imageUrl withName:(NSString *)name withTheTitle:(NSString *)title withHospital:(NSString *)hospital{
    UIImageView *image = [[UIImageView alloc] initWithFrame:CGRectMake(APPLICATION_WIDTH/2-41.5, 12, 83, 83)];
    image.layer.cornerRadius = 41.5;
    image.layer.masksToBounds = YES;
    [image sd_setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:[UIImage imageNamed:@"grxxtx"]];
    [self.contentView addSubview:image];
    UILabel *nameWithTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(image.frame)+15, APPLICATION_WIDTH, 15)];
    nameWithTitle.font = [UIFont systemFontOfSize:16];
    nameWithTitle.textColor = [UIColor colorWithHexString:@"#333333"];
    nameWithTitle.textAlignment = NSTextAlignmentCenter;
    nameWithTitle.text = [NSString stringWithFormat:@"%@  %@",name,title];
    [self.contentView addSubview:nameWithTitle];
    UILabel *hospitalLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(nameWithTitle.frame)+15, APPLICATION_WIDTH, 15)];
    hospitalLabel.font = [UIFont systemFontOfSize:13];
    hospitalLabel.textColor = [UIColor colorWithHexString:@"#333333"];
    hospitalLabel.textAlignment = NSTextAlignmentCenter;
    hospitalLabel.text = hospital;
    [self.contentView addSubview:hospitalLabel];
}
-(void)setImageName:(NSString *)imageName withText:(NSString *)text{
    UIImageView *image = [[UIImageView alloc] initWithFrame:CGRectMake(15.0/375.0*APPLICATION_WIDTH, 17, 26, 26)];
    image.layer.cornerRadius = 13;
    image.layer.masksToBounds = YES;
    image.image = [UIImage imageNamed:imageName];
    [self.contentView addSubview:image];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(image.frame)+10, 23, 200, 15)];
    label.font = [UIFont systemFontOfSize:15];
    label.textColor = [UIColor colorWithHexString:@"#333333"];
    label.text = text;
    [self.contentView addSubview:label];
    
    UIView * line = [[UIView alloc] initWithFrame:CGRectMake(0, 59, APPLICATION_WIDTH, 1)];
    line.backgroundColor = [UIColor colorWithHexString:@"#e5e5e5"];
    [self.contentView addSubview:line];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
