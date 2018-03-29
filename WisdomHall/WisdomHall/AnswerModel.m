//
//  AnswerModel.m
//  WisdomHall
//
//  Created by XTU-TI on 2017/5/24.
//  Copyright © 2017年 majinxing. All rights reserved.
//

#import "AnswerModel.h"
#import "DYHeader.h"

@implementation AnswerModel
-(instancetype)init{
    self = [super init];
    if (self) {
        _A = @"";
        _B = @"";
        _C = @"";
        _D = @"";
        _answerAry = [NSMutableArray arrayWithCapacity:4];
        [self answerAryChange];
    }
    return self;
}
-(void)answerAryChange{
    [_answerAry removeAllObjects];
    [_answerAry addObject:_A];
    [_answerAry addObject:_B];
    [_answerAry addObject:_C];
    [_answerAry addObject:_D];
}
-(void)changeAnswerWithBtn:(UIButton *)btn{
    if (btn.tag == 1) {
        if ([_A isEqualToString:@""]) {
            _A = @"选中";
        }else{
            _A = @"";
        }
    }
    if(btn.tag == 2){
        if ([_B isEqualToString:@""]) {
            _B = @"选中";
        }else{
            _B = @"";
        }
    }if(btn.tag == 3){
        if ([_C isEqualToString:@""]) {
            _C = @"选中";
        }else{
            _C = @"";
        }
    }if(btn.tag == 4){
        if ([_D isEqualToString:@""]) {
            _D = @"选中";
        }else{
            _D = @"";
        }
    }
}

@end
