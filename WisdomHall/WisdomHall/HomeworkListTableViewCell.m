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
@end

@implementation HomeworkListTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    UIImage * image = [[Appsetting sharedInstance] grayscale:[UIImage imageNamed:@"作业"]];
    _homeworkImage.image = image;
    // Initialization code
}
-(void)addContentViewWith:(Homework *)homework{
    _homeworkInfo.text = homework.homeworkInfo;
    [_homeworkInfo setEnabled:NO];
    _imageNumber.text = homework.homeworkImageNumber;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
