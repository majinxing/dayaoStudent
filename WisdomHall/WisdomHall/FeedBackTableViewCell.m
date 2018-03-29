//
//  FeedBackTableViewCell.m
//  WisdomHall
//
//  Created by XTU-TI on 2017/8/1.
//  Copyright © 2017年 majinxing. All rights reserved.
//

#import "FeedBackTableViewCell.h"

@interface FeedBackTableViewCell()<UITextFieldDelegate>
@property (strong, nonatomic) IBOutlet UILabel *feedBackLabel;
@property (strong, nonatomic) IBOutlet UITextView *feedBackTextView;


@end
@implementation FeedBackTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(void)addContentView:(NSString *)labelStr withTextFiled:(NSString *)textFileStr withIndex:(NSInteger)index{
    _feedBackLabel.text = labelStr;
    _feedBackTextView.text = textFileStr;
    _feedBackTextView.tag = index;
    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
#pragma mark UITextFieldDelegate
-(BOOL)textViewShouldBeginEditing:(UITextView *)textView{
    //    if ([_labelText.text isEqualToString:@"题目答案:"]) {
    //        if (self.delegate&&[self.delegate respondsToSelector:@selector(retuanAnswerDelegate)]) {
    //            [self.delegate retuanAnswerDelegate];
    //        }
    //        return NO;
    //    }
    return YES;
}
- (void)textViewDidChange:(UITextView *)textView{
//    CGRect bounds = textView.bounds;
//    // 计算 text view 的高度
//    CGSize maxSize = CGSizeMake(bounds.size.width, CGFLOAT_MAX);
//    CGSize newSize = [textView sizeThatFits:maxSize];
//    bounds.size = newSize;
//    textView.bounds = bounds;
//    // 让 table view 重新计算高度
//    UITableView *tableView = [self tableView];
//    [tableView beginUpdates];
//    [tableView endUpdates];
    
    if (self.delegate&&[self.delegate respondsToSelector:@selector(feedBackCellDelegateTextViewChange:)]) {
        [self.delegate feedBackCellDelegateTextViewChange:textView];
    }
}
//-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString*)text
//{
//    if ([text isEqualToString:@"\n"]) {
//        [textView resignFirstResponder];
//        return NO;
//    }
//    return YES;
//}
//- (UITableView *)tableView
//{
//    UIView *tableView = self.superview;
//    while (![tableView isKindOfClass:[UITableView class]] && tableView) {
//        tableView = tableView.superview;
//    }
//    return (UITableView *)tableView;
//}

@end
