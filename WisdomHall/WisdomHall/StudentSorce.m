//
//  StudentSorce.m
//  WisdomHall
//
//  Created by XTU-TI on 2017/9/5.
//  Copyright © 2017年 majinxing. All rights reserved.
//

#import "StudentSorce.h"
#import "DYHeader.h"

@implementation StudentSorce

-(void)setSelfInfoWithDict:(NSDictionary *)dict{
    _studentName = [dict objectForKey:@"userName"];
    if ([UIUtils isBlankString:[NSString stringWithFormat:@"%@",[dict objectForKey:@"score"]]]) {
        _score = @"0";
    }else{
        _score = [dict objectForKey:@"score"];
    }
}
@end

