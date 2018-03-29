//
//  ClassRoomModel.m
//  WisdomHall
//
//  Created by XTU-TI on 2017/7/5.
//  Copyright © 2017年 majinxing. All rights reserved.
//

#import "ClassRoomModel.h"

@implementation ClassRoomModel
-(void)setInfoWithDict:(NSDictionary *)dict{
    self.seat = [dict objectForKey:@"seat"];
    self.classRoomId = [dict objectForKey:@"id"];
    self.universityId = [dict objectForKey:@"universityId"];
    self.classRoomName = [dict objectForKey:@"name"];
    self.mck = [dict objectForKey:@"mck"];
    self.type = [dict objectForKey:@"type"];
}
@end
