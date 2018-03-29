//
//  QuestionBank.m
//  WisdomHall
//
//  Created by XTU-TI on 2017/9/1.
//  Copyright © 2017年 majinxing. All rights reserved.
//

#import "QuestionBank.h"

@implementation QuestionBank
-(void)setSelfInfoWithDict:(NSDictionary *)dict{
    _statues = [dict objectForKey:@"status"];
    _libId = [dict objectForKey:@"id"];
    _libName = [dict objectForKey:@"name"];
}

@end
