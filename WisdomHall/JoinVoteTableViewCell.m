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
@property (strong, nonatomic) IBOutlet UILabel *voteStateLabel;
@property (strong, nonatomic) IBOutlet UIView *fristBackView;
@property (strong, nonatomic) IBOutlet UIView *secondBackView;

@end
@implementation JoinVoteTableViewCell

- (void)awakeFromNib {
    [_voteBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [super awakeFromNib];
    
    _firstTextView.font = [UIFont fontWithName:@"PingFangSC-Regular" size:15];
    _firstTextView.textColor = [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1/1.0];
    
    _firstLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:12];
    _firstLabel.textColor = [UIColor colorWithRed:128/255.0 green:128/255.0 blue:128/255.0 alpha:1/1.0];
    
    _voteStateLabel.font = [UIFont fontWithName:@"PingFangSC-Semibold" size:12];
    _voteStateLabel.textColor = [UIColor colorWithRed:0/255.0 green:118/255.0 blue:253/255.0 alpha:1/1.0];
    
    _fristBackView.layer.masksToBounds = YES;
    _fristBackView.layer.cornerRadius = 5;
    _secondBackView.layer.masksToBounds = YES;
    _secondBackView.layer.cornerRadius = 5;
    // Initialization code
}
-(void)setTileOrdescribe:(NSString *)title withLableText:(NSString *)labelText withVoteState:(NSString *)voteStatus selfState:(NSString *)state{
    
    _firstTextView.text = [NSString stringWithFormat:@"投票标题：%@",title];
    
    NSMutableString * str  = [NSMutableString stringWithFormat:@"%@", labelText];
    
    [str deleteCharactersInRange:NSMakeRange(0, 5)];
    
    _firstLabel.text = [NSString stringWithFormat:@"%@",str];
    
    _voteStateLabel.text = [NSString stringWithFormat:@"%@:%@",voteStatus,state];
}
-(void)setQuestionContent:(NSString *)str{
    _firstTextView.text = [NSString stringWithFormat:@"题目：%@",str];
}
-(void)setSelectText:(NSString *)selectText withTag:(int)tag withSelect:(NSString *)select{
    _secondTextVIew.text = selectText;
    _voteBtn.tag = tag;
    if ([select isEqualToString:@"选中"]) {
        _selecdImage.image = [UIImage imageNamed:@"Oval"];
    }else{
        _selecdImage.image = [UIImage imageNamed:@"Oval3"];
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
