//
//  QuestionsTableViewCell.m
//  WisdomHall
//
//  Created by XTU-TI on 2017/5/23.
//  Copyright © 2017年 majinxing. All rights reserved.
//

#import "QuestionsTableViewCell.h"
#import "DYHeader.h"

@interface QuestionsTableViewCell()<UITextViewDelegate>
@property (strong, nonatomic) IBOutlet UITextView *answerText;

@end
@implementation QuestionsTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self=[super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
    }return self;
}

-(void)settitleTextViewText:(NSString *)text withAllQuestionNumber:(int)questionNum{
    self.titleTextView.text = [NSString stringWithFormat:@"%@",text];
}
-(void)setQuestionAnswer:(NSString *)answer withIndex:(int)n{
    if ([UIUtils isBlankString:answer]) {
        self.answerText.text = @"";
    }else{
        self.answerText.text = answer;
    }
    self.answerText.tag = n;
}
- (IBAction)selectBtnPressed:(UIButton*)btn {
    if (self.delegate&&[self.delegate respondsToSelector:@selector(selectBtnPressedDelegate:)]) {
        [self.delegate selectBtnPressedDelegate:btn];
    }
}
- (void)awakeFromNib {
    [super awakeFromNib];
    _answerText.layer.masksToBounds = YES;
    _answerText.layer.cornerRadius = 5;
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
#pragma mark textViewDelegate

-(BOOL)textViewShouldBeginEditing:(UITextView *)textView{
    return YES;
}
- (void)textViewDidChange:(UITextView *)textView{
    CGRect bounds = textView.bounds;
    // 计算 text view 的高度
    CGSize maxSize = CGSizeMake(bounds.size.width, CGFLOAT_MAX);
    CGSize newSize = [textView sizeThatFits:maxSize];
    bounds.size = newSize;
    textView.bounds = bounds;
    // 让 table view 重新计算高度
    UITableView *tableView = [self tableView];
    
    [tableView beginUpdates];
    [tableView endUpdates];
    if (self.delegate&&[self.delegate respondsToSelector:@selector(textViewDidChangeDelegate:)]) {
        [self.delegate textViewDidChangeDelegate:textView];
    }
    //    [self returnTextViewTithLabel:_labelText.text withTextViewText:textView.text];
}

-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString*)text
{
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    return YES;
}
- (UITableView *)tableView
{
    UIView *tableView = self.superview;
    while (![tableView isKindOfClass:[UITableView class]] && tableView) {
        tableView = tableView.superview;
    }
    return (UITableView *)tableView;
}
@end
