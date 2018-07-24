//
//  ChoiceQuestionTableViewCell.h
//  WisdomHall
//
//  Created by XTU-TI on 2018/5/2.
//  Copyright © 2018年 majinxing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "optionsModel.h"


@protocol ChoiceQuestionTableViewCellDelegate <NSObject>

-(void)firstSelectImageBtnDelegate:(UIButton *)sender;
-(void)selectScoreDeleate:(UIButton *)sender;
-(void)selectDifficultyDelegate:(UIButton *)sender;
-(void)thirthSelectOptionsImageBtnDelegate:(UIButton *)sender;
-(void)addOptionsDelegate:(UIButton *)sender;
-(void)thirthSelectOptionDelegate:(UIButton *)sender;
-(void)textViewDidChangeDelegate:(UITextView *)textView;

-(void)deleAnswerImageDelegate:(UIButton *)sender;

-(void)answerImageDelegate:(UIButton *)btn;

@end

@interface ChoiceQuestionTableViewCell : UITableViewCell

@property (nonatomic,weak)id<ChoiceQuestionTableViewCellDelegate>delegate;

-(void)addFirstTitleTextView:(NSString *)textStr withImageAry:(NSMutableArray *)ary withIsEdit:(BOOL)edit ;

-(void)setScoreAndDifficult:(NSString *)score withDifficult:(NSString *)difficult withEdit:(BOOL)edit;

-(void)addOptionWithModel:(optionsModel *)optionsModel withEdit:(BOOL)edit withIndexRow:(int)row withISelected:(BOOL)isSelected;

-(void)addSeventhTextViewWithStr:(NSString *)str;

-(void)eigthTitleType:(NSString *)titleType withScore:(NSString *)score isSelect:(BOOL)select btnTag:(int)index;

-(void)addOptionWithModel:(optionsModel *)optionsM withIndexRow:(int)row withISelected:(BOOL)isSelected;//题库

-(void)addSeventhTextViewWithStrEndEditor:(NSString *)str;

-(void)addSeventhTextViewWithStr:(NSString *)str withIndexRow:(int)row;//带序号

-(void)addFirstTitleTextView:(NSString *)textStr withImageAry:(NSMutableArray *)ary withIsEdit:(BOOL)edit withIndexRow:(int)indexRow;//标记哪一题（all）

-(void)addCorrectImage:(NSString *)str;//cell的正错image

-(void)setThirdImagee:(NSString *)str;//改变选框颜色

-(void)changeSeventhTextColor;//改变文字颜色

-(void)changeFirstTitleTextColor;
@end
