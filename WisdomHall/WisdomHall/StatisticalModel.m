//
//  StatisticalModel.m
//  WisdomHall
//
//  Created by XTU-TI on 2018/1/30.
//  Copyright © 2018年 majinxing. All rights reserved.
//

#import "StatisticalModel.h"
#import "DYHeader.h"

@implementation StatisticalModel
-(instancetype)init{
    self = [super init];
    if (self) {
        self.allIdAry = [NSMutableArray arrayWithCapacity:1];
        self.departmentsAry = [NSMutableArray arrayWithCapacity:1];
        self.professional = [NSMutableArray arrayWithCapacity:1];
        self.theClass = [NSMutableArray arrayWithCapacity:1];
    }
    return self;
}
-(BOOL)statisticalModelIsNil{
    if (self.departmentsAry.count>0){
        
    }else{
        return NO;
    }
    
    if ([UIUtils isBlankString:self.startTime]){
        return NO;
    }else  if ([UIUtils isBlankString:self.endTime]){
        return NO;
    }
    return YES;
}
-(NSMutableDictionary *)returnDict{
    NSMutableDictionary * dict = [[NSMutableDictionary alloc] init];
    [dict setObject:@"500" forKey:@"universityId"];
    if (self.departmentsAry.count>0) {

        [dict setObject:self.departmentsAry forKey:@"facultyIdList"];
    }
    if (self.professional.count>0) {

        [dict setObject:self.professional forKey:@"majorIdList"];
    }
    if (self.theClass.count>0) {

        [dict setObject:self.theClass forKey:@"classIdList"];
    }
    if (![UIUtils isBlankString:self.endTime]&&![UIUtils isBlankString:self.startTime]) {
        NSDictionary * d = [[NSDictionary alloc] initWithObjectsAndKeys:[NSString stringWithFormat:@"%@ 00:00:00",self.startTime],@"startTime",[NSString stringWithFormat:@"%@ 23:59:59",self.endTime],@"endTime", nil];
        NSArray * ary = [[NSArray alloc] initWithObjects:d, nil];
        [dict setObject:ary forKey:@"timePeriodList"];
    }
    return dict;
}
@end
