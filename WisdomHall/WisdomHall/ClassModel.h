//
//  ClassModel.h
//  WisdomHall
//
//  Created by XTU-TI on 2017/7/3.
//  Copyright © 2017年 majinxing. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ClassModel : NSObject
@property (nonatomic,copy)NSString * signStatus;//签到状态
@property (nonatomic,copy)NSString * sclassId;//课程模板id
@property (nonatomic,copy)NSString * courseDetailId;//具体课程id
@property (nonatomic,copy)NSString * signWay;
@property (nonatomic,copy)NSString * typeRoom;//教室名
@property (nonatomic,copy)NSString * weekDayName;
@property (nonatomic,copy)NSString * endTh;//上课结束的节数
@property (nonatomic,copy)NSString * startTh;//上课开始的节数
@property (nonatomic,copy)NSString * actEndTime;
@property (nonatomic,copy)NSString * actStarTime;
@property (nonatomic,copy)NSString * courseStatus;
@property (nonatomic,copy)NSString * teacherId;
@property (nonatomic,copy)NSString * teacherWorkNo;
@property (nonatomic,copy)NSString * teacherName;
@property (nonatomic,copy)NSString * time;
@property (nonatomic,copy)NSString * total;
@property (nonatomic,copy)NSString * pictureId;
@property (nonatomic,copy)NSString * roomId;
@property (nonatomic,copy)NSString * address;
@property (nonatomic,copy)NSString * creatTime;
@property (nonatomic,copy)NSString * name;//课程名
@property (nonatomic,copy)NSString * status;
@property (nonatomic,strong)NSMutableArray * mck;
@property (nonatomic,copy)NSString * courseType;//1、周期 2、临时
@property (nonatomic,copy)NSString * backColock;//课程的背景颜色
@property (nonatomic,copy)NSString * teacherPictureId;
@property (nonatomic,assign)int n;//已签到
@property (nonatomic,assign)int m;//未签到

-(void)setInfoWithDict:(NSDictionary *)dict;
@end
