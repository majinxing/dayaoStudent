//
//  SchoolModel.m
//  WisdomHall
//
//  Created by XTU-TI on 2017/6/30.
//  Copyright © 2017年 majinxing. All rights reserved.
//

#import "SchoolModel.h"

@implementation SchoolModel
-(void)setInfoWithDict:(NSDictionary *)dict{
    _schoolName = [dict objectForKey:@"name"];
    _schoolId = [dict objectForKey:@"id"];
    _schoolHost = [dict objectForKey:@"host"];
    _allowregister = [dict objectForKey:@"allowregister"];
}
@end
