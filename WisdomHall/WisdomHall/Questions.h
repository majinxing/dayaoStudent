//
//  Questions.h
//  WisdomHall
//
//  Created by XTU-TI on 2017/5/22.
//  Copyright © 2017年 majinxing. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Questions : NSObject
@property (nonatomic,copy) NSString * questionsID;//试题ID
@property (nonatomic,copy) NSString * title;//题目
@property (nonatomic,copy) NSString * score;//分数
@property (nonatomic,copy) NSString * difficulty;//难度
@property (nonatomic,copy) NSString * answer;//答案
@property (nonatomic,copy) NSString * multiSelect;//单/多选  
@property (nonatomic,copy) NSString * qid;//题号 10
-(BOOL)whetherIsEmpty;
-(void)setSelfInfoWithDict:(NSDictionary *)dict;
+(NSMutableArray *)returnText:(NSMutableArray *)ary;
-(void)getSelfInfo:(NSDictionary *)dict;
@end
