//
//  StatisticalResultModel.h
//  WisdomHall
//
//  Created by XTU-TI on 2018/3/24.
//  Copyright © 2018年 majinxing. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface StatisticalResultModel : NSObject
@property (nonatomic,copy) NSString * actNum;//实际签到次数
@property (nonatomic,copy) NSString * attendanceRate;//到课率
@property (nonatomic,copy) NSString * courseName;//课程名字
@property (nonatomic,copy) NSString * totalNum;

@property (nonatomic,copy) NSString * lateNum;//迟到数

@property (nonatomic,copy) NSString * leaveEarlyNum;//早退人数

@property (nonatomic,copy) NSString * courseId;//课程id

-(void)setValueWithDict:(NSDictionary *)dict;
@end
