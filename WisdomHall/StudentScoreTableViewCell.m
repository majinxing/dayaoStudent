//
//  StudentScoreTableViewCell.m
//  WisdomHall
//
//  Created by XTU-TI on 2017/9/5.
//  Copyright © 2017年 majinxing. All rights reserved.
//

#import "StudentScoreTableViewCell.h"

@interface StudentScoreTableViewCell()
@property (strong, nonatomic) IBOutlet UILabel *studentScore;
@property (strong, nonatomic) IBOutlet UILabel *studentName;

@end
@implementation StudentScoreTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(void)addStudent:(StudentSorce *)s{
    _studentName.text = [NSString stringWithFormat:@"姓名：%@",s.studentName];
    _studentScore.text = [NSString stringWithFormat:@"分数：%@",s.score];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
