//
//  CourseStatisticalModel.h
//  WisdomHall
//
//  Created by XTU-TI on 2018/7/25.
//  Copyright © 2018年 majinxing. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CourseStatisticalModel : NSObject
@property (nonatomic,copy) NSString * courseName;
@property (nonatomic,copy) NSString * absenceNum;//旷课
@property (nonatomic,copy) NSString * actNum;//实到
@property (nonatomic,copy) NSString * answerAmount;//抢答
@property (nonatomic,copy) NSString * callAmount;//点名
@property (nonatomic,copy) NSString * existAmount;//退出
@property (nonatomic,copy) NSString * lateNum;//迟到
@property (nonatomic,copy) NSString * leaveEarlyNum;//早退
@property (nonatomic,copy) NSString * leaveNum;//请假
@property (nonatomic,copy) NSString * onlineTime;
@property (nonatomic,copy) NSString * totalNum;
@property (nonatomic,copy) NSString * courseTime;
@property (nonatomic,copy) NSString * courseSignState;

-(void)setValueWithDict:(NSDictionary *)dict;
@end
