//
//  JoinVoteTableViewCell.m
//  WisdomHall
//
//  Created by XTU-TI on 2017/6/7.
//  Copyright © 2017年 majinxing. All rights reserved.
//

#import "JoinVoteTableViewCell.h"


@interface JoinVoteTableViewCell()<UITextViewDelegate>
@property (strong, nonatomic) IBOutlet UITextView *firstTextView;
@property (strong, nonatomic) IBOutlet UILabel *firstLabel;

@property (strong, nonatomic) IBOutlet UITextView *secondTextVIew;
@property (strong, nonatomic) IBOutlet UIButton *voteBtn;
@property (strong, nonatomic) IBOutlet UIImageView *selecdImage;

@end
@implementation JoinVoteTableViewCell

- (void)awakeFromNib {
    [_voteBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [super awakeFromNib];
    // Initialization code
}
-(void)setTileOrdescribe:(NSString *)title withLableText:(NSString *)labelText{
    _firstTextView.text = [NSString stringWithFormat:@"投票标题：%@",title];
    _firstLabel.text = [NSString stringWithFormat:@"%@",labelText];
}
-(void)setQuestionContent:(NSString *)str{
    _firstTextView.text = [NSString stringWithFormat:@"题目：%@",str];
}
-(void)setSelectText:(NSString *)selectText withTag:(int)tag withSelect:(NSString *)select{
    _secondTextVIew.text = selectText;
    _voteBtn.tag = tag;
    if ([select isEqualToString:@"选中"]) {
        _selecdImage.image = [UIImage imageNamed:@"方形选中-fill"];
    }else{
        _selecdImage.image = [UIImage imageNamed:@"方形未选中"];
    }
}
- (IBAction)voteBtnPressed:(UIButton *)btn {
    if (self.delegate&&[self.delegate respondsToSelector:@selector(voteBtnDelegatePressed:)]) {
        [self.delegate voteBtnDelegatePressed:btn];
    }
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
    
//    if (textView.text.length>0) {
//        _titleLabel.text = @"";
//    }else if (textView.text.length == 0){
//        _titleLabel.text = _lableText;
//    }
//    
//    [self voteTextFileTextChange:textView];
    
    //    [self returnTextViewTithLabel:_labelText.text withTextViewText:textView.text];
}
-(void)voteTextFileTextChange:(UITextView *)textView{
//    if (self.delegate&&[self.delegate respondsToSelector:@selector(textFileTextChangeDelegate:)]) {
//        [self.delegate textFileTextChangeDelegate:textView];
//    }
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
