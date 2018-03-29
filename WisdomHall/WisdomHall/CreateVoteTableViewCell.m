//
//  CreateVoteTableViewCell.m
//  WisdomHall
//
//  Created by XTU-TI on 2017/6/3.
//  Copyright © 2017年 majinxing. All rights reserved.
//

#import "CreateVoteTableViewCell.h"
#import "DYHeader.h"

@interface CreateVoteTableViewCell()<UITextViewDelegate,UITextFieldDelegate>
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (nonatomic,strong) NSString * lableText;
@property (strong, nonatomic) IBOutlet UITextView *textFile;

@property (strong, nonatomic) IBOutlet UITextField *selectNumTextView;

@property (strong, nonatomic) IBOutlet UILabel *selectLabel;
@property (weak, nonatomic) IBOutlet UITextView *selectTextView;


@end
@implementation CreateVoteTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    _lableText = [[NSString alloc] init];
    _selectNumTextView.delegate = self;
    _selectTextView.delegate = self;
    
    // Initialization code
}
#pragma mark UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    return [textField resignFirstResponder];
}
-(void)addSelectNumeberWithNumer:(NSString *)number withTag:(int)tag{
    _selectNumTextView.text = number;
    _selectNumTextView.keyboardType = UIKeyboardTypeNumberPad;
    _selectNumTextView.placeholder = @"输入投票的最多选项输如：1";
    _selectNumTextView.tag = tag;
    [_selectNumTextView addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
}
-(void)addSelectInfo:(NSString *)selectNumber withSelectText:(NSString *)selectText withTag:(int)tag{
    _selectLabel.text = selectNumber;
    _selectTextView.text = selectText;
    _selectTextView.tag = tag;
    _selectTextView.layer.masksToBounds = YES;
    _selectTextView.layer.cornerRadius = 5;
    _selectTextView.layer.borderWidth = 1;
    _selectTextView.layer.borderColor = RGBA_COLOR(224,224,224, 1).CGColor;
}

-(void)addTableTextWithTextFile:(NSString *)labelText with:(NSString *)textFile withTag:(int)tag{
    if ([UIUtils isBlankString:textFile]) {
        _titleLabel.text = labelText;
    }else{
        _titleLabel.text = @"";
    }
    _lableText = labelText;
    _textFile.text = textFile;
    _textFile.tag = tag;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
#pragma mark textFiledDelegate
-(void)textFieldDidChange:(UITextField *)textFile{
    if (self.delegate&&[self.delegate respondsToSelector:@selector(textFieldDidChangeDelegate:)]) {
        [self.delegate textFieldDidChangeDelegate:textFile];
    }
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
    
    if (textView.text.length>0) {
        _titleLabel.text = @"";
    }else if (textView.text.length == 0){
        _titleLabel.text = _lableText;
    }
    
    [self voteTextFileTextChange:textView];
    
//    [self returnTextViewTithLabel:_labelText.text withTextViewText:textView.text];
}
-(void)voteTextFileTextChange:(UITextView *)textView{
    if (self.delegate&&[self.delegate respondsToSelector:@selector(textFileTextChangeDelegate:)]) {
        [self.delegate textFileTextChangeDelegate:textView];
    }
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
