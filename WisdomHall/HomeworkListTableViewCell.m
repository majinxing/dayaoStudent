//
//  HomeworkListTableViewCell.m
//  WisdomHall
//
//  Created by XTU-TI on 2018/3/23.
//  Copyright © 2018年 majinxing. All rights reserved.
//

#import "HomeworkListTableViewCell.h"
#import "Appsetting.h"

@interface HomeworkListTableViewCell()
@property (strong, nonatomic) IBOutlet UILabel *homeworkName;
@property (strong, nonatomic) IBOutlet UITextField *homeworkInfo;
@property (strong, nonatomic) IBOutlet UIImageView *homeworkImage;
@property (strong, nonatomic) IBOutlet UILabel *imageNumber;
@property (strong, nonatomic) IBOutlet UIView *backView;
@property (strong, nonatomic) IBOutlet UILabel *timeLabel;
@end

@implementation HomeworkListTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    UIImage * image = [[Appsetting sharedInstance] grayscale:[UIImage imageNamed:@"作业"]];
    _homeworkImage.image = image;
    _timeLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:12];
    _timeLabel.textColor = [UIColor colorWithRed:128/255.0 green:128/255.0 blue:128/255.0 alpha:1/1.0];
    _backView.layer.masksToBounds = YES;
    _backView.layer.cornerRadius = 5;
    // Initialization code
}
-(void)addContentViewWith:(Homework *)homework{
    _homeworkInfo.text = homework.homeworkInfo;
//    _homeworkInfo.editing = NO;
    
    [_homeworkInfo setEnabled:NO];
    _imageNumber.text = homework.homeworkImageNumber;
    if (![UIUtils isBlankString:[NSString stringWithFormat:@"%@",homework.endTime]]) {
        NSArray * ary = [[NSString stringWithFormat:@"%@",homework.endTime] componentsSeparatedByString:@" "];
        if (ary.count>0) {
            _timeLabel.text = [NSString stringWithFormat:@"%@",ary[0]];
        }
    }
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
