//
//  StatisticalResultModel.m
//  WisdomHall
//
//  Created by XTU-TI on 2018/1/30.
//  Copyright © 2018年 majinxing. All rights reserved.
//

#import "StatisticalResultModel.h"
#import "DYHeader.h"

@implementation StatisticalResultModel
-(void)setValueWithDict:(NSDictionary *)dict{
    _resultName = [NSString stringWithFormat:@"%@",[dict objectForKey:@"courseName"]];
    if ([UIUtils isBlankString:_resultName]) {
      _resultName = [NSString stringWithFormat:@"%@",[dict objectForKey:@"name"]];
    }
    _totalNum = [NSString stringWithFormat:@"%@",[dict objectForKey:@"totalNum"]];
    _absenceNum = [NSString stringWithFormat:@"%@",[dict objectForKey:@"absenceNum"]];
    _leaveNum = [NSString stringWithFormat:@"%@",[dict objectForKey:@"leaveNum"]];
    _actNum = [NSString stringWithFormat:@"%@",[dict objectForKey:@"actNum"]];
    _attendanceRate = [NSString stringWithFormat:@"%@",[dict objectForKey:@"attendanceRate"]];
    _teacherName = [NSString stringWithFormat:@"%@",[dict objectForKey:@"teacherName"]];
}
@end
