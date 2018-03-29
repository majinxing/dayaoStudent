//
//  VoteOption.h
//  WisdomHall
//
//  Created by XTU-TI on 2017/8/21.
//  Copyright © 2017年 majinxing. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VoteOption : NSObject
@property (nonatomic,copy)NSString * optionId;
@property (nonatomic,copy)NSString * content;
@property (nonatomic,copy)NSString * count;//投票的数量
@property (nonatomic,copy)NSString * voteId;//投票的id
-(void)setInfoWithDict:(NSDictionary *)dict;
-(void)setInfo:(NSDictionary *)dict;
@end
