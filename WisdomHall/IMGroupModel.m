//
//  IMGroupModel.m
//  WisdomHall
//
//  Created by XTU-TI on 2018/7/19.
//  Copyright © 2018年 majinxing. All rights reserved.
//

#import "IMGroupModel.h"
#import "SignPeople.h"

@implementation IMGroupModel
-(BOOL)isEmptyInfo{
    if ([UIUtils isBlankString:_groupName]) {
        return NO;
    }
    if ([UIUtils isBlankString:_groupIntroduction]) {
        _groupIntroduction = @"";
    }
    if (_groupPeople.count>0) {
        NSMutableArray * ary = [NSMutableArray arrayWithCapacity:1];
        
        UserModel * user = [[Appsetting sharedInstance] getUsetInfo];
        
        for (int i = 0; i<_groupPeople.count; i++) {
            SignPeople * s = _groupPeople[i];
            NSString * str = [NSString stringWithFormat:@"%@%@",user.school,s.workNo];
            [ary addObject:str];
        }
        [ary addObject:[NSString stringWithFormat:@"%@%@",user.school,user.studentId]];
        [_groupPeople removeAllObjects];
        _groupPeople = [NSMutableArray arrayWithArray:ary];
        
    }else{
        return NO;
    }
    return YES;
}
@end
