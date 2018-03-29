//
//  MJXQuickReplyTableViewCell.m
//  XinSuiFang
//
//  Created by majinxing on 16/11/4.
//  Copyright © 2016年 majinxing. All rights reserved.
//

#import "MJXQuickReplyTableViewCell.h"

@implementation MJXQuickReplyTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self != nil)
    {
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}
-(void)addTextWithText:(NSString *)text{
    UITextView * tV = [[UITextView alloc] init];
    tV.font = [UIFont systemFontOfSize:15];
    tV.textColor = [UIColor colorWithHexString:@"#333333"];
    tV.text = text;
    tV.userInteractionEnabled = NO;
    CGSize h = [self heightForString:text fontSize:15 andWidth:APPLICATION_WIDTH-30];
    tV.frame = CGRectMake(15, 10, APPLICATION_WIDTH-30, h.height);
    [self.contentView addSubview:tV];
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

@end
