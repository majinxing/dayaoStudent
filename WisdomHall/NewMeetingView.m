//
//  NewMeetingView.m
//  WisdomHall
//
//  Created by XTU-TI on 2018/7/4.
//  Copyright © 2018年 majinxing. All rights reserved.
//

#import "NewMeetingView.h"
#import "DYHeader.h"

@interface NewMeetingView()
@property (nonatomic,strong) UILabel * nMeeting;
@property (nonatomic,strong) UILabel * meetingName;
@property (nonatomic,strong) UILabel * meetingTime;
@property (nonatomic,strong) UILabel * meetingAttention;
@property (nonatomic,strong) UILabel * meetingLocation;
//@property ()
@end
@implementation NewMeetingView

-(instancetype)init{
    self = [super init];
    if (self) {
        
    }
    return self;
}

-(void)addContentView:(MeetingModel *)meetingModel{
    if (!_nMeeting) {
        _nMeeting = [[UILabel alloc] initWithFrame:CGRectMake(20, 5, 60, 21)];
    }
    _nMeeting.font = [UIFont fontWithName:@"PingFangSC-Semibold" size:15];
    
    _nMeeting.text = @"最新会议";
    
    [self addSubview:_nMeeting];
    
    if (!_meetingName) {
        _meetingName = [[UILabel alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(_nMeeting.frame)+10, APPLICATION_WIDTH-140, 20)];
        
    }
    _meetingName.text = meetingModel.meetingName;
    _meetingTime.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14];
    [self addSubview:_meetingName];
    
    if (!_meetingTime) {
        _meetingTime = [[UILabel alloc] initWithFrame:CGRectMake(APPLICATION_WIDTH-20-64, CGRectGetMaxY(_nMeeting.frame)+10, 64, 20)];
    }
    _meetingTime.font =  [UIFont fontWithName:@"PingFangSC-Regular" size:12];
    
    _meetingTime.text = meetingModel.meetingTime;
    
    [self addSubview:_meetingTime];
    
    if (!_meetingAttention) {
        _meetingAttention = [[UILabel alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(_meetingName.frame)+5, APPLICATION_WIDTH-40, 45)];
    }
    _meetingAttention.backgroundColor = [UIColor colorWithHexString:@"#FAFAFA"];
    
    _meetingAttention.font = [UIFont fontWithName:@"PingFangSC-Regular" size:12];
    
    _meetingAttention.text = @"参与会议者请准时到达，带上纸笔以及笔记本电脑，准备好教研有关资料。";
    
    _meetingAttention.numberOfLines = 0;
    
    [self addSubview:_meetingAttention];
    
    if (!_meetingLocation) {
        _meetingLocation = [[UILabel alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(_meetingAttention.frame), APPLICATION_WIDTH-40, 20)];
    }
    _meetingLocation.text = meetingModel.meetingPlace;
    
    _meetingLocation.font =  [UIFont fontWithName:@"PingFangSC-Thin" size:13];
    
    [self addSubview:_meetingLocation];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
