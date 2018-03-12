//
//  QuestionsTableViewCell.h
//  WisdomHall
//
//  Created by XTU-TI on 2017/5/23.
//  Copyright © 2017年 majinxing. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol QuestionsTableViewCellDelegate <NSObject>
-(void)selectBtnPressedDelegate:(UIButton *)btn;
-(void)textViewDidChangeDelegate:(UITextView *)textView;
@end

@interface QuestionsTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UITextView *titleTextView;
@property (strong, nonatomic) IBOutlet UIImageView *selecteImage;
@property (strong, nonatomic) IBOutlet UILabel *optionsLabel;
@property (strong, nonatomic) IBOutlet UITextView *optionsTextView;
@property (strong, nonatomic) IBOutlet UIButton *selectBtn;
@property (weak, nonatomic) id<QuestionsTableViewCellDelegate> delegate;

-(void)settitleTextViewText:(NSString *)text withAllQuestionNumber:(int)questionNum;
-(void)setQuestionAnswer:(NSString *)answer withIndex:(int)n;
@end
