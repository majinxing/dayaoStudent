//
//  Group.m
//  WisdomHall
//
//  Created by XTU-TI on 2017/10/9.
//  Copyright © 2017年 majinxing. All rights reserved.
//

#import "GroupModel.h"

@implementation GroupModel
-(void)setSelfWithDict:(NSDictionary *)dict{
    _groupId = [dict objectForKey:@"id"];
    _groupName = [dict objectForKey:@"name"];

}
@end
