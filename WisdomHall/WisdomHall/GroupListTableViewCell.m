//
//  GroupListTableViewCell.m
//  WisdomHall
//
//  Created by XTU-TI on 2017/10/10.
//  Copyright © 2017年 majinxing. All rights reserved.
//

#import "GroupListTableViewCell.h"
#import "GroupModel.h"

@interface GroupListTableViewCell()
@property (strong, nonatomic) IBOutlet UILabel *groupName;

@property (strong, nonatomic) IBOutlet UILabel *inviteCode;

@end
@implementation GroupListTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(void)addContentView:(GroupModel *)group{
    _groupName.text = group.groupName;
    _inviteCode.text = [NSString stringWithFormat:@"邀请码：%@",group.groupId];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
