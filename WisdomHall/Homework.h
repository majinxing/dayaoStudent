//
//  Homework.h
//  WisdomHall
//
//  Created by XTU-TI on 2018/3/23.
//  Copyright © 2018年 majinxing. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Homework : NSObject
@property (nonatomic,copy) NSString * homeworkInfo;
@property (nonatomic,copy) NSString * homeworkId;
@property (nonatomic,copy) NSString * homeworkImageNumber;
@property (nonatomic,strong) NSMutableArray * homeworkAry;
@property (nonatomic,copy) NSString * endTime;
-(void)setValueWithDict:(NSDictionary *)dict;
@end
