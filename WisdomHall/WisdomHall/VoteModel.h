//
//  VoteModel.h
//  WisdomHall
//
//  Created by XTU-TI on 2017/6/5.
//  Copyright © 2017年 majinxing. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DYHeader.h"

@interface VoteModel : NSObject
@property (nonatomic,copy)NSString * title;//主题
@property (nonatomic,copy)NSString * describe;//描述
@property (nonatomic,copy)NSString * chooseNumber;//单选还是双选
@property (nonatomic,strong)NSMutableArray * selectAry;//选项
@property (nonatomic,copy)NSString *  largestNumbe;//最大可选择几个
@property (nonatomic,copy)NSString * time;//
@property (nonatomic,copy)NSString * voteState;
@property (nonatomic,copy)NSString * voteId;
@property (nonatomic,copy)NSString * selfVoteStatus;

-(void)changeText:(UITextView *)textView;
-(void)setInfo:(NSDictionary *)dict;
@end
