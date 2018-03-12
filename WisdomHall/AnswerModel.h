//
//  AnswerModel.h
//  WisdomHall
//
//  Created by XTU-TI on 2017/5/24.
//  Copyright © 2017年 majinxing. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DYHeader.h"

@interface AnswerModel : NSObject
@property (nonatomic,copy)NSString * A;
@property (nonatomic,copy)NSString * B;
@property (nonatomic,copy)NSString * C;
@property (nonatomic,copy)NSString * D;
@property (nonatomic,strong)NSMutableArray * answerAry;
-(void)changeAnswerWithBtn:(UIButton *)btn;
-(void)answerAryChange;
@end
