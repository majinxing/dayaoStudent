//
//  StatisticalResultModel.h
//  WisdomHall
//
//  Created by XTU-TI on 2018/1/30.
//  Copyright © 2018年 majinxing. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface StatisticalResultModel : NSObject
@property (nonatomic,copy) NSString * resultName;//名字
@property (nonatomic,copy) NSString * absenceNum;//未到 缺勤人数
@property (nonatomic,copy) NSString * attendanceRate;//到课率
@property (nonatomic,copy) NSString * faculityId;//id
@property (nonatomic,copy) NSString * leaveNum;//请假数
@property (nonatomic,copy) NSString * lateNum;//迟到数
@property (nonatomic,copy) NSString * totalNum;//应到人数
@property (nonatomic,copy) NSString * actNum;//实到人数
@property (nonatomic,copy) NSString * teacherName;//老师名字
-(void)setValueWithDict:(NSDictionary *)dict;
//@property (nonatomic,copy) NSString *
//@property (nonatomic,copy) NSString *
@end
