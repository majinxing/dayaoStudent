//
//  MJXfollowUpTableViewCell.m
//  XinSuiFang
//
//  Created by majinxing on 16/9/20.
//  Copyright © 2016年 majinxing. All rights reserved.
//

#import "MJXfollowUpTableViewCell.h"

@interface MJXfollowUpTableViewCell ()<UITextViewDelegate>
@property (nonatomic,strong)UILabel *doctorl;
@end
@implementation MJXfollowUpTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self != nil)
    {
        
    }
    return self;
}
-(void)addNameOfTheFollowUpWithName:(NSString *)name{
    UIImageView *viewImage = [[UIImageView alloc] initWithFrame:CGRectMake(2, 15, 20,20)];
    viewImage.image = [UIImage imageNamed:@"mingc"];
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(12,20, 1, 70)];
    line.backgroundColor = [UIColor colorWithHexString:@"#e5e5e5"];
    [self.contentView addSubview:line];
    
    [self.contentView addSubview:viewImage];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(30, 20, 100, 10)];
    titleLabel.font = [UIFont systemFontOfSize:15];
    titleLabel.textColor = [UIColor colorWithHexString:@"#333333"];
    titleLabel.text = @"随访名称";
    [self.contentView addSubview:titleLabel];
    _textField = [[UITextField alloc] initWithFrame:CGRectMake(30, 40, APPLICATION_WIDTH-30, 40)];
    _textField.backgroundColor = [UIColor colorWithHexString:@"#f7f7f7"];
    _textField.placeholder = @"  请输入随访名称";
    if (name.length>0&&name!=nil&&![name isEqualToString:@"(null)"]) {
        _textField.text = [NSString stringWithFormat:@" %@",name];
    }
    _textField.font = [UIFont systemFontOfSize:15];
    _textField.textColor = [UIColor colorWithHexString:@"#333333"];
    [self.contentView addSubview:_textField];
    
    
}
-(void)addContentViewWithTimeStr:(NSString *)timeStr withText:(NSString *)textStr withTextEditor:(BOOL)N withDelegateButtonTag:(int) btnTag{
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(12, 0, 1, 190)];
    line.backgroundColor = [UIColor colorWithHexString:@"#e5e5e5"];
    [self.contentView addSubview:line];
    
    UIButton *deleteRemindButton = [UIButton buttonWithType:UIButtonTypeCustom];
    deleteRemindButton.tag = btnTag;
    deleteRemindButton.frame = CGRectMake(2, 28, 20,20);
    deleteRemindButton.backgroundColor = [UIColor colorWithHexString:@"#e5e5e5"];
    deleteRemindButton.layer.cornerRadius = 10;
    deleteRemindButton.layer.masksToBounds = YES;
    if (N&&btnTag!=1) {
        [deleteRemindButton setBackgroundImage:[UIImage imageNamed:@"jian"] forState:UIControlStateNormal];
    }
    if (!N){
        deleteRemindButton.userInteractionEnabled = NO;
    }
    [deleteRemindButton addTarget:self action:@selector(deleteRemindButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:deleteRemindButton];
    
    UIView *backFather = [[UIView alloc] initWithFrame:CGRectMake(20, 10, APPLICATION_WIDTH-20-3,110)];
 
    [self.contentView addSubview:backFather];
    UILabel *lable = [[UILabel alloc] initWithFrame:CGRectMake(10, 20,150, 10)];
    lable.text = @"复查提醒间隔";
    lable.font = [UIFont systemFontOfSize:15];
    lable.textColor = [UIColor colorWithHexString:@"#333333"];
    [backFather addSubview:lable];
    
//    UIButton *timeInstructions = [UIButton buttonWithType:UIButtonTypeCustom];
//    [timeInstructions setTitle:@"基准日期说明" forState:UIControlStateNormal];
//    timeInstructions.titleLabel.font = [UIFont systemFontOfSize:13];
//    [timeInstructions setTitleColor:[UIColor colorWithHexString:@"#01aeff"] forState:UIControlStateNormal];
//    timeInstructions.frame = CGRectMake(APPLICATION_WIDTH-120, 20, 100, 10);
//    [backFather addSubview:timeInstructions];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.userInteractionEnabled = N;
    button.titleLabel.font = [UIFont systemFontOfSize:15];
    button.backgroundColor = [UIColor colorWithHexString:@"#f7f7f7"];
    button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    button.titleEdgeInsets = UIEdgeInsetsMake(0, 7, 0, 0);
    if (timeStr.length>0) {
        [button setTitle:timeStr forState:UIControlStateNormal];
        [button setTitleColor:[UIColor colorWithHexString:@"#333333"] forState:UIControlStateNormal];
    }else{
        [button setTitle:@"请选择提醒时间如：基准日期两周后" forState:UIControlStateNormal];
        [button setTitleColor:[UIColor colorWithHexString:@"#999999"] forState:UIControlStateNormal];
    }
    [button addTarget:self action:@selector(changeTime:) forControlEvents:UIControlEventTouchUpInside];
    button.frame = CGRectMake(10,40,backFather.frame.size.width-15,40);
    button.tag = btnTag+2000;
    [backFather addSubview:button];
    
    _textView = [[UITextView alloc] initWithFrame:CGRectMake(10,90, backFather.frame.size.width-15, 80)];
    if (textStr.length>0) {
        [_textView setText:textStr];
    }else{
        [_textView setText:@"请输入医嘱内容"];
    }
    _textView.editable = N;
    _textView.backgroundColor = [UIColor colorWithHexString:@"#f7f7f7"];
    _textView.font = [UIFont systemFontOfSize:15];
    _textView.textColor = [UIColor colorWithHexString:@"#999999"];
    _textView.tag = btnTag+1000;
    [backFather addSubview:_textView];
}
-(void)addRemindButtonView{
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(12, 0, 1, 25)];
    line.backgroundColor = [UIColor colorWithHexString:@"#e5e5e5"];
    [self.contentView addSubview:line];
    
    UIButton *addRemindButton = [UIButton buttonWithType:UIButtonTypeCustom];
  
    addRemindButton.frame = CGRectMake(2, 15, 20,20);
  
    addRemindButton.backgroundColor = [UIColor grayColor];
    addRemindButton.layer.cornerRadius = 10;
    addRemindButton.layer.masksToBounds = YES;
    [addRemindButton setBackgroundImage:[UIImage imageNamed:@"tianjiaT"] forState:UIControlStateNormal];
    [addRemindButton addTarget:self action:@selector(addRemindButton) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:addRemindButton];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(30, 20, 100, 10)];
    label.text = @"添加";
    label.font = [UIFont systemFontOfSize:15];
    label.textColor = [UIColor colorWithHexString:@"#999999"];
    [self.contentView addSubview:label];
}

-(void)changeTime:(UIButton *)btn{
    if (self.delegate&&[self.delegate respondsToSelector:@selector(changeTimeButtonPressed:)]) {
        [self.delegate changeTimeButtonPressed:btn];
    }
}
-(void)addRemindButton{
    if (self.delegate&&[self.delegate respondsToSelector:@selector(addRemindButtonPressed)]) {
        [self.delegate addRemindButtonPressed];
    }
}
-(void)deleteRemindButton:(UIButton *)btn{
    if (self.delegate&&[self.delegate respondsToSelector:@selector(deleteRemindButtonPressed:)]) {
        [self.delegate deleteRemindButtonPressed:btn];
    }
}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event

{
    [self endEditing:YES];
    
}
////开始编辑
//
//-(BOOL)textViewShouldBeginEditing:(UITextView *)textView
//
//{
//    
//    NSLog(@"textViewShouldBeginEditing");
//    
//    return YES;
//    
//}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
