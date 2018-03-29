//
//  StatisticalModel.h
//  WisdomHall
//
//  Created by XTU-TI on 2018/1/30.
//  Copyright © 2018年 majinxing. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface StatisticalModel : NSObject
@property (nonatomic,strong)NSMutableArray * departmentsAry;
@property (nonatomic,strong)NSMutableArray * professional;
@property (nonatomic,strong)NSMutableArray * theClass;

@property (nonatomic,copy)NSString * startTime;
@property (nonatomic,copy)NSString * endTime;
@property (nonatomic,copy)NSString * result;
@property (nonatomic,strong) NSMutableArray * allIdAry;
-(BOOL)statisticalModelIsNil;
-(NSMutableDictionary *)returnDict;
@end
