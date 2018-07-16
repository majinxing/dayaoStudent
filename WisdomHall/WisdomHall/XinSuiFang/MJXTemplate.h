//
//  MJXTemplate.h
//  XinSuiFang
//
//  Created by majinxing on 16/9/21.
//  Copyright © 2016年 majinxing. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MJXTemplate : NSObject
@property (nonatomic,strong)NSString *timeYear;
@property (nonatomic,strong)NSString *timeMonth;
@property (nonatomic,strong)NSString *timeWeeks;
@property (nonatomic,strong)NSString *timeDay;
@property (nonatomic,strong)NSString *state;//提醒状态
@property (nonatomic,strong)NSString *timeStr;//年月日类型
@property (nonatomic,strong)NSString *futureTime;//未来的时间
@property (nonatomic,strong)NSString *advice;
@property (nonatomic,strong)NSString *nodeId;//节点ID
@property (nonatomic,strong)NSString *isOK;
@property (nonatomic,strong)NSString *templateId;//模板ID
@property (nonatomic,strong)NSString *templateName;//模板名字
@end
