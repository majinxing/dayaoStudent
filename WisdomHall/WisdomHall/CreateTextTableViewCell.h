//
//  CreateTextTableViewCell.h
//  WisdomHall
//
//  Created by XTU-TI on 2017/5/12.
//  Copyright © 2017年 majinxing. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CreateTextTableViewCellDelegate <NSObject>

-(void)createTopicPressedDelegate;

-(void)returnTextViewTextWithLabelDelegate:(NSString *)labelText withTextViewText:(NSString *)textViewText;

-(void)retuanAnswerDelegate;

@end
@interface CreateTextTableViewCell : UITableViewCell

@property (nonatomic,weak) id<CreateTextTableViewCellDelegate>delegate;
-(void)textLabelText:(NSString *)textStr;
-(void)textViewText:(NSString *)text;
//创建试卷时候控件填充文字
-(void)addContentView:(NSString *)lableStr withTextViewStr:(NSString *)textStr;
@end
