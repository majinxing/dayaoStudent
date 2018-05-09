//
//  MeetingModel.h
//  WisdomHall
//
//  Created by XTU-TI on 2017/6/20.
//  Copyright © 2017年 majinxing. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MeetingModel : NSObject
@property (nonatomic,copy) NSString * meetingName;//会议名
@property (nonatomic,copy) NSString * meetingHost;//会议创建者
@property (nonatomic,copy) NSString * meetingHostId;//会议创建者id
@property (nonatomic,copy) NSString * meetingPlace;//会议地点
@property (nonatomic,copy) NSString * meetingPlaceId;//会议室的id
@property (nonatomic,copy) NSString * meetingTime;//会议时间

@property (nonatomic,copy) NSString * signStartTime;//会议签到时间

@property (nonatomic,copy) NSString * meetingImage;//会议图片
@property (nonatomic,copy) NSString * peopleNumber;//会议人数
@property (nonatomic,copy) NSString * meetingId;//会议id
@property (nonatomic,copy) NSString * meetingDetailId;
@property (nonatomic,copy) NSString * seat;//座次表
@property (nonatomic,strong) NSMutableArray * mck;//路由器的mac地址
@property (nonatomic,copy) NSString * createTime;//创建时间
@property (nonatomic,copy) NSString * imageUrl;//图片
@property (nonatomic,copy) NSString * meetingTotal;//总人数
@property (nonatomic,copy) NSString * meetingSchoolName;
@property (nonatomic,copy) NSString * userName;
@property (nonatomic,copy) NSString * signWay;//签到方式
@property (nonatomic,copy) NSString * meetingStatus;//会议状态
@property (nonatomic,copy) NSString * signStatus;//签到状态
@property (nonatomic,copy) NSString * url;
@property (nonatomic,copy) NSString * userSeat;//座次
@property (nonatomic,copy) NSString * workNo;
@property (nonatomic,strong) NSMutableArray * signAry;//签到人model数组
@property (nonatomic,strong) NSMutableArray * signNo;//未签到
@property (nonatomic,assign)NSInteger n;//签到人数
@property (nonatomic,assign)NSInteger m;//未签到人数

@property (nonatomic,copy) NSString *meetingSignId;//拍照上传id

-(void)setMeetingInfoWithDict:(NSDictionary *)dict;
//会议参与人员信息
-(void)setSignPeopleWithNSArray:(NSArray *)ary;
@end
