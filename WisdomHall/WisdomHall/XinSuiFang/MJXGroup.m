//
//  MJXGroup.m
//  XinSuiFang
//
//  Created by majinxing on 16/11/23.
//  Copyright © 2016年 majinxing. All rights reserved.
//

#import "MJXGroup.h"

@implementation MJXGroup
-(void)saveGroup:(NSDictionary *)dict{
    _gName = [dict objectForKey:@"gname"];
    _gId = [dict objectForKey:@"gid"];
}
@end
