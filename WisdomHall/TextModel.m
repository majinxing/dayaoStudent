//
//  TextModel.m
//  WisdomHall
//
//  Created by XTU-TI on 2017/5/18.
//  Copyright © 2017年 majinxing. All rights reserved.
//

#import "TextModel.h"
#import "UIUtils.h"


@interface TextModel()

@end
@implementation TextModel
-(instancetype)init{
    self = [super init];
    if (self) {
        self.textState = @"未开始";
        self.textId = [NSString stringWithFormat:@"%@",[UIUtils getCurrentDate]];
        self.totalScore = @"0";
        self.totalNumber = @"0";
        self.score = @"0";
    }
    return self;
}
/**
 *
 **/
-(BOOL)whetherIsEmpty{
    if ([UIUtils isBlankString:[NSString stringWithFormat:@"%@",self.textId]]) {
        return NO;
    }else if ([UIUtils isBlankString:self.title]){
        return NO;
    }else if ([UIUtils isBlankString:self.type]){
        return NO;
    }else if ([UIUtils isBlankString:self.indexPoint]){
        return NO;
    }else if ([UIUtils isBlankString:self.timeLimit]){
        return NO;
    }else if ([UIUtils isBlankString:self.textState]){
        return NO;
    }else if ([UIUtils isBlankString:self.redo]){
        return NO;
    }
    return YES;
}

-(void)setSelfInfoWithDict:(NSDictionary *)dict{
    _textId = [dict objectForKey:@"id"];
    
    _createName = [dict objectForKey:@"createName"];
    
    _createUserId = [dict objectForKey:@"createUser"];
    if ([UIUtils isBlankString:[NSString stringWithFormat:@"%@",[dict objectForKey:@"actScore"]]]) {
        _score = @"0";
    }else{
        _score = [NSString stringWithFormat:@"%@",[dict objectForKey:@"actScore"]];

    }
    
    _totalScore = [NSString stringWithFormat:@"%@",[dict objectForKey:@"totalScore"]];
    
    _title = [dict objectForKey:@"name"];
    
    _resultStatus = [NSString stringWithFormat:@"%@",[dict objectForKey:@"resultStatus"]];
    
    NSString * str = [NSString stringWithFormat:@"%@",[dict objectForKey:@"status"]];
    if ([str isEqualToString:@"1"]) {
        _statusName = @"关闭";
    }else if ([str isEqualToString:@"2"]){
        _statusName = @"未进行";
    }else if ([str isEqualToString:@"3"]){
        _statusName = @"进行中";
    }else if ([str isEqualToString:@"4"]){
        _statusName = @"已完成";
    }else if ([str isEqualToString:@"5"]){
        _statusName = @"已批阅";
    }
    
}

@end
