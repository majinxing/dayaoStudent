//
//  DiscussListTableViewCell.m
//  WisdomHall
//
//  Created by XTU-TI on 2017/6/13.
//  Copyright © 2017年 majinxing. All rights reserved.
//

#import "DiscussListTableViewCell.h"


@interface DiscussListTableViewCell()
@property (strong, nonatomic) IBOutlet UIImageView *imageDiscuss;

@property (strong, nonatomic) IBOutlet UILabel *discussName;

@end
@implementation DiscussListTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(void)setImage:(NSString *)imageStr withLableTitle:(NSString *)title{
    _imageDiscuss.image = [UIImage imageNamed:imageStr];
    _discussName.text = title;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
