//
//  ClassModel.m
//  WisdomHall
//
//  Created by XTU-TI on 2017/7/3.
//  Copyright © 2017年 majinxing. All rights reserved.
//

#import "ClassModel.h"
#import "DYHeader.h"

@implementation ClassModel
-(void)setInfoWithDict:(NSDictionary *)dict{
    
    
    self.sclassId = [dict objectForKey:@"id"];
    self.signWay = [dict objectForKey:@"signWay"];
    self.typeRoom = [dict objectForKey:@"roomName"];
    self.teacherId = [dict objectForKey:@"teacherId"];
    self.teacherName = [dict objectForKey:@"teacherName"];
    self.weekDayName = [dict objectForKey:@"weekDayName"];
    self.endTh = [dict objectForKey:@"endTh"];
    self.startTh = [dict objectForKey:@"startTh"];
    
    self.actEndTime = [dict objectForKey:@"actEndTime"];
    self.actEndTime = [self.actEndTime stringByReplacingOccurrencesOfString:@"\n" withString:@" "];
    self.actEndTime = [self.actEndTime stringByReplacingOccurrencesOfString:@"\t" withString:@""];
    
    self.actStarTime = [dict objectForKey:@"actStartTime"];
    self.actStarTime = [self.actStarTime stringByReplacingOccurrencesOfString:@"\n" withString:@" "];
    self.actStarTime = [self.actStarTime stringByReplacingOccurrencesOfString:@"\t" withString:@""];
    
    NSString * str = [NSString stringWithFormat:@"%@",[dict objectForKey:@"signStartTime"]];
    if (![UIUtils isBlankString:str]) {
        self.signStartTime = str;//[dict objectForKey:@"actStartTime"];
        self.signStartTime = [self.signStartTime stringByReplacingOccurrencesOfString:@"\n" withString:@" "];
        self.signStartTime = [self.signStartTime stringByReplacingOccurrencesOfString:@"\t" withString:@""];
        self.signStartTime = [UIUtils timeAddTenMin:self.signStartTime];
    }else{
        self.signStartTime = [NSString stringWithFormat:@"%@",self.actStarTime];
    }
    
    
    self.courseDetailId = [dict objectForKey:@"courseDetailId"];
    self.time = [dict objectForKey:@"actStartTime"];
    self.total = [dict objectForKey:@"total"];
    self.pictureId = [dict objectForKey:@"pictureId"];
    self.roomId = [dict objectForKey:@"roomId"];
    self.address = [dict objectForKey:@"address"];
    self.creatTime = [dict objectForKey:@"createTime"];
    self.name = [dict objectForKey:@"name"];
    self.status = [dict objectForKey:@"status"];
    self.teacherPictureId = [NSString stringWithFormat:@"%@",[dict objectForKey:@"headId"]];
    self.mck = [[NSMutableArray alloc] initWithArray:[[dict objectForKey:@"mck"] componentsSeparatedByString:@";"]];
    
    self.teacherWorkNo = [dict objectForKey:@"teacherWorkNo"];
    self.courseType = [dict objectForKey:@"courseType"];
    self.signStatus = [dict objectForKey:@"signStatus"];
    
}
@end






