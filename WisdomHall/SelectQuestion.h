//
//  SelectQuestion.h
//  WisdomHall
//
//  Created by XTU-TI on 2017/9/4.
//  Copyright © 2017年 majinxing. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SelectQuestionDelecate <NSObject>

-(void)selectQViewOutViewDelegate;

-(void)selectEdDelegate:(UIButton *)btn;

@end
@interface SelectQuestion : UIView
@property (nonatomic,weak)id<SelectQuestionDelecate>delegate;
-(void)addScrollViewWithBtnNumber:(int)n;
@end
