//
//  MeetingModel.m
//  WisdomHall
//
//  Created by XTU-TI on 2017/6/20.
//  Copyright © 2017年 majinxing. All rights reserved.
//

#import "MeetingModel.h"
#import "SignPeople.h"

@implementation MeetingModel
-(instancetype)init{
    self = [super init];
    if (self) {
        _signAry = [NSMutableArray arrayWithCapacity:1];
        _signNo = [NSMutableArray arrayWithCapacity:1];
        _n = 0;
        _m = 0;
    }
    return self;
}
-(void)setMeetingInfoWithDict:(NSDictionary *)dict{
    self.meetingId = [dict objectForKey:@"id"];
    self.meetingDetailId = [NSString stringWithFormat:@"%@",[dict objectForKey:@"detailId"]];
    self.mck = [[NSMutableArray alloc] initWithArray:[[dict objectForKey:@"mck"] componentsSeparatedByString:@";"]];
    self.seat = [NSString stringWithFormat:@"%@",[dict objectForKey:@"seat"]];
    self.meetingHostId = [dict objectForKey:@"teacherId"];
    self.meetingHost = [dict objectForKey:@"userName"];
    self.meetingTime = [dict objectForKey:@"actStartTime"];
    self.meetingPlace = [dict objectForKey:@"roomName"];
    //    self.meetingPlaceId = [dict objectForKey:@"roomId"];
    //    self.meetingTotal = [dict objectForKey:@"total"];
    self.signWay = [dict objectForKey:@"signType"];
    //    self.imageUrl = [dict objectForKey:@"url"];
    //    self.meetingStatus = [dict objectForKey:@"status"];
    self.meetingName = [dict objectForKey:@"name"];
    self.signStatus = [dict objectForKey:@"signStatus"];
    if ([[NSString stringWithFormat:@"%@",self.signStatus] isEqualToString:@"3"]) {
        self.signStatus = @"5";
    }
    //    self.url = [dict objectForKey:@"url"];
    self.userSeat = [dict objectForKey:@"userSeat"];
    
    NSArray * a = [dict objectForKey:@"facilitatorInfoList"];
    
    self.meetingHostId = [dict objectForKey:@"createUser"];
    
    if (a.count>0) {
        self.workNo = [a[0] objectForKey:@"workNo"];
        self.meetingHost = [a[0] objectForKey:@"userName"];
    }
    
    //    [self setSignPeopleWithNSArray:[dict objectForKey:@"userSeatList"]];
}
-(void)setSignPeopleWithNSArray:(NSArray *)ary{
    _n = 0;
    _m = 0;//数据重新初始化，这是model对象可能不被销毁，容易造成数据重复叠加
    for (int i =0 ; i<ary.count; i++) {
        SignPeople * sign = [[SignPeople alloc] init];
        [sign setInfoWithDict:ary[i]];
        if ([[NSString stringWithFormat:@"%@",sign.signStatus] isEqualToString:@"2"]) {
            _n = _n +1;
        }else if([[NSString stringWithFormat:@"%@",sign.signStatus] isEqualToString:@"1"]){
            _m = _m+1;
            [_signNo  addObject:sign];
        }
        [_signAry addObject:sign];
    }
}

@end
