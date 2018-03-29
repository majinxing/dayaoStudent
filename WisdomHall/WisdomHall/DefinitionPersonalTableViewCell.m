//
//  DefinitionPersonalTableViewCell.m
//  WisdomHall
//
//  Created by XTU-TI on 2017/6/30.
//  Copyright © 2017年 majinxing. All rights reserved.
//

#import "DefinitionPersonalTableViewCell.h"
#import "DYHeader.h"

@interface DefinitionPersonalTableViewCell ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UIButton *seeSeat;

@property (strong, nonatomic) IBOutlet UILabel *infoLabel;
@property (nonatomic,assign)int temp;
@property (nonatomic,strong)UIButton * g;
@property (strong, nonatomic) IBOutlet UILabel *cycleLabel;
@property (strong, nonatomic) IBOutlet UISwitch *switchCycle;


@end
@implementation DefinitionPersonalTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    _g = [UIButton buttonWithType:UIButtonTypeCustom];
    _g.backgroundColor = [UIColor clearColor];
    [self.contentView addSubview:_g];
    [_g addTarget:self action:@selector(ggg:) forControlEvents:UIControlEventTouchUpInside];
    [_switchCycle setOn:NO];// 默认是NO关着
    _switchCycle.onTintColor = RGBA_COLOR(231, 231, 231, 1);
}
-(void)addContentView:(NSString *)infoLabelText withTextFileText:(NSString *)textFile withIndex:(int)n{
    _infoLabel.text = infoLabelText;
    _textFile.tag = n;
    _textFile.placeholder = infoLabelText;
    _textFile.text = textFile;
    _textFile.delegate = self;
    if (n==3){
        _g.frame = CGRectMake(CGRectGetMaxX(_infoLabel.frame), 0,400, 60);
        _g.tag = 3;
    }else if(n==5){
        _g.frame = CGRectMake(CGRectGetMaxX(_infoLabel.frame), 0,400, 60);
        _g.tag = 5;
    }else if(n==6){
        _g.frame = CGRectMake(CGRectGetMaxX(_infoLabel.frame), 0,400, 60);
        _g.tag = 6;
    }else if(n==7){
        _g.frame = CGRectMake(CGRectGetMaxX(_infoLabel.frame), 0,400, 60);
        _g.tag = 7;
    }else if(n==8){
        _g.frame = CGRectMake(CGRectGetMaxX(_infoLabel.frame), 0,400, 60);
        _g.tag = 8;
    }
    [_textFile addTarget:self action:@selector(textFileDidChange:) forControlEvents:UIControlEventEditingChanged];
}
-(void)addCourseContentView:(NSString *)infoLabelText withTextFileText:(NSString *)textFile withIndex:(int)n{
    _infoLabel.text = infoLabelText;
    _textFile.tag = n;
    _textFile.placeholder = infoLabelText;
    _textFile.text = textFile;
    _textFile.delegate = self;
    if (n==3){
        _g.frame = CGRectMake(CGRectGetMaxX(_infoLabel.frame), 0,400, 60);
        _g.tag = 3;
    }else if (n == 2){
        _g.frame = CGRectMake(CGRectGetMaxX(_infoLabel.frame), 0,400, 60);
        _g.tag = 2;
    }else if (n == 4){
        _g.frame = CGRectMake(CGRectGetMaxX(_infoLabel.frame), 0,400, 60);
        _g.tag = 4;
    }else if (n == 5){
        _g.frame = CGRectMake(CGRectGetMaxX(_infoLabel.frame), 0,400, 60);
        _g.tag = 5;
    }else if (n == 6){
        _g.frame = CGRectMake(CGRectGetMaxX(_infoLabel.frame), 0,400, 60);
        _g.tag = 6;
    }
    
    [_textFile addTarget:self action:@selector(textFileDidChange:) forControlEvents:UIControlEventEditingChanged];
}
-(void)addSwitchState:(NSString *)str{
    if ([str isEqualToString:@"no"]) {
        [_switchCycle setOn: NO];
        _cycleLabel.text = @"单次会议";
        _cycleLabel.textColor = [UIColor blackColor];
        _switchCycle.thumbTintColor = [UIColor whiteColor];

    }else{
        [_switchCycle setOn:YES];
        _cycleLabel.text = @"例会";
        _cycleLabel.textColor = RGBA_COLOR(33, 99, 174, 1);
        _switchCycle.thumbTintColor = RGBA_COLOR(33, 99, 174, 1);
    }
}
-(void)addMeetingContentView:(NSString *)infoLabelText withTextFileText:(NSString *)textFile withIndex:(int)n{
    _infoLabel.text = infoLabelText;
    _textFile.tag = n;
    _textFile.placeholder = infoLabelText;
    _textFile.text = textFile;
    _textFile.delegate = self;
    if (n == 1) {
        _g.frame = CGRectMake(CGRectGetMaxX(_infoLabel.frame), 0,400, 60);
        _g.tag = 1;
    }else if (n == 2){
        _g.frame = CGRectMake(CGRectGetMaxX(_infoLabel.frame), 0,400, 60);
        _g.tag = 2;
    }else if (n == 3){
        _g.frame = CGRectMake(CGRectGetMaxX(_infoLabel.frame), 0,400, 60);
        _g.tag = 3;
    }else if (n == 4){
        _g.frame = CGRectMake(CGRectGetMaxX(_infoLabel.frame), 0,400, 60);
        _g.tag = 4;
    }else if (n == 5){
        _g.frame = CGRectMake(CGRectGetMaxX(_infoLabel.frame), 0,400, 60);
        _g.tag = 5;
    }else if (n == 6){
        _g.frame = CGRectMake(CGRectGetMaxX(_infoLabel.frame), 0,400, 60);
        _g.tag = 6;
    }
    
    [_textFile addTarget:self action:@selector(textFileDidChange:) forControlEvents:UIControlEventEditingChanged];
}
-(void)addTemporaryCourseContentView:(NSString *)infoLabelText withTextFileText:(NSString *)textFile withIndex:(int)n{
    _infoLabel.text = infoLabelText;
    _textFile.tag = n;
    _textFile.placeholder = infoLabelText;
    _textFile.text = textFile;
    _textFile.delegate = self;
    if (n==3){
        _g.frame = CGRectMake(CGRectGetMaxX(_infoLabel.frame), 0,400, 60);
        _g.tag = 3;
    }else if (n == 2){
        _g.frame = CGRectMake(CGRectGetMaxX(_infoLabel.frame), 0,400, 60);
        _g.tag = 2;
    }else if (n == 4){
        _g.frame = CGRectMake(CGRectGetMaxX(_infoLabel.frame), 0,400, 60);
        _g.tag = 4;
    }else if (n == 5){
        _g.frame = CGRectMake(CGRectGetMaxX(_infoLabel.frame), 0,400, 60);
        _g.tag = 5;
    }
    
    [_textFile addTarget:self action:@selector(textFileDidChange:) forControlEvents:UIControlEventEditingChanged];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)textFileDidChange:(UITextField *)textFile{
    if (self.delegate&&[self.delegate respondsToSelector:@selector(textFileDidChangeForDPTableViewCellDelegate:)]) {
        [self.delegate textFileDidChangeForDPTableViewCellDelegate:textFile];
    }
}
-(void)ggg:(UIButton *)btn{
    if (self.delegate&&[self.delegate respondsToSelector:@selector(gggDelegate:)]) {
        [self.delegate gggDelegate:btn];
    }
}
- (IBAction)seeSeatPressed:(id)sender {
    if (self.delegate&&[self.delegate respondsToSelector:@selector(seeSaetPressedDelegate)]) {
        [self.delegate seeSaetPressedDelegate];
    }
}
- (IBAction)switchCycle:(UISwitch *)sender {
    //yes ON
    if (self.delegate&&[self.delegate respondsToSelector:@selector(switchCycleDelegate:)]) {
        [self.delegate switchCycleDelegate:sender];
    }
}
#pragma mark UITextFileDelegae
-(void)textFieldDidBeginEditing:(UITextField *)textField{
    
    if (self.delegate&&[self.delegate respondsToSelector:@selector(textFieldDidBeginEditingDPTableViewCellDelegate:)]) {
        
        [self.delegate textFieldDidBeginEditingDPTableViewCellDelegate:textField];
    }
}
@end
