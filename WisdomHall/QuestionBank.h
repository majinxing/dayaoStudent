//
//  QuestionBank.h
//  WisdomHall
//
//  Created by XTU-TI on 2017/9/1.
//  Copyright © 2017年 majinxing. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface QuestionBank : NSObject
@property (nonatomic,copy)NSString * statues ;//题库状态
@property (nonatomic,copy)NSString * libId;//题库id
@property (nonatomic,copy)NSString * libName;//题库名字
-(void)setSelfInfoWithDict:(NSDictionary *)dict;
@end
