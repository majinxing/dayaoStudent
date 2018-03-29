//
//  CourseCollectionViewCell.m
//  WisdomHall
//
//  Created by XTU-TI on 2017/5/3.
//  Copyright © 2017年 majinxing. All rights reserved.
//

#import "CourseCollectionViewCell.h"
#import "DYHeader.h"
#import "MeetingModel.h"
#import "ClassModel.h"

@interface CourseCollectionViewCell ()
@property (strong, nonatomic) IBOutlet UIImageView *cellImage;
@property (strong, nonatomic) IBOutlet UILabel *classOrMeetingName;
@property (strong, nonatomic) IBOutlet UILabel *hostName;
@property (strong, nonatomic) IBOutlet UILabel *place;
@property (strong, nonatomic) IBOutlet UILabel *time;

@property (strong, nonatomic) IBOutlet UIImageView *imageH;

@end
@implementation CourseCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(id)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    if (self) {
        self = [[NSBundle mainBundle]loadNibNamed:@"CourseCollectionViewCell" owner:self options:nil].lastObject;
        self.backgroundColor = [UIColor clearColor];
        
        self.layer.masksToBounds = YES;
        self.layer.cornerRadius = 5.f;
        self.layer.borderWidth = 1;
        self.layer.borderColor = [UIColor colorWithHexString:@"#29a7e1"].CGColor;
    }
    return self;
    
}
-(void)setInfoForContentView:(MeetingModel *)meetingModel{
    _classOrMeetingName.text = [NSString stringWithFormat:@"会议名：%@",meetingModel.meetingName];
    if ([UIUtils isBlankString:meetingModel.meetingHost]) {
        _hostName.text = [NSString stringWithFormat:@"创建者："];

    }else{
        _hostName.text = [NSString stringWithFormat:@"创建者：%@",meetingModel.meetingHost];
    }
    
    _place.text = [NSString stringWithFormat:@"地点：%@",meetingModel.meetingPlace];
    
    NSMutableString *strUrl = [NSMutableString stringWithFormat:@"%@",meetingModel.meetingTime];
    
    _imageH.image = [UIImage imageNamed:@"meet"];
    
//    [strUrl deleteCharactersInRange:NSMakeRange(0,5)];
    

    _time.text = [NSString stringWithFormat:@"时间：%@",strUrl];
}

-(void)setClassInfoForContentView:(ClassModel *)classModel{
    _classOrMeetingName.text = [NSString stringWithFormat:@"课程名：%@",classModel.name];
    if ([UIUtils isBlankString:classModel.teacherName]) {
        _hostName.text = [NSString stringWithFormat:@"老师："];
    }else{
        _hostName.text = [NSString stringWithFormat:@"老师：%@",classModel.teacherName];
    }
    
    _place.text = [NSString stringWithFormat:@"地点：%@",classModel.typeRoom];
    
    NSMutableString *strUrl = [NSMutableString stringWithFormat:@"%@",classModel.actStarTime];
    
    _imageH.image = [UIImage imageNamed:@"index_user_left"];
    
    [strUrl deleteCharactersInRange:NSMakeRange(0,10)];
    
    [strUrl deleteCharactersInRange:NSMakeRange(strUrl.length-3, 3)];
    
    _time.text = [NSString stringWithFormat:@"时间：%@",strUrl];
}
@end
