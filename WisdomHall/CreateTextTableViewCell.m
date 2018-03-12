//
//  CreateTextTableViewCell.m
//  WisdomHall
//
//  Created by XTU-TI on 2017/5/12.
//  Copyright © 2017年 majinxing. All rights reserved.
//

#import "CreateTextTableViewCell.h"

@interface CreateTextTableViewCell()<UITextViewDelegate>


@property (strong, nonatomic) IBOutlet UITextView *textView;

@property (strong, nonatomic) IBOutlet UILabel *labelText;
@property (strong, nonatomic) IBOutlet UIButton *createBtn;


@end
@implementation CreateTextTableViewCell

- (void)awakeFromNib {
    _createBtn.layer.masksToBounds = YES;
    
    _createBtn.layer.cornerRadius = 5;
    
    [super awakeFromNib];
    // Initialization code
}
-(void)addContentView:(NSString *)lableStr withTextViewStr:(NSString *)textStr{
    _labelText.text = lableStr;
    _textView.text = textStr;
}
/**
 *  编辑label文字内容
 **/
-(void)textLabelText:(NSString *)textStr{
    _labelText.text = textStr;
    if ([textStr isEqualToString:@"试题分值："]) {
        _textView.keyboardType = UIKeyboardTypeNumberPad;
    }
}
/**
 * 编辑textView的内容
 **/
-(void)textViewText:(NSString *)text{
    _textView.text = text;
};
- (IBAction)createTopicPressed:(id)sender {
    if (self.delegate&&[self.delegate respondsToSelector:@selector(createTopicPressedDelegate)]) {
        [self.delegate createTopicPressedDelegate];
    }
}
-(void)returnTextViewTextWithLabel:(NSString *)labelText withTextViewText:(NSString *)textViewText{
    if (self.delegate&&[self.delegate respondsToSelector:@selector(returnTextViewTextWithLabelDelegate:withTextViewText:)]) {
        [self.delegate returnTextViewTextWithLabelDelegate:labelText withTextViewText:textViewText];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}
#pragma mark textViewDelegate

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
    [self returnTextViewTextWithLabel:_labelText.text withTextViewText:textView.text];
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
