//
//  CorrectAnswer.h
//  WisdomHall
//
//  Created by XTU-TI on 2018/5/7.
//  Copyright © 2018年 majinxing. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CorrectAnswer : UIView

@property (nonatomic,strong) UITextView * textView;

@property (nonatomic,strong) UILabel * scoreLabel;

-(void)addContentView:(NSString *)correctAnswer withScore:(NSString *)score;
@end
