//
//  CourseStatisticalModel.m
//  WisdomHall
//
//  Created by XTU-TI on 2018/7/25.
//  Copyright © 2018年 majinxing. All rights reserved.
//

#import "CourseStatisticalModel.h"

@implementation CourseStatisticalModel

-(void)setValueWithDict:(NSDictionary *)dict{
    _absenceNum = [NSString stringWithFormat:@"%@",[dict objectForKey:@"absenceNum"]];
    _actNum = [NSString stringWithFormat:@"%@",[dict objectForKey:@"actNum"]];
    _answerAmount = [NSString stringWithFormat:@"%@",[dict objectForKey:@"answerAmount"]];
    _callAmount = [NSString stringWithFormat:@"%@",[dict objectForKey:@"callAmount"]];
    _existAmount = [NSString stringWithFormat:@"%@",[dict objectForKey:@"existAmount"]];
    _lateNum = [NSString stringWithFormat:@"%@",[dict objectForKey:@"lateNum"]];
    _leaveEarlyNum = [NSString stringWithFormat:@"%@",[dict objectForKey:@"leaveEarlyNum"]];
    _leaveNum = [NSString stringWithFormat:@"%@",[dict objectForKey:@"leaveNum"]];
    _onlineTime = [NSString stringWithFormat:@"%@",[dict objectForKey:@"onlineTime"]];
    _totalNum = [NSString stringWithFormat:@"%@",[dict objectForKey:@"totalNum"]];
    _courseTime = [NSString stringWithFormat:@"%@",[dict objectForKey:@"actEndTime"]];
//    签到标识：1.未签到，2.已签到，3.请假已批准 4.迟到  5.早退 6.请假待批准
    
    NSString * signState = [NSString stringWithFormat:@"%@",[dict objectForKey:@"signStatus"]];
    if (![UIUtils isBlankString:signState]) {
        if ([signState isEqualToString:@"1"]) {
            _courseSignState = @"未签到";
        }else if ([signState isEqualToString:@"2"]) {
            _courseSignState = @"已签到";
        }else if ([signState isEqualToString:@"3"]) {
            _courseSignState = @"请假已批准";
        }else if ([signState isEqualToString:@"4"]) {
            _courseSignState = @"迟到";
        }else if ([signState isEqualToString:@"5"]) {
            _courseSignState = @"早退";
        }else if ([signState isEqualToString:@"6"]) {
            _courseSignState = @"请假待批准";
        }else{
            _courseSignState = @"";
        }
    }else{
        _courseSignState = @"";
    }
    
}

@end
