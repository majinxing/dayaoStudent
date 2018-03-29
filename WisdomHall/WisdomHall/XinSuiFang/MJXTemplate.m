//
//  MJXTemplate.m
//  XinSuiFang
//
//  Created by majinxing on 16/9/21.
//  Copyright © 2016年 majinxing. All rights reserved.
//

#import "MJXTemplate.h"

@implementation MJXTemplate
-(instancetype)init{
    self = [super init];
    if (self) {
        _timeDay = [[NSString alloc] init];
        _timeYear = [[NSString alloc] init];
        _timeMonth = [[NSString alloc] init];
        _timeWeeks = [[NSString alloc] init];
        _timeStr = [[NSString alloc] init];
        _advice = [[NSString alloc] init];
        _futureTime = [[NSString alloc] init];
        _state = [[NSString alloc] init];
        _nodeId = [[NSString alloc] init];
        _isOK = [[NSString alloc] init];
        _templateId = [[NSString alloc] init];
        _templateName = [[NSString alloc] init];
    }
    return self;
}
@end
