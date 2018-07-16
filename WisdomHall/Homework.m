//
//  Homework.m
//  WisdomHall
//
//  Created by XTU-TI on 2018/3/23.
//  Copyright © 2018年 majinxing. All rights reserved.
//

#import "Homework.h"
#import "DYHeader.h"

@implementation Homework
-(void)setValueWithDict:(NSDictionary *)dict{
    _homeworkId = [dict objectForKey:@"id"];
    _homeworkInfo = [dict objectForKey:@"content"];
    NSArray * ary = [dict objectForKey:@"resourceList"];
    NSString * str = [NSString stringWithFormat:@"%@",[dict objectForKey:@"finishTime"]];
    
    str = [str substringToIndex:10];
    
    NSString * time = [UIUtils getTheTimeStamp:str];
    
    _endTime = [NSString stringWithFormat:@"%@",time];
    _homeworkImageNumber = [NSString stringWithFormat:@"%lu",(unsigned long)ary.count];
    _homeworkAry = [[NSMutableArray alloc] initWithArray:ary];
}
@end
