//
//  StatisticalCourseTableViewCell.m
//  WisdomHall
//
//  Created by XTU-TI on 2018/7/25.
//  Copyright © 2018年 majinxing. All rights reserved.
//

#import "StatisticalCourseTableViewCell.h"

@interface StatisticalCourseTableViewCell()
@property (strong, nonatomic) IBOutlet UIView *backView;
@property (strong, nonatomic) IBOutlet UILabel *courseName;

@property (strong, nonatomic) IBOutlet UILabel *courseTime;
@property (strong, nonatomic) IBOutlet UILabel *courseOnlineTime;
@property (strong, nonatomic) IBOutlet UILabel *courseOutTimes;
@property (strong, nonatomic) IBOutlet UILabel *courseAnswer;
@property (strong, nonatomic) IBOutlet UILabel *courseAsk;
@property (strong, nonatomic) IBOutlet UILabel *courseSignState;

@end
@implementation StatisticalCourseTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    _backView.layer.masksToBounds = YES;
    _backView.layer.cornerRadius = 15;
    _courseName.font = [UIFont fontWithName:@"PingFangSC-Semibold" size:15];
    _courseTime.font = [UIFont fontWithName:@"PingFangSC-Semibold" size:15];
    _courseOnlineTime.font = [UIFont fontWithName:@"PingFangSC-Semibold" size:15];
    _courseOutTimes.font = [UIFont fontWithName:@"PingFangSC-Semibold" size:15];
    _courseAsk.font = [UIFont fontWithName:@"PingFangSC-Semibold" size:15];
    _courseAsk.font = [UIFont fontWithName:@"PingFangSC-Semibold" size:15];
 _courseSignState.font = [UIFont fontWithName:@"PingFangSC-Semibold" size:15];
    // Initialization code
}
-(void)addContentView:(CourseStatisticalModel *)c{
    _courseName.text = c.courseName;
    
    _courseTime.text = c.courseTime;
    
    _courseOnlineTime.text = c.onlineTime;
   
    _courseOutTimes.text = c.existAmount;
   
    _courseAnswer.text = c.answerAmount;

    _courseAsk.text = c.callAmount;
   
    _courseSignState.text = c.courseSignState;
   
    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
