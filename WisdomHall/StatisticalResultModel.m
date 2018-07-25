//
//  StatisticalResultModel.m
//  WisdomHall
//
//  Created by XTU-TI on 2018/3/24.
//  Copyright © 2018年 majinxing. All rights reserved.
//

#import "StatisticalResultModel.h"

@implementation StatisticalResultModel
-(void)setValueWithDict:(NSDictionary *)dict{
    _actNum = [dict objectForKey:@"actNum"];
    _attendanceRate = [dict objectForKey:@"attendanceRate"];
    _totalNum = [dict objectForKey:@"totalNum"];
    _courseName = [dict objectForKey:@"courseName"];
    _lateNum = [NSString stringWithFormat:@"%@",[dict objectForKey:@"lateNum"]];
    _leaveEarlyNum = [NSString stringWithFormat:@"%@",[dict objectForKey:@"leaveEarlyNum"]];
    _courseId = [NSString stringWithFormat:@"%@",[dict objectForKey:@"courseId"]];
}
@end
